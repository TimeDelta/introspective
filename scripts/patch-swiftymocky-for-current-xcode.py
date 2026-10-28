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
    print("SwiftyMocky Optional-literal backport already applied")
elif digest == "4501e35beab03bbd80a8c796abb8e3d98c7dee573f255376ba47cdb87c61a192":
    patched, count = re.subn(rb"^extension Optional:.*?^}\n\n", b"", original, flags=re.M | re.S)
    assert count == 6
    source.chmod(source.stat().st_mode | stat.S_IWUSR)
    source.write_bytes(patched)
    print("Applied upstream SwiftyMocky Optional-literal compatibility backport")
else:
    raise SystemExit("Unexpected SwiftyMocky source; review the compatibility backport before applying")

# SwiftyMocky's newer podspec also replaces the obsolete XCTest overlay library.
# Apply that upstream linker correction to CocoaPods-generated settings only.
if len(sys.argv) == 1:
    support = Path(__file__).resolve().parents[1] / "Pods/Target Support Files/SwiftyMocky"
    configs = list(support.glob("*.xcconfig"))
    if not configs:
        raise SystemExit("Missing SwiftyMocky CocoaPods xcconfig files")
    for config in configs:
        text = config.read_text()
        if "-weak-lswiftXCTest" in text:
            config.chmod(config.stat().st_mode | stat.S_IWUSR)
            config.write_text(text.replace("-weak-lswiftXCTest", "-weak-lXCTestSwiftSupport"))
        elif "-weak-lXCTestSwiftSupport" not in text:
            raise SystemExit("Unexpected SwiftyMocky linker settings; review the backport")
    print("Applied upstream XCTestSwiftSupport linker settings")
