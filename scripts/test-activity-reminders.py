#!/usr/bin/env python3
"""Run the production activity reminder planner/preferences and the native tests."""
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
    with tempfile.TemporaryDirectory(prefix="introspective-activity-reminders-") as directory:
        build = Path(directory)
        (build / "Common").mkdir()
        (build / "Tests").mkdir()
        shutil.copy2(ROOT / "Common/Common/Utils/ActivityReminderSettings.swift", build / "Common/ActivityReminderSettings.swift")
        shutil.copy2(ROOT / "MoodHealthTests/ActivityReminderPlanTests.swift", build / "Tests/ActivityReminderPlanTests.swift")
        (build / "Package.swift").write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "ActivityReminderValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Common", path: "Common"),
    .testTarget(name: "ActivityReminderPlanTests", dependencies: ["Common"], path: "Tests"),
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
