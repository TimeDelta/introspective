"""The diagnostic upload remains a required gate after bounded transport retries."""
import os
import sys


def main():
    outcomes = [os.environ.get(f'UPLOAD_{name}', '') for name in ('FIRST', 'SECOND', 'THIRD')]
    for attempt, outcome in enumerate(outcomes, 1):
        if outcome == 'success':
            print(f'Diagnostics uploaded successfully on attempt {attempt}.')
            return 0
    print(f'::error::No diagnostic upload succeeded (attempt outcomes: {outcomes}).', file=sys.stderr)
    return 1


if __name__ == '__main__':
    sys.exit(main())
