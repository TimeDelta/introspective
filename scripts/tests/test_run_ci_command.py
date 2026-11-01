from pathlib import Path
import os
import select
import subprocess
import sys
import tempfile
import unittest

RUNNER = Path(__file__).resolve().parents[1] / 'run-ci-command.sh'


class TestCommandCapture(unittest.TestCase):
    def test_progress_arrives_before_exit_and_preserves_failure_and_full_log(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'tests.log'
            release = Path(directory) / 'release'
            progress = "Test case 'Example.testOne()' passed on 'Clone 1 of iPhone' (1.000 seconds)"
            program = '''import pathlib, sys, time
print('verbose diagnostic retained in artifact', flush=True)
print(sys.argv[2], flush=True)
deadline = time.monotonic() + 5
while not pathlib.Path(sys.argv[1]).exists() and time.monotonic() < deadline:
    time.sleep(0.01)
sys.exit(23)
'''
            with subprocess.Popen([str(RUNNER), str(log), sys.executable, '-c', program,
                                   str(release), progress], env=dict(os.environ, CI_TEST_PROGRESS='1'),
                                  stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as process:
                try:
                    ready, _, _ = select.select([process.stdout], [], [], 3)
                    self.assertTrue(ready, 'Progress was buffered until command exit')
                    self.assertEqual(process.stdout.readline().strip(), progress)
                    self.assertIsNone(process.poll())
                finally:
                    release.touch()
                    _, errors = process.communicate(timeout=3)
                self.assertEqual(process.returncode, 23)
                self.assertIn('verbose diagnostic retained in artifact', log.read_text())
                self.assertIn('verbose diagnostic retained in artifact', errors)

    def test_full_log_is_preserved_and_console_output_is_bounded(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'build.log'
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c',
                                     'for i in range(500): print("line", i)'], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0)
            self.assertIn('line 0\n', log.read_text())
            self.assertIn('line 499\n', log.read_text())
            self.assertLessEqual(len(result.stdout.splitlines()), 40)

    def test_failure_status_and_stderr_are_preserved(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'build.log'
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c',
                                     'import sys; print("compiler error", file=sys.stderr); sys.exit(7)'], capture_output=True, text=True)
            self.assertEqual(result.returncode, 7)
            self.assertIn('compiler error', result.stderr)
            self.assertIn('compiler error', log.read_text())

    def test_early_compiler_errors_remain_visible_after_long_timing_summaries(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'build.log'
            program = 'import sys; print("file.swift:1: error: missing dependency"); [print("timing", i) for i in range(500)]; sys.exit(65)'
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c', program],
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 65)
            self.assertIn('error: missing dependency', result.stderr)
            self.assertIn('timing 499', result.stderr)
            self.assertLessEqual(len(result.stderr.splitlines()), 120)

    def test_arguments_are_passed_without_shell_evaluation(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'build.log'
            literal = 'spaces $(not-a-command) $HOME ;'
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c',
                                     'import sys; print(sys.argv[1])', literal], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0)
            self.assertEqual(log.read_text().strip(), literal)

    def test_assertions_and_failed_cases_remain_visible_after_framework_errors(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'tests.log'
            messages = [
                'XCTest issue in -[QueryTests testRestore]: XCTAssertEqual failed: 2 != 1',
                'QueryTests.swift:42: error: -[QueryTests testRestore] : XCTAssertEqual failed',
                "Test Case '-[QueryTests testRestore]' failed (0.010 seconds).",
            ]
            program = '''import sys
for i in range(80): print('CoreData: error: startup diagnostic', i)
for message in sys.argv[1:]: print(message)
for i in range(500): print('timing', i)
sys.exit(65)
'''
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c', program, *messages],
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 65)
            for message in messages:
                self.assertIn(message, result.stderr)
            self.assertNotIn('CoreData: error:', result.stderr)
            self.assertEqual(log.read_text().count('CoreData: error:'), 80)
            self.assertLessEqual(len(result.stderr.splitlines()), 120)
