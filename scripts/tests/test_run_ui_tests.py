from pathlib import Path
import json
import os
import runpy
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'run-ui-tests.py'
MODULE = runpy.run_path(str(SCRIPT))
AX_ERROR = MODULE['AX_ERROR']
ELIGIBLE = MODULE['startup_timeout_only']


def startup_summary():
    return {'result': 'Failed', 'passedTests': 0, 'failedTests': 1, 'skippedTests': 0,
            'totalTestCount': 1, 'expectedFailures': 0, 'testFailures': [{
                'targetName': 'IntrospectiveUITests',
                'testIdentifierString': 'IntrospectiveUITests-Runner (26232) encountered an error',
                'failureText': 'The test runner failed to initialize for UI testing. '
                               f'(Underlying Error: {AX_ERROR})'}]}


class UIStartupRecovery(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.bundle = self.root / 'Tests.xcresult'
        self.log = self.root / 'tests.log'
        self.calls = self.root / 'calls.jsonl'
        self.summary = self.root / 'summary.json'
        self.summary.write_text(json.dumps(startup_summary()))
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.write_command('xcodebuild', '''import json, os, pathlib, sys
root = pathlib.Path(os.environ['RECOVERY_TEST_ROOT'])
with (root / 'calls.jsonl').open('a') as output:
    output.write(json.dumps(['xcodebuild', *sys.argv[1:]]) + '\\n')
counter = root / 'counter'
number = int(counter.read_text()) + 1 if counter.exists() else 1
counter.write_text(str(number))
bundle = pathlib.Path(sys.argv[sys.argv.index('-resultBundlePath') + 1])
bundle.mkdir()
(bundle / 'attempt.txt').write_text(str(number))
mode = os.environ.get('RECOVERY_TEST_MODE', 'startup')
if mode == 'success' or number == 2 and mode != 'repeat':
    print("Test Case '-[UITests testOne]' started.")
    print("Test Case '-[UITests testOne]' passed (0.1 seconds).")
    sys.exit(0)
if mode == 'real':
    print("Test Case '-[UITests testOne]' started.")
if mode == 'other':
    print('The simulator was not found')
else:
    print('The test runner failed to initialize for UI testing. Timed out waiting for AX loaded notification')
sys.exit(65)
''')
        self.write_command('xcrun', '''import json, os, pathlib, sys
root = pathlib.Path(os.environ['RECOVERY_TEST_ROOT'])
with (root / 'calls.jsonl').open('a') as output:
    output.write(json.dumps(['xcrun', *sys.argv[1:]]) + '\\n')
if sys.argv[1] == 'xcresulttool':
    print((root / 'summary.json').read_text())
elif os.environ.get('RECOVERY_TEST_REBOOT_FAIL') == '1':
    print('simulator restart failed', file=sys.stderr)
    sys.exit(2)
''')

    def write_command(self, name, program):
        path = self.bin / name
        path.write_text('#!' + sys.executable + '\n' + program)
        path.chmod(0o755)

    def run_ui(self, mode='startup', workers=1, **extra):
        return subprocess.run([sys.executable, str(SCRIPT), '--log', str(self.log),
                               '--simulator', 'simulator-id', '--workers', str(workers), '--',
                               'xcodebuild', 'test-without-building', '-resultBundlePath', str(self.bundle),
                               '-only-testing:IntrospectiveUITests/Original/testOne',
                               '-only-testing:IntrospectiveUITests/Original/testTwo'],
                              env=dict(os.environ, PATH=str(self.bin) + os.pathsep + os.environ['PATH'],
                                       RECOVERY_TEST_ROOT=str(self.root), RECOVERY_TEST_MODE=mode,
                                       CI_TEST_PROGRESS='1', **extra),
                              capture_output=True, text=True, timeout=10)

    def recorded(self, command):
        return [call for call in map(json.loads, self.calls.read_text().splitlines()) if call[0] == command]

    def test_success_runs_once_without_simulator_commands(self):
        result = self.run_ui('success')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)
        self.assertEqual(self.recorded('xcrun'), [])

    def test_startup_retry_preserves_first_attempt_and_identical_selection(self):
        result = self.run_ui()
        self.assertEqual(result.returncode, 0, result.stderr)
        attempts = self.recorded('xcodebuild')
        self.assertEqual(len(attempts), 2)
        self.assertEqual(attempts[0], attempts[1])
        self.assertIn(AX_ERROR, (self.root / 'tests-startup-failure.log').read_text())
        self.assertEqual((self.root / 'Tests-startup-failure.xcresult/attempt.txt').read_text(), '1')
        self.assertEqual((self.bundle / 'attempt.txt').read_text(), '2')
        self.assertEqual(json.loads((self.root / 'tests-startup-failure.summary.json').read_text()), startup_summary())
        self.assertEqual(self.recorded('xcrun')[1:], [
            ['xcrun', 'simctl', 'shutdown', 'all'], ['xcrun', 'simctl', 'boot', 'simulator-id'],
            ['xcrun', 'simctl', 'bootstatus', 'simulator-id', '-b']])
        self.assertIn('one startup retry', result.stdout)

    def test_second_startup_failure_stays_failed_and_never_retries_again(self):
        result = self.run_ui('repeat')
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 2)
        self.assertIn(AX_ERROR, self.log.read_text())

    def test_started_test_is_never_retried_even_with_an_ax_timeout(self):
        result = self.run_ui('real')
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)
        self.assertEqual(self.recorded('xcrun'), [])

    def test_unrelated_startup_failure_is_not_retried(self):
        result = self.run_ui('other')
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)
        self.assertEqual(self.recorded('xcrun'), [])

    def test_restart_failure_stops_without_running_the_tests_again(self):
        result = self.run_ui(RECOVERY_TEST_REBOOT_FAIL='1')
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)
        self.assertIn('Simulator recovery failed', result.stderr)
        self.assertIn('simulator restart failed', (self.root / 'tests-simulator-recovery.log').read_text())

    def test_parallel_recovery_leaves_template_shut_down_for_xcode_clones(self):
        result = self.run_ui(workers=2)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.recorded('xcrun')[1:], [['xcrun', 'simctl', 'shutdown', 'all']])

    def test_invalid_summary_does_not_authorize_recovery(self):
        self.summary.write_text('invalid JSON')
        result = self.run_ui()
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)

    def test_summary_cannot_hide_a_failed_passed_or_skipped_real_test(self):
        good = startup_summary()
        self.assertTrue(ELIGIBLE(AX_ERROR, good))
        variants = [dict(good, passedTests=1), dict(good, skippedTests=1),
                    dict(good, expectedFailures=1), dict(good, totalTestCount=2),
                    dict(good, failedTests=True), dict(good, testFailures=[])]
        for field, value in [('testIdentifierString', 'Original/testOne()'),
                             ('testIdentifierString', None), ('failureText', None),
                             ('testIdentifierURL', 'test://UI/Original/testOne'),
                             ('targetName', 'OtherTarget'), ('failureText', 'A real assertion failed')]:
            variants.append(dict(good, testFailures=[dict(good['testFailures'][0], **{field: value})]))
        for variant in variants:
            with self.subTest(summary=variant):
                self.assertFalse(ELIGIBLE(AX_ERROR, variant))
        for marker in ["Test Case '-[UI testOne]' started.", "Test case 'UI.testOne()' failed on 'Phone'",
                       "Test Suite 'UI' started."]:
            self.assertFalse(ELIGIBLE(AX_ERROR + '\n' + marker, good))

    def test_existing_diagnostics_are_never_overwritten(self):
        saved = self.root / 'tests-startup-failure.log'
        saved.write_text('keep original diagnostics')
        result = self.run_ui()
        self.assertEqual(result.returncode, 65)
        self.assertEqual(len(self.recorded('xcodebuild')), 1)
        self.assertEqual(saved.read_text(), 'keep original diagnostics')
