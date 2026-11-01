#!/usr/bin/env python3
"""Check every declared native test ran successfully, including cache hits."""
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
SOURCES = [ROOT / 'MoodHealthTests' / name for name in
           ('MoodHealthExchangeTests.swift', 'SavedQueryTests.swift', 'ResultsProcessingTests.swift')]


def expected_test_count():
    pattern = r'^\s*(?:(?:public|internal|private|final|override)\s+)*func\s+test\w+\s*\('
    count = sum(len(re.findall(pattern, source.read_text(), re.MULTILINE)) for source in SOURCES)
    if count < 35:
        raise ValueError(f'Native suite unexpectedly shrank below the 35-test baseline: {count}')
    return count


def validate(summary, expected):
    if summary.get('result') != 'Passed':
        raise ValueError(f'Test run did not pass: {summary.get("result")}')
    for field in ('failedTests', 'skippedTests', 'expectedFailures'):
        if summary.get(field) != 0:
            raise ValueError(f'{field} must be zero: {summary.get(field)}')
    if summary.get('passedTests') != expected or summary.get('totalTestCount') != expected:
        raise ValueError(f'Expected all {expected} declared tests to pass: {summary}')


if __name__ == '__main__':
    summary = json.loads(Path(sys.argv[1]).read_text())
    expected = expected_test_count()
    validate(summary, expected)
    print(f'All {expected} declared native tests passed; no failures or skips.')
