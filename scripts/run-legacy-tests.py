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
RUNNER_READY = re.compile(rb'Telling test runner to start executing tests\.|'
                          rb'_IDE_startExecutingTestPlanWithProtocolVersion:')


class TestActivityReader:
    def __init__(self, path, pattern=TEST_ACTIVITY):
        self.path = path
        self.pattern = pattern
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
        return self.pattern.search(text) is not None


class RunnerReadinessReader:
    def __init__(self, bundle):
        self.bundle = bundle
        self.readers = {}
        # Do not treat a previous attempt's handshake as new progress.
        for path in self.paths():
            reader = TestActivityReader(path, RUNNER_READY)
            reader.offset = path.stat().st_size
            self.readers[path] = reader

    def paths(self):
        return self.bundle.glob('Staging/**/Session*.log') if self.bundle else []

    def ready(self):
        for path in self.paths():
            if path not in self.readers:
                self.readers[path] = TestActivityReader(path, RUNNER_READY)
            if self.readers[path].started():
                return True
        return False


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
                        directory / 'sample.log', timeout=30)
                break
    capture(['xcrun', 'simctl', 'list', 'devices', 'available', '--json'], directory / 'simulators.json')
    capture(['xcrun', 'simctl', 'spawn', simulator, 'launchctl', 'print',
             'user/foreground/com.apple.testmanagerd'], directory / 'testmanagerd.txt')


def stop(process):
    # xcodebuild and the logging wrapper share this private process group.
    # Give Xcode a chance to finalize its result bundle before forcing exit.
    def signal_group(sig):
        try:
            os.killpg(process.pid, sig)
        except ProcessLookupError:
            return
        except PermissionError as error:
            # macOS can leave a protected process in the group after our wrapper
            # has exited. Keep the timeout failure rather than raising a second
            # exception, and still signal our directly owned process if alive.
            print(f'::warning::Cannot signal test process group {process.pid}: {error}', file=sys.stderr)
            if process.poll() is None:
                try:
                    process.send_signal(sig)
                except (ProcessLookupError, PermissionError) as child_error:
                    print(f'::warning::Cannot signal test wrapper: {child_error}', file=sys.stderr)

    for sig, grace in ((signal.SIGINT, 30), (signal.SIGTERM, 5), (signal.SIGKILL, 5)):
        signal_group(sig)
        try:
            process.wait(timeout=grace)
            break
        except subprocess.TimeoutExpired:
            pass
    # The wrapper may exit before its child; remove any remaining group members.
    signal_group(signal.SIGKILL)


def run(log, command, simulator, startup_timeout, ready_timeout=120):
    log.parent.mkdir(parents=True, exist_ok=True)
    log.write_bytes(b'')  # A previous run's activity must not disable startup monitoring.
    env = dict(os.environ, CI_TEST_PROGRESS='0')
    bundle_index = command.index('-resultBundlePath') if '-resultBundlePath' in command else None
    bundle = Path(command[bundle_index + 1]) if bundle_index is not None else None
    readiness = RunnerReadinessReader(bundle)
    process = subprocess.Popen([str(ROOT / 'run-ci-command.sh'), str(log), *command],
                               env=env, start_new_session=True)
    reader = TestActivityReader(log)
    deadline = time.monotonic() + startup_timeout
    runner_ready = False
    try:
        while process.poll() is None:
            if reader.started():
                # XCTest's per-case timeouts and the workflow's execution-stage
                # budget apply after startup. No per-result polling is needed.
                return process.wait()
            now = time.monotonic()
            if not runner_ready and readiness.ready():
                runner_ready = True
                deadline = now + ready_timeout
                print(f'Legacy test host completed the XCTest handshake; allowing {ready_timeout:g} seconds '
                      'for the first test activity.', flush=True)
            if now >= deadline:
                phase = 'after the XCTest handshake' if runner_ready else 'during test-host launch'
                budget = ready_timeout if runner_ready else startup_timeout
                print(f'::error::Legacy test host did not start testing {phase} within {budget:g} seconds. '
                      'Capturing diagnostics and stopping this attempt.', flush=True)
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
    parser.add_argument('--ready-timeout', type=float, default=120)
    parser.add_argument('command', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ['--'] else args.command
    if any(not math.isfinite(value) or value <= 0 for value in (args.startup_timeout, args.ready_timeout)):
        parser.error('Startup budgets must be finite and positive')
    if not command or Path(command[0]).name != 'xcodebuild' or 'test-without-building' not in command:
        parser.error('Expected xcodebuild test-without-building')
    if '-resultBundlePath' in command and command.index('-resultBundlePath') + 1 >= len(command):
        parser.error('Missing result bundle path')
    # GitHub can cancel the stage independently of the job. Clean up the private
    # process group on TERM as well as Python's normal KeyboardInterrupt on INT.
    def terminate(signum, _frame):
        raise SystemExit(128 + signum)
    signal.signal(signal.SIGTERM, terminate)
    return run(args.log, command, args.simulator, args.startup_timeout, args.ready_timeout)


if __name__ == '__main__':
    sys.exit(main())
