#!/usr/bin/env python3
"""Backport upstream's Optional-literal fix to our pinned SwiftyMocky runtime.

Upstream: https://github.com/MakeAWishFoundation/SwiftyMocky/commit/779da72725c3308ed96dd97f0afd1e25af8adc95
The full upgrade changes the generator and pins an older Sourcery. Keep this
compatibility fix narrow while retaining the existing generated mocks.
Run after pod install, before building simulator tests.
"""
import hashlib
from pathlib import Path
import re
import stat
import sys

source = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / "Pods/SwiftyMocky/Sources/SwiftyMocky/Parameter+Literals.swift"
original = source.read_bytes()
digest = hashlib.sha256(original).hexdigest()
if digest == "76d4d52ebd04c729eaa654d78a0aa717e020e8ffffef6e266b8ba968d087b2e9":
    print("SwiftyMocky compatibility backport already applied")
    sys.exit(0)
if digest != "4501e35beab03bbd80a8c796abb8e3d98c7dee573f255376ba47cdb87c61a192":
    raise SystemExit("Unexpected SwiftyMocky source; review the compatibility backport before applying")
patched, count = re.subn(rb"^extension Optional:.*?^}\n\n", b"", original, flags=re.M | re.S)
assert count == 6
source.chmod(source.stat().st_mode | stat.S_IWUSR)
source.write_bytes(patched)
print("Applied upstream SwiftyMocky Optional-literal compatibility backport")
