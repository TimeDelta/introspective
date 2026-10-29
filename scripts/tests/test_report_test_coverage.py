import importlib.util
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'report-test-coverage.py'
spec = importlib.util.spec_from_file_location('coverage_report', SCRIPT)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class CoverageReport(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.sources = ['App/Used.swift', 'App/Unmeasured.swift', 'Pods/Vendor.swift', 'MoodHealthTests/Test.swift']
        self.file = {'path': str(self.root / 'App/Used.swift'), 'coveredLines': 4, 'executableLines': 10,
                     'functions': [{'name': 'save()', 'lineNumber': 12, 'coveredLines': 0,
                                    'executableLines': 6, 'executionCount': 0}]}
        self.coverage = {'targets': [{'name': 'App.app', 'files': [self.file]}]}

    def report(self, coverage=None, summary=None):
        return module.build_report(coverage, summary, self.root, self.sources, [], 'native')

    def test_unmeasured_sources_are_distinct_from_measured_uncovered_lines(self):
        report = self.report(self.coverage)
        self.assertEqual(report['sourceFilesNotMeasured'], ['App/Unmeasured.swift'])
        self.assertEqual(report['files'][0]['uncoveredLines'], 6)
        function = report['functionsNeedingTests'][0]
        self.assertEqual((function['name'], function['line'], function['executionCount']), ('save()', 12, 0))

    def test_native_compiled_production_sources_are_kept_but_tests_and_dependencies_are_excluded(self):
        files = [dict(self.file, path=str(self.root / source)) for source in self.sources]
        files.append(dict(self.file, path='/outside/Other.swift'))
        report = self.report({'targets': [{'name': 'MoodHealthTests.xctest', 'files': files}]})
        self.assertEqual({file['path'] for file in report['files']}, {'App/Used.swift', 'App/Unmeasured.swift'})

    def test_missing_or_empty_coverage_is_unavailable_without_invented_zero_percent(self):
        for coverage in [None, {'targets': []}]:
            report = self.report(coverage)
            self.assertEqual(report['measurementStatus'], 'unavailable')
            self.assertEqual(len(report['sourceFilesNotMeasured']), 2)
            self.assertIn('not 0% coverage', module.markdown(report))
            self.assertIn('execution is unverified', module.markdown(report))

    def test_failed_suite_is_reported_as_partial_and_separate_targets_are_not_added(self):
        self.coverage['targets'].append({'name': 'Other.framework', 'files': [self.file]})
        report = self.report(self.coverage, {'result': 'Failed', 'passedTests': 87, 'failedTests': 1, 'skippedTests': 0})
        self.assertEqual(len(report['files']), 2)
        text = module.markdown(report)
        self.assertIn('Coverage is partial', text)
        self.assertIn('87 passed, 1 failed, 0 skipped', text)
        self.assertIn('must not be added or averaged', text)

    def test_scheme_exclusions_include_disabled_targets_and_individual_cases(self):
        scheme = self.root / 'CI.xcscheme'
        scheme.write_text('''<Scheme><TestAction><Testables>
          <TestableReference skipped="YES"><BuildableReference BlueprintName="DisabledTests"/></TestableReference>
          <TestableReference skipped="NO"><BuildableReference BlueprintName="Tests"/><SkippedTests>
          <Test Identifier="HealthTests"/><Test Identifier="OtherTests/testOne()"/>
          </SkippedTests></TestableReference></Testables></TestAction></Scheme>''')
        self.assertEqual([item['identifier'] for item in module.scheme_exclusions(scheme)],
                         ['*', 'HealthTests', 'OtherTests/testOne()'])

    def test_malformed_coverage_cannot_produce_plausible_statistics(self):
        for covered, executable in [(11, 10), (-1, 10), ('4', 10), (True, 10)]:
            self.file.update(coveredLines=covered, executableLines=executable)
            with self.assertRaises(ValueError):
                self.report(self.coverage)
        with self.assertRaises(ValueError):
            self.report({})

    def test_markdown_escapes_source_and_function_names(self):
        self.file['functions'][0]['name'] = 'save|`value`\n()'
        text = module.markdown(self.report(self.coverage))
        self.assertIn("save\\|'value' ()", text)


if __name__ == '__main__':
    unittest.main()
