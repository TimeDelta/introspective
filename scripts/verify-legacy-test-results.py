#!/usr/bin/env python3
"""Require the original legacy suite to run completely, respecting scheme exclusions."""
import argparse
import json
from pathlib import Path
import re
import runpy
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
METHOD = re.compile(r'^\s*(?:(?:public|internal|private|final|override)\s+)*func\s+(test\w+)\s*\(\s*\)', re.MULTILINE)
# Test classes are top-level declarations. A file can contain several classes,
# alongside nested helpers; never attribute every method to the filename.
CLASS = re.compile(r'^(?:(?:public|internal|private|final|open)\s+)*class\s+(\w+)\s*:', re.MULTILINE)


def inventory(directory, scheme, minimum=4297):
    classes = {}
    for path in sorted(directory.rglob('*.swift')):
        source = path.read_text()
        methods = METHOD.findall(source)
        if not methods:
            continue
        declarations = list(CLASS.finditer(source))
        assigned = 0
        for index, declaration in enumerate(declarations):
            end = declarations[index + 1].start() if index + 1 < len(declarations) else len(source)
            class_methods = METHOD.findall(source[declaration.end():end])
            if not class_methods:
                continue
            name = declaration.group(1)
            if name in classes or len(class_methods) != len(set(class_methods)):
                raise ValueError(f'Ambiguous or duplicate legacy test declarations: {path}')
            classes[name] = class_methods
            assigned += len(class_methods)
        if assigned != len(methods):
            raise ValueError(f'Ambiguous legacy test declarations: {path}')
    targets = [target for target in ET.parse(scheme).findall('.//TestableReference')
               if target.find('BuildableReference') is not None and
               target.find('BuildableReference').get('BlueprintName') == 'IntrospectiveTests']
    if len(targets) != 1 or targets[0].get('skipped') == 'YES':
        raise ValueError('The original IntrospectiveTests target must be enabled exactly once')
    declared = {f'{name}/{method}' for name, methods in classes.items() for method in methods}
    excluded = set()
    for node in targets[0].findall('./SkippedTests/Test'):
        identifier = node.get('Identifier', '').removesuffix('()')
        matches = {test for test in declared if test == identifier or test.startswith(identifier + '/')}
        if not matches:
            raise ValueError(f'Scheme exclusion has no matching legacy test: {identifier}')
        excluded.update(matches)
    selected = declared - excluded
    if len(selected) < minimum:
        raise ValueError(f'Legacy inventory shrank below its {minimum}-case baseline: {len(selected)}')
    return {'selected': sorted(selected), 'excluded': sorted(excluded)}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('summary', type=Path)
    args = parser.parse_args()
    tests = inventory(ROOT / 'IntrospectiveTests', ROOT / 'Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
    validate = runpy.run_path(str(ROOT / 'scripts/verify-native-test-results.py'))['validate']
    validate(json.loads(args.summary.read_text()), len(tests['selected']))
    print(f"All {len(tests['selected'])} selected legacy tests passed without failures or skips; "
          f"{len(tests['excluded'])} declarations are explicitly excluded by the scheme.")


if __name__ == '__main__':
    main()
