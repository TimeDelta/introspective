#!/usr/bin/env python3
"""Recover once from XCTest's AX startup timeout before any test has run."""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
AX_ERROR = 'Timed out waiting for AX loaded notification'
RUNNER_ERROR = re.compile(r'^IntrospectiveUITests-Runner \(\d+\) encountered an error$')
TEST_ACTIVITY = re.compile(r'^\s*Test (?:Case|case|Suite|suite)\b', re.MULTILINE)


def startup_timeout_only(log, summary):
    """Xcode counts its synthetic runner error as one failed test. Fail closed."""
    if AX_ERROR not in log or TEST_ACTIVITY.search(log):
        return False
    if not isinstance(summary, dict) or summary.get('result') != 'Failed':
        return False
    for field in ('passedTests', 'skippedTests', 'expectedFailures'):
        if type(summary.get(field)) is not int or summary[field] != 0:
            return False
    failures = summary.get('testFailures')
    if not isinstance(failures, list) or len(failures) != 1:
        return False
    for field in ('failedTests', 'totalTestCount'):
        if type(summary.get(field)) is not int or summary[field] != 1:
            return False
    failure = failures[0]
    if not isinstance(failure, dict):
        return False
    identifier = failure.get('testIdentifierString')
    message = failure.get('failureText')
    if not isinstance(identifier, str) or not isinstance(message, str):
        return False
    return (failure.get('targetName') == 'IntrospectiveUITests'
            and RUNNER_ERROR.fullmatch(identifier) is not None
            and not failure.get('testIdentifierURL')
            and 'The test runner failed to initialize for UI testing.' in message
            and AX_ERROR in message)


def summary_for(bundle):
    try:
        result = subprocess.run(['xcrun', 'xcresulttool', 'get', 'test-results', 'summary',
                                 '--path', str(bundle)], capture_output=True, text=True, timeout=30)
        return json.loads(result.stdout) if result.returncode == 0 else None
    except (ValueError, OSError, subprocess.TimeoutExpired):
        return None


def recovery_path(path):
    return path.with_name(path.stem + '-startup-failure' + path.suffix)


def restart_simulator(simulator, workers, log):
    commands = [['xcrun', 'simctl', 'shutdown', 'all']]
    if workers == 1:
        commands += [['xcrun', 'simctl', 'boot', simulator],
                     ['xcrun', 'simctl', 'bootstatus', simulator, '-b']]
    # Parallel UI workers boot their own clones from the shut-down template.
    with log.open('w') as output:
        for command in commands:
            print('Recovery command: ' + ' '.join(command), file=output, flush=True)
            try:
                result = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT, timeout=120)
            except (OSError, subprocess.TimeoutExpired) as error:
                print(str(error), file=output)
                return False
            if result.returncode:
                return False
    return True


def run(log, command):
    return subprocess.run([str(ROOT / 'run-ci-command.sh'), str(log), *command]).returncode


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, required=True)
    parser.add_argument('--simulator', required=True)
    parser.add_argument('--workers', type=int, choices=(1, 2), required=True)
    parser.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ['--'] else args.command
    if (not command or Path(command[0]).name != 'xcodebuild'
            or 'test-without-building' not in command or command.count('-resultBundlePath') != 1):
        parser.error('Expected xcodebuild test-without-building with one -resultBundlePath')
    index = command.index('-resultBundlePath')
    if index + 1 >= len(command):
        parser.error('Missing result bundle path')
    bundle = Path(command[index + 1])
    status = run(args.log, command)
    if status == 0:
        return 0
    log_text = args.log.read_text(errors='replace')
    if AX_ERROR not in log_text or TEST_ACTIVITY.search(log_text):
        return status
    summary = summary_for(bundle)
    if not startup_timeout_only(log_text, summary):
        return status
    saved_log, saved_bundle = recovery_path(args.log), recovery_path(bundle)
    # Preserve the failed launch and never overwrite diagnostics from another attempt.
    if saved_log.exists() or saved_bundle.exists() or not bundle.is_dir():
        print('Startup recovery refused: saved diagnostics already exist.', file=sys.stderr)
        return status
    args.log.rename(saved_log)
    bundle.rename(saved_bundle)
    saved_log.with_suffix('.summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    print('::warning::XCTest accessibility startup timed out before any test started. '
          'Preserved diagnostics; restarting the simulator for one startup retry.', flush=True)
    recovery_log = args.log.with_name(args.log.stem + '-simulator-recovery.log')
    if not restart_simulator(args.simulator, args.workers, recovery_log):
        print('Simulator recovery failed; see ' + str(recovery_log), file=sys.stderr)
        return status
    # Identical selectors and result path; the workflow still verifies the entire suite.
    # There is deliberately no loop: a second initialization failure remains a failure.
    return run(args.log, command)


if __name__ == '__main__':
    sys.exit(main())
