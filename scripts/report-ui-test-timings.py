#!/usr/bin/env python3
"""Report UI wall time and test hotspots for serial and parallel XCTest output."""
import argparse
from collections import defaultdict
import json
import os
from pathlib import Path
import re

SERIAL = re.compile(r"Test Case '-\[(?:IntrospectiveUITests\.)?(\w+) (test\w+)\]' (passed|failed) \(([\d.]+) seconds\)")
PARALLEL = re.compile(r"Test case '(?:IntrospectiveUITests\.)?(\w+)\.(test\w+)\(\)' (passed|failed) on .+? \(([\d.]+) seconds\)")


def parse_cases(log):
    cases = []
    for line in log.splitlines():
        match = SERIAL.search(line) or PARALLEL.search(line)
        if match:
            cls, method, status, seconds = match.groups()
            cases.append({'class': cls, 'test': method, 'result': status, 'seconds': float(seconds)})
    return cases


def report(log, summary, workers):
    cases = parse_cases(log)
    classes = defaultdict(lambda: {'attempts': 0, 'failed': 0, 'seconds': 0.0})
    for case in cases:
        row = classes[case['class']]
        row['attempts'] += 1
        row['failed'] += case['result'] == 'failed'
        row['seconds'] += case['seconds']
    wall = None
    if isinstance(summary.get('startTime'), (int, float)) and isinstance(summary.get('finishTime'), (int, float)):
        wall = max(0, summary['finishTime'] - summary['startTime'])
    launches = [float(value) for value in re.findall(r'CI_UI_LAUNCH_SECONDS (\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)\b', log)]
    instructions = [float(value) for value in re.findall(r'CI_UI_INSTRUCTION_WAIT_SECONDS (\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)\b', log)]
    return {'launchAttempts': len(launches), 'launchSeconds': sum(launches) if launches else None,
            'instructionWaitAttempts': len(instructions), 'instructionWaitSeconds': sum(instructions) if instructions else None,
            'workers': workers, 'observedWorkers': sorted(set(re.findall(r"(?:passed|failed) on '([^']+)'", log))), 'wallSeconds': wall,
            'recordedCases': len({(c['class'], c['test']) for c in cases}), 'attempts': len(cases),
            'reportedTotal': summary.get('totalTestCount'), 'result': summary.get('result'),
            'cumulativeSeconds': sum(c['seconds'] for c in cases),
            'classes': [{'class': cls, **row} for cls, row in sorted(classes.items(), key=lambda v: -v[1]['seconds'])],
            'slowest': sorted(cases, key=lambda c: -c['seconds'])[:10]}


def markdown(data):
    wall = 'unavailable (run did not produce a summary)' if data['wallSeconds'] is None else f"{data['wallSeconds'] / 60:.1f} minutes"
    shard = os.environ.get('CI_UI_SHARD', '1')
    count = os.environ.get('CI_UI_SHARD_COUNT', '1')
    lines = [f'### Legacy UI timings — shard {shard}/{count}', '', f"Configured UI workers per runner: {data['workers']}. Test execution wall time: {wall}.",
             f"Timed {data['recordedCases']} unique cases in {data['attempts']} attempts; result bundle reports {data['reportedTotal'] or 'unknown'} cases.",
             f"Worker destinations observed in the log: {len(data['observedWorkers']) if data['observedWorkers'] else 'not reported'}.", '', 'Cumulative times below add work across workers; they are not wall time.', '',
             '| Test class | Attempts | Failed | Cumulative minutes |', '| --- | ---: | ---: | ---: |']
    lines += [f"| {r['class']} | {r['attempts']} | {r['failed']} | {r['seconds'] / 60:.1f} |" for r in data['classes']]
    if data['launchSeconds'] is not None:
        lines += ['', f"App launch calls: {data['launchSeconds']:.1f}s across {data['launchAttempts']} attempts."]
    if data['instructionWaitSeconds'] is not None:
        lines += [f"Optional tutorial waits: {data['instructionWaitSeconds']:.1f}s across {data['instructionWaitAttempts']} attempts."]
    lines += ['', 'Slowest individual attempts:', '']
    lines += [f"- `{r['class']}/{r['test']}`: {r['seconds']:.1f}s ({r['result']})" for r in data['slowest']]
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, required=True)
    parser.add_argument('--summary', type=Path, required=True)
    parser.add_argument('--json', type=Path, required=True)
    args = parser.parse_args()
    summary = {}
    if args.summary.exists() and args.summary.stat().st_size:
        summary = json.loads(args.summary.read_text())
    data = report(args.log.read_text() if args.log.exists() else '', summary, os.environ.get('CI_UI_WORKERS', '1'))
    args.json.write_text(json.dumps(data, indent=2) + '\n')
    print(markdown(data), end='')


if __name__ == '__main__':
    main()
