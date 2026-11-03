#!/usr/bin/env python3
"""Run the actual dashboard value/persistence XCTest sources without an iOS build."""
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    if shutil.which('xcrun') is None:
        raise SystemExit('macOS with Xcode command-line tools is required')
    with tempfile.TemporaryDirectory(prefix='introspective-dashboard-') as directory:
        build = Path(directory)
        (build / 'Common').mkdir()
        (build / 'Tests').mkdir()
        for name in ['PinnedQueryPreferences.swift', 'PinnedQuerySummary.swift', 'QueryReadScope.swift']:
            shutil.copy2(ROOT / 'Common/Common/Utils' / name, build / 'Common' / name)
        for name in ['PinnedQueryPreferencesTests.swift', 'PinnedQuerySummaryTests.swift']:
            shutil.copy2(ROOT / 'MoodHealthTests' / name, build / 'Tests' / name)
        (build / 'Package.swift').write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "DashboardValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Common", path: "Common"),
    .testTarget(name: "DashboardTests", dependencies: ["Common"], path: "Tests"),
])
''')
        subprocess.run(['xcrun', 'swift', 'test', '--package-path', directory], check=True)


if __name__ == '__main__':
    main()
