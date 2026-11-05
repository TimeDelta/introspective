import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest import mock


SCRIPT = Path(__file__).resolve().parents[1] / 'collect-ui-launch-profiles.py'
SPEC = importlib.util.spec_from_file_location('ui_launch_profile_collector', SCRIPT)
COLLECTOR = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(COLLECTOR)
SIMULATOR = '11223344-5566-7788-99AA-BBCCDDEEFF00'
FIRST = '12345678-1234-1234-1234-123456789ABC'
SECOND = '23456789-2345-2345-2345-23456789ABCD'
HISTORICAL = '34567890-3456-3456-3456-3456789ABCDE'


class UILaunchProfileCollection(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.container = self.root / 'app-data'
        self.profiles = self.container.joinpath(*COLLECTOR.PROFILE_PARTS)
        self.profiles.mkdir(parents=True)
        self.log = self.root / 'ui.log'
        self.output = self.root / 'artifacts'
        self.log.write_text(self.marker(FIRST))
        self.command = mock.patch.object(COLLECTOR.subprocess, 'run', return_value=SimpleNamespace(
            returncode=0, stdout=str(self.container) + '\n', stderr='private app metadata'))
        self.run = self.command.start()
        self.addCleanup(self.command.stop)

    def marker(self, trace_id, **changes):
        trace = {'schema': 1, 'traceID': trace_id, 'startUptime': 10.0, 'endUptime': 12.0}
        trace.update(changes)
        return 'CI_UI_LAUNCH_TRACE ' + json.dumps(trace) + '\n'

    def profile(self, trace_id=FIRST, **changes):
        profile = {'schema': 1, 'traceID': trace_id,
                   'stages': {'will_finish_begin': 10.5, 'dependencies_ready': 10.6, 'fixtures_ready': 10.7}}
        profile.update(changes)
        return profile

    def write_profile(self, trace_id=FIRST, contents=None):
        path = self.profiles / (trace_id + '.json')
        path.write_text(json.dumps(self.profile(trace_id) if contents is None else contents))
        return path

    def collect(self, simulator=SIMULATOR, workers=1, output=None):
        return COLLECTOR.collect(simulator, workers, self.log, output or self.output)

    def codes(self, status):
        return {item['code'] for item in status['errors']}

    def candidate_files(self, files):
        """Model case-sensitive or insensitive lookups without relying on the host FS."""
        real_open = os.open
        opened = []

        def open_candidate(path, flags, *args, **kwargs):
            if path in files and kwargs.get('dir_fd') is not None:
                target = files[path]
                if isinstance(target, OSError):
                    raise target
                descriptor = real_open(target, flags)
                opened.append((path, descriptor))
                return descriptor
            return real_open(path, flags, *args, **kwargs)

        return mock.patch.object(COLLECTOR.os, 'open', side_effect=open_candidate), opened

    def assert_candidates_closed(self, opened):
        for _, descriptor in opened:
            with self.assertRaises(OSError):
                os.fstat(descriptor)

    def test_only_current_phase_profiles_are_atomically_sanitized_without_source_mutation(self):
        first = self.write_profile()
        historical = self.write_profile(HISTORICAL)
        (self.container / 'private-health-records.json').write_text('sensitive unrelated data')
        (self.profiles / 'private-metadata.txt').write_text('sensitive unrelated data')
        original = {path: (path.read_bytes(), path.stat().st_mtime_ns) for path in
                    (first, historical, self.container / 'private-health-records.json')}
        replacements = []
        replace = os.replace

        def observe_replace(source, destination, **kwargs):
            replacements.append((source, destination))
            return replace(source, destination, **kwargs)

        with mock.patch.object(COLLECTOR.os, 'replace', side_effect=observe_replace):
            status = self.collect()
        self.assertEqual(status['availability'], 'complete')
        self.assertEqual(status['requested'], [FIRST])
        self.assertEqual(status['copied'], [FIRST])
        self.assertEqual(status['missing'], [])
        self.assertEqual(set(path.name for path in self.output.iterdir()), {FIRST + '.json', 'collection-status.json'})
        self.assertEqual(json.loads((self.output / (FIRST + '.json')).read_text()), self.profile())
        self.assertEqual(json.loads((self.output / 'collection-status.json').read_text()), status)
        self.assertEqual({path: (path.read_bytes(), path.stat().st_mtime_ns) for path in original}, original)
        self.assertEqual([destination for _, destination in replacements], [FIRST + '.json', 'collection-status.json'])
        self.assertTrue(all(source.startswith('.ui-launch-') for source, _ in replacements))
        self.run.assert_called_once_with(
            ['xcrun', 'simctl', 'get_app_container', SIMULATOR, 'com.bnova.Introspective', 'data'],
            capture_output=True, text=True, timeout=15, check=False)
        self.assertNotIn('sensitive', json.dumps(status))
        self.assertNotIn(str(self.container), json.dumps(status))

    def test_optional_early_timing_markers_are_copied_without_adding_missing_fields(self):
        for index, early in enumerate((
            {'process_entry': 10.1, 'delegate_initialized': 10.2},
            {'process_entry': 10.1}, {'delegate_initialized': 10.2},
        )):
            with self.subTest(early=early):
                record = self.profile()
                record['stages'].update(early)
                source = self.write_profile(contents=record)
                original = source.read_bytes()
                output = self.root / ('early-markers-' + str(index))
                status = self.collect(output=output)
                self.assertEqual(status['availability'], 'complete')
                self.assertEqual(status['copied'], [FIRST])
                copied = json.loads((output / (FIRST + '.json')).read_text())
                self.assertEqual(copied, record)
                self.assertEqual(copied['schema'], 1)
                self.assertEqual(set(copied), {'schema', 'traceID', 'stages'})
                self.assertEqual(source.read_bytes(), original)

    def test_early_marker_allowlist_still_rejects_metadata_and_invalid_numbers(self):
        valid = self.profile()
        valid['stages'].update(process_entry=10.1, delegate_initialized=10.2)
        cases = [
            {**valid, 'private': 'health value'},
            {**valid, 'process_entry': 10.1},
            {**valid, 'stages': {**valid['stages'], 'private_health_value': 10.3}},
        ]
        for marker in ('process_entry', 'delegate_initialized'):
            for value in ('health value', True, None, -1, float('nan'), float('inf'), 10 ** 1000):
                cases.append({**valid, 'stages': {**valid['stages'], marker: value}})
        for index, record in enumerate(cases):
            with self.subTest(index=index):
                source = self.write_profile(contents=record)
                original = source.read_bytes()
                output = self.root / ('invalid-early-markers-' + str(index))
                status = self.collect(output=output)
                self.assertEqual(status['availability'], 'unavailable')
                self.assertEqual(status['copied'], [])
                self.assertEqual(status['missing'], [FIRST])
                self.assertEqual(set(path.name for path in output.iterdir()), {'collection-status.json'})
                self.assertEqual(source.read_bytes(), original)
                self.assertNotIn('health value', json.dumps(status))

    def test_separate_phase_does_not_copy_historical_files_and_reuse_is_refused(self):
        self.write_profile()
        self.write_profile(SECOND)
        self.collect()
        self.log.write_text(self.marker(SECOND))
        reused = self.collect()
        self.assertIn('output_directory_not_empty', self.codes(reused))
        self.assertFalse((self.output / (SECOND + '.json')).exists())
        current = self.root / 'next-phase'
        status = self.collect(output=current)
        self.assertEqual(status['copied'], [SECOND])
        self.assertFalse((current / (FIRST + '.json')).exists())
        self.assertEqual(set(path.name for path in current.iterdir()), {SECOND + '.json', 'collection-status.json'})

    def test_equivalent_uuid_case_preserves_wrapper_spelling_in_filename_and_json(self):
        self.log.write_text(self.marker(FIRST.lower()))
        self.write_profile()
        status = self.collect()
        self.assertEqual(status['copied'], [FIRST.lower()])
        self.assertEqual(json.loads((self.output / (FIRST.lower() + '.json')).read_text())['traceID'], FIRST.lower())

    def test_distinct_files_for_uuid_case_variants_are_ambiguous_on_every_filesystem(self):
        mixed = FIRST[:-3] + 'AbC'
        self.log.write_text(self.marker(mixed))
        first, second = self.root / 'first-candidate.json', self.root / 'second-candidate.json'
        first.write_text(json.dumps(self.profile(mixed)))
        second.write_text(json.dumps(self.profile(mixed)))
        original = {path: path.read_bytes() for path in (first, second)}
        files = {mixed + '.json': first, FIRST + '.json': first, FIRST.lower() + '.json': second}
        patch, opened = self.candidate_files(files)
        with patch:
            status = self.collect()
        self.assertEqual([name for name, _ in opened], list(files))
        self.assertEqual(status['availability'], 'unavailable')
        self.assertEqual(status['copied'], [])
        self.assertEqual(status['missing'], [mixed])
        self.assertIn('profile_file_ambiguous', self.codes(status))
        self.assertEqual(set(path.name for path in self.output.iterdir()), {'collection-status.json'})
        self.assertEqual({path: path.read_bytes() for path in original}, original)
        self.assert_candidates_closed(opened)

    def test_same_inode_case_aliases_are_accepted_on_every_filesystem(self):
        mixed = FIRST[:-3] + 'AbC'
        self.log.write_text(self.marker(mixed))
        source = self.root / 'shared-candidate.json'
        source.write_text(json.dumps(self.profile(mixed)))
        files = {spelling + '.json': source for spelling in (mixed, mixed.upper(), mixed.lower())}
        patch, opened = self.candidate_files(files)
        with patch:
            status = self.collect()
        self.assertEqual([name for name, _ in opened], list(files))
        self.assertEqual(status['availability'], 'complete')
        self.assertEqual(status['copied'], [mixed])
        self.assertEqual(status['missing'], [])
        self.assertEqual(json.loads((self.output / (mixed + '.json')).read_text()), self.profile(mixed))
        self.assert_candidates_closed(opened)

    def test_unsafe_later_case_candidate_rejects_otherwise_valid_profile(self):
        source = self.write_profile()
        files = {FIRST + '.json': source, FIRST.lower() + '.json': PermissionError('private metadata')}
        patch, opened = self.candidate_files(files)
        with patch:
            status = self.collect()
        self.assertEqual(status['copied'], [])
        self.assertEqual(status['missing'], [FIRST])
        self.assertIn('profile_file_unsafe', self.codes(status))
        self.assertNotIn('private metadata', json.dumps(status))
        self.assert_candidates_closed(opened)

    def test_missing_profile_is_missing_and_retains_available_profiles(self):
        self.log.write_text(self.marker(FIRST) + self.marker(SECOND))
        self.write_profile()
        status = self.collect()
        self.assertEqual(status['availability'], 'partial')
        self.assertEqual(status['copied'], [FIRST])
        self.assertEqual(status['missing'], [SECOND])
        self.assertIn('profile_missing', self.codes(status))

    def test_invalid_profile_schemas_and_numbers_never_upload_source_bytes(self):
        cases = [
            ('invalid json', '{"private":"health value",'),
            ('wrong nonce', json.dumps(self.profile(SECOND))),
            ('unknown metadata', json.dumps(self.profile(private='health value'))),
            ('unknown stage', json.dumps(self.profile(stages={'private_health_value': 12.0}))),
            ('boolean schema', json.dumps(self.profile(schema=True))),
            ('string stage', json.dumps(self.profile(stages={'will_finish_begin': 'health value'}))),
            ('boolean stage', json.dumps(self.profile(stages={'will_finish_begin': True}))),
            ('negative uptime', json.dumps(self.profile(stages={'will_finish_begin': -1.0}))),
            ('nan', json.dumps(self.profile(stages={'will_finish_begin': float('nan')}))),
            ('infinity', json.dumps(self.profile(stages={'will_finish_begin': float('inf')}))),
            ('numeric overflow', json.dumps(self.profile(stages={'will_finish_begin': 1.0})).replace('1.0', '1e999')),
            ('integer overflow', json.dumps(self.profile(stages={'will_finish_begin': 10 ** 1000}))),
            ('duplicate field', '{"schema":1,"schema":1,"traceID":"' + FIRST + '","stages":{}}'),
            ('duplicate stage', '{"schema":1,"traceID":"' + FIRST + '","stages":{"app_active":1,"app_active":2}}'),
            ('uuid traversal', json.dumps(self.profile(trace_id='../private'))),
            ('braced uuid', json.dumps(self.profile(trace_id='{' + FIRST + '}'))),
            ('oversized', ' ' * (COLLECTOR.MAX_PROFILE_BYTES + 1)),
        ]
        for index, (label, contents) in enumerate(cases):
            with self.subTest(label=label):
                source = self.profiles / (FIRST + '.json')
                source.write_text(contents)
                output = self.root / ('invalid-' + str(index))
                status = self.collect(output=output)
                self.assertEqual(status['availability'], 'unavailable')
                self.assertEqual(status['missing'], [FIRST])
                self.assertFalse((output / (FIRST + '.json')).exists())
                self.assertEqual(source.read_text(), contents)
                self.assertNotIn('health value', json.dumps(status))
                self.assertEqual(set(path.name for path in output.iterdir()), {'collection-status.json'})

    def test_every_profile_directory_component_rejects_symlinks(self):
        self.write_profile()
        for index, parts in enumerate(((), ('Library',), ('Library', 'Caches'), COLLECTOR.PROFILE_PARTS)):
            with self.subTest(parts=parts):
                location = self.container.joinpath(*parts)
                moved = self.root / ('moved-' + str(index))
                location.rename(moved)
                location.symlink_to(moved, target_is_directory=True)
                try:
                    status = self.collect(output=self.root / ('symlink-' + str(index)))
                    self.assertEqual(status['copied'], [])
                    self.assertIn('profile_directory_unsafe', self.codes(status))
                finally:
                    location.unlink()
                    moved.rename(location)

    def test_profile_file_symlinks_and_nonregular_files_are_rejected(self):
        outside = self.root / 'outside.json'
        outside.write_text(json.dumps(self.profile()))
        source = self.profiles / (FIRST + '.json')
        source.symlink_to(outside)
        status = self.collect()
        self.assertIn('profile_file_unsafe', self.codes(status))
        self.assertEqual(status['copied'], [])
        source.unlink()
        os.mkfifo(source)
        status = self.collect(output=self.root / 'fifo-output')
        self.assertIn('profile_file_unsafe', self.codes(status))
        self.assertEqual(status['copied'], [])

    def test_output_must_not_be_a_symlink_or_overlap_source(self):
        source = self.write_profile()
        original = source.read_bytes()
        for index, output in enumerate((self.container, self.profiles, self.container / 'new-output')):
            with self.subTest(output=output):
                status = self.collect(output=output)
                self.assertIn('output_overlaps_app_container', self.codes(status))
                self.assertEqual(source.read_bytes(), original)
                self.assertFalse((self.profiles / 'collection-status.json').exists())
        destination = self.root / 'destination'
        destination.mkdir()
        self.output.symlink_to(destination, target_is_directory=True)
        status = self.collect()
        self.assertIn('output_directory_unsafe', self.codes(status))
        self.assertEqual(list(destination.iterdir()), [])

    def test_missing_log_and_no_trace_markers_do_not_probe_or_invent_metrics(self):
        self.log.unlink()
        status = self.collect(simulator='')
        self.assertEqual(status['availability'], 'unavailable')
        self.assertEqual(status['requested'], [])
        self.assertEqual(status['copied'], [])
        self.assertIn('log_unavailable', self.codes(status))
        self.run.assert_not_called()
        self.log.write_text('Build failed before tests began\n')
        status = self.collect(output=self.root / 'early-failure')
        self.assertIn('no_trace_markers', self.codes(status))
        self.run.assert_not_called()

    def test_blank_invalid_and_unavailable_simulator_produce_diagnostics(self):
        for index, simulator in enumerate(('', '../simulator', 'booted')):
            with self.subTest(simulator=simulator):
                status = self.collect(simulator=simulator, output=self.root / ('simulator-' + str(index)))
                self.assertEqual(status['availability'], 'unavailable')
                self.assertEqual(status['missing'], [FIRST])
        self.run.assert_not_called()
        self.run.return_value = SimpleNamespace(returncode=1, stdout='', stderr='private simulator metadata')
        status = self.collect(output=self.root / 'container-failure')
        self.assertIn('container_unavailable', self.codes(status))
        self.assertNotIn('private', json.dumps(status))
        self.run.side_effect = subprocess.TimeoutExpired('xcrun', 15)
        status = self.collect(output=self.root / 'container-timeout')
        self.assertIn('container_unavailable', self.codes(status))

    def test_container_path_traversal_and_multiline_output_are_rejected(self):
        for index, path in enumerate(('relative/path', str(self.container / '..' / 'outside'),
                                      str(self.container) + '\nprivate-metadata')):
            with self.subTest(path=path):
                self.run.return_value = SimpleNamespace(returncode=0, stdout=path, stderr='')
                status = self.collect(output=self.root / ('container-path-' + str(index)))
                self.assertIn('invalid_container_path', self.codes(status))
                self.assertEqual(status['copied'], [])

    def test_parallel_mode_collects_known_container_but_never_claims_clone_coverage(self):
        self.write_profile()
        status = self.collect(workers=2)
        self.assertEqual(status['availability'], 'partial')
        self.assertEqual(status['copied'], [FIRST])
        self.assertIn('clone containers are not resolved', status['notes'][0])
        self.run.assert_called_once()

    def test_invalid_wrapper_markers_cannot_request_arbitrary_files(self):
        bad_markers = [self.marker('../private'), self.marker('{' + FIRST + '}'),
                       self.marker(FIRST, schema=True), self.marker(FIRST, startUptime=float('nan')),
                       self.marker(FIRST, endUptime=1.0), self.marker(FIRST, private='health value')]
        self.log.write_text(''.join(bad_markers))
        status = self.collect()
        self.assertEqual(status['requested'], [])
        self.assertIn('invalid_trace_marker', self.codes(status))
        self.assertNotIn('health value', json.dumps(status))
        self.run.assert_not_called()

    def test_cli_uses_mock_xcrun_and_returns_zero_for_missing_or_tampered_profiles(self):
        self.command.stop()
        binary = self.root / 'bin'
        binary.mkdir()
        invocations = self.root / 'commands.json'
        fake = binary / 'xcrun'
        fake.write_text('#!' + sys.executable + '\nimport json, pathlib, sys\n' +
                        'pathlib.Path(' + repr(str(invocations)) + ').write_text(json.dumps(sys.argv[1:]))\n' +
                        'print(' + repr(str(self.container)) + ')\n')
        fake.chmod(0o755)
        self.write_profile(contents=self.profile(private='health value'))
        result = subprocess.run([sys.executable, str(SCRIPT), '--simulator', SIMULATOR, '--workers', '2',
                                 '--log', str(self.log), '--output', str(self.output)],
                                capture_output=True, text=True, env=dict(os.environ, PATH=str(binary) + os.pathsep + os.environ['PATH']),
                                timeout=15)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('unavailable', result.stdout)
        self.assertNotIn('health value', result.stdout)
        self.assertNotIn('Traceback', result.stderr)
        self.assertEqual(json.loads(invocations.read_text()),
                         ['simctl', 'get_app_container', SIMULATOR, 'com.bnova.Introspective', 'data'])
        self.assertEqual(json.loads((self.output / 'collection-status.json').read_text())['missing'], [FIRST])


if __name__ == '__main__':
    unittest.main()
