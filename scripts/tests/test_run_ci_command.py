from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

RUNNER = Path(__file__).resolve().parents[1] / 'run-ci-command.sh'


class TestCommandCapture(unittest.TestCase):
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

    def test_arguments_are_passed_without_shell_evaluation(self):
        with tempfile.TemporaryDirectory() as directory:
            log = Path(directory) / 'build.log'
            literal = 'spaces $(not-a-command) $HOME ;'
            result = subprocess.run([str(RUNNER), str(log), sys.executable, '-c',
                                     'import sys; print(sys.argv[1])', literal], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0)
            self.assertEqual(log.read_text().strip(), literal)
