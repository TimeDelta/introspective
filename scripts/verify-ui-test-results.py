#!/usr/bin/env python3
"""Require every declared legacy UI case to execute and pass, without skips."""
import json
from pathlib import Path
import re
import runpy
import sys

ROOT = Path(__file__).resolve().parents[1]


def expected_test_count():
    pattern = r"^\s*(?:(?:public|internal|private|final|override)\s+)*func\s+test\w+\s*\(\s*\)"
    count = sum(len(re.findall(pattern, path.read_text(), re.MULTILINE))
                for path in (ROOT / "IntrospectiveUITests").rglob("*.swift"))
    if count < 108:
        raise ValueError(f"UI suite unexpectedly shrank below its 108-test baseline: {count}")
    return count


if __name__ == "__main__":
    summary = json.loads(Path(sys.argv[1]).read_text())
    expected = expected_test_count()
    validate = runpy.run_path(str(ROOT / "scripts/verify-native-test-results.py"))["validate"]
    validate(summary, expected)
    print(f"All {expected} declared UI tests passed; no failures or skips.")
