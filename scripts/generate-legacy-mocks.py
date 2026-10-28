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
IMPORTS = ["HealthKit", "CoreData", "Presentr", "CSV", "SwiftDate", "UserNotifications", "Instructions", "UIKit"]


def compatible_template(source):
    # Adapt the frozen SwiftyMocky 4 template to the frozen Sourcery 2.3 runtime.
    # Keep the installed dependency unchanged and fail clearly if it changes.
    old_signature = "[String: SourceryRuntime.Attribute]"
    old_mapping = "return attributes.map { $0.1.description }"
    if (source.count(".characters.split(") != 6 or source.count(old_signature) != 1
            or source.count(old_mapping) != 1):
        raise RuntimeError("Unexpected SwiftyMocky template; review compatibility adapter")
    selection = 'let autoMockable: Bool = type.inheritedTypes.contains("AutoMockable") || type.annotations["AutoMockable"] != nil'
    if source.count(selection) != 1:
        raise RuntimeError("Unexpected SwiftyMocky type selection; review module filter")
    variables = 'let allVariables = uniques(variables: aProtocol.allVariables.filter({ !$0.isStatic }))'
    if source.count(variables) != 1:
        raise RuntimeError("Unexpected SwiftyMocky property selection; review inline mock adapter")
    instance_methods = 'aProtocol.allMethods.filter({ !$0.isStatic })'
    static_methods = 'aProtocol.allMethods.filter({ $0.isStatic })'
    if source.count(instance_methods) != 2 or source.count(static_methods) != 2:
        raise RuntimeError("Unexpected SwiftyMocky method selection; review initializer adapter")
    return (source.replace(instance_methods, 'aProtocol.allMethods.filter({ !$0.isStatic || $0.isInitializer })')
            .replace(static_methods, 'aProtocol.allMethods.filter({ $0.isStatic && !$0.isInitializer })')
            .replace(".characters.split(", ".split(")
            .replace(old_signature, "[String: [SourceryRuntime.Attribute]]")
            .replace(old_mapping, "return attributes.values.flatMap { $0 }.map { $0.description }")
            .replace(selection, selection + '\n    if autoMockable, let selected = argument["mockTypes"] as? [String], !selected.contains(type.name) { continue }')
            .replace(variables, 'let manual = (argument["manualProperties"] as? [String: [String]])?[type.name] ?? []\n    let allVariables = uniques(variables: aProtocol.allVariables.filter({ !$0.isStatic && (autoMockable || !manual.contains($0.name)) }))'))


def manual_properties():
    properties = {}
    for path in (ROOT / "IntrospectiveTests/CustomMocks").rglob("*.swift"):
        prefix = path.read_text().split("// sourcery:inline:", 1)[0]
        match = re.search(r"\bclass\s+(\w+)", prefix)
        if match:
            properties[match[1]] = sorted(set(re.findall(r"\bvar\s+(\w+)", prefix)))
    return properties


def configurations():
    template = ROOT / "ci-output/mock-templates/Mock.swifttemplate"
    modules = []
    for output in sorted((ROOT / "IntrospectiveTests").glob("*Mocks.swift")):
        module = output.stem.removesuffix("Mocks")
        source_dir = ROOT / module / module
        if not source_dir.is_dir():
            source_dir = ROOT / module
        if not source_dir.is_dir():
            continue
        files = [path for path in sorted(source_dir.rglob("*.swift"))
                 if not re.search(r"Delegate|Mock|DateExtension", path.name)]
        if files:
            modules.append((module, output, files))
    # Sourcery must see cross-module parent protocols (e.g. Sample -> Attributed).
    # Every inline custom mock gets the same complete inheritance information.
    sources = [str(ROOT / "IntrospectiveTests/CustomMocks")]
    sources += sorted({str(path) for _, _, files in modules for path in files})
    for module, output, files in modules:
        # Parse dependencies without emitting their AutoMockable classes again.
        names = sorted({name for path in files
                        for name in re.findall(r"\b(?:protocol|class|struct|enum)\s+(\w+)", path.read_text())})
        yield module, {
            "sources": {"include": sources},
            "templates": [str(template)],
            "output": str(output),
            "args": {"testable": TESTABLE, "import": IMPORTS, "mockTypes": names, "manualProperties": manual_properties()},
        }


def combined_configuration(configs):
    if not configs:
        raise RuntimeError("No legacy mock inputs found")
    result = dict(configs[0])
    result["output"] = str(ROOT / "IntrospectiveTests/CommonMocks.swift")
    result["args"] = dict(result["args"], mockTypes=sorted({
        name for config in configs for name in config["args"]["mockTypes"]}))
    if any(config["sources"] != result["sources"] for config in configs):
        raise RuntimeError("Mock configurations must share complete protocol inputs")
    return result


def finish_combined_output(configs, combined):
    output = Path(combined["output"])
    source = output.read_text()
    names = re.findall(r"^(?:open|public(?: final)?) class (\w+Mock)\b", source, re.MULTILINE)
    required = {"DatabaseMock", "QueryMock", "ActivityDAOMock", "SampleGroupInformationMock"}
    if not required.issubset(names) or len(names) != len(set(names)):
        raise RuntimeError("Combined mock output is missing core mocks or contains duplicate declarations")
    # Keep the original project source references; their declarations now live
    # in CommonMocks.swift. Inline custom mocks remain in their own files.
    for config in configs:
        previous = Path(config["output"])
        if previous != output:
            previous.write_text("// Generated legacy mocks are consolidated in CommonMocks.swift.\n")
    print(f"Generated {len(names)} protocol mocks in one pass; preserved custom inline mocks.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config-only", action="store_true")
    options = parser.parse_args()
    config_dir = ROOT / "ci-output/mock-configs"
    config_dir.mkdir(parents=True, exist_ok=True)
    sourcery = ROOT / "Pods/Sourcery/bin/sourcery"
    source = ROOT / "Pods/SwiftyMocky/Sources/SwiftyMocky/Mock.swifttemplate"
    if source.exists():
        template = ROOT / "ci-output/mock-templates/Mock.swifttemplate"
        template.parent.mkdir(parents=True, exist_ok=True)
        template.write_text(compatible_template(source.read_text()))
    elif not options.config_only:
        raise FileNotFoundError("Run pod install --deployment before generating mocks")
    configs = []
    for module, config in configurations():
        path = config_dir / (module + ".yml")
        path.write_text(json.dumps(config, indent=2) + "\n")
        configs.append(config)
    combined = config_dir / "all.yml"
    config = combined_configuration(configs)
    combined.write_text(json.dumps({"configurations": [config]}, indent=2) + "\n")
    if not options.config_only:
        # Parse inheritance and rewrite inline mocks once, rather than once per module.
        subprocess.run([str(sourcery), "--config", str(combined)], cwd=ROOT, check=True)
        finish_combined_output(configs, config)


if __name__ == "__main__":
    main()
