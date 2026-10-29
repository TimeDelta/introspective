import runpy
from pathlib import Path
import unittest

REPORTER = runpy.run_path(str(Path(__file__).resolve().parents[1] / 'report-ui-test-timings.py'))


class UITestTimings(unittest.TestCase):
    def test_serial_and_parallel_attempts_are_counted_without_confusing_wall_time(self):
        log = """
Test Case '-[IntrospectiveUITests.ExampleUITests testFirst]' passed (30.000 seconds).
Test case 'OtherUITests.testSecond()' failed on 'Clone 1 of iPhone' (20.000 seconds)
Test case 'OtherUITests.testSecond()' passed on 'Clone 2 of iPhone' (10.000 seconds)
"""
        data = REPORTER['report'](log, {'startTime': 100, 'finishTime': 140, 'totalTestCount': 2}, 2)
        self.assertEqual(data['wallSeconds'], 40)
        self.assertEqual(data['cumulativeSeconds'], 60)
        self.assertEqual(data['recordedCases'], 2)
        self.assertEqual(data['attempts'], 3)
        self.assertEqual(len(data['observedWorkers']), 2)
        self.assertEqual(sum(c['failed'] for c in data['classes']), 1)
        self.assertIn('not wall time', REPORTER['markdown'](data))

    def test_preexecution_failure_has_no_invented_timings(self):
        data = REPORTER['report']('Build failed before tests began', {}, 2)
        self.assertEqual(data['recordedCases'], 0)
        self.assertIsNone(data['wallSeconds'])
        self.assertIn('unavailable', REPORTER['markdown'](data))
