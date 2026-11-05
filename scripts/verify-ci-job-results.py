#!/usr/bin/env python3
"""Require every selected CI job, including shared UI preparation, to pass."""
import argparse
import sys


def validate(suite, validation, ui_build, ui_tests):
    if suite not in {'', 'all', 'ui', 'focused', 'legacy', 'mocks'}:
        raise ValueError(f'Unknown CI suite: {suite!r}')
    needs_ui = suite in {'', 'all', 'ui'}
    jobs = (
        ('Native/legacy/Release validation', validation, 'skipped' if suite == 'ui' else 'success'),
        ('Shared UI build', ui_build, 'success' if needs_ui else 'skipped'),
        ('Complete UI shards', ui_tests, 'success' if needs_ui else 'skipped'),
    )
    for name, actual, expected in jobs:
        if actual != expected:
            raise ValueError(f'{name}: expected {expected}, received {actual!r}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--suite', default='')
    parser.add_argument('--validation', required=True)
    parser.add_argument('--ui-build', required=True)
    parser.add_argument('--ui-tests', required=True)
    args = parser.parse_args()
    try:
        validate(args.suite, args.validation, args.ui_build, args.ui_tests)
    except ValueError as error:
        print(f'::error::{error}', file=sys.stderr)
        return 1
    print('All selected CI jobs passed; only unselected jobs were skipped.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
