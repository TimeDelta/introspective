import itertools
from pathlib import Path
import runpy
import subprocess
import sys
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / 'verify-ci-job-results.py'
VALIDATE = runpy.run_path(str(SCRIPT))['validate']


class RequiredCIJobs(unittest.TestCase):
    def test_full_ci_cannot_pass_with_failed_cancelled_or_skipped_preparation_or_shards(self):
        for suite in ('', 'all'):
            VALIDATE(suite, 'success', 'success', 'success')
            for job in range(3):
                for state in ('failure', 'cancelled', 'skipped', '', None):
                    results = ['success'] * 3
                    results[job] = state
                    with self.subTest(suite=suite, job=job, state=state), self.assertRaises(ValueError):
                        VALIDATE(suite, *results)

    def test_ui_only_requires_preparation_and_tests_without_unrelated_validation(self):
        VALIDATE('ui', 'skipped', 'success', 'success')
        for state in ('failure', 'cancelled', 'skipped', ''):
            with self.subTest(state=state):
                with self.assertRaises(ValueError):
                    VALIDATE('ui', 'skipped', state, 'success')
                with self.assertRaises(ValueError):
                    VALIDATE('ui', 'skipped', 'success', state)
        with self.assertRaises(ValueError):
            VALIDATE('ui', 'success', 'success', 'success')

    def test_non_ui_suites_require_validation_and_only_deliberately_skip_ui(self):
        for suite in ('focused', 'legacy', 'mocks'):
            VALIDATE(suite, 'success', 'skipped', 'skipped')
            for state in ('failure', 'cancelled', 'skipped', ''):
                with self.subTest(suite=suite, state=state), self.assertRaises(ValueError):
                    VALIDATE(suite, state, 'skipped', 'skipped')
            with self.assertRaises(ValueError):
                VALIDATE(suite, 'success', 'success', 'skipped')
            with self.assertRaises(ValueError):
                VALIDATE(suite, 'success', 'skipped', 'success')

    def test_no_suite_can_report_success_when_all_jobs_are_skipped(self):
        for suite in ('', 'all', 'ui', 'focused', 'legacy', 'mocks'):
            with self.subTest(suite=suite), self.assertRaises(ValueError):
                VALIDATE(suite, 'skipped', 'skipped', 'skipped')

    def test_job_result_combinations_have_only_the_selected_success_path(self):
        valid = {
            '': ('success', 'success', 'success'),
            'all': ('success', 'success', 'success'),
            'ui': ('skipped', 'success', 'success'),
            'legacy': ('success', 'skipped', 'skipped'),
            'focused': ('success', 'skipped', 'skipped'),
            'mocks': ('success', 'skipped', 'skipped'),
        }
        states = ('success', 'failure', 'cancelled', 'skipped', '')
        for suite, accepted in valid.items():
            for results in itertools.product(states, repeat=3):
                with self.subTest(suite=suite, results=results):
                    if results == accepted:
                        VALIDATE(suite, *results)
                    else:
                        with self.assertRaises(ValueError):
                            VALIDATE(suite, *results)

    def test_unknown_suite_is_rejected_instead_of_silently_omitting_ui(self):
        for suite in ('typo', 'UI', None):
            with self.subTest(suite=suite), self.assertRaisesRegex(ValueError, 'Unknown CI suite'):
                VALIDATE(suite, 'success', 'skipped', 'skipped')

    def test_cli_failure_exit_keeps_failed_shared_build_visible(self):
        command = [sys.executable, str(SCRIPT), '--suite', 'ui', '--validation', 'skipped',
                   '--ui-build', 'failure', '--ui-tests', 'skipped']
        failed = subprocess.run(command, capture_output=True, text=True)
        self.assertNotEqual(failed.returncode, 0)
        self.assertIn('Shared UI build', failed.stderr)
        self.assertIn('::error::', failed.stderr)
        command[-3] = 'success'
        command[-1] = 'success'
        passed = subprocess.run(command, capture_output=True, text=True)
        self.assertEqual(passed.returncode, 0, passed.stderr)


if __name__ == '__main__':
    unittest.main()
