#!/usr/bin/env python3
"""Run the production Foundation analytics/planning tests on macOS without an iOS build."""
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    if shutil.which('xcrun') is None:
        raise SystemExit('macOS with Xcode command-line tools is required')
    with tempfile.TemporaryDirectory(prefix='introspective-mood-analytics-') as directory:
        build = Path(directory)
        (build / 'Common').mkdir()
        (build / 'Tests').mkdir()
        common = ROOT / 'Common/Common/Utils'
        for name in ['MoodTrackingPreferences.swift', 'MoodReviewAnalytics.swift']:
            shutil.copy2(common / name, build / 'Common' / name)
        source = ROOT / 'MoodHealthTests/MoodAnalyticsTests.swift'
        shutil.copy2(source, build / 'Tests' / source.name)
        (build / 'Package.swift').write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "MoodAnalyticsValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Common", path: "Common"),
    .testTarget(name: "MoodAnalyticsTests", dependencies: ["Common"], path: "Tests"),
])
''')
        # SwiftPM supplies the platform's XCTest Swift overlay and discovers every test method.
        # No remote packages, alternate implementation, or hand-maintained test subset.
        subprocess.run(['xcrun', 'swift', 'test', '--package-path', directory], check=True)


if __name__ == '__main__':
    main()
