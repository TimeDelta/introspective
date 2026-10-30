import importlib.util
import contextlib
import io
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import time
import unittest
from unittest.mock import patch, Mock

SCRIPT = Path(__file__).resolve().parents[1] / 'run-legacy-tests.py'
SPEC = importlib.util.spec_from_file_location('legacy_runner', SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class LegacyStartupWatchdog(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.log = self.root / 'tests.log'
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.write_command('xcodebuild', '''import json, os, pathlib, sys, time
root = pathlib.Path(os.environ['LEGACY_TEST_ROOT'])
(root / 'pid').write_text(str(os.getpid()))
with (root / 'calls.jsonl').open('a') as output:
    output.write(json.dumps(sys.argv[1:]) + '\\n')
mode = os.environ.get('LEGACY_TEST_MODE', 'success')
if mode == 'hang':
    print('Installing test host; no test output yet', flush=True)
    time.sleep(60)
elif mode == 'fail':
    print("Test Case '-[Legacy testOne]' started.", flush=True)
    print('file.swift:1: error: expected a real assertion failure', flush=True)
    sys.exit(23)
else:
    for i in range(500):
        print(f"Test Case '-[Legacy test{i}]' passed (0.1 seconds).", flush=True)
''')
        self.write_command('ps', '''import os, pathlib
pid = int((pathlib.Path(os.environ['LEGACY_TEST_ROOT']) / 'pid').read_text())
print('PID PGID STATE ELAPSED CPU MEM COMMAND')
print(f'{pid} {os.getpgid(pid)} S 00:01 0.0 0.1 /Xcode/xcodebuild')
''')
        self.write_command('sample', '''import pathlib, sys
pathlib.Path(sys.argv[sys.argv.index('-file') + 1]).write_text('captured process sample')
''')
        self.write_command('xcrun', '''import os, sys
print(' '.join(sys.argv[1:]))
sys.exit(2 if os.environ.get('LEGACY_DIAG_FAIL') == '1' else 0)
''')

    def write_command(self, name, code):
        path = self.bin / name
        path.write_text('#!' + sys.executable + '\n' + code)
        path.chmod(0o755)

    def arguments(self, timeout='2'):
        return [sys.executable, str(SCRIPT), '--log', str(self.log), '--simulator', 'simulator-id',
                '--startup-timeout', timeout, '--', 'xcodebuild', 'test-without-building',
                '-scheme', 'CI-CD', 'literal $(not-a-command)']

    def environment(self, mode, **extra):
        return dict(os.environ, PATH=str(self.bin) + os.pathsep + os.environ['PATH'],
                    LEGACY_TEST_ROOT=str(self.root), LEGACY_TEST_MODE=mode, CI_TEST_PROGRESS='1', **extra)

    def run_legacy(self, mode='success', timeout='2', **extra):
        return subprocess.run(self.arguments(timeout), env=self.environment(mode, **extra),
                              capture_output=True, text=True, timeout=10)

    def assert_child_stopped(self):
        pid = int((self.root / 'pid').read_text())
        # A killed adopted child may remain as a zombie until the host reaps it.
        result = subprocess.run(['/bin/ps', '-o', 'stat=', '-p', str(pid)], capture_output=True, text=True)
        self.assertTrue(result.returncode != 0 or result.stdout.strip().startswith('Z'), result.stdout)

    def test_normal_run_preserves_selection_and_full_log_without_live_case_streaming(self):
        result = self.run_legacy()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(self.log.read_text().splitlines()), 500)
        self.assertLessEqual(len(result.stdout.splitlines()), 40)
        calls = list(map(json.loads, (self.root / 'calls.jsonl').read_text().splitlines()))
        self.assertEqual(calls, [['test-without-building', '-scheme', 'CI-CD', 'literal $(not-a-command)']])

    def test_actual_failure_status_and_diagnostics_are_preserved(self):
        result = self.run_legacy('fail')
        self.assertEqual(result.returncode, 23)
        self.assertIn('expected a real assertion failure', result.stderr)
        self.assertIn('expected a real assertion failure', self.log.read_text())

    def test_startup_stall_captures_diagnostics_stops_process_and_does_not_retry(self):
        result = self.run_legacy('hang', timeout='0.5')
        self.assertEqual(result.returncode, 124, result.stderr)
        self.assertIn('did not start testing', result.stdout)
        diagnostics = self.root / 'tests-startup-diagnostics'
        self.assertIn('xcodebuild', (diagnostics / 'processes.txt').read_text())
        self.assertEqual((diagnostics / 'xcodebuild.sample.txt').read_text(), 'captured process sample')
        self.assertIn('simctl list', (diagnostics / 'simulators.json').read_text())
        self.assertIn('user/foreground/com.apple.testmanagerd', (diagnostics / 'testmanagerd.txt').read_text())
        self.assertEqual(len((self.root / 'calls.jsonl').read_text().splitlines()), 1)
        self.assert_child_stopped()

    def test_old_log_activity_does_not_hide_a_new_startup_stall(self):
        self.log.write_text("Test Suite 'Previous run' started.\n")
        result = self.run_legacy('hang', timeout='0.5')
        self.assertEqual(result.returncode, 124)
        self.assertNotIn('Previous run', self.log.read_text())
        self.assert_child_stopped()

    def test_diagnostic_command_failure_still_stops_the_stalled_process(self):
        result = self.run_legacy('hang', timeout='0.5', LEGACY_DIAG_FAIL='1')
        self.assertEqual(result.returncode, 124)
        self.assert_child_stopped()

    def test_cancellation_cleans_up_the_command_process_group(self):
        with subprocess.Popen(self.arguments('60'), env=self.environment('hang'),
                              stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as process:
            try:
                deadline = time.monotonic() + 3
                while not (self.root / 'pid').exists() and time.monotonic() < deadline:
                    time.sleep(0.01)
                self.assertTrue((self.root / 'pid').exists())
                process.send_signal(signal.SIGTERM)
                process.communicate(timeout=5)
                self.assertEqual(process.returncode, 143)
                self.assert_child_stopped()
            finally:
                if process.poll() is None:
                    process.kill()
                    process.communicate()

    def test_startup_budget_is_disabled_after_test_activity_begins(self):
        process = Mock()
        process.poll.return_value = None
        process.wait.return_value = 0
        with patch.object(MODULE.subprocess, 'Popen', return_value=process), \
                patch.object(MODULE.TestActivityReader, 'started', return_value=True), \
                patch.object(MODULE.time, 'monotonic', return_value=0), \
                patch.object(MODULE, 'stop') as stop:
            self.assertEqual(MODULE.run(self.log, ['xcodebuild'], 'sim', 0.001), 0)
            process.wait.assert_called_once_with()
            stop.assert_not_called()

    def test_log_reader_handles_incremental_and_split_test_activity(self):
        reader = MODULE.TestActivityReader(self.log)
        self.assertFalse(reader.started())
        self.log.write_bytes(b'Installing host\nTe')
        self.assertFalse(reader.started())
        with self.log.open('ab') as log:
            log.write(b"st Case '-[Legacy testOne]' started.\n")
        self.assertTrue(reader.started())

    def test_unbounded_or_invalid_startup_budgets_are_rejected(self):
        for value in ['0', '-1', 'nan', 'inf']:
            with self.subTest(timeout=value):
                result = self.run_legacy(timeout=value)
                self.assertEqual(result.returncode, 2)
        self.assertFalse((self.root / 'calls.jsonl').exists())

    def test_ready_handshake_gets_a_separate_budget_for_first_test_activity(self):
        process = Mock(pid=12345)
        process.poll.return_value = None
        process.wait.return_value = 0
        readiness = Mock()
        readiness.ready.return_value = True
        clock = [0.0]
        def advance(_duration):
            clock[0] += 6
        with patch.object(MODULE.subprocess, 'Popen', return_value=process), \
                patch.object(MODULE.TestActivityReader, 'started', side_effect=[False, False, True]), \
                patch.object(MODULE, 'RunnerReadinessReader', return_value=readiness), \
                patch.object(MODULE.time, 'monotonic', side_effect=lambda: clock[0]), \
                patch.object(MODULE.time, 'sleep', side_effect=advance), patch.object(MODULE, 'stop') as stop, \
                contextlib.redirect_stdout(io.StringIO()) as output:
            self.assertEqual(MODULE.run(self.log, ['xcodebuild'], 'sim', 5), 0)
            self.assertIn('completed the XCTest handshake', output.getvalue())
            readiness.ready.assert_called_once_with()
            stop.assert_not_called()

    def test_repeated_ready_notifications_cannot_extend_the_second_budget(self):
        process = Mock(pid=12345)
        process.poll.return_value = None
        readiness = Mock()
        readiness.ready.return_value = True
        clock = [0.0]
        def advance(_duration):
            clock[0] += 121
        with patch.object(MODULE.subprocess, 'Popen', return_value=process), \
                patch.object(MODULE.TestActivityReader, 'started', return_value=False), \
                patch.object(MODULE, 'RunnerReadinessReader', return_value=readiness), \
                patch.object(MODULE.time, 'monotonic', side_effect=lambda: clock[0]), \
                patch.object(MODULE.time, 'sleep', side_effect=advance), patch.object(MODULE, 'stop') as stop, \
                patch.object(MODULE, 'startup_diagnostics'), contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(MODULE.run(self.log, ['xcodebuild'], 'sim', 5), 124)
            readiness.ready.assert_called_once_with()
            stop.assert_called_once_with(process)

    def test_readiness_uses_only_new_incremental_session_handshakes(self):
        bundle = self.root / 'Tests.xcresult'
        session = bundle / 'Staging/1_Test/Diagnostics/Session-tests.log'
        session.parent.mkdir(parents=True)
        session.write_text('Telling test runner to start executing tests.\n')
        readiness = MODULE.RunnerReadinessReader(bundle)
        self.assertFalse(readiness.ready(), 'Old startup progress must not grant extra time')
        with session.open('a') as stream:
            stream.write('Telling test runner to start exec')
        self.assertFalse(readiness.ready())
        with session.open('a') as stream:
            stream.write('uting tests.\n')
        self.assertTrue(readiness.ready())

    def test_new_session_log_reports_ready_after_monitoring_started(self):
        bundle = self.root / 'Tests.xcresult'
        readiness = MODULE.RunnerReadinessReader(bundle)
        self.assertFalse(readiness.ready())
        session = bundle / 'Staging/1_Test/Diagnostics/Session-tests.log'
        session.parent.mkdir(parents=True)
        session.write_text('_IDE_startExecutingTestPlanWithProtocolVersion:36\n')
        self.assertTrue(readiness.ready())

    def test_macos_permission_error_during_final_group_cleanup_preserves_timeout(self):
        process = Mock(pid=12345)
        process.poll.return_value = None
        process.wait.return_value = 0
        readiness = Mock()
        readiness.ready.return_value = False
        with patch.object(MODULE.subprocess, 'Popen', return_value=process), \
                patch.object(MODULE.TestActivityReader, 'started', return_value=False), \
                patch.object(MODULE, 'RunnerReadinessReader', return_value=readiness), \
                patch.object(MODULE.time, 'monotonic', side_effect=[0, 10]), \
                patch.object(MODULE, 'startup_diagnostics'), \
                patch.object(MODULE.os, 'killpg', side_effect=[None, PermissionError('Operation not permitted')]), \
                contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()) as errors:
            self.assertEqual(MODULE.run(self.log, ['xcodebuild'], 'sim', 5), 124)
            self.assertIn('Cannot signal test process group', errors.getvalue())

    def test_denied_group_signal_falls_back_to_the_owned_wrapper(self):
        process = Mock(pid=12345)
        process.poll.side_effect = [None, 0]
        with patch.object(MODULE.os, 'killpg', side_effect=PermissionError('Operation not permitted')), \
                contextlib.redirect_stderr(io.StringIO()):
            MODULE.stop(process)
            process.send_signal.assert_called_once_with(signal.SIGINT)
