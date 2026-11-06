#!/usr/bin/env python3
"""Run production mood/stress Foundation tests without an iOS build."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    if shutil.which('xcrun'):
        compiler = ['xcrun', 'swift']
    elif shutil.which('swift'):
        compiler = ['swift']
    else:
        raise SystemExit('Install Swift or use macOS with Xcode command-line tools')
    with tempfile.TemporaryDirectory(prefix='introspective-mood-analytics-') as directory:
        build = Path(directory)
        (build / 'Common').mkdir()
        (build / 'Tests').mkdir()
        common = ROOT / 'Common/Common/Utils'
        for name in ['MoodTrackingPreferences.swift', 'MoodReviewAnalytics.swift',
                     'StressTracking.swift', 'StressReviewAnalytics.swift', 'StressReminderSettings.swift']:
            shutil.copy2(common / name, build / 'Common' / name)
        for name in ['MoodAnalyticsTests.swift', 'StressAnalyticsTests.swift', 'StressReminderPlanTests.swift']:
            source = ROOT / 'MoodHealthTests' / name
            shutil.copy2(source, build / 'Tests' / source.name)
        (build / 'Package.swift').write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "MoodAnalyticsValidation", platforms: [.macOS(.v13)], targets: [
    .target(name: "Common", path: "Common"),
    .testTarget(name: "MoodAnalyticsTests", dependencies: ["Common"], path: "Tests"),
], swiftLanguageVersions: [.v5])
''')
        # SwiftPM supplies the platform's XCTest Swift overlay and discovers every test method.
        # No remote packages, alternate implementation, or hand-maintained test subset.
        # Keep caches writable in restricted cloud environments without changing HOME.
        cache = build / 'cache'
        environment = os.environ.copy()
        environment.update(XDG_CACHE_HOME=str(cache),
                           CLANG_MODULE_CACHE_PATH=str(cache / 'clang'),
                           SWIFTPM_MODULECACHE_OVERRIDE=str(cache / 'modules'))
        subprocess.run([*compiler, 'test', '--package-path', directory, '--jobs', '2',
                        '--cache-path', str(cache / 'packages'),
                        '--config-path', str(cache / 'configuration'),
                        '--security-path', str(cache / 'security')], check=True, env=environment)


if __name__ == '__main__':
    main()
