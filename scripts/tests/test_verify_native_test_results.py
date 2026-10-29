import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location('verifier', Path(__file__).resolve().parents[1] / 'verify-native-test-results.py')
verifier = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verifier)


class TestCoverageGate(unittest.TestCase):
    def summary(self, **updates):
        return dict(result='Passed', passedTests=35, totalTestCount=35, failedTests=0,
                    skippedTests=0, expectedFailures=0) | updates

    def test_complete_run_passes(self):
        verifier.validate(self.summary(), 35)

    def test_skipped_failed_and_expected_failures_are_rejected(self):
        for field in ('skippedTests', 'failedTests', 'expectedFailures'):
            with self.subTest(field=field), self.assertRaises(ValueError):
                verifier.validate(self.summary(**{field: 1}), 35)

    def test_missing_new_or_existing_tests_are_rejected(self):
        for expected in (36, 40, 48):
            with self.subTest(expected=expected), self.assertRaises(ValueError):
                verifier.validate(self.summary(), expected)
        with self.assertRaises(ValueError):
            verifier.validate(self.summary(passedTests=34), 35)

    def test_incomplete_result_is_rejected(self):
        for summary in ({}, self.summary(result='Failed'), self.summary(totalTestCount=0)):
            with self.subTest(summary=summary), self.assertRaises(ValueError):
                verifier.validate(summary, 35)

    def test_repository_discovery_preserves_baseline(self):
        self.assertGreaterEqual(verifier.expected_test_count(), 35)
