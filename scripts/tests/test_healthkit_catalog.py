import copy
import hashlib
import json
from pathlib import Path
import runpy
import unittest

ROOT = Path(__file__).resolve().parents[2]
GENERATOR = runpy.run_path(str(ROOT / 'scripts/generate-healthkit-catalog.py'))
MANIFEST = json.loads((ROOT / 'scripts/healthkit-catalog.json').read_text())


class HealthKitCatalogGeneration(unittest.TestCase):
    def test_sdk_inventory_includes_every_family_without_alias_duplicates(self):
        entries = GENERATOR['validate'](MANIFEST)
        self.assertEqual(len(entries), 221)
        self.assertEqual(len({e['identifier'] for e in entries}), 221)
        self.assertEqual(sum(e['family'] == 'quantity' for e in entries), 120)
        self.assertEqual(sum(e['family'] == 'category' for e in entries), 69)
        self.assertEqual(sum(e['family'] in GENERATOR['EXTERNAL'] for e in entries), 10)
        self.assertEqual({e['family'] for e in entries}, GENERATOR['FAMILIES'])

    def test_existing_and_new_saved_identifiers_are_frozen_independently_of_display_order(self):
        self.assertEqual(MANIFEST['legacyIDs'], {str(i): name for i, name in enumerate(GENERATOR['LEGACY'])})
        entries = GENERATOR['validate'](MANIFEST)
        self.assertEqual([e['id'] for e in entries if e['id'] >= 21], list(range(21, 230)))
        altered = copy.deepcopy(MANIFEST)
        a = next(e for e in altered['entries'] if e['id'] == 21)
        b = next(e for e in altered['entries'] if e['id'] == 22)
        a['id'], b['id'] = b['id'], a['id']
        with self.assertRaisesRegex(ValueError, 'existing catalog identifier'):
            GENERATOR['validate'](altered)
        altered = copy.deepcopy(MANIFEST)
        altered['legacyIDs']['13'], altered['legacyIDs']['14'] = altered['legacyIDs']['14'], altered['legacyIDs']['13']
        with self.assertRaisesRegex(ValueError, '0–20'):
            GENERATOR['validate'](altered)

    def test_generation_is_deterministic_and_matches_checked_in_sources(self):
        samples, queries = GENERATOR['render'](MANIFEST)
        reversed_manifest = copy.deepcopy(MANIFEST)
        reversed_manifest['entries'].reverse()
        self.assertEqual(GENERATOR['render'](reversed_manifest), (samples, queries))
        self.assertEqual(samples, GENERATOR['SAMPLES'].read_text())
        self.assertEqual(queries, GENERATOR['QUERIES'].read_text())
        self.assertEqual(samples.count('HealthCatalogRegistration(descriptor:'), 211)
        self.assertEqual(queries.count('values[ObjectIdentifier('), 199)
        for entry in MANIFEST['entries']:
            self.assertIn('public enum ' + entry['swiftName'] + ': HealthCatalogDefinition', samples)
            wrapped = GENERATOR['sample_type'](entry)
            if entry['family'] in GENERATOR['EXTERNAL']:
                self.assertIsNone(wrapped)
            elif entry['id'] >= 21:
                self.assertIn(f'CatalogHealthKitQuery<{wrapped}>()', queries)

    def test_aliases_resolve_to_one_canonical_entry_and_never_get_another_saved_id(self):
        aliases = MANIFEST['aliases']
        self.assertEqual(aliases, {'HKCategoryTypeIdentifierAudioExposureEvent': 'HKCategoryTypeIdentifierEnvironmentalAudioExposureEvent'})
        identifiers = {e['identifier'] for e in MANIFEST['entries']}
        self.assertNotIn(next(iter(aliases)), identifiers)
        for value in ('HKUnknown', next(iter(aliases))):
            altered = copy.deepcopy(MANIFEST)
            altered['aliases'][next(iter(aliases))] = value
            with self.assertRaisesRegex(ValueError, 'Aliases'):
                GENERATOR['validate'](altered)

    def test_duplicate_malformed_and_future_sdk_values_are_rejected_before_generation(self):
        cases = [('id', True), ('id', -1), ('id', 32768), ('id', 22),
                 ('identifier', 'HK bad'), ('identifier', MANIFEST['entries'][1]['identifier']),
                 ('swiftName', 'bad symbol'), ('family', 'futureFamily'), ('name', ''),
                 ('group', ''), ('minimumOS', ''), ('minimumOS', '18..0'),
                 ('minimumOS', '26.3'), ('minimumOS', '27.0'), ('canonicalUnit', 'not-a-unit')]
        for key, value in cases:
            altered = copy.deepcopy(MANIFEST)
            altered['entries'][0][key] = value
            with self.subTest(key=key, value=value), self.assertRaises(ValueError):
                GENERATOR['render'](altered)
        altered = copy.deepcopy(MANIFEST)
        altered['entries'][0]['categoryValues'] = {'not-integer': 'Unknown'}
        with self.assertRaises(ValueError):
            GENERATOR['validate'](altered)

    def test_type_coverage_cannot_shrink_or_lose_sdk_provenance(self):
        altered = copy.deepcopy(MANIFEST)
        altered['entries'].pop()
        with self.assertRaisesRegex(ValueError, 'shrink'):
            GENERATOR['validate'](altered)
        for key, value in [('url', 'http://example.test/header'), ('sha256', 'wrong')]:
            altered = copy.deepcopy(MANIFEST)
            altered['sources'][0][key] = value
            with self.assertRaisesRegex(ValueError, 'provenance'):
                GENERATOR['validate'](altered)

    def test_sdk_source_hashes_and_unique_unit_spellings_are_explicit(self):
        self.assertEqual(len(MANIFEST['sources']), 3)
        self.assertTrue(all(len(s['sha256']) == 64 for s in MANIFEST['sources']))
        for entry in MANIFEST['entries']:
            if entry['family'] == 'quantity':
                self.assertIn(entry['canonicalUnit'], GENERATOR['UNITS'])
            if entry['family'] == 'category':
                self.assertTrue(entry['categoryValues'], entry['identifier'])


if __name__ == '__main__':
    unittest.main()
