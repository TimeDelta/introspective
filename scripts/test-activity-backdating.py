#!/usr/bin/env python3
"""Run the production activity backdating helper and its native tests with SwiftPM."""
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
    with tempfile.TemporaryDirectory(prefix="introspective-activity-backdating-") as directory:
        build = Path(directory)
        (build / "Samples").mkdir()
        (build / "Tests").mkdir()
        shutil.copy2(ROOT / "Samples/Samples/Utils/ActivityBackdate.swift", build / "Samples/ActivityBackdate.swift")
        shutil.copy2(ROOT / "MoodHealthTests/ActivityBackdateTests.swift", build / "Tests/ActivityBackdateTests.swift")
        (build / "Package.swift").write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "ActivityBackdatingValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Samples", path: "Samples"),
    .testTarget(name: "ActivityBackdateTests", dependencies: ["Samples"], path: "Tests"),
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
