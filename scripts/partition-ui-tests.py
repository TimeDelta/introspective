#!/usr/bin/env python3
"""Assign every UI class to a disjoint, balanced CI shard."""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
# Completed serial run 40785354352. New classes use their case count as a weight.
CLASS_SECONDS = {
    'RecordActivitiesUITests': 1662,
    'RecordMedicationsUITests': 840,
    'GraphSetupScreenUITests': 480,
    'QueryScreenUITests': 288,
    'MoodSettingsUITests': 264,
    'MoodResultsUITests': 138,
    'ActivityResultsUITests': 114,
    'RecordMoodsUITests': 102,
    'ActivitySettingsUITests': 60,
    'GeneralResultsUITests': 18,
}
METHOD = re.compile(r'^\s*(?:(?:public|internal|private|final|override)\s+)*func\s+(test\w+)\s*\(\s*\)', re.MULTILINE)
CLASS = re.compile(r'\bclass\s+(\w+)\s*:\s*(?:UITest|XCTestCase)\b')


def discover_tests(directory=None):
    classes = {}
    for path in sorted((directory or ROOT / 'IntrospectiveUITests').rglob('*.swift')):
        source = path.read_text()
        methods = METHOD.findall(source)
        if not methods:
            continue
        names = CLASS.findall(source)
        if len(names) != 1:
            raise ValueError(f'{path}: expected one UI test class for its cases')
        name = names[0]
        if name in classes or len(methods) != len(set(methods)):
            raise ValueError(f'Duplicate UI class or test declaration: {path}')
        classes[name] = sorted(methods)
    total = sum(map(len, classes.values()))
    if total < 108:
        raise ValueError(f'UI inventory shrank below its 108-case baseline: {total}')
    return classes


def partition(classes, count):
    if not 1 <= count <= len(classes):
        raise ValueError('Shard count must be between one and the number of UI classes')
    shards = [[] for _ in range(count)]
    weights = [0] * count
    weight = lambda name: CLASS_SECONDS.get(name, len(classes[name]) * 40)
    for name in sorted(classes, key=lambda name: (-weight(name), name)):
        index = min(range(count), key=lambda index: (weights[index], index))
        shards[index].append(name)
        weights[index] += weight(name)
    assigned = [name for shard in shards for name in shard]
    if len(assigned) != len(set(assigned)) or set(assigned) != set(classes):
        raise ValueError('Every UI class must be assigned exactly once')
    return [sorted(shard) for shard in shards]


def selection(shard=1, count=1, classes=None):
    classes = discover_tests() if classes is None else classes
    if not 1 <= shard <= count:
        raise ValueError('Shard index is outside the selected shard count')
    names = partition(classes, count)[shard - 1]
    inventory = json.dumps(classes, sort_keys=True).encode()
    return {
        'shard': shard, 'shardCount': count,
        'inventorySHA256': hashlib.sha256(inventory).hexdigest(),
        'totalTestCount': sum(map(len, classes.values())),
        'classes': names,
        'tests': [f'IntrospectiveUITests/{name}/{method}' for name in names for method in classes[name]],
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--shard', type=int, default=1)
    parser.add_argument('--count', type=int, default=1)
    parser.add_argument('--json', type=Path)
    args = parser.parse_args()
    data = selection(args.shard, args.count)
    if args.json:
        args.json.write_text(json.dumps(data, indent=2) + '\n')
    for name in data['classes']:
        print(f'IntrospectiveUITests/{name}')


if __name__ == '__main__':
    main()
