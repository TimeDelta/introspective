#!/usr/bin/env python3
"""Turn xccov JSON into per-suite test-writing priorities without inventing coverage."""
import argparse
import json
from pathlib import Path
import runpy
import subprocess
import xml.etree.ElementTree as ET

TEST_DIRS = {'IntrospectiveTests', 'IntrospectiveUITests', 'MoodHealthTests', 'TestSupport'}
IGNORED_DIRS = TEST_DIRS | {'Pods', 'Carthage', '.build', 'build', 'ci-output'}


def production_path(path, root):
    try:
        relative = Path(path).resolve().relative_to(root.resolve())
    except ValueError:
        return None
    if relative.suffix != '.swift' or any(part in IGNORED_DIRS for part in relative.parts):
        return None
    return relative.as_posix()


def line_counts(item):
    covered, executable = item.get('coveredLines'), item.get('executableLines')
    if (type(covered) is not int or type(executable) is not int or
            not 0 <= covered <= executable):
        raise ValueError('Invalid xccov executable/covered line counts')
    return covered, executable


def scheme_exclusions(scheme):
    excluded = []
    for target in ET.parse(scheme).findall('.//TestableReference'):
        reference = target.find('BuildableReference')
        name = reference.get('BlueprintName') if reference is not None else 'Unknown target'
        if target.get('skipped') == 'YES':
            excluded.append({'target': name, 'identifier': '*', 'reason': 'Target disabled in scheme'})
        for test in target.findall('./SkippedTests/Test'):
            excluded.append({'target': name, 'identifier': test.get('Identifier'), 'reason': 'Test excluded by scheme'})
    return excluded


def execution_status(summary, expected):
    if not summary:
        return {'status': 'unverified', 'reason': 'No test result was produced.'}
    if expected is None:
        return {'status': 'unverified', 'reason': 'The selected test count was not supplied.'}
    validate = runpy.run_path(str(Path(__file__).with_name('verify-native-test-results.py')))['validate']
    try:
        validate(summary, expected)
    except ValueError as error:
        return {'status': 'partial', 'reason': str(error)}
    return {'status': 'complete', 'reason': f'All {expected} selected tests passed without failures or skips.'}


def expected_test_count(kind, root, scheme, shard, shard_count):
    scripts = root / 'scripts'
    if kind == 'tests':
        return runpy.run_path(str(scripts / 'verify-native-test-results.py'))['expected_test_count']()
    if kind == 'ui':
        return runpy.run_path(str(scripts / 'verify-ui-test-results.py'))['expected_test_count'](shard, shard_count)
    inventory = runpy.run_path(str(scripts / 'verify-legacy-test-results.py'))['inventory']
    return len(inventory(root / 'IntrospectiveTests', scheme)['selected'])


def build_report(coverage, summary, root, sources, exclusions, label, expected_tests=None):
    files, gaps = [], []
    measured = set()
    if coverage is not None:
        if not isinstance(coverage.get('targets'), list):
            raise ValueError('Missing xccov targets array')
        for target in coverage['targets']:
            for file in target.get('files', []):
                path = production_path(file['path'], root)
                if path is None:
                    continue
                covered, executable = line_counts(file)
                measured.add(path)
                files.append({'target': target['name'], 'path': path, 'coveredLines': covered,
                              'executableLines': executable, 'uncoveredLines': executable - covered})
                for function in file.get('functions', []):
                    fc, fe = line_counts(function)
                    if fe > fc:
                        gaps.append({'target': target['name'], 'path': path, 'name': function['name'],
                                     'line': function.get('lineNumber'), 'coveredLines': fc,
                                     'executableLines': fe, 'uncoveredLines': fe - fc,
                                     'executionCount': function.get('executionCount')})
    files.sort(key=lambda f: (-f['uncoveredLines'], f['path'], f['target']))
    gaps.sort(key=lambda f: (-f['uncoveredLines'], f['path'], f['line'] or 0, f['name'], f['target']))
    inventory = {path for source in sources if (path := production_path(root / source, root)) is not None}
    return {'suite': label, 'measurementStatus': 'available' if files else 'unavailable',
            'testResult': summary, 'expectedTestCount': expected_tests,
            'testExecution': execution_status(summary, expected_tests),
            'schemeExclusions': exclusions, 'files': files,
            'functionsNeedingTests': gaps, 'sourceFilesNotMeasured': sorted(inventory - measured)}


def cell(value):
    return str(value).replace('|', '\\|').replace('\n', ' ').replace('`', "'")


def markdown(report):
    lines = [f"### Coverage — {cell(report['suite'])}", '']
    result = report['testResult']
    if result:
        lines += [f"Test result: **{cell(result.get('result', 'Unknown'))}**; "
                  f"{result.get('passedTests', '?')} passed, {result.get('failedTests', '?')} failed, "
                  f"{result.get('skippedTests', '?')} skipped.", '']
    execution = report['testExecution']
    if execution['status'] == 'partial':
        lines += ['Coverage is partial because the complete selected suite did not pass without skips. '
                  'Fix failing/skipped/unrun tests before treating these gaps as missing assertions.', '']
    elif execution['status'] == 'unverified':
        lines += [f"{cell(execution['reason'])} Test execution is unverified.", '']
    else:
        lines += [execution['reason'], '']
    lines += ['Each job reports its own measurements. Percentages from separate jobs must not be added or averaged. '
              'Line coverage does not prove branch coverage or assertion quality.', '']
    if report['measurementStatus'] == 'unavailable':
        lines += ['**Coverage unavailable.** No measured production Swift files were exported; this is not 0% coverage.', '']
    else:
        lines += ['Production files with the most uncovered executable lines:', '',
                  '| Target | File | Covered / executable lines |', '| --- | --- | ---: |']
        for file in report['files'][:25]:
            lines.append(f"| {cell(file['target'])} | {cell(file['path'])} | {file['coveredLines']} / {file['executableLines']} |")
        lines += ['', 'Functions to investigate when writing behavioral tests:', '',
                  '| Function | Location | Uncovered / executable lines |', '| --- | --- | ---: |']
        for function in report['functionsNeedingTests'][:40]:
            lines.append(f"| {cell(function['name'])} | {cell(function['path'])}:{function['line'] or '?'} | "
                         f"{function['uncoveredLines']} / {function['executableLines']} |")
        lines += ['']
    lines += [f"{len(report['sourceFilesNotMeasured'])} tracked production Swift files have no measurement in this job. "
              'They may be outside the selected target or absent from instrumentation; they are not counted as uncovered.', '']
    exclusions = report['schemeExclusions']
    lines += [f"Explicit scheme exclusions: {len(exclusions)}." if exclusions is not None else
              'Scheme exclusions unavailable: the selected scheme was not generated.', '']
    for item in exclusions or []:
        lines.append(f"- {cell(item['target'])}/{cell(item['identifier'])}: {cell(item['reason'])}")
    lines += ['', 'The JSON artifact contains every measured file/function, every unmeasured source path, '
              'and all explicit exclusions for test planning.', '']
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--coverage', type=Path, required=True)
    parser.add_argument('--summary', type=Path, required=True)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parent.parent)
    parser.add_argument('--scheme', type=Path, required=True)
    parser.add_argument('--kind', choices=['tests', 'legacy', 'ui'], required=True)
    parser.add_argument('--shard', type=int, default=1)
    parser.add_argument('--shard-count', type=int, default=1)
    parser.add_argument('--label', required=True)
    parser.add_argument('--json', type=Path, required=True)
    args = parser.parse_args()
    coverage = json.loads(args.coverage.read_text()) if args.coverage.is_file() and args.coverage.stat().st_size else None
    summary = json.loads(args.summary.read_text()) if args.summary.is_file() and args.summary.stat().st_size else None
    sources = subprocess.check_output(['git', 'ls-files', '-z', '--', '*.swift'], cwd=args.root).decode().split('\0')
    exclusions = scheme_exclusions(args.scheme) if args.scheme.is_file() else None
    expected = expected_test_count(args.kind, args.root, args.scheme, args.shard, args.shard_count)
    report = build_report(coverage, summary, args.root, [p for p in sources if p], exclusions, args.label, expected)
    report['scheme'] = str(args.scheme)
    args.json.write_text(json.dumps(report, indent=2) + '\n')
    print(markdown(report))


if __name__ == '__main__':
    main()
