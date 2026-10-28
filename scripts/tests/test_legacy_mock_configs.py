import runpy
from pathlib import Path
import unittest
import tempfile

GENERATOR = runpy.run_path(str(Path(__file__).resolve().parents[1] / 'generate-legacy-mocks.py'))


class LegacyMockInputs(unittest.TestCase):
    def test_all_modules_resolve_sample_parent_protocols(self):
        configs = dict(GENERATOR['configurations']())
        inputs = {tuple(config['sources']['include']) for config in configs.values()}
        self.assertEqual(len(inputs), 1)
        paths = next(iter(inputs))
        for suffix in ('/Attributes/Attributes/Attributed.swift', '/Samples/Samples/Sample.swift',
                       '/Common/Common/Describable.swift'):
            self.assertTrue(any(path.endswith(suffix) for path in paths), suffix)

    def test_dependency_types_are_not_emitted_into_each_module(self):
        configs = dict(GENERATOR['configurations']())
        for module, name in [('Samples', 'Sample'), ('SampleGroupers', 'SampleGrouper'),
                             ('SampleGroupInformation', 'SampleGroupInformation')]:
            self.assertIn(name, configs[module]['args']['mockTypes'])
            self.assertNotIn(name, configs['Common']['args']['mockTypes'])

    def test_handwritten_mock_descriptions_are_preserved(self):
        properties = GENERATOR['manual_properties']()
        for name in ('SampleMock', 'CoreDataSampleMock', 'MoodMock', 'SampleGrouperMock',
                     'SubQueryMatcherMock', 'AttributeRestrictionMock'):
            self.assertIn('description', properties[name])
            self.assertNotIn('matcher', properties[name])  # Generated region is excluded.

    def test_single_pass_preserves_all_module_mock_types(self):
        configs = list(dict(GENERATOR['configurations']()).values())
        combined = GENERATOR['combined_configuration'](configs)
        expected = {name for config in configs for name in config['args']['mockTypes']}
        self.assertEqual(set(combined['args']['mockTypes']), expected)
        self.assertEqual(combined['sources'], configs[0]['sources'])
        self.assertTrue(combined['output'].endswith('/IntrospectiveTests/CommonMocks.swift'))

    def test_inconsistent_dependency_inputs_are_rejected(self):
        configs = list(dict(GENERATOR['configurations']()).values())
        configs[-1] = dict(configs[-1], sources={'include': []})
        with self.assertRaises(RuntimeError):
            GENERATOR['combined_configuration'](configs)

    def test_incomplete_or_duplicate_output_does_not_clear_previous_files(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'CommonMocks.swift'
            previous = Path(directory) / 'SamplesMocks.swift'
            previous.write_text('previous mocks')
            configs = [{'output': str(output)}, {'output': str(previous)}]
            valid = ''.join('open class ' + name + ' {}\n' for name in
                            ['DatabaseMock', 'QueryMock', 'ActivityDAOMock', 'SampleGroupInformationMock'])
            for source in ('', valid + 'open class QueryMock {}\n'):
                output.write_text(source)
                with self.assertRaises(RuntimeError):
                    GENERATOR['finish_combined_output'](configs, {'output': str(output)})
                self.assertEqual(previous.read_text(), 'previous mocks')
            output.write_text(valid)
            GENERATOR['finish_combined_output'](configs, {'output': str(output)})
            self.assertEqual(output.read_text(), valid)
            self.assertIn('consolidated in CommonMocks.swift', previous.read_text())
