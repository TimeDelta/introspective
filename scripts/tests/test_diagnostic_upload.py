from pathlib import Path
import os
import subprocess
import sys
import unittest

GATE = Path(__file__).resolve().parents[2] / '.github/actions/upload-diagnostics/check-upload.py'


class DiagnosticUploadGateTests(unittest.TestCase):
    def run_gate(self, first='', second='', third=''):
        return subprocess.run([sys.executable, str(GATE)], capture_output=True, text=True,
                              env=dict(os.environ, UPLOAD_FIRST=first, UPLOAD_SECOND=second, UPLOAD_THIRD=third))

    def test_initial_success_needs_no_retry(self):
        result = self.run_gate('success', 'skipped', 'skipped')
        self.assertEqual(result.returncode, 0)
        self.assertIn('attempt 1', result.stdout)

    def test_transport_failures_can_recover_on_either_retry(self):
        for outcomes in [('failure', 'success', 'skipped'), ('failure', 'failure', 'success')]:
            with self.subTest(outcomes=outcomes):
                self.assertEqual(self.run_gate(*outcomes).returncode, 0)

    def test_exhausted_retries_fail_the_job(self):
        result = self.run_gate('failure', 'failure', 'failure')
        self.assertEqual(result.returncode, 1)
        self.assertIn('::error::No diagnostic upload succeeded', result.stderr)

    def test_missing_cancelled_or_skipped_attempts_never_count_as_success(self):
        for outcomes in [('', '', ''), ('skipped', 'skipped', 'skipped'),
                         ('cancelled', '', ''), ('failure', 'skipped', '')]:
            with self.subTest(outcomes=outcomes):
                self.assertNotEqual(self.run_gate(*outcomes).returncode, 0)
