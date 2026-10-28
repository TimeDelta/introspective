#!/usr/bin/env python3
"""Regenerate original test mocks using the versions frozen in Podfile.lock.

The SwiftyMocky pod ships its template, so a separately installed CLI is not
needed. JSON configs are valid YAML and avoid a Python package dependency.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TESTABLE = ["Introspective", "AttributeRestrictions", "Attributes", "BooleanAlgebra",
            "Common", "DataExport", "DataImport", "DependencyInjection", "Notifications",
            "Persistence", "Queries", "SampleGroupers", "SampleGroupInformation", "Samples",
            "Settings", "UIExtensions"]
IMPORTS = ["HealthKit", "CoreData", "Presentr", "CSV", "SwiftDate", "UserNotifications", "Instructions"]


def configurations():
    template = ROOT / "Pods/SwiftyMocky/Sources/SwiftyMocky/Mock.swifttemplate"
    for output in sorted((ROOT / "IntrospectiveTests").glob("*Mocks.swift")):
        module = output.stem.removesuffix("Mocks")
        source_dir = ROOT / module / module
        if not source_dir.is_dir():
            source_dir = ROOT / module  # The app keeps its sources directly in Introspective/.
        if not source_dir.is_dir():
            continue
        sources = [str(ROOT / "IntrospectiveTests/CustomMocks")]
        sources += [str(path) for path in sorted(source_dir.rglob("*.swift"))
                    if not re.search(r"Delegate|Mock|DateExtension", path.name)]
        if len(sources) == 1:
            continue
        yield module, {
            "sources": {"include": sources},
            "templates": [str(template)],
            "output": str(output),
            "args": {"testable": TESTABLE, "import": IMPORTS},
        }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config-only", action="store_true")
    options = parser.parse_args()
    config_dir = ROOT / "ci-output/mock-configs"
    config_dir.mkdir(parents=True, exist_ok=True)
    sourcery = ROOT / "Pods/Sourcery/bin/sourcery"
    for module, config in configurations():
        path = config_dir / (module + ".yml")
        path.write_text(json.dumps(config, indent=2) + "\n")
        if not options.config_only:
            subprocess.run([str(sourcery), "--config", str(path), "--disableCache"],
                           cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
