#!/usr/bin/env python3
"""Preserve unchanged build inputs across checkouts without reusing changed content."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time

SCHEMA = 1


def input_files(root):
    files = set(subprocess.check_output(['git', 'ls-files', '-z'], cwd=root).decode().split('\0')) - {''}
    files.add('Common/Common/GitVersion.swift')
    files.add('Pods/Pods.xcodeproj/project.pbxproj')
    files.update(str(p.relative_to(root)) for p in (root / 'IntrospectiveTests').rglob('*.swift'))
    support = root / 'Pods/Target Support Files'
    files.update(str(p.relative_to(root)) for p in support.rglob('*') if p.is_file())
    return sorted(files)


def safe_file(root, name):
    path = root / name
    if Path(name).is_absolute() or '..' in Path(name).parts or not path.is_file() or path.is_symlink():
        return None
    try:
        path.resolve().relative_to(root.resolve())
    except ValueError:
        return None
    return path


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def snapshot(root, names):
    files = {}
    for name in names:
        if path := safe_file(root, name):
            stat = path.stat()
            files[name] = {'sha256': digest(path), 'mtimeNS': stat.st_mtime_ns}
    return {'schema': SCHEMA, 'workspace': str(root.resolve()), 'files': files}


def restore(root, manifest, names):
    if manifest.get('schema') != SCHEMA or manifest.get('workspace') != str(root.resolve()):
        return 0
    files = manifest.get('files')
    if not isinstance(files, dict):
        return 0
    # Validate the complete manifest before changing any timestamps.
    for name, info in files.items():
        if (not isinstance(name, str) or not isinstance(info, dict) or
                not isinstance(info.get('sha256'), str) or len(info['sha256']) != 64 or
                type(info.get('mtimeNS')) is not int or not 0 < info['mtimeNS'] <= time.time_ns()):
            return 0
    restored = 0
    for name in names:
        info = files.get(name)
        path = safe_file(root, name)
        if info is None or path is None:
            continue
        stat = path.stat()
        if digest(path) == info['sha256']:
            os.utime(path, ns=(stat.st_atime_ns, info['mtimeNS']))
            restored += 1
        elif stat.st_mtime_ns == info['mtimeNS']:
            # Content changed despite an identical timestamp: force Xcode to see it.
            os.utime(path, ns=(stat.st_atime_ns, time.time_ns()))
    return restored


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode', choices=['save', 'restore'])
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument('--manifest', type=Path, required=True)
    args = parser.parse_args()
    names = input_files(args.root)
    if args.mode == 'save':
        data = snapshot(args.root, names)
        args.manifest.parent.mkdir(parents=True, exist_ok=True)
        args.manifest.write_text(json.dumps(data, sort_keys=True) + '\n')
        print(f"Saved content hashes and timestamps for {len(data['files'])} build inputs.")
    elif args.manifest.is_file():
        try:
            manifest = json.loads(args.manifest.read_text())
            if not isinstance(manifest, dict):
                raise ValueError('Invalid manifest')
            count = restore(args.root, manifest, names)
            print(f'Restored timestamps for {count} unchanged build inputs; full Xcode build still required.')
        except (ValueError, OSError) as error:
            print(f'No source timestamps restored from unusable cache manifest: {type(error).__name__}.')
    else:
        print('No previous source manifest; Xcode will build with checkout timestamps.')


if __name__ == '__main__':
    main()
