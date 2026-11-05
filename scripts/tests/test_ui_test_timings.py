import json
import math
import os
import runpy
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import uuid

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

    def test_launch_and_optional_wait_timings_include_all_recorded_attempts(self):
        log = "CI_UI_LAUNCH_SECONDS 2.5\nCI_UI_LAUNCH_SECONDS 3.5\nCI_UI_LAUNCH_SECONDS 1e-4\nCI_UI_INSTRUCTION_WAIT_SECONDS 1.1\n"
        data = REPORTER['report'](log, {}, 1)
        self.assertEqual(data['launchAttempts'], 3)
        self.assertAlmostEqual(data['launchSeconds'], 6.0001)
        self.assertAlmostEqual(data['instructionWaitSeconds'], 1.1)
        self.assertIn('App launch calls: 6.0s across 3 attempts', REPORTER['markdown'](data))
        self.assertIsNone(data['wallSeconds'])

    def test_old_logs_without_markers_do_not_claim_zero_launch_or_wait_cost(self):
        data = REPORTER['report']("Test Case '-[ExampleUITests testFirst]' passed (10.000 seconds).", {}, 1)
        self.assertIsNone(data['launchSeconds'])
        self.assertIsNone(data['instructionWaitSeconds'])
        self.assertNotIn('App launch calls:', REPORTER['markdown'](data))


class StartupProfiling(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.first = 'abcdef01-2345-4567-89ab-cdef01234567'
        self.second = str(uuid.UUID(int=2))

    def trace(self, identity=None, start=100.0, end=120.0, **extra):
        record = {'schema': 1, 'traceID': identity or self.first, 'startUptime': start, 'endUptime': end, **extra}
        return 'CI_UI_LAUNCH_TRACE ' + json.dumps(record) + '\n'

    def profile(self, identity=None, stages=None, filename=None, **extra):
        identity = identity or self.first
        record = {
            'schema': 1, 'traceID': identity,
            'stages': stages if stages is not None else dict(zip(REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES'],
                                                                (102, 103, 105, 108, 109, 110, 112, 113, 114))),
            **extra,
        }
        path = self.directory / (filename or f'{identity}.json')
        path.write_text(json.dumps(record))
        return record

    def early_profile(self, identity=None, entry=100.5, delegate=101.0):
        record = self.profile(identity)
        return self.profile(identity, stages={**record['stages'],
                                             'process_entry': entry, 'delegate_initialized': delegate})

    def startup(self, log=None):
        return REPORTER['report'](self.trace() if log is None else log, {}, 2, self.directory)['startupProfiling']

    def assert_unavailable(self, data):
        self.assertEqual(data['status'], 'unavailable')
        self.assertEqual(data['pairedCount'], 0)
        self.assertIsNone(data['cumulativeSeconds'])

    def test_known_split_accounts_for_wrapper(self):
        self.profile()
        data = REPORTER['report'](self.trace() + 'CI_UI_LAUNCH_SECONDS 20\n', {}, 2, self.directory)
        startup = data['startupProfiling']
        self.assertEqual(startup['status'], 'complete')
        self.assertEqual((startup['traceCount'], startup['pairedCount']), (1, 1))
        cumulative = startup['cumulativeSeconds']
        self.assertEqual(cumulative['launch'], 20)
        self.assertEqual(cumulative['appBootstrap'], 12)
        self.assertEqual(cumulative['unattributedLaunch'], 8)
        self.assertEqual(cumulative['phases'], dict(zip(REPORTER['PHASE_NAMES'], (1, 2, 3, 1, 1, 2, 2))))
        self.assertAlmostEqual(sum(cumulative['phases'].values()) + cumulative['unattributedLaunch'], cumulative['launch'])
        rendered = REPORTER['markdown'](data)
        self.assertIn('paired calls only', rendered)
        self.assertIn('not wall time', rendered)
        self.assertIn('does not establish when the first frame rendered', rendered)
        self.assertIn('Unattributed launch time', rendered)

    def test_early_markers_decompose_the_same_launch_without_changing_bootstrap(self):
        self.early_profile()
        data = REPORTER['report'](self.trace(), {}, 2, self.directory)
        startup = data['startupProfiling']
        self.assertEqual(startup['status'], 'complete')
        early = startup['earlyStartup']
        self.assertEqual(early, {
            'status': 'complete', 'pairedCount': 1, 'missingMarkerCount': 0,
            'incompleteMarkerCount': 0, 'aggregationErrorCount': 0,
            'cumulativeSeconds': {'beforeProcessEntry': 0.5, 'entryToDelegate': 0.5,
                                  'delegateToWillFinish': 1.0, 'afterReady': 6.0},
        })
        cumulative = startup['cumulativeSeconds']
        self.assertEqual(cumulative['appBootstrap'], 12)
        self.assertEqual(cumulative['unattributedLaunch'], 8)
        self.assertEqual(cumulative['phases'], dict(zip(REPORTER['PHASE_NAMES'], (1, 2, 3, 1, 1, 2, 2))))
        self.assertEqual(sum(early['cumulativeSeconds'].values()) + cumulative['appBootstrap'],
                         cumulative['launch'])
        rendered = REPORTER['markdown'](data)
        for boundary in ('Launch call to Swift main entry', 'Main entry to delegate initialization',
                         'Delegate initialization to will-finish entry', 'Recorded ready to launch return'):
            self.assertIn(boundary, rendered)
        self.assertIn('first explicit Swift main body marker', rendered)
        self.assertIn('after runtime loading', rendered)
        self.assertIn('do not isolate termination', rendered)
        self.assertIn('XCTest automation', rendered)
        self.assertIn('does not establish when the first frame rendered', rendered)

    def test_old_profiles_keep_bootstrap_without_inventing_early_intervals(self):
        self.profile()
        data = REPORTER['report'](self.trace(), {}, 2, self.directory)
        startup = data['startupProfiling']
        self.assertEqual(startup['status'], 'complete')
        self.assertEqual(startup['cumulativeSeconds']['appBootstrap'], 12)
        self.assertEqual(startup['earlyStartup'], {
            'status': 'unavailable', 'pairedCount': 0, 'missingMarkerCount': 1,
            'incompleteMarkerCount': 0, 'aggregationErrorCount': 0, 'cumulativeSeconds': None,
        })
        rendered = REPORTER['markdown'](data)
        self.assertIn('older or missing markers do not represent zero time', rendered)
        self.assertNotIn('| Launch call to Swift main entry |', rendered)
        no_trace = self.startup('Build failed before tests began\n')['earlyStartup']
        self.assertEqual(no_trace['pairedCount'], 0)
        self.assertEqual(no_trace['missingMarkerCount'], 0)
        self.assertIsNone(no_trace['cumulativeSeconds'])

    def test_one_early_marker_retains_bootstrap_but_cannot_measure_early_intervals(self):
        original = self.profile()['stages']
        for marker in ('process_entry', 'delegate_initialized'):
            with self.subTest(marker=marker):
                self.profile(stages={**original, marker: 101})
                startup = self.startup()
                self.assertEqual(startup['status'], 'complete')
                self.assertEqual(startup['pairedCount'], 1)
                self.assertEqual(startup['cumulativeSeconds']['appBootstrap'], 12)
                self.assertEqual(startup['earlyStartup'], {
                    'status': 'unavailable', 'pairedCount': 0, 'missingMarkerCount': 0,
                    'incompleteMarkerCount': 1, 'aggregationErrorCount': 0, 'cumulativeSeconds': None,
                })

    def test_early_totals_pair_ids_and_cover_only_the_instrumented_subset(self):
        self.early_profile()
        original = self.profile(self.second)['stages']
        self.profile(self.second, stages={**{name: value + 100 for name, value in original.items()},
                                          'process_entry': 201, 'delegate_initialized': 201.5})
        old, incomplete, missing = (str(uuid.UUID(int=value)) for value in (3, 4, 5))
        self.profile(old)
        self.profile(incomplete, stages={**original, 'process_entry': 101})
        startup = self.startup(self.trace(self.second, start=200, end=240) + self.trace(missing)
                               + self.trace(old) + self.trace(incomplete) + self.trace())
        self.assertEqual(startup['status'], 'partial')
        self.assertEqual((startup['traceCount'], startup['pairedCount'], startup['missingProfileCount']), (5, 4, 1))
        self.assertEqual(startup['cumulativeSeconds']['launch'], 100)
        self.assertEqual(startup['cumulativeSeconds']['appBootstrap'], 48)
        early = startup['earlyStartup']
        self.assertEqual(early['status'], 'partial')
        self.assertEqual((early['pairedCount'], early['missingMarkerCount'], early['incompleteMarkerCount']), (2, 1, 1))
        self.assertEqual(early['cumulativeSeconds'], {
            'beforeProcessEntry': 1.5, 'entryToDelegate': 1.0,
            'delegateToWillFinish': 1.5, 'afterReady': 32.0,
        })
        # The two early pairs have 60 seconds of launch time and 24 of bootstrap;
        # neither the old profile nor the incomplete profile contributes here.
        self.assertEqual(sum(early['cumulativeSeconds'].values()) + 24, 60)

    def test_early_completeness_respects_collection_availability(self):
        self.early_profile()
        for availability, expected in (('complete', 'complete'), ('partial', 'partial'), ('unavailable', 'partial')):
            with self.subTest(availability=availability):
                (self.directory / 'collection-status.json').write_text(json.dumps({
                    'schema': 1, 'availability': availability,
                }))
                startup = self.startup()
                self.assertEqual(startup['collectionAvailability'], availability)
                self.assertEqual(startup['earlyStartup']['pairedCount'], 1)
                self.assertEqual(startup['earlyStartup']['status'], expected)

    def test_early_markers_require_a_valid_existing_bootstrap_profile(self):
        original = self.early_profile()['stages']
        missing = {name: value for name, value in original.items() if name != 'initial_view_appeared'}
        invalid = {**original, 'dependencies_ready': 101}
        for stages, counter in ((missing, 'incompleteProfileCount'), (invalid, 'invalidProfileCount')):
            with self.subTest(counter=counter):
                self.profile(stages=stages)
                startup = self.startup()
                self.assert_unavailable(startup)
                self.assertEqual(startup[counter], 1)
                self.assertEqual(startup['earlyStartup']['pairedCount'], 0)
                self.assertEqual(startup['earlyStartup']['missingMarkerCount'], 0)
                self.assertEqual(startup['earlyStartup']['incompleteMarkerCount'], 0)
                self.assertIsNone(startup['earlyStartup']['cumulativeSeconds'])

    def test_corrupt_early_marker_numbers_reject_the_entire_profile(self):
        original = self.early_profile()['stages']
        for marker in ('process_entry', 'delegate_initialized'):
            for value in ('101', True, None, -1, math.nan, math.inf, -math.inf, 10 ** 400):
                for complete in (False, True):
                    with self.subTest(marker=marker, value=value, complete=complete):
                        stages = {**original, marker: value}
                        if not complete:
                            del stages['delegate_initialized' if marker == 'process_entry' else 'process_entry']
                        self.profile(stages=stages)
                        startup = self.startup()
                        self.assert_unavailable(startup)
                        self.assertEqual(startup['invalidProfileCount'], 1)
                        self.assertEqual(startup['earlyStartup']['pairedCount'], 0)
                        self.assertEqual(startup['earlyStartup']['incompleteMarkerCount'], 0)

    def test_reversed_early_clock_order_rejects_the_entire_profile(self):
        original = self.profile()['stages']
        changes = (
            {'process_entry': 101.5, 'delegate_initialized': 101},
            {'process_entry': 101, 'delegate_initialized': 102.5},
            {'process_entry': 102.5, 'delegate_initialized': 103},
            {'process_entry': 102.5}, {'delegate_initialized': 102.5},
        )
        for change in changes:
            with self.subTest(change=change):
                self.profile(stages={**original, **change})
                startup = self.startup()
                self.assert_unavailable(startup)
                self.assertEqual(startup['invalidProfileCount'], 1)
                self.assertEqual(startup['outsideWindowCount'], 0)
                self.assertEqual(startup['earlyStartup']['pairedCount'], 0)

    def test_early_markers_outside_wrapper_are_excluded_without_clamping(self):
        original = self.profile()['stages']
        changes = (
            {'process_entry': 99.5, 'delegate_initialized': 101},
            {'process_entry': 99, 'delegate_initialized': 99.5},
            {'process_entry': 99.5}, {'delegate_initialized': 99.5},
            {'process_entry': 121}, {'delegate_initialized': 121},
        )
        for change in changes:
            with self.subTest(change=change):
                self.profile(stages={**original, **change})
                startup = self.startup()
                self.assert_unavailable(startup)
                self.assertEqual(startup['outsideWindowCount'], 1)
                self.assertEqual(startup['earlyStartup']['pairedCount'], 0)

    def test_early_marker_boundaries_are_inclusive_and_zero_intervals_are_measured(self):
        stages = {name: 100 for name in REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES']}
        self.profile(stages={**stages, 'process_entry': 100, 'delegate_initialized': 100})
        startup = self.startup(self.trace(start=100, end=100))
        self.assertEqual(startup['status'], 'complete')
        self.assertEqual(startup['earlyStartup']['status'], 'complete')
        self.assertEqual(startup['earlyStartup']['pairedCount'], 1)
        self.assertEqual(startup['earlyStartup']['cumulativeSeconds'], {
            'beforeProcessEntry': 0, 'entryToDelegate': 0, 'delegateToWillFinish': 0, 'afterReady': 0,
        })
        self.early_profile(entry=100, delegate=102)
        startup = self.startup(self.trace(start=100, end=114))
        self.assertEqual(startup['earlyStartup']['status'], 'complete')
        self.assertEqual(startup['earlyStartup']['cumulativeSeconds'], {
            'beforeProcessEntry': 0, 'entryToDelegate': 2, 'delegateToWillFinish': 0, 'afterReady': 0,
        })

    def test_early_aggregation_is_independent_of_bootstrap_aggregate_overflow(self):
        stages = {name: 0 for name in REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES']}
        self.profile(stages={**stages, 'process_entry': 0, 'delegate_initialized': 0})
        self.profile(self.second, stages=stages)
        log = self.trace(start=0, end=1e308) + self.trace(self.second, start=0, end=1e308)
        data = REPORTER['report'](log, {}, 2, self.directory)
        startup = data['startupProfiling']
        self.assertEqual(startup['aggregationErrorCount'], 1)
        self.assertIsNone(startup['cumulativeSeconds'])
        early = startup['earlyStartup']
        self.assertEqual(early['status'], 'partial')
        self.assertEqual((early['pairedCount'], early['missingMarkerCount'], early['aggregationErrorCount']), (1, 1, 0))
        self.assertEqual(early['cumulativeSeconds'], {
            'beforeProcessEntry': 0, 'entryToDelegate': 0, 'delegateToWillFinish': 0, 'afterReady': 1e308,
        })
        json.dumps(data, allow_nan=False)

    def test_overflowed_early_totals_are_unavailable_and_never_emit_infinity(self):
        stages = {name: 0 for name in REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES']}
        stages.update(process_entry=0, delegate_initialized=0)
        self.profile(stages=stages)
        self.profile(self.second, stages=stages)
        log = self.trace(start=0, end=1e308) + self.trace(self.second, start=0, end=1e308)
        data = REPORTER['report'](log, {}, 2, self.directory)
        early = data['startupProfiling']['earlyStartup']
        self.assertEqual(early['status'], 'unavailable')
        self.assertEqual(early['pairedCount'], 2)
        self.assertEqual(early['aggregationErrorCount'], 1)
        self.assertIsNone(early['cumulativeSeconds'])
        json.dumps(data, allow_nan=False)

    def test_unknown_wrapper_profile_and_stage_fields_are_rejected_without_copying_them(self):
        record = self.profile()
        wrapper = self.startup(self.trace(secretFixture='private-fixture'))
        self.assert_unavailable(wrapper)
        self.assertEqual(wrapper['invalidTraceCount'], 1)
        for extra in ({'secretFixture': 'private-fixture'}, {'user': {'name': 'private-user'}}):
            with self.subTest(extra=extra):
                self.profile(**extra)
                data = self.startup()
                self.assert_unavailable(data)
                self.assertEqual(data['invalidProfileCount'], 1)
                self.assertNotIn('private-fixture', json.dumps(data))
                self.assertNotIn('private-user', json.dumps(data))
        self.profile(stages={**record['stages'], 'unknown_stage': 114})
        stages = self.startup()
        self.assert_unavailable(stages)
        self.assertEqual(stages['invalidProfileCount'], 1)

    def test_duplicate_json_fields_in_wrapper_and_profile_objects_are_invalid(self):
        record = self.profile()
        valid_trace = self.trace().rstrip()
        for duplicate in ('"schema": 1', '"endUptime": 119.0'):
            with self.subTest(wrapper=duplicate):
                data = self.startup(valid_trace[:-1] + ', ' + duplicate + '}\n')
                self.assert_unavailable(data)
                self.assertEqual(data['invalidTraceCount'], 1)
        payload = json.dumps(record)
        invalid_profiles = (
            payload[:-1] + ', "schema": 1}',
            payload.replace('"dependencies_ready": 103', '"dependencies_ready": 103, "dependencies_ready": 104'),
        )
        path = self.directory / f'{self.first}.json'
        for invalid in invalid_profiles:
            with self.subTest(profile=invalid):
                path.write_text(invalid)
                data = self.startup()
                self.assert_unavailable(data)
                self.assertEqual(data['invalidProfileCount'], 1)
                self.assertIsNone(REPORTER['read_profile_json'](path))

    def test_symlink_profile_is_invalid_and_target_is_not_used(self):
        self.profile(self.second)
        target = self.directory / f'{self.second}.json'
        path = self.directory / f'{self.first}.json'
        target.write_text(json.dumps({**json.loads(target.read_text()), 'traceID': self.first}))
        path.symlink_to(target)
        self.assertIsNone(REPORTER['read_profile_json'](path))
        data = self.startup()
        self.assert_unavailable(data)
        self.assertEqual(data['invalidProfileCount'], 1)
        self.assertEqual(data['missingProfileCount'], 0)
        target.unlink()
        broken = self.startup()
        self.assert_unavailable(broken)
        self.assertEqual(broken['invalidProfileCount'], 1)

    def test_trace_ids_pair_out_of_order_with_only_matched_subset_quantified(self):
        self.profile(self.second)
        self.profile(self.first)
        missing = str(uuid.UUID(int=3))
        data = self.startup(self.trace(self.second) + self.trace(missing) + self.trace(self.first)
                            + 'CI_UI_LAUNCH_SECONDS 20\n' * 3)
        self.assertEqual(data['status'], 'partial')
        self.assertEqual((data['traceCount'], data['pairedCount'], data['missingProfileCount']), (3, 2, 1))
        self.assertEqual(data['cumulativeSeconds']['launch'], 40)
        self.assertEqual(data['cumulativeSeconds']['appBootstrap'], 24)

    def test_ready_endpoint_accepts_view_and_active_in_either_order_or_before_did_finish_end(self):
        for active, appeared, expected in ((113, 114, 12), (114, 113, 12), (111, 111.5, 10)):
            with self.subTest(active=active, appeared=appeared):
                record = self.profile()
                record['stages'].update(app_active=active, initial_view_appeared=appeared)
                self.profile(stages=record['stages'])
                startup = self.startup()
                self.assertEqual(startup['status'], 'complete')
                self.assertEqual(startup['cumulativeSeconds']['appBootstrap'], expected)

    def test_wrapper_boundaries_are_inclusive_and_zero_measured_durations_are_valid(self):
        self.profile(stages={name: 100 for name in REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES']})
        data = self.startup(self.trace(start=100, end=100))
        self.assertEqual(data['status'], 'complete')
        self.assertEqual(data['cumulativeSeconds']['launch'], 0)
        self.assertEqual(data['cumulativeSeconds']['appBootstrap'], 0)
        self.profile()
        self.assertEqual(self.startup(self.trace(start=102, end=114))['cumulativeSeconds']['unattributedLaunch'], 0)

    def test_no_markers_absent_directory_and_missing_profiles_remain_unavailable(self):
        self.profile()
        self.assert_unavailable(self.startup('CI_UI_LAUNCH_SECONDS 20\n'))
        for directory in (None, self.directory / 'absent'):
            with self.subTest(directory=directory):
                data = REPORTER['report'](self.trace(), {}, 1, directory)['startupProfiling']
                self.assert_unavailable(data)
                self.assertFalse(data['profilesDirectoryAvailable'])
                self.assertEqual(data['missingProfileCount'], 1)
        (self.directory / f'{self.first}.json').unlink()
        self.assert_unavailable(self.startup())
        self.assertEqual(self.startup()['missingProfileCount'], 1)

    def test_incomplete_record_does_not_invent_missing_stage_time(self):
        record = self.profile()
        del record['stages']['initial_view_appeared']
        self.profile(stages=record['stages'])
        data = self.startup()
        self.assert_unavailable(data)
        self.assertEqual(data['incompleteProfileCount'], 1)

    def test_duplicate_wrapper_ids_are_excluded_instead_of_counted_twice(self):
        self.profile()
        self.profile(self.second)
        data = self.startup(self.trace() + self.trace(self.first.upper()) + self.trace(self.second))
        self.assertEqual(data['status'], 'partial')
        self.assertEqual((data['pairedCount'], data['duplicateTraceCount']), (1, 1))
        self.assertEqual(data['cumulativeSeconds']['launch'], 20)
        invalid_duplicate = self.startup(self.trace() + self.trace(start='invalid'))
        self.assert_unavailable(invalid_duplicate)
        self.assertEqual(invalid_duplicate['duplicateTraceCount'], 1)
        self.assertEqual(invalid_duplicate['invalidTraceCount'], 1)

    def test_duplicate_profile_ids_are_excluded(self):
        identity = 'abcdef01-2345-4567-89ab-cdef01234567'
        self.profile(identity)
        # Case alone cannot distinguish files on the macOS runner's filesystem.
        # Compact and hyphenated spellings remain distinct files but normalize
        # to the same UUID, exercising the actual duplicate-profile guard.
        compact = uuid.UUID(identity).hex.upper()
        self.profile(identity.upper(), filename=f'{compact}.json')
        self.assertEqual(len(list(self.directory.glob('*.json'))), 2)
        data = self.startup(self.trace(identity))
        self.assert_unavailable(data)
        self.assertEqual(data['duplicateProfileCount'], 1)

    def test_foreign_profiles_and_collection_metadata_are_not_app_records(self):
        self.profile()
        self.profile(self.second)
        (self.directory / 'unrelated.json').write_text('{broken')
        (self.directory / 'collection-status.json').write_text(json.dumps({
            'schema': 1, 'availability': 'partial', 'errors': [{'code': 'private-value'}],
        }))
        data = self.startup()
        self.assertEqual(data['status'], 'partial')
        self.assertEqual(data['pairedCount'], 1)
        self.assertEqual(data['invalidProfileCount'], 0)
        self.assertEqual(data['collectionAvailability'], 'partial')
        self.assertNotIn('private-value', json.dumps(data))
        (self.directory / 'collection-status.json').write_text('{broken')
        self.assertEqual(self.startup()['status'], 'complete')

    def test_invalid_wrapper_json_schema_id_and_clock_values_are_excluded(self):
        self.profile()
        invalid = (
            'CI_UI_LAUNCH_TRACE {broken\n',
            self.trace(schema=2), self.trace(schema=True), self.trace('invalid-uuid'),
            self.trace(start='100'), self.trace(start=True), self.trace(start=-1),
            self.trace(end=math.inf), self.trace(start=math.nan), self.trace(start=121),
            self.trace(start=10 ** 400), self.trace(extra='x' * REPORTER['MAX_PROFILE_BYTES']),
        )
        for log in invalid:
            with self.subTest(log=log[:100]):
                data = self.startup(log)
                self.assert_unavailable(data)
                self.assertEqual(data['invalidTraceCount'], 1)

    def test_malformed_oversized_wrong_id_or_schema_profiles_are_excluded(self):
        path = self.directory / f'{self.first}.json'
        invalid = (
            '{broken', '[]', json.dumps({'schema': 1, 'traceID': self.first, 'stages': 'invalid'}),
            json.dumps(self.profile(schema=2)), json.dumps(self.profile(schema=True)),
            json.dumps(self.profile(traceID=self.second)),
            json.dumps(self.profile(extra='x' * REPORTER['MAX_PROFILE_BYTES'])),
        )
        for payload in invalid:
            with self.subTest(payload=payload[:100]):
                path.write_text(payload)
                data = self.startup()
                self.assert_unavailable(data)
                self.assertEqual(data['invalidProfileCount'], 1)

    def test_invalid_stage_numbers_and_reversed_chain_are_excluded(self):
        original = self.profile()['stages']
        changes = (
            {'dependencies_ready': '103'}, {'dependencies_ready': True},
            {'dependencies_ready': math.inf}, {'dependencies_ready': math.nan},
            {'dependencies_ready': -1}, {'dependencies_ready': 106},
            {'app_active': 101}, {'initial_view_appeared': -1},
            {'did_finish_end': 10 ** 400},
        )
        for change in changes:
            with self.subTest(change=change):
                self.profile(stages={**original, **change})
                data = self.startup()
                self.assert_unavailable(data)
                self.assertEqual(data['invalidProfileCount'], 1)

    def test_clock_window_anomalies_are_excluded_without_clamping(self):
        self.profile()
        for start, end in ((102.01, 120), (100, 113.99)):
            with self.subTest(start=start, end=end):
                data = self.startup(self.trace(start=start, end=end))
                self.assert_unavailable(data)
                self.assertEqual(data['outsideWindowCount'], 1)

    def test_overflowed_cumulative_values_are_unavailable_instead_of_nonfinite(self):
        stages = {name: 0 for name in REPORTER['BOOTSTRAP_STAGES'] + REPORTER['READY_STAGES']}
        self.profile(stages=stages)
        self.profile(self.second, stages=stages)
        log = self.trace(start=0, end=1e308) + self.trace(self.second, start=0, end=1e308)
        data = REPORTER['report'](log, {}, 2, self.directory)
        startup = data['startupProfiling']
        self.assertEqual(startup['status'], 'unavailable')
        self.assertEqual(startup['pairedCount'], 2)
        self.assertIsNone(startup['cumulativeSeconds'])
        self.assertEqual(startup['aggregationErrorCount'], 1)
        self.assertIn('exceeds the supported numeric range', REPORTER['markdown'](data))
        json.dumps(data, allow_nan=False)

    def test_command_line_keeps_default_arguments_and_accepts_startup_directory(self):
        self.profile()
        log = self.directory / 'xcode.log'
        summary = self.directory / 'summary.json'
        output = self.directory / 'report.json'
        log.write_text(self.trace() + 'CI_UI_LAUNCH_SECONDS 20\n')
        summary.write_text('{}')
        command = [sys.executable, str(Path(__file__).resolve().parents[1] / 'report-ui-test-timings.py'),
                   '--log', str(log), '--summary', str(summary), '--json', str(output)]
        environment = {**os.environ, 'CI_UI_WORKERS': '2'}
        legacy = subprocess.run(command, check=True, capture_output=True, text=True, env=environment)
        self.assertEqual(json.loads(output.read_text())['launchSeconds'], 20)
        self.assertEqual(json.loads(output.read_text())['startupProfiling']['status'], 'unavailable')
        self.assertIn('unavailable', legacy.stdout)
        subprocess.run(command + ['--startup-profiles', str(self.directory)], check=True, capture_output=True,
                       text=True, env=environment)
        data = json.loads(output.read_text())
        self.assertEqual(data['startupProfiling']['status'], 'complete')
        self.assertEqual(data['workers'], '2')
