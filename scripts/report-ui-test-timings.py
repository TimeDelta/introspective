#!/usr/bin/env python3
"""Report UI wall time and test hotspots for serial and parallel XCTest output."""
import argparse
from collections import defaultdict
import json
import math
import os
from pathlib import Path
import re
import stat
import uuid

SERIAL = re.compile(r"Test Case '-\[(?:IntrospectiveUITests\.)?(\w+) (test\w+)\]' (passed|failed) \(([\d.]+) seconds\)")
PARALLEL = re.compile(r"Test case '(?:IntrospectiveUITests\.)?(\w+)\.(test\w+)\(\)' (passed|failed) on .+? \(([\d.]+) seconds\)")
TRACE_MARKER = 'CI_UI_LAUNCH_TRACE '
MAX_PROFILE_BYTES = 64 * 1024
BOOTSTRAP_STAGES = (
    'will_finish_begin', 'dependencies_ready', 'preferences_ready', 'fixtures_ready',
    'will_finish_end', 'did_finish_begin', 'did_finish_end',
)
READY_STAGES = ('app_active', 'initial_view_appeared')
EARLY_STAGES = ('process_entry', 'delegate_initialized')
EARLY_PHASES = ('beforeProcessEntry', 'entryToDelegate', 'delegateToWillFinish', 'afterReady')
PHASE_NAMES = (
    'dependencies', 'preferences', 'fixtureDatabase', 'willFinishOther',
    'storyboardGap', 'didFinish', 'readyAfterDidFinish',
)
TRACE_FIELDS = {'schema', 'traceID', 'startUptime', 'endUptime'}
PROFILE_FIELDS = {'schema', 'traceID', 'stages'}
STAGE_FIELDS = set(BOOTSTRAP_STAGES + READY_STAGES + EARLY_STAGES)


def finite_time(value):
    try:
        return type(value) in (int, float) and math.isfinite(value) and value >= 0
    except OverflowError:
        return False


def trace_id(value):
    if not isinstance(value, str):
        return None
    try:
        return str(uuid.UUID(value))
    except (ValueError, AttributeError):
        return None


def unique_json_object(pairs):
    value = {}
    for key, item in pairs:
        if key in value:
            raise ValueError('Duplicate JSON field')
        value[key] = item
    return value


def read_profile_json(path):
    """Read bounded, unambiguous JSON objects from regular files without following links."""
    try:
        if path.is_symlink():
            return None
        flags = os.O_RDONLY | getattr(os, 'O_NOFOLLOW', 0) | getattr(os, 'O_NONBLOCK', 0)
        with os.fdopen(os.open(path, flags), 'rb') as handle:
            if not stat.S_ISREG(os.fstat(handle.fileno()).st_mode):
                return None
            payload = handle.read(MAX_PROFILE_BYTES + 1)
        if len(payload) > MAX_PROFILE_BYTES:
            return None
        value = json.loads(payload, object_pairs_hook=unique_json_object)
        return value if isinstance(value, dict) else None
    except (OSError, ValueError, UnicodeError, RecursionError):
        return None


def startup_profiling(log, directory=None):
    """Pair unique wrapper traces with app lifecycle records from the same launch."""
    result = {
        'status': 'unavailable', 'traceCount': 0, 'pairedCount': 0,
        'missingProfileCount': 0, 'invalidTraceCount': 0, 'invalidProfileCount': 0,
        'incompleteProfileCount': 0, 'duplicateTraceCount': 0,
        'duplicateProfileCount': 0, 'outsideWindowCount': 0,
        'aggregationErrorCount': 0,
        'profilesDirectoryAvailable': False, 'collectionAvailability': None,
        'cumulativeSeconds': None,
        'earlyStartup': {
            'status': 'unavailable', 'pairedCount': 0, 'missingMarkerCount': 0,
            'incompleteMarkerCount': 0, 'aggregationErrorCount': 0,
            'cumulativeSeconds': None,
        },
    }
    traces = defaultdict(list)
    for line in log.splitlines():
        if TRACE_MARKER not in line:
            continue
        result['traceCount'] += 1
        payload = line.split(TRACE_MARKER, 1)[1].strip()
        record = None
        if len(payload.encode('utf-8')) <= MAX_PROFILE_BYTES:
            try:
                record = json.loads(payload, object_pairs_hook=unique_json_object)
            except (ValueError, RecursionError):
                pass
        identity = trace_id(record.get('traceID')) if isinstance(record, dict) else None
        valid = (isinstance(record, dict) and set(record) == TRACE_FIELDS
                 and type(record.get('schema')) is int and record['schema'] == 1)
        valid = valid and identity is not None
        if valid:
            start, end = record.get('startUptime'), record.get('endUptime')
            valid = finite_time(start) and finite_time(end) and end >= start and math.isfinite(end - start)
        if not valid:
            result['invalidTraceCount'] += 1
        if identity is not None:
            # Even an invalid occurrence makes a repeated ID ambiguous.
            traces[identity].append((start, end) if valid else None)
    result['duplicateTraceCount'] = sum(len(records) > 1 for records in traces.values())
    unique = {identity: records[0] for identity, records in traces.items()
              if len(records) == 1 and records[0] is not None}

    profiles = defaultdict(list)
    if directory is not None:
        directory = Path(directory)
        result['profilesDirectoryAvailable'] = directory.is_dir()
        if result['profilesDirectoryAvailable']:
            collection = read_profile_json(directory / 'collection-status.json')
            if (collection and type(collection.get('schema')) is int and collection['schema'] == 1
                    and collection.get('availability') in ('complete', 'partial', 'unavailable')):
                result['collectionAvailability'] = collection['availability']
            for path in directory.glob('*.json'):
                # The collector uses UUID.json. Ignore metadata and foreign/stale launches.
                identity = trace_id(path.stem)
                if identity in unique and (path.is_symlink() or path.is_file()):
                    profiles[identity].append(path)

    pairs = []
    early_pairs = []
    for identity, (start, end) in unique.items():
        paths = profiles[identity]
        if not paths:
            result['missingProfileCount'] += 1
            continue
        if len(paths) != 1:
            result['duplicateProfileCount'] += 1
            continue
        record = read_profile_json(paths[0])
        if (not record or set(record) != PROFILE_FIELDS
                or type(record.get('schema')) is not int or record['schema'] != 1
                or trace_id(record.get('traceID')) != identity or not isinstance(record.get('stages'), dict)):
            result['invalidProfileCount'] += 1
            continue
        stages = record['stages']
        if not set(stages).issubset(STAGE_FIELDS):
            result['invalidProfileCount'] += 1
            continue
        if any(stage not in stages for stage in BOOTSTRAP_STAGES + READY_STAGES):
            result['incompleteProfileCount'] += 1
            continue
        chain = [stages[stage] for stage in BOOTSTRAP_STAGES]
        active, appeared = (stages[stage] for stage in READY_STAGES)
        if (not all(finite_time(value) for value in stages.values())
                or any(later < earlier for earlier, later in zip(chain, chain[1:]))
                or active < chain[0] or appeared < chain[0]):
            result['invalidProfileCount'] += 1
            continue
        ready = max(chain[-1], active, appeared)
        if chain[0] < start or ready > end:
            result['outsideWindowCount'] += 1
            continue
        early = [stages[stage] for stage in EARLY_STAGES if stage in stages]
        if any(value < start or value > end for value in early):
            result['outsideWindowCount'] += 1
            continue
        early_chain = early + [chain[0]]
        if any(later < earlier for earlier, later in zip(early_chain, early_chain[1:])):
            result['invalidProfileCount'] += 1
            continue
        if len(early) == len(EARLY_STAGES):
            entry, delegate = early
            early_pairs.append(dict(zip(EARLY_PHASES, (
                entry - start, delegate - entry, chain[0] - delegate, end - ready,
            ))))
        elif early:
            result['earlyStartup']['incompleteMarkerCount'] += 1
        else:
            result['earlyStartup']['missingMarkerCount'] += 1
        phases = [later - earlier for earlier, later in zip(chain, chain[1:])]
        phases.append(ready - chain[-1])
        bootstrap = ready - chain[0]
        pairs.append({'launch': end - start, 'appBootstrap': bootstrap,
                      'unattributedLaunch': (end - start) - bootstrap,
                      'phases': dict(zip(PHASE_NAMES, phases))})

    result['pairedCount'] = len(pairs)
    if pairs:
        try:
            cumulative = {key: math.fsum(pair[key] for pair in pairs)
                          for key in ('launch', 'appBootstrap', 'unattributedLaunch')}
            cumulative['phases'] = {key: math.fsum(pair['phases'][key] for pair in pairs) for key in PHASE_NAMES}
        except OverflowError:
            # Keep unavailable values rather than emitting non-finite JSON numbers.
            result['aggregationErrorCount'] = 1
        else:
            result['cumulativeSeconds'] = cumulative
            result['status'] = 'complete' if (
                result['pairedCount'] == result['traceCount']
                and result['collectionAvailability'] in (None, 'complete')
            ) else 'partial'
    early_result = result['earlyStartup']
    early_result['pairedCount'] = len(early_pairs)
    if early_pairs:
        try:
            early_result['cumulativeSeconds'] = {
                key: math.fsum(pair[key] for pair in early_pairs) for key in EARLY_PHASES
            }
        except OverflowError:
            early_result['aggregationErrorCount'] = 1
        else:
            early_result['status'] = 'complete' if (
                len(early_pairs) == result['traceCount']
                and result['collectionAvailability'] in (None, 'complete')
            ) else 'partial'
    return result


def parse_cases(log):
    cases = []
    for line in log.splitlines():
        match = SERIAL.search(line) or PARALLEL.search(line)
        if match:
            cls, method, status, seconds = match.groups()
            cases.append({'class': cls, 'test': method, 'result': status, 'seconds': float(seconds)})
    return cases


def report(log, summary, workers, startup_profiles=None):
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
            'slowest': sorted(cases, key=lambda c: -c['seconds'])[:10],
            'startupProfiling': startup_profiling(log, startup_profiles)}


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
    startup = data.get('startupProfiling')
    if startup is not None:
        lines += ['', f"Startup profiling: {startup['status']}; paired {startup['pairedCount']} of {startup['traceCount']} launch traces."]
        cumulative = startup['cumulativeSeconds']
        if cumulative is None:
            lines += ['App bootstrap and unattributed launch time are unavailable; missing records do not represent zero time.']
        else:
            lines += [
                f"For the {startup['pairedCount']} paired calls only, cumulative launch time was {cumulative['launch']:.3f}s: "
                f"recorded app bootstrap {cumulative['appBootstrap']:.3f}s and unattributed launch time {cumulative['unattributedLaunch']:.3f}s.",
                'These totals add paired calls across workers; they are not wall time or estimates for unpaired launches.',
                '', '| Recorded app bootstrap phase | Cumulative seconds (paired calls only) |', '| --- | ---: |',
            ]
            labels = ('Dependencies', 'Preferences', 'Fixture/database setup', 'Other will-finish work',
                      'Storyboard/lifecycle gap', 'Did-finish work', 'Readiness after did-finish')
            lines += [f"| {label} | {cumulative['phases'][key]:.3f} |" for key, label in zip(PHASE_NAMES, labels)]
        lines += [
            'App bootstrap runs from will-finish entry through the latest of did-finish completion, app-active, and initial-view appearance. '
            'This measures lifecycle and appearance callbacks; it does not establish when the first frame rendered.',
            'Unattributed launch time is the surrounding launch-call duration minus recorded app bootstrap. '
            'It can include work before the first app callback, termination, XCTest automation, and idle time; these records do not isolate their costs.',
            f"Data quality: missing profiles {startup['missingProfileCount']}; incomplete profiles {startup['incompleteProfileCount']}; "
            f"invalid traces {startup['invalidTraceCount']}; invalid profiles {startup['invalidProfileCount']}; "
            f"duplicate trace IDs {startup['duplicateTraceCount']}; duplicate profile IDs {startup['duplicateProfileCount']}; "
            f"profiles outside the launch clock window {startup['outsideWindowCount']}.",
        ]
        if startup['collectionAvailability'] is not None:
            lines += [f"Profile collection availability: {startup['collectionAvailability']}."]
        if startup['aggregationErrorCount']:
            lines += ['Paired cumulative times are unavailable because their sum exceeds the supported numeric range.']
        early = startup['earlyStartup']
        lines += ['', f"Early startup profiling: {early['status']}; paired {early['pairedCount']} of {startup['traceCount']} launch traces."]
        if early['cumulativeSeconds'] is None:
            lines += ['Process-entry and delegate intervals are unavailable; older or missing markers do not represent zero time.']
        else:
            labels = ('Launch call to Swift main entry', 'Main entry to delegate initialization',
                      'Delegate initialization to will-finish entry', 'Recorded ready to launch return')
            lines += ['', '| Launch boundary interval | Cumulative seconds (early-marker pairs only) |', '| --- | ---: |']
            lines += [f"| {label} | {early['cumulativeSeconds'][key]:.3f} |" for key, label in zip(EARLY_PHASES, labels)]
        lines += [
            'Main entry is the first explicit Swift main body marker, after runtime loading. '
            'These boundaries locate elapsed time; they do not isolate termination, runtime loading, UIKit, XCTest automation, or scheduling costs.',
            f"Early marker quality: absent {early['missingMarkerCount']}; incomplete {early['incompleteMarkerCount']}; "
            f"aggregation errors {early['aggregationErrorCount']}.",
        ]
    lines += ['', 'Slowest individual attempts:', '']
    lines += [f"- `{r['class']}/{r['test']}`: {r['seconds']:.1f}s ({r['result']})" for r in data['slowest']]
    return '\n'.join(lines) + '\n'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, required=True)
    parser.add_argument('--summary', type=Path, required=True)
    parser.add_argument('--json', type=Path, required=True)
    parser.add_argument('--startup-profiles', type=Path, help='Directory of app startup UUID.json records for this test phase')
    args = parser.parse_args()
    summary = {}
    if args.summary.exists() and args.summary.stat().st_size:
        summary = json.loads(args.summary.read_text())
    data = report(args.log.read_text() if args.log.exists() else '', summary, os.environ.get('CI_UI_WORKERS', '1'), args.startup_profiles)
    args.json.write_text(json.dumps(data, indent=2) + '\n')
    print(markdown(data), end='')


if __name__ == '__main__':
    main()
