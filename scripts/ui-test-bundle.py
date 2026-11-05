#!/usr/bin/env python3
"""Transport the complete, original Xcode UI build between CI jobs."""
import argparse
import gzip
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import plistlib
import re
import shutil
import stat
import sys
import tarfile
import tempfile
from xml.parsers.expat import ExpatError


SCHEME = Path('Introspective.xcodeproj/xcshareddata/xcschemes/UIRegressionTests.xcscheme')
GIT_VERSION = Path('Common/Common/GitVersion.swift')
MANIFEST = 'manifest.json'
SCHEME_MEMBER = 'Metadata/UIRegressionTests.xcscheme'
GIT_MEMBER = 'Metadata/GitVersion.swift'
UI_TARGET = 'IntrospectiveUITests'


class BundleError(ValueError):
    pass


def require(condition, message):
    if not condition:
        raise BundleError(message)


def absolute(path):
    result = Path(os.path.abspath(path))
    require(not any(character in str(result) for character in '\r\n'), 'paths must not contain newlines')
    return result


def digest(path):
    value = hashlib.sha256()
    with path.open('rb') as source:
        for block in iter(lambda: source.read(1024 * 1024), b''):
            value.update(block)
    return value.hexdigest()


def within(path, root):
    return path == root or root in path.parents


def check_roots(products, workspace):
    require(products != Path(products.anchor), 'Products cannot be a filesystem root')
    require(not products.is_symlink(), 'Products must not be a symlink')
    require(workspace.is_dir(), 'workspace does not exist')
    require(not within(workspace, products), 'Products must not contain the workspace')


def plan_target(plan):
    require(isinstance(plan, dict), 'generated xctestrun is not a dictionary')
    metadata = plan.get('__xctestrun_metadata__')
    require(isinstance(metadata, dict), 'generated xctestrun lacks __xctestrun_metadata__')
    version = metadata.get('FormatVersion')
    if type(version) is int and version == 1:
        targets = [(name, value) for name, value in plan.items() if name != '__xctestrun_metadata__']
        require(len(targets) == 1, 'v1 xctestrun must contain exactly one UI test target')
        name, target = targets[0]
    elif type(version) is int and version == 2:
        configurations = plan.get('TestConfigurations')
        require(isinstance(configurations, list) and configurations, 'v2 xctestrun lacks TestConfigurations')
        require(all(isinstance(item, dict) and type(item.get('IsEnabled', True)) is bool
                    for item in configurations), 'invalid xctestrun configuration')
        enabled = [item for item in configurations if item.get('IsEnabled', True)]
        require(len(enabled) == 1, 'xctestrun must contain exactly one enabled configuration')
        targets = enabled[0].get('TestTargets')
        require(isinstance(targets, list) and len(targets) == 1,
                'enabled xctestrun configuration must contain exactly one UI test target')
        name, target = None, targets[0]
    else:
        raise BundleError('unsupported xctestrun FormatVersion; inspect the producer’s generated plan on Xcode CI')
    require(isinstance(target, dict), 'invalid xctestrun test target')
    require(target.get('IsUITestBundle') is True, 'xctestrun target is not a UI test bundle')
    require(target.get('IsEnabled', True) is True, 'xctestrun UI target is disabled')
    if 'BlueprintName' in target:
        require(target['BlueprintName'] == UI_TARGET, 'xctestrun target must be IntrospectiveUITests')
    elif version == 1:
        require(name == UI_TARGET, 'xctestrun target must be IntrospectiveUITests')
    for field in ('OnlyTestIdentifiers', 'SkipTestIdentifiers'):
        require(field not in target or target[field] == [],
                f'xctestrun {field} must be empty; regenerate the full UI scheme before building')
    return target


def validate_plan(plan_path, original_products, staged_products):
    """Check launch paths only. All other generated plist fields remain opaque."""
    try:
        plan = plistlib.loads(plan_path.read_bytes())
    except (plistlib.InvalidFileException, ValueError, TypeError, OverflowError, ExpatError) as error:
        raise BundleError(f'invalid generated xctestrun: {error}') from error
    target = plan_target(plan)

    def location(field, host=None):
        value = target.get(field)
        require(isinstance(value, str) and value, f'xctestrun lacks {field}')
        value = value.replace('__TESTROOT__', str(original_products))
        if host is not None:
            value = value.replace('__TESTHOST__', str(host))
        require('__' not in value, f'unrecognized placeholder in xctestrun {field}')
        require(Path(value).is_absolute(), f'xctestrun {field} must resolve to an absolute path')
        original = absolute(value)
        require(within(original, original_products), f'xctestrun {field} escapes Products')
        staged = staged_products / original.relative_to(original_products)
        require(staged.is_dir(), f'xctestrun {field} is missing: {original}')
        require(within(staged.resolve(), staged_products.resolve()), f'xctestrun {field} escapes Products through a link')
        return original

    host = location('TestHostPath')
    require(host.name == 'IntrospectiveUITests-Runner.app', 'xctestrun TestHostPath is not the UI runner app')
    bundle = location('TestBundlePath', host)
    require(bundle == host / 'PlugIns/IntrospectiveUITests.xctest',
            'xctestrun TestBundlePath must be the UI bundle embedded in its runner')
    app = location('UITargetAppPath', host)
    require(app.name == 'Introspective.app', 'xctestrun UITargetAppPath is not Introspective.app')


def generated_plan(products):
    plans = sorted(products.glob('*.xctestrun'))
    require(len(plans) == 1 and plans[0].is_file() and not plans[0].is_symlink(),
            'expected exactly one freshly generated root xctestrun; run prepare before build-for-testing')
    require(not any(character in plans[0].name for character in '\r\n'), 'generated plan filename contains a newline')
    return plans[0]


def check_tree(products):
    for directory, folders, files in os.walk(products, followlinks=False):
        for name in folders + files:
            path = Path(directory) / name
            mode = path.lstat().st_mode
            require(stat.S_ISREG(mode) or stat.S_ISDIR(mode) or stat.S_ISLNK(mode),
                    f'unsupported product file: {path}')
            require(not mode & 0o7000, f'unsafe product permissions: {path}')
            if path.is_symlink():
                target = os.readlink(path)
                require(not Path(target).is_absolute(), f'absolute product symlink: {path}')
                require(within(path.resolve(strict=True), products.resolve()),
                        f'product symlink escapes Products: {path}')


def append_output(path, key, value):
    with path.open('a') as output:
        output.write(f'{key}={value}\n')


def provenance(args):
    require(re.fullmatch(r'[0-9a-fA-F]{40}|[0-9a-fA-F]{64}', args.revision) is not None,
            'revision must be a full commit SHA')
    require(re.fullmatch(r'[1-9][0-9]*', args.run_id) is not None, 'run ID must be positive')
    require(re.fullmatch(r'[1-9][0-9]*', args.attempt) is not None, 'producer attempt must be positive')
    xcode = args.xcode_version.read_bytes().decode('utf-8')
    require(xcode.strip(), 'Xcode version file is empty')
    return {'schema': 1, 'commit': args.revision, 'run_id': args.run_id,
            'producer_attempt': args.attempt, 'architecture': args.architecture,
            'xcode_version': xcode, 'products_root': str(args.products),
            'workspace_root': str(args.workspace)}


def prepare(args):
    require(args.products != Path(args.products.anchor), 'Products cannot be a filesystem root')
    require(not args.products.is_symlink(), 'Products must not be a symlink')
    for path in args.products.glob('*.xctestrun'):
        require(path.is_file() or path.is_symlink(), f'refusing to remove non-file xctestrun: {path}')
        path.unlink()


def package(args):
    check_roots(args.products, args.workspace)
    require(args.products.is_dir(), 'Products does not exist; build-for-testing must succeed first')
    require(not within(args.archive, args.products), 'archive must be outside Products')
    plan = generated_plan(args.products)
    validate_plan(plan, args.products, args.products)
    check_tree(args.products)
    require(args.scheme.is_file() and not args.scheme.is_symlink(), 'generated UI scheme is missing')
    manifest = provenance(args)
    manifest.update(plan_relative_path=plan.name, plan_sha256=digest(plan), scheme_sha256=digest(args.scheme))
    git_version = args.workspace / GIT_VERSION
    require(not git_version.is_symlink(), 'generated GitVersion.swift must not be a symlink')
    if git_version.is_file():
        manifest['git_version_sha256'] = digest(git_version)
    args.archive.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(dir=args.archive.parent, prefix='.ui-bundle-', delete=False) as output:
            temporary = Path(output.name)
            with gzip.GzipFile(fileobj=output, mode='wb', compresslevel=1, mtime=0) as compressed:
                with tarfile.open(fileobj=compressed, mode='w') as archive:
                    # Write provenance first so restore need not seek through a second full gzip pass to read it.
                    data = json.dumps(manifest, sort_keys=True, indent=2).encode() + b'\n'
                    info = tarfile.TarInfo(MANIFEST)
                    info.size, info.mode = len(data), 0o644
                    archive.addfile(info, io.BytesIO(data))
                    def regular_hardlinks(info):
                        # Copy hard-linked files as regular files so extraction has no link-order dependency.
                        if info.islnk():
                            info.type, info.linkname = tarfile.REGTYPE, ''
                            info.size = (args.products / PurePosixPath(info.name).relative_to('Products')).stat().st_size
                        return info
                    archive.add(args.products, arcname='Products', filter=regular_hardlinks)
                    archive.add(args.scheme, arcname=SCHEME_MEMBER, recursive=False)
                    if 'git_version_sha256' in manifest:
                        archive.add(git_version, arcname=GIT_MEMBER, recursive=False)
        archive_hash = digest(temporary)
        os.replace(temporary, args.archive)
        append_output(args.github_output, 'archive_sha256', archive_hash)
        append_output(args.github_output, 'archive_bytes', args.archive.stat().st_size)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


def archive_members(archive):
    members = {}
    for member in archive.getmembers():
        path = PurePosixPath(member.name)
        require(member.name and path.parts and not path.is_absolute() and '..' not in path.parts
                and '\\' not in member.name and str(path) == member.name.rstrip('/'),
                f'unsafe archive path: {member.name!r}')
        require(str(path) not in members, f'duplicate archive path: {member.name}')
        require((path.parts[0] == 'Products') or member.name in (MANIFEST, SCHEME_MEMBER, GIT_MEMBER, 'Metadata'),
                f'unexpected archive path: {member.name}')
        require(member.isdir() or member.isfile() or member.issym(),
                f'unsupported archive member: {member.name}')
        require(not member.mode & 0o7000, f'unsafe archive permissions: {member.name}')
        if member.issym():
            require(path.parts[0] == 'Products' and not PurePosixPath(member.linkname).is_absolute()
                    and '\\' not in member.linkname and member.linkname,
                    f'unsafe archive symlink: {member.name}')
            target = PurePosixPath(os.path.normpath(str(path.parent / member.linkname)))
            require(target.parts and target.parts[0] == 'Products' and '..' not in target.parts,
                    f'escaping archive symlink: {member.name}')
        members[str(path)] = member
    for name, member in members.items():
        for ancestor in PurePosixPath(name).parents:
            if str(ancestor) in members:
                require(members[str(ancestor)].isdir(), f'archive member beneath a non-directory: {name}')
    require('Products' in members and members['Products'].isdir(), 'archive lacks Products directory')
    for name in (MANIFEST, SCHEME_MEMBER):
        require(name in members and members[name].isfile(), f'archive lacks regular {name}')
    if GIT_MEMBER in members:
        require(members[GIT_MEMBER].isfile(), 'GitVersion.swift must be a regular file')
    return members


def read_manifest(archive, members, expected):
    require(members[MANIFEST].size <= 65536, 'archive manifest is too large')
    with archive.extractfile(members[MANIFEST]) as source:
        manifest = json.load(source)
    require(isinstance(manifest, dict), 'invalid archive manifest')
    for key, value in expected.items():
        require(type(manifest.get(key)) is type(value) and manifest[key] == value,
                f'archive provenance mismatch: {key}')
    plan = manifest.get('plan_relative_path')
    require(isinstance(plan, str) and PurePosixPath(plan).name == plan
            and plan.endswith('.xctestrun') and not any(char in plan for char in '\r\n'),
            'invalid manifest plan path')
    require('Products/' + plan in members and members['Products/' + plan].isfile(),
            'archive lacks original generated xctestrun')
    for field in ('plan_sha256', 'scheme_sha256'):
        require(re.fullmatch(r'[0-9a-f]{64}', str(manifest.get(field, ''))) is not None,
                f'invalid manifest {field}')
    require(('git_version_sha256' in manifest) == (GIT_MEMBER in members),
            'GitVersion.swift manifest does not match archive')
    return manifest


def extract(archive, members, staging):
    # Avoid tarfile.extractall: validate the complete member graph before creating anything.
    for name, member in members.items():
        destination = staging / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        if member.isdir():
            destination.mkdir(exist_ok=True)
        elif member.issym():
            destination.symlink_to(member.linkname)
            if os.chmod in os.supports_follow_symlinks:
                os.chmod(destination, member.mode, follow_symlinks=False)
        else:
            with archive.extractfile(member) as source, destination.open('xb') as output:
                shutil.copyfileobj(source, output)
            destination.chmod(member.mode)
    # Apply directory permissions after their children have been written.
    for name, member in sorted(members.items(), key=lambda item: len(PurePosixPath(item[0]).parts), reverse=True):
        if member.isdir():
            (staging / name).chmod(member.mode)


def restore(args):
    check_roots(args.products, args.workspace)
    require(re.fullmatch(r'[0-9a-f]{64}', args.sha256) is not None, 'expected archive SHA256 is invalid')
    require(digest(args.archive) == args.sha256, 'archive SHA256 mismatch')
    expected = provenance(args)
    # Stage on the destination filesystem without changing the existing Products tree.
    parent = args.products.parent
    while not parent.exists():
        parent = parent.parent
    with tarfile.open(args.archive, mode='r:gz') as archive:
        members = archive_members(archive)
        manifest = read_manifest(archive, members, expected)
        with tempfile.TemporaryDirectory(prefix='.ui-restore-', dir=parent) as temporary:
            staging = Path(temporary)
            extract(archive, members, staging)
            staged_products = staging / 'Products'
            check_tree(staged_products)
            plan = generated_plan(staged_products)
            require(plan.name == manifest['plan_relative_path'] and digest(plan) == manifest['plan_sha256'],
                    'original xctestrun hash mismatch')
            require(digest(staging / SCHEME_MEMBER) == manifest['scheme_sha256'], 'UI scheme hash mismatch')
            if GIT_MEMBER in members:
                require(digest(staging / GIT_MEMBER) == manifest['git_version_sha256'], 'GitVersion.swift hash mismatch')
            validate_plan(plan, args.products, staged_products)
            scheme = args.workspace / SCHEME
            git_version = args.workspace / GIT_VERSION
            require(not scheme.is_symlink() and not git_version.is_symlink(), 'metadata destinations must not be symlinks')
            for path in (scheme, git_version):
                require(not path.exists() or path.is_file(), 'metadata destination is not a regular file')
                require(within(path.parent.resolve(), args.workspace.resolve()), 'metadata destination escapes workspace')
                for ancestor in path.parents:
                    require(not ancestor.exists() or ancestor.is_dir(), 'metadata parent is not a directory')
                    if ancestor == args.workspace:
                        break
            args.products.parent.mkdir(parents=True, exist_ok=True)
            backup = staging / 'previous-products'
            had_products = args.products.exists()
            if had_products:
                args.products.rename(backup)
            try:
                staged_products.rename(args.products)
            except OSError:
                if had_products:
                    backup.rename(args.products)
                raise
            scheme.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(staging / SCHEME_MEMBER, scheme)
            if GIT_MEMBER in members:
                git_version.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(staging / GIT_MEMBER, git_version)
            append_output(args.github_env, 'CI_UI_XCTESTRUN', str(args.products / plan.name))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    for name in ('prepare', 'package', 'restore'):
        command = commands.add_parser(name)
        command.add_argument('--products', type=Path, required=True)
        if name == 'prepare':
            continue
        command.add_argument('--archive', type=Path, required=True)
        command.add_argument('--revision', required=True)
        command.add_argument('--run-id', required=True)
        command.add_argument('--attempt', required=True, help='producer attempt, including on partial reruns')
        command.add_argument('--architecture', choices=('X64', 'ARM64'), required=True)
        command.add_argument('--xcode-version', type=Path, required=True)
        command.add_argument('--workspace', type=Path, required=True)
        if name == 'package':
            command.add_argument('--scheme', type=Path, required=True)
            command.add_argument('--github-output', type=Path, required=True)
        else:
            command.add_argument('--sha256', required=True)
            command.add_argument('--github-env', type=Path, required=True)
    args = parser.parse_args()
    try:
        args.products = absolute(args.products)
        if args.command != 'prepare':
            args.workspace, args.archive = absolute(args.workspace), absolute(args.archive)
        globals()[args.command](args)
    except (BundleError, OSError, tarfile.TarError, ValueError, EOFError, RuntimeError) as error:
        print(f'UI test bundle error: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
