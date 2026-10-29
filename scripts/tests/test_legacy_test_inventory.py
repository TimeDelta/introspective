from pathlib import Path
import runpy
import tempfile
import unittest

INVENTORY = runpy.run_path(str(Path(__file__).resolve().parents[1] / 'verify-legacy-test-results.py'))['inventory']


class LegacyTestInventory(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.scheme = self.root / 'CI.xcscheme'
        self.scheme.write_text('''<Scheme><TestAction><Testables><TestableReference skipped="NO">
<BuildableReference BlueprintName="IntrospectiveTests"/>
<SkippedTests><Test Identifier="PermissionTests"/><Test Identifier="NormalTests/testExcluded"/></SkippedTests>
</TestableReference></Testables></TestAction></Scheme>''')
        (self.root / 'NormalTests.swift').write_text('final class NormalTests: UnitTest {\nfunc testFirst() {}\nfunc testExcluded() {}\n}')
        (self.root / 'PermissionTests.swift').write_text('class PermissionTests: FunctionalTest {\nfunc testPermission() {}\n}')

    def test_class_and_case_exclusions_preserve_every_other_case(self):
        data = INVENTORY(self.root, self.scheme, minimum=1)
        self.assertEqual(data['selected'], ['NormalTests/testFirst'])
        self.assertEqual(data['excluded'], ['NormalTests/testExcluded', 'PermissionTests/testPermission'])
        (self.root / 'NewTests.swift').write_text('class NewTests: UnitTest {\nfunc testNew() {}\n}')
        self.assertEqual(len(INVENTORY(self.root, self.scheme, minimum=1)['selected']), 2)

    def test_deleted_or_renamed_exclusions_and_disabled_target_fail(self):
        original = self.scheme.read_text()
        for source in [original.replace('PermissionTests', 'RemovedTests'),
                       original.replace('testExcluded', 'testRenamed'),
                       original.replace('skipped="NO"', 'skipped="YES"')]:
            self.scheme.write_text(source)
            with self.assertRaises(ValueError):
                INVENTORY(self.root, self.scheme, minimum=1)

    def test_duplicate_declarations_and_baseline_shrink_fail(self):
        with self.assertRaisesRegex(ValueError, 'baseline'):
            INVENTORY(self.root, self.scheme, minimum=2)
        path = self.root / 'NormalTests.swift'
        path.write_text(path.read_text().replace('func testFirst() {}', 'func testFirst() {}\nfunc testFirst() {}'))
        with self.assertRaisesRegex(ValueError, 'duplicate'):
            INVENTORY(self.root, self.scheme, minimum=1)

    def test_real_inventory_retains_the_restored_suite_and_explicit_exclusions(self):
        root = Path(__file__).resolve().parents[2]
        data = INVENTORY(root / 'IntrospectiveTests', root / 'Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
        self.assertGreaterEqual(len(data['selected']), 4297)
        self.assertEqual(len(data['excluded']), 41)
