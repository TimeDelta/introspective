from collections import Counter
from pathlib import Path
import runpy
import json
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
PARTITIONS = runpy.run_path(str(ROOT / 'partition-ui-tests.py'))
VALIDATE = runpy.run_path(str(ROOT / 'verify-native-test-results.py'))['validate']


class UITestPartitions(unittest.TestCase):
    def test_measured_lane_costs_balance_full_suite_and_preflight(self):
        classes = PARTITIONS['discover_tests']()
        weights = PARTITIONS['CLASS_SECONDS']
        for count in (2, 3):
            with self.subTest(count=count):
                shards = PARTITIONS['partition'](classes, count)
                totals = [sum(weights.get(name, len(classes[name]) * 40) for name in shard)
                          for shard in shards]
                self.assertLess(max(totals) - min(totals), sum(totals) / count * 0.05)

    def test_all_source_classes_and_cases_run_once_across_one_two_or_three_shards(self):
        complete = PARTITIONS['selection']()
        self.assertGreaterEqual(len(complete['tests']), 115)
        self.assertEqual(len(complete['tests']), len(set(complete['tests'])))
        for count in (1, 2, 3):
            with self.subTest(count=count):
                shards = [PARTITIONS['selection'](index, count) for index in range(1, count + 1)]
                self.assertEqual(Counter(name for shard in shards for name in shard['classes']),
                                 Counter(complete['classes']))
                self.assertEqual(Counter(test for shard in shards for test in shard['tests']),
                                 Counter(complete['tests']))
                for shard in shards:
                    self.assertTrue(shard['classes'])
                    self.assertTrue(shard['tests'])
                    self.assertEqual(shard['totalTestCount'], complete['totalTestCount'])
                    self.assertEqual(shard['inventorySHA256'], complete['inventorySHA256'])

    def test_single_runner_keeps_the_entire_suite(self):
        classes = PARTITIONS['discover_tests']()
        data = PARTITIONS['selection'](1, 1)
        self.assertEqual(set(data['classes']), set(classes))
        self.assertEqual(len(data['tests']), sum(map(len, classes.values())))

    def test_assignment_is_deterministic_and_inventory_order_is_irrelevant(self):
        classes = PARTITIONS['discover_tests']()
        for count in (1, 2, 3):
            with self.subTest(count=count):
                forward = PARTITIONS['partition'](classes, count)
                reverse = PARTITIONS['partition'](dict(reversed(list(classes.items()))), count)
                self.assertEqual(forward, reverse)
                self.assertEqual(forward, PARTITIONS['partition'](classes, count))

    def test_new_classes_are_automatically_balanced_by_case_count(self):
        classes = {'NewUITests': ['testOne', 'testTwo', 'testThree'],
                   'OtherUITests': ['testOne', 'testTwo'], 'ThirdUITests': ['testOne']}
        for count in (1, 2, 3):
            with self.subTest(count=count):
                shards = PARTITIONS['partition'](classes, count)
                self.assertEqual(Counter(name for shard in shards for name in shard), Counter(classes.keys()))
                self.assertTrue(all(shards))
                self.assertEqual(shards, PARTITIONS['partition'](dict(reversed(list(classes.items()))), count))
        # The fallback keeps this six-case inventory evenly split across two
        # runners without requiring measured weights for newly added classes.
        self.assertEqual([sum(len(classes[name]) for name in shard)
                          for shard in PARTITIONS['partition'](classes, 2)], [3, 3])

    def test_invalid_shard_requests_fail_instead_of_running_an_empty_suite(self):
        for index, count in [(2, 1), (0, 2), (3, 2), (4, 3), (1, 0), (1, 999)]:
            with self.subTest(index=index, count=count), self.assertRaises(ValueError):
                PARTITIONS['selection'](index, count)

    def test_incomplete_skipped_or_unfiltered_shard_results_fail(self):
        total = PARTITIONS['selection']()['totalTestCount']
        for count in (1, 2, 3):
            for index in range(1, count + 1):
                expected = len(PARTITIONS['selection'](index, count)['tests'])
                summary = dict(result='Passed', passedTests=expected, totalTestCount=expected,
                               skippedTests=0, failedTests=0, expectedFailures=0)
                VALIDATE(summary, expected)
                invalid = [dict(passedTests=expected - 1, totalTestCount=expected - 1), dict(skippedTests=1)]
                if count > 1:
                    invalid.append(dict(passedTests=total, totalTestCount=total))
                for updates in invalid:
                    with self.subTest(count=count, shard=index, updates=updates), self.assertRaises(ValueError):
                        VALIDATE(summary | updates, expected)

    def test_source_inventory_rejects_missing_and_duplicate_declarations(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / 'Example.swift'
            methods = '\n'.join(f'func testCase{i}() {{}}' for i in range(115))
            path.write_text('final class ExampleUITests: UITest {\n' + methods + '\n}')
            self.assertEqual(len(PARTITIONS['discover_tests'](root)['ExampleUITests']), 115)
            path.write_text(path.read_text().replace('func testCase0()', 'func helper()'))
            with self.assertRaises(ValueError):
                PARTITIONS['discover_tests'](root)
            path.write_text('final class ExampleUITests: UITest {\n' + methods + '\nfunc testCase0() {}\n}')
            with self.assertRaises(ValueError):
                PARTITIONS['discover_tests'](root)

    def test_preflight_is_a_nonempty_subset_and_keeps_full_inventory_unchanged(self):
        full = PARTITIONS['selection']()
        expected = {f'IntrospectiveUITests/{name}/{method}'
                    for name, methods in PARTITIONS['PREFLIGHT_TESTS'].items() for method in methods}
        self.assertEqual(len(expected), 14)
        for count in (1, 2, 3):
            selected = []
            for index in range(1, count + 1):
                shard = PARTITIONS['selection'](index, count)
                preflight = PARTITIONS['preflight_selection'](index, count)
                self.assertTrue(preflight['tests'])
                self.assertLess(set(preflight['tests']), set(shard['tests']))
                self.assertEqual(preflight['inventorySHA256'], full['inventorySHA256'])
                self.assertEqual(preflight['totalTestCount'], full['totalTestCount'])
                selected.extend(preflight['tests'])
            self.assertEqual(Counter(selected), Counter(expected))
        self.assertEqual(PARTITIONS['selection'](), full)

    def test_renamed_or_removed_preflight_tests_fail_instead_of_disappearing(self):
        classes = PARTITIONS['discover_tests']()
        name, methods = next(iter(PARTITIONS['PREFLIGHT_TESTS'].items()))
        classes[name].remove(methods[0])
        with self.assertRaisesRegex(ValueError, 'Missing UI preflight'):
            PARTITIONS['preflight_selection'](1, 2, classes)

    def test_preflight_cli_emits_case_selectors_and_cannot_satisfy_full_gate(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            manifest = root / 'selection.json'
            for shard_count in (1, 2, 3):
                for index in range(1, shard_count + 1):
                    with self.subTest(count=shard_count, shard=index):
                        result = subprocess.run([sys.executable, str(ROOT / 'partition-ui-tests.py'),
                                                 '--shard', str(index), '--count', str(shard_count),
                                                 '--preflight', '--json', str(manifest)],
                                                check=True, capture_output=True, text=True)
                        data = json.loads(manifest.read_text())
                        self.assertEqual(result.stdout.splitlines(), data['tests'])
                        self.assertTrue(all(test.count('/') == 2 for test in data['tests']))
                        summary = root / 'summary.json'
                        count = len(data['tests'])
                        summary.write_text(json.dumps(dict(result='Passed', passedTests=count, totalTestCount=count,
                                                           skippedTests=0, failedTests=0, expectedFailures=0)))
                        command = [sys.executable, str(ROOT / 'verify-ui-test-results.py'), str(summary),
                                   '--shard', str(index), '--count', str(shard_count)]
                        self.assertNotEqual(subprocess.run(command, capture_output=True).returncode, 0)
                        self.assertEqual(subprocess.run(command + ['--preflight'], capture_output=True).returncode, 0)
                        for updates in [dict(skippedTests=1), dict(passedTests=count - 1), dict(result='Failed')]:
                            payload = json.loads(summary.read_text()) | updates
                            invalid = root / 'invalid.json'
                            invalid.write_text(json.dumps(payload))
                            bad_command = command.copy()
                            bad_command[2] = str(invalid)
                            self.assertNotEqual(subprocess.run(bad_command + ['--preflight'],
                                                               capture_output=True).returncode, 0)
