#!/usr/bin/env python3
"""Capture legacy results quietly and bound test-host startup, without retrying tests."""
import argparse
import math
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
TEST_ACTIVITY = re.compile(rb'^\s*Test (?:Case|case|Suite|suite)\b', re.MULTILINE)


class TestActivityReader:
    def __init__(self, path):
        self.path = path
        self.offset = 0
        self.tail = b''

    def started(self):
        try:
            with self.path.open('rb') as stream:
                stream.seek(self.offset)
                chunk = stream.read()
                self.offset = stream.tell()
        except FileNotFoundError:
            return False
        text = self.tail + chunk
        self.tail = text[-256:]
        return TEST_ACTIVITY.search(text) is not None


def capture(command, path, timeout=10):
    with path.open('w') as output:
        try:
            result = subprocess.run(command, stdout=output, stderr=subprocess.STDOUT, timeout=timeout)
            return result.returncode
        except (OSError, subprocess.TimeoutExpired) as error:
            print(str(error), file=output)
            return None


def startup_diagnostics(process, simulator, directory):
    directory.mkdir(parents=True, exist_ok=True)
    processes = directory / 'processes.txt'
    capture(['ps', '-axo', 'pid,pgid,state,etime,%cpu,%mem,command'], processes)
    # Sample only xcodebuild processes owned by this command's process group.
    # Diagnostic failures must not prevent terminating the stalled test host.
    if processes.exists():
        for line in processes.read_text(errors='replace').splitlines()[1:]:
            parts = line.split(None, 6)
            if (len(parts) == 7 and parts[0].isdigit() and parts[1] == str(process.pid)
                    and Path(parts[6].split()[0]).name == 'xcodebuild'):
                capture(['sample', parts[0], '3', '1', '-file', str(directory / 'xcodebuild.sample.txt')],
                        directory / 'sample.log')
                break
    capture(['xcrun', 'simctl', 'list', 'devices', 'available', '--json'], directory / 'simulators.json')
    capture(['xcrun', 'simctl', 'spawn', simulator, 'launchctl', 'print',
             'system/com.apple.testmanagerd'], directory / 'testmanagerd.txt')


def stop(process):
    # xcodebuild and the logging wrapper share this private process group.
    # Give Xcode a chance to finalize its result bundle before forcing exit.
    for sig, grace in ((signal.SIGINT, 30), (signal.SIGTERM, 5), (signal.SIGKILL, 5)):
        try:
            os.killpg(process.pid, sig)
        except ProcessLookupError:
            break
        try:
            process.wait(timeout=grace)
            break
        except subprocess.TimeoutExpired:
            pass
    # The wrapper may exit before its child; remove any remaining group members.
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass


def run(log, command, simulator, startup_timeout):
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_bytes(b'')  # A previous run's activity must not disable startup monitoring.
    env = dict(os.environ, CI_TEST_PROGRESS='0')
    process = subprocess.Popen([str(ROOT / 'run-ci-command.sh'), str(log), *command],
                               env=env, start_new_session=True)
    reader = TestActivityReader(log)
    deadline = time.monotonic() + startup_timeout
    try:
        while process.poll() is None:
            if reader.started():
                # XCTest's per-case timeouts and the workflow's execution-stage
                # budget apply after startup. No per-result polling is needed.
                return process.wait()
            if time.monotonic() >= deadline:
                print('::error::Legacy test host did not start testing within '
                      f'{startup_timeout:g} seconds. Capturing diagnostics and stopping this attempt.', flush=True)
                try:
                    startup_diagnostics(process, simulator, log.with_name(log.stem + '-startup-diagnostics'))
                finally:
                    stop(process)
                return 124
            time.sleep(min(1, max(0.01, deadline - time.monotonic())))
        return process.returncode
    except BaseException:
        stop(process)
        raise


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log', type=Path, required=True)
    parser.add_argument('--simulator', required=True)
    parser.add_argument('--startup-timeout', type=float, default=300)
    parser.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ['--'] else args.command
    if not math.isfinite(args.startup_timeout) or args.startup_timeout <= 0:
        parser.error('Startup timeout must be finite and positive')
    if not command or Path(command[0]).name != 'xcodebuild' or 'test-without-building' not in command:
        parser.error('Expected xcodebuild test-without-building')
    # GitHub can cancel the stage independently of the job. Clean up the private
    # process group on TERM as well as Python's normal KeyboardInterrupt on INT.
    def terminate(signum, _frame):
        raise SystemExit(128 + signum)
    signal.signal(signal.SIGTERM, terminate)
    return run(args.log, command, args.simulator, args.startup_timeout)


if __name__ == '__main__':
    sys.exit(main())
