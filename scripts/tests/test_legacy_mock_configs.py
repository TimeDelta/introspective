import runpy
from pathlib import Path
import unittest

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
