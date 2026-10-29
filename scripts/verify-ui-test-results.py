#!/usr/bin/env python3
"""Require every declared legacy UI case to execute and pass, without skips."""
import argparse
import json
from pathlib import Path
import runpy

ROOT = Path(__file__).resolve().parents[1]


def expected_test_count(shard=1, count=1, preflight=False):
    select = runpy.run_path(str(ROOT / 'scripts/partition-ui-tests.py'))['preflight_selection' if preflight else 'selection']
    return len(select(shard, count)['tests'])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('summary', type=Path)
    parser.add_argument('--shard', type=int, default=1)
    parser.add_argument('--count', type=int, default=1)
    parser.add_argument('--preflight', action='store_true')
    args = parser.parse_args()
    summary = json.loads(args.summary.read_text())
    expected = expected_test_count(args.shard, args.count, args.preflight)
    validate = runpy.run_path(str(ROOT / "scripts/verify-native-test-results.py"))["validate"]
    validate(summary, expected)
    phase = "preflight" if args.preflight else "full suite"
    print(f"All {expected} UI tests assigned to shard {args.shard}/{args.count} ({phase}) passed; no failures or skips.")
