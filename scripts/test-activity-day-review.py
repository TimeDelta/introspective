#!/usr/bin/env python3
"""Run production activity-day models/routing and native XCTest cases with SwiftPM."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    if shutil.which("xcrun"):
        compiler = ["xcrun", "swift"]
    elif shutil.which("swift"):
        compiler = ["swift"]
    else:
        raise SystemExit("Install Swift or use macOS with Xcode command-line tools")
    with tempfile.TemporaryDirectory(prefix="introspective-activity-day-review-") as directory:
        build = Path(directory)
        (build / "Common").mkdir()
        (build / "Tests").mkdir()
        for name in ("ActivityDayReview", "ActivityCatchUpRouting"):
            shutil.copy2(ROOT / f"Common/Common/Utils/{name}.swift", build / f"Common/{name}.swift")
            shutil.copy2(ROOT / f"MoodHealthTests/{name}Tests.swift", build / f"Tests/{name}Tests.swift")
        shutil.copy2(ROOT / "MoodHealthTests/ActivityGapChoicesTests.swift", build / "Tests/ActivityGapChoicesTests.swift")
        (build / "Package.swift").write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "ActivityDayReviewValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Common", path: "Common"),
    .testTarget(name: "ActivityDayReviewTests", dependencies: ["Common"], path: "Tests"),
], swiftLanguageVersions: [.v5])
''')
        cache = build / "cache"
        environment = os.environ.copy()
        environment.update(XDG_CACHE_HOME=str(cache),
                           CLANG_MODULE_CACHE_PATH=str(cache / "clang"),
                           SWIFTPM_MODULECACHE_OVERRIDE=str(cache / "modules"))
        subprocess.run([*compiler, "test", "--package-path", directory, "--jobs", "2",
                        "--cache-path", str(cache / "packages"),
                        "--config-path", str(cache / "configuration"),
                        "--security-path", str(cache / "security")], check=True, env=environment)


if __name__ == "__main__":
    main()
