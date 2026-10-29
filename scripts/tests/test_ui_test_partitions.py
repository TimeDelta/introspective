from pathlib import Path
import runpy
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
PARTITIONS = runpy.run_path(str(ROOT / 'partition-ui-tests.py'))
VALIDATE = runpy.run_path(str(ROOT / 'verify-native-test-results.py'))['validate']


class UITestPartitions(unittest.TestCase):
    def test_all_source_cases_run_once_across_both_shards(self):
        complete = PARTITIONS['selection']()
        shards = [PARTITIONS['selection'](index, 2) for index in (1, 2)]
        first, second = [set(shard['tests']) for shard in shards]
        self.assertGreaterEqual(len(complete['tests']), 108)
        self.assertFalse(first & second)
        self.assertEqual(first | second, set(complete['tests']))
        self.assertEqual(len(first) + len(second), complete['totalTestCount'])
        self.assertEqual(shards[0]['inventorySHA256'], shards[1]['inventorySHA256'])

    def test_single_runner_keeps_the_entire_suite(self):
        classes = PARTITIONS['discover_tests']()
        data = PARTITIONS['selection'](1, 1)
        self.assertEqual(set(data['classes']), set(classes))
        self.assertEqual(len(data['tests']), sum(map(len, classes.values())))

    def test_new_classes_are_automatically_included_and_file_order_is_irrelevant(self):
        classes = {'NewUITests': ['testNew'], 'OtherUITests': ['testOne', 'testTwo']}
        forward = PARTITIONS['partition'](classes, 2)
        reverse = PARTITIONS['partition'](dict(reversed(list(classes.items()))), 2)
        self.assertEqual(forward, reverse)
        self.assertEqual(set(name for shard in forward for name in shard), set(classes))

    def test_invalid_shard_requests_fail_instead_of_running_an_empty_suite(self):
        for index, count in [(0, 2), (3, 2), (1, 0), (1, 999)]:
            with self.subTest(index=index, count=count), self.assertRaises(ValueError):
                PARTITIONS['selection'](index, count)

    def test_incomplete_skipped_or_unfiltered_shard_results_fail(self):
        for index in (1, 2):
            expected = len(PARTITIONS['selection'](index, 2)['tests'])
            summary = dict(result='Passed', passedTests=expected, totalTestCount=expected,
                           skippedTests=0, failedTests=0, expectedFailures=0)
            VALIDATE(summary, expected)
            for updates in [dict(passedTests=expected - 1, totalTestCount=expected - 1),
                            dict(skippedTests=1), dict(passedTests=108, totalTestCount=108)]:
                with self.subTest(shard=index, updates=updates), self.assertRaises(ValueError):
                    VALIDATE(summary | updates, expected)

    def test_source_inventory_rejects_missing_and_duplicate_declarations(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / 'Example.swift'
            methods = '\n'.join(f'func testCase{i}() {{}}' for i in range(108))
            path.write_text('final class ExampleUITests: UITest {\n' + methods + '\n}')
            self.assertEqual(len(PARTITIONS['discover_tests'](root)['ExampleUITests']), 108)
            path.write_text(path.read_text().replace('func testCase0()', 'func helper()'))
            with self.assertRaises(ValueError):
                PARTITIONS['discover_tests'](root)
            path.write_text('final class ExampleUITests: UITest {\n' + methods + '\nfunc testCase0() {}\n}')
            with self.assertRaises(ValueError):
                PARTITIONS['discover_tests'](root)
