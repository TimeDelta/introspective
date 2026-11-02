#!/usr/bin/env python3
"""Compile the production formatter cache with Foundation and benchmark it on macOS."""
import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--iterations', type=int, default=2000)
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error('--iterations must be positive')
    if shutil.which('xcrun') is None:
        parser.error('macOS with Xcode command-line tools is required')
    production = (ROOT / 'Common/Common/Utils/CalendarUtil.swift').read_text()
    marker = '\ninternal final class CalendarStyleFormatterCache {'
    if production.count(marker) != 1:
        parser.error('could not locate the production formatter cache')
    helper = production[production.index(marker):]
    benchmark = (ROOT / 'scripts/date-formatting-benchmark.swift').read_text()
    with tempfile.TemporaryDirectory(prefix='introspective-date-benchmark-') as directory:
        source = Path(directory) / 'main.swift'
        executable = Path(directory) / 'benchmark'
        source.write_text('import Foundation\n' + helper + '\n' + benchmark)
        subprocess.run(['xcrun', 'swiftc', '-swift-version', '5', '-O', str(source), '-o', str(executable)], check=True)
        subprocess.run([str(executable), str(args.iterations)], check=True)


if __name__ == '__main__':
    main()
