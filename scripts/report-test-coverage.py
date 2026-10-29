#!/usr/bin/env python3
"""Turn xccov JSON into per-suite test-writing priorities without inventing coverage."""
import argparse
import json
from pathlib import Path
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


def build_report(coverage, summary, root, sources, exclusions, label):
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
            'testResult': summary, 'schemeExclusions': exclusions, 'files': files,
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
        if result.get('result') != 'Passed':
            lines += ['Coverage is partial because this suite did not pass. Fix failing/unrun tests before treating these gaps as missing assertions.', '']
    else:
        lines += ['No test result was produced. Test execution is unverified.', '']
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
    lines += [f"Explicit scheme exclusions: {len(report['schemeExclusions'])}.", '']
    for item in report['schemeExclusions']:
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
    parser.add_argument('--label', required=True)
    parser.add_argument('--json', type=Path, required=True)
    args = parser.parse_args()
    coverage = json.loads(args.coverage.read_text()) if args.coverage.is_file() and args.coverage.stat().st_size else None
    summary = json.loads(args.summary.read_text()) if args.summary.is_file() and args.summary.stat().st_size else None
    sources = subprocess.check_output(['git', 'ls-files', '-z', '--', '*.swift'], cwd=args.root).decode().split('\0')
    report = build_report(coverage, summary, args.root, [p for p in sources if p], scheme_exclusions(args.scheme), args.label)
    args.json.write_text(json.dumps(report, indent=2) + '\n')
    print(markdown(report))


if __name__ == '__main__':
    main()
