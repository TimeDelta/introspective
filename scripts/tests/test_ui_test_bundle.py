from pathlib import Path
import copy
import hashlib
import io
import json
import os
import plistlib
import subprocess
import sys
import tarfile
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / 'ui-test-bundle.py'
SCHEME = Path('Introspective.xcodeproj/xcshareddata/xcschemes/UIRegressionTests.xcscheme')
GIT_VERSION = Path('Common/Common/GitVersion.swift')
REVISION = '46ccfa71' + 'a' * 32


class UITestBuildBundle(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix='ui__bundle__')
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.workspace = self.root / 'checkout'
        self.workspace.mkdir()
        self.products = self.root / 'DerivedData/Build/Products'
        self.products.mkdir(parents=True)
        self.archive = self.root / 'ui-test-build.tar.gz'
        self.output = self.root / 'github-output'
        self.env = self.root / 'github-env'
        self.xcode = self.root / 'xcode-version.txt'
        self.xcode.write_text('Xcode 16.4\nBuild version 16F6\n')
        self.scheme = self.workspace / SCHEME
        self.scheme.parent.mkdir(parents=True)
        self.scheme.write_bytes(b'<?xml version="1.0"?><Scheme><TestAction codeCoverageEnabled="YES"/></Scheme>\n')
        self.git_version = self.workspace / GIT_VERSION
        self.git_version.parent.mkdir(parents=True)
        self.git_version.write_bytes(b'let gitRevision = "46ccfa71"\n')
        self.runner = self.products / 'Debug-iphonesimulator/IntrospectiveUITests-Runner.app'
        self.bundle = self.runner / 'PlugIns/IntrospectiveUITests.xctest'
        self.bundle.mkdir(parents=True)
        self.write(self.bundle / 'IntrospectiveUITests', b'UI test Mach-O', 0o755)
        self.write(self.runner / 'IntrospectiveUITests-Runner', b'runner Mach-O', 0o755)
        self.app = self.products / 'Debug-iphonesimulator/Introspective.app'
        self.app.mkdir()
        self.write(self.app / 'Introspective', b'coverage-instrumented application Mach-O', 0o775)
        self.framework = self.products / 'Debug-iphonesimulator/Dependency.framework'
        self.write(self.framework / 'Versions/A/Dependency', b'dependent framework Mach-O', 0o755)
        (self.framework / 'Versions/Current').symlink_to('A', target_is_directory=True)
        (self.framework / 'Dependency').symlink_to('Versions/Current/Dependency')
        self.write(self.products / 'Debug-iphonesimulator/Introspective.app.dSYM/Contents/Resources/DWARF/Introspective',
                   b'coverage reporting symbols')
        self.plan = self.products / 'UIRegressionTests_iphonesimulator18.5-arm64.xctestrun'
        self.make_plan(2)

    def write(self, path, content, mode=0o644):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(content)
        path.chmod(mode)

    def make_plan(self, version, binary=False):
        target = {
            'BlueprintName': 'IntrospectiveUITests', 'IsUITestBundle': True,
            'TestHostPath': '__TESTROOT__/Debug-iphonesimulator/IntrospectiveUITests-Runner.app',
            'TestBundlePath': '__TESTHOST__/PlugIns/IntrospectiveUITests.xctest',
            'UITargetAppPath': '__TESTROOT__/Debug-iphonesimulator/Introspective.app',
            'EnvironmentVariables': {'DYLD_FRAMEWORK_PATH': '__TESTROOT__/Debug-iphonesimulator',
                                     'SIM_ROOT': '__SIMRUNTIMEROOT__', 'SPECIAL': 'value with spaces'},
            'CommandLineArguments': ['--original-argument', 'value with spaces'],
            'TestingEnvironmentVariables': {'DYLD_INSERT_LIBRARIES': '__TESTBUNDLE__/Frameworks/libXCTestBundleInject.dylib'},
            'IsMainThreadCheckerEnabled': True, 'IsThreadPerformanceCheckerEnabled': True,
            'OnlyTestIdentifiers': [], 'SkipTestIdentifiers': [],
        }
        if version == 1:
            target.pop('BlueprintName')  # Real v1 target keys can provide the target identity.
            self.plan_data = {
                '__xctestrun_metadata__': {'FormatVersion': 1, 'CodeCoverageBuildableInfos': [{
                    'BlueprintName': 'Introspective',
                    'ProductPath': '__TESTROOT__/Debug-iphonesimulator/Introspective.app/Introspective'}]},
                'IntrospectiveUITests': target,
            }
        else:
            self.plan_data = {
                '__xctestrun_metadata__': {'FormatVersion': 2},
                'TestConfigurations': [{'Name': 'UI tests', 'TestTargets': [target]}],
                'CodeCoverageBuildableInfos': [{'BlueprintName': 'Introspective',
                    'ProductPaths': ['__TESTROOT__/Debug-iphonesimulator/Introspective.app/Introspective']}],
                'CodeCoverageTargetIDs': ['Original-Application-Target-ID'],
            }
        self.save_plan(binary)

    def save_plan(self, binary=False):
        self.plan.write_bytes(plistlib.dumps(self.plan_data,
                              fmt=plistlib.FMT_BINARY if binary else plistlib.FMT_XML, sort_keys=False))

    def target(self):
        if 'TestConfigurations' in self.plan_data:
            return self.plan_data['TestConfigurations'][0]['TestTargets'][0]
        return self.plan_data['IntrospectiveUITests']

    def command(self, command, *extra, **environment):
        arguments = [sys.executable, str(SCRIPT), command, '--products', str(self.products)]
        if command != 'prepare':
            arguments += ['--archive', str(self.archive), '--revision', REVISION, '--run-id', '12345',
                          '--attempt', '1', '--architecture', 'ARM64', '--xcode-version', str(self.xcode),
                          '--workspace', str(self.workspace)]
            if command == 'package':
                arguments += ['--scheme', str(self.scheme), '--github-output', str(self.output)]
            else:
                arguments += ['--sha256', self.archive_hash if hasattr(self, 'archive_hash') else '0' * 64,
                              '--github-env', str(self.env)]
        return subprocess.run([*arguments, *map(str, extra)], capture_output=True, text=True,
                              env=dict(os.environ, **environment), timeout=15)

    def package(self):
        result = self.command('package')
        self.assertEqual(result.returncode, 0, result.stderr)
        outputs = dict(line.split('=', 1) for line in self.output.read_text().splitlines())
        self.archive_hash = outputs['archive_sha256']
        self.assertEqual(self.archive_hash, hashlib.sha256(self.archive.read_bytes()).hexdigest())
        self.assertEqual(int(outputs['archive_bytes']), self.archive.stat().st_size)

    def sentinel(self, products=None):
        products = products or self.products
        marker = products / 'cached-file-must-survive-rejection'
        marker.write_text('existing cached build')
        return marker

    def assert_rejected(self, result, marker, error):
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertIn(error, result.stderr)
        self.assertNotIn('Traceback', result.stderr)
        self.assertEqual(marker.read_text(), 'existing cached build')
        self.assertFalse(self.env.exists())
        self.assertEqual(list(self.root.rglob('.ui-restore-*')), [])

    def rewrite_archive(self, transform=None, extra=()):
        entries = []
        with tarfile.open(self.archive, 'r:gz') as source:
            for member in source.getmembers():
                content = source.extractfile(member).read() if member.isfile() else None
                if transform:
                    member, content = transform(copy.copy(member), content)
                if member is not None:
                    entries.append((member, content))
        with tarfile.open(self.archive, 'w:gz', compresslevel=1) as destination:
            for member, content in [*entries, *extra]:
                destination.addfile(member, io.BytesIO(content) if content is not None else None)
        self.archive_hash = hashlib.sha256(self.archive.read_bytes()).hexdigest()

    def test_prepare_removes_only_root_plans_and_retains_compiled_products(self):
        nested = self.products / 'nested/cached.xctestrun'
        self.write(nested, b'keep nested data')
        (self.products / 'another.xctestrun').write_text('stale plan')
        (self.products / 'linked.xctestrun').symlink_to('missing-plan')
        marker = self.sentinel()
        result = self.command('prepare')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(list(self.products.glob('*.xctestrun')), [])
        self.assertTrue(nested.exists())
        self.assertTrue((self.app / 'Introspective').exists())
        self.assertTrue(marker.exists())

    def test_roundtrip_v1_and_v2_preserves_all_original_bytes_modes_and_links(self):
        for version in (1, 2):
            with self.subTest(version=version):
                self.make_plan(version, binary=version == 2)
                original_plan = self.plan.read_bytes()
                original_scheme = self.scheme.read_bytes()
                original_git = self.git_version.read_bytes()
                self.package()
                marker = self.sentinel()
                self.scheme.write_text('consumer checkout scheme')
                self.git_version.write_text('consumer checkout version')
                result = self.command('restore')
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertFalse(marker.exists())
                self.assertEqual(self.plan.read_bytes(), original_plan)
                self.assertEqual(self.scheme.read_bytes(), original_scheme)
                self.assertEqual(self.git_version.read_bytes(), original_git)
                self.assertEqual((self.app / 'Introspective').stat().st_mode & 0o777, 0o775)
                self.assertEqual((self.bundle / 'IntrospectiveUITests').stat().st_mode & 0o777, 0o755)
                self.assertTrue((self.framework / 'Dependency').is_symlink())
                self.assertEqual(os.readlink(self.framework / 'Dependency'), 'Versions/Current/Dependency')
                self.assertEqual((self.framework / 'Dependency').read_bytes(), b'dependent framework Mach-O')
                self.assertTrue((self.products / 'Debug-iphonesimulator/Introspective.app.dSYM').is_dir())
                self.assertEqual(self.env.read_text().splitlines()[-1], f'CI_UI_XCTESTRUN={self.plan}')

    def test_absolute_generated_launch_paths_are_preserved(self):
        target = self.target()
        target.update(TestHostPath=str(self.runner), TestBundlePath=str(self.bundle), UITargetAppPath=str(self.app))
        self.save_plan()
        original = self.plan.read_bytes()
        self.package()
        self.assertEqual(self.command('restore').returncode, 0)
        self.assertEqual(self.plan.read_bytes(), original)

    def test_product_roots_containing_placeholder_names_remain_literal(self):
        original_products = self.products
        self.products = self.products.with_name('Products__TESTHOST__and__UNKNOWN__')
        original_products.rename(self.products)
        self.plan = self.products / self.plan.name
        paths = {'TestHostPath': self.runner, 'TestBundlePath': self.bundle, 'UITargetAppPath': self.app}
        for absolute_paths in (False, True):
            with self.subTest(absolute_paths=absolute_paths):
                if absolute_paths:
                    self.target().update({field: str(self.products / path.relative_to(original_products))
                                          for field, path in paths.items()})
                self.save_plan()
                original = self.plan.read_bytes()
                self.package()
                result = self.command('restore')
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(self.plan.read_bytes(), original)

    def test_partial_rerun_uses_original_producer_attempt(self):
        self.package()
        result = self.command('restore', GITHUB_RUN_ATTEMPT='2')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.env.unlink()
        marker = self.sentinel()
        self.assert_rejected(self.command('restore', '--attempt', '2', GITHUB_RUN_ATTEMPT='2'),
                             marker, 'producer_attempt')

    def test_provenance_mismatches_do_not_replace_cached_products_or_metadata(self):
        self.package()
        marker = self.sentinel()
        original_scheme = self.scheme.read_bytes()
        other_workspace = self.root / 'other-checkout'
        other_workspace.mkdir()
        cases = [('--revision', 'b' * 40, 'commit'), ('--run-id', '67890', 'run_id'),
                 ('--attempt', '2', 'producer_attempt'), ('--architecture', 'X64', 'architecture'),
                 ('--workspace', str(other_workspace), 'workspace_root')]
        for option, value, field in cases:
            with self.subTest(field=field):
                self.assert_rejected(self.command('restore', option, value), marker, field)
                self.assertEqual(self.scheme.read_bytes(), original_scheme)
        other_products = self.root / 'other-products'
        other_products.mkdir()
        other_marker = self.sentinel(other_products)
        self.assert_rejected(self.command('restore', '--products', other_products), other_marker, 'products_root')
        self.xcode.write_text('Xcode 16.4\nBuild version 16F7\n')
        self.assert_rejected(self.command('restore'), marker, 'xcode_version')
        self.xcode.write_bytes(b'Xcode 16.4\r\nBuild version 16F6\r\n')
        self.assert_rejected(self.command('restore'), marker, 'xcode_version')

    def test_wrong_sha_and_missing_or_truncated_artifact_leave_existing_files(self):
        self.package()
        marker = self.sentinel()
        self.assert_rejected(self.command('restore', '--sha256', 'f' * 64), marker, 'SHA256 mismatch')
        self.archive.write_bytes(b'not a gzip tar archive')
        self.archive_hash = hashlib.sha256(self.archive.read_bytes()).hexdigest()
        self.assert_rejected(self.command('restore'), marker, 'error:')
        self.archive.unlink()
        self.assert_rejected(self.command('restore'), marker, 'No such file')

    def test_rejects_stale_native_unrelated_ambiguous_and_filtered_plans(self):
        original = copy.deepcopy(self.plan_data)
        mutations = [
            ('not UI', lambda: self.target().update(IsUITestBundle=False)),
            ('wrong target', lambda: self.target().update(BlueprintName='IntrospectiveTests')),
            ('only subset', lambda: self.target().update(OnlyTestIdentifiers=['IntrospectiveUITests/UITests/testOne'])),
            ('skipped suite', lambda: self.target().update(SkipTestIdentifiers=['IntrospectiveUITests/UITests'])),
            ('two targets', lambda: self.plan_data['TestConfigurations'][0]['TestTargets'].append(copy.deepcopy(self.target()))),
            ('two configurations', lambda: self.plan_data['TestConfigurations'].append(copy.deepcopy(self.plan_data['TestConfigurations'][0]))),
            ('no enabled configuration', lambda: self.plan_data['TestConfigurations'][0].update(IsEnabled=False)),
            ('native runner', lambda: self.target().update(TestHostPath='__TESTROOT__/Debug-iphonesimulator/Introspective.app')),
            ('wrong bundle', lambda: self.target().update(TestBundlePath='__TESTROOT__/Debug-iphonesimulator/Introspective.app')),
            ('missing runner', lambda: self.target().update(TestHostPath='__TESTROOT__/Missing/IntrospectiveUITests-Runner.app')),
            ('path escape', lambda: self.target().update(UITargetAppPath='/tmp/Introspective.app')),
            ('unknown path placeholder', lambda: self.target().update(UITargetAppPath='__SIMRUNTIMEROOT__/Introspective.app')),
        ]
        for name, mutate in mutations:
            with self.subTest(name=name):
                self.plan_data = copy.deepcopy(original)
                mutate()
                self.save_plan()
                result = self.command('package')
                self.assertNotEqual(result.returncode, 0, result.stderr)
                self.assertFalse(self.archive.exists())
                self.assertFalse(self.output.exists())

    def test_disabled_v2_configurations_do_not_change_the_enabled_ui_plan(self):
        self.plan_data['TestConfigurations'].append({'Name': 'Disabled', 'IsEnabled': False,
                                                     'TestTargets': [{'BlueprintName': 'UnusedNativeTests'}]})
        self.save_plan()
        self.package()
        result = self.command('restore')
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_unknown_launch_path_placeholders_are_rejected_without_output(self):
        original = copy.deepcopy(self.plan_data)
        paths = {'TestHostPath': self.runner, 'TestBundlePath': self.bundle, 'UITargetAppPath': self.app}
        for field, path in paths.items():
            for absolute_path in (False, True):
                with self.subTest(field=field, absolute_path=absolute_path):
                    self.plan_data = copy.deepcopy(original)
                    value = str(path) if absolute_path else self.target()[field]
                    self.target()[field] = value + '/__UNKNOWN__'
                    self.save_plan()
                    result = self.command('package')
                    self.assertNotEqual(result.returncode, 0, result.stdout)
                    self.assertIn(f'unrecognized placeholder in xctestrun {field}', result.stderr)
                    self.assertNotIn('Traceback', result.stderr)
                    self.assertFalse(self.archive.exists())
                    self.assertFalse(self.output.exists())
                    self.assertFalse(self.env.exists())

    def test_v2_blueprint_name_is_optional_when_ui_launch_paths_identify_target(self):
        self.target().pop('BlueprintName')
        self.save_plan()
        self.package()
        result = self.command('restore')
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_v1_wrong_target_key_without_blueprint_is_rejected(self):
        self.make_plan(1)
        self.plan_data['UnrelatedTests'] = self.plan_data.pop('IntrospectiveUITests')
        self.save_plan()
        result = self.command('package')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('target must be IntrospectiveUITests', result.stderr)

    def test_missing_and_multiple_root_plans_are_rejected(self):
        self.plan.unlink()
        self.assertNotEqual(self.command('package').returncode, 0)
        self.make_plan(2)
        (self.products / 'stale.xctestrun').write_bytes(self.plan.read_bytes())
        result = self.command('package')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('exactly one freshly generated', result.stderr)
        self.assertFalse(self.archive.exists())

    def test_corrupt_plist_and_unknown_format_are_rejected_explicitly(self):
        for invalid in (b'not an xctestrun plist', b'<?xml version="1.0"?><plist><dict>'):
            self.plan.write_bytes(invalid)
            result = self.command('package')
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('invalid generated xctestrun', result.stderr)
            self.assertNotIn('Traceback', result.stderr)
        self.make_plan(2)
        self.plan_data['__xctestrun_metadata__']['FormatVersion'] = 3
        self.save_plan()
        result = self.command('package')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('inspect the producer', result.stderr)

    def test_optional_generated_swift_file_and_regularized_hardlinks(self):
        self.git_version.unlink()
        os.link(self.app / 'Introspective', self.app / 'second-linked-executable')
        self.package()
        with tarfile.open(self.archive) as archive:
            self.assertNotIn('Metadata/GitVersion.swift', archive.getnames())
            self.assertTrue(all(not member.islnk() for member in archive.getmembers()))
        result = self.command('restore')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.app / 'second-linked-executable').read_bytes(), (self.app / 'Introspective').read_bytes())
        self.assertFalse(self.git_version.exists())

    def test_rejects_unsafe_members_before_touching_products(self):
        cases = [('../escaped', tarfile.REGTYPE, ''), ('/absolute', tarfile.REGTYPE, ''),
                 ('.', tarfile.REGTYPE, ''), ('Products/escape', tarfile.SYMTYPE, '../../escaped'),
                 ('Products/absolute-link', tarfile.SYMTYPE, '/tmp/escaped'),
                 ('Products/device', tarfile.CHRTYPE, ''),
                 ('Products/hardlink', tarfile.LNKTYPE, 'Products/Debug-iphonesimulator/Introspective.app/Introspective'),
                 ('Unexpected/payload', tarfile.REGTYPE, '')]
        for name, kind, link in cases:
            with self.subTest(name=name):
                self.package()
                member = tarfile.TarInfo(name)
                member.type, member.linkname = kind, link
                member.mode = 0o644
                self.rewrite_archive(extra=[(member, b'' if kind == tarfile.REGTYPE else None)])
                self.assert_rejected(self.command('restore'), self.sentinel(), 'archive')
                self.assertFalse((self.root / 'escaped').exists())

    def test_symlink_ancestor_duplicate_member_and_dangling_link_are_rejected(self):
        self.package()
        link = tarfile.TarInfo('Products/linked-directory')
        link.type, link.linkname = tarfile.SYMTYPE, 'Debug-iphonesimulator'
        child = tarfile.TarInfo('Products/linked-directory/payload')
        self.rewrite_archive(extra=[(link, None), (child, b'')])
        self.assert_rejected(self.command('restore'), self.sentinel(), 'non-directory')
        self.package()
        duplicate = tarfile.TarInfo('manifest.json')
        self.rewrite_archive(extra=[(duplicate, b'')])
        self.assert_rejected(self.command('restore'), self.sentinel(), 'duplicate')
        self.package()
        link.linkname = 'missing'
        self.rewrite_archive(extra=[(link, None)])
        self.assert_rejected(self.command('restore'), self.sentinel(), 'error:')

    def test_plan_hash_mismatch_and_missing_embedded_bundle_are_rejected_after_staging(self):
        self.package()
        def corrupt_plan(member, content):
            if member.name.endswith('.xctestrun'):
                content += b'\n'
                member.size = len(content)
            return member, content
        self.rewrite_archive(corrupt_plan)
        self.assert_rejected(self.command('restore'), self.sentinel(), 'xctestrun hash mismatch')
        self.package()
        def omit_bundle(member, content):
            return (None, None) if 'IntrospectiveUITests.xctest' in member.name else (member, content)
        self.rewrite_archive(omit_bundle)
        self.assert_rejected(self.command('restore'), self.sentinel(), 'TestBundlePath is missing')

    def test_archive_inside_products_and_escaping_source_symlink_are_rejected(self):
        result = self.command('package', '--archive', self.products / 'recursive.tar.gz')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('outside Products', result.stderr)
        (self.products / 'escaping-link').symlink_to('../outside')
        result = self.command('package')
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.archive.exists())

    def test_metadata_hash_mismatch_and_unsafe_destinations_leave_products_untouched(self):
        self.package()
        def corrupt_scheme(member, content):
            if member.name == 'Metadata/UIRegressionTests.xcscheme':
                content += b'changed'
                member.size = len(content)
            return member, content
        self.rewrite_archive(corrupt_scheme)
        self.assert_rejected(self.command('restore'), self.sentinel(), 'scheme hash mismatch')
        self.package()
        original = self.scheme.read_bytes()
        self.scheme.unlink()
        outside = self.root / 'outside-scheme'
        outside.write_bytes(original)
        self.scheme.symlink_to(outside)
        self.assert_rejected(self.command('restore'), self.sentinel(), 'destinations must not be symlinks')
        self.assertEqual(outside.read_bytes(), original)

    def test_symlink_loops_and_newline_output_paths_fail_explicitly(self):
        (self.products / 'loop').symlink_to('loop')
        result = self.command('package')
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn('Traceback', result.stderr)
        result = self.command('prepare', '--products', str(self.products) + '\nunsafe=value')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('paths must not contain newlines', result.stderr)
        self.assertNotIn('Traceback', result.stderr)


if __name__ == '__main__':
    unittest.main()
