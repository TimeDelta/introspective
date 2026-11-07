#!/usr/bin/env python3
"""Generate stable HealthKit metatypes from the checked-in SDK catalog.

The manifest is append-only. Generation never consults the current device or
downloads documentation, so OS availability cannot renumber saved query IDs.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'scripts/healthkit-catalog.json'
SAMPLES = ROOT / 'Samples/Samples/HealthKit/Catalog/HealthCatalog.generated.swift'
QUERIES = ROOT / 'Queries/Queries/HealthKit/HealthCatalogQueryRegistry.generated.swift'
LEGACY = ['Activity', 'BloodPressure', 'BodyMassIndex', 'DietarySugar', 'FatigueImpl',
          'HeartRate', 'LeanBodyMass', 'MedicationDose', 'MoodImpl', 'PainImpl',
          'RestingHeartRate', 'SexualActivity', 'Sleep', 'Weight', 'Steps',
          'ActiveEnergy', 'Workout', 'LostItemEvent', 'MetricContextEntry',
          'StressCheckIn', 'StressorResponse']
FAMILIES = {'quantity', 'category', 'correlation', 'clinical', 'document', 'characteristic',
            'activitySummary', 'workout', 'workoutRoute', 'heartbeatSeries',
            'electrocardiogram', 'audiogram', 'visionPrescription', 'stateOfMind',
            'scoredAssessment', 'medicationDose', 'userAnnotatedMedication',
            'verifiableClinical', 'attachment'}
EXTERNAL = {'characteristic', 'activitySummary', 'userAnnotatedMedication',
            'verifiableClinical', 'attachment'}
# Documented +unitFromString: spellings, including the two permitted forms of
# liter. Restricting the manifest prevents untrusted strings reaching that ObjC
# parser, whose errors are exceptions rather than Swift throws.
UNITS = {'g', 'kg', 'm', 'cm', 'm/s', 'count', '%', 'degC', 'S', 'min', 'count/min',
         'count/s', 'kcal', 'kcal/(kg*hr)', 'ml/(kg*min)', 'W', 'dBASPL', 'ms',
         'mmHg', 'L', 'mL', 'L/min', 'mg/dL', 'IU', 'appleEffortScore'}
# Freeze every ID in the initial catalog, independently of names/units/labels.
# Future entries append above 229; existing saved queries must never be remapped.
INITIAL_IDENTITY_HASH = '267a5577ae5cae8047b3868a126390146d78ec2e6e093df9b68d29d983a6da81'


def validate(data: dict) -> list[dict]:
    if data.get('schemaVersion') != 1 or data.get('sdkVersion') != '26.2':
        raise ValueError('Unsupported catalog schema/SDK; review a new SDK explicitly')
    if data.get('legacyIDs') != {str(i): name for i, name in enumerate(LEGACY)}:
        raise ValueError('Existing sample IDs 0–20 must remain unchanged')
    entries = data.get('entries')
    if not isinstance(entries, list) or len(entries) < 221:
        raise ValueError('The supported SDK catalog must not shrink')
    ids, identifiers, symbols = set(), set(), set()
    for entry in entries:
        ident, stable_id, symbol = entry.get('identifier'), entry.get('id'), entry.get('swiftName')
        if type(stable_id) is not int or not 0 <= stable_id <= 32767 or stable_id in ids:
            raise ValueError(f'Duplicate or invalid stable ID: {stable_id!r}')
        if not isinstance(ident, str) or not re.fullmatch(r'HK[A-Za-z0-9]+', ident) or ident in identifiers:
            raise ValueError(f'Duplicate or invalid Health identifier: {ident!r}')
        if not isinstance(symbol, str) or not re.fullmatch(r'[A-Z][A-Za-z0-9]+Definition', symbol) or symbol in symbols:
            raise ValueError(f'Duplicate or invalid Swift definition: {symbol!r}')
        if entry.get('family') not in FAMILIES:
            raise ValueError(f'Unknown family for {ident}')
        version = entry.get('minimumOS', '')
        if not isinstance(version, str) or not re.fullmatch(r'\d+(?:\.\d+){0,2}', version):
            raise ValueError(f'Invalid OS version for {ident}')
        pieces = tuple(int(piece) for piece in version.split('.'))
        if (pieces + (0,) * (3 - len(pieces))) > (26, 2, 0):
            raise ValueError(f'{ident} is not part of SDK 26.2')
        for key in ('name', 'group'):
            if not isinstance(entry.get(key), str) or not entry[key].strip():
                raise ValueError(f'Missing {key} for {ident}')
        legacy = entry.get('legacyType')
        if stable_id < len(LEGACY):
            if legacy != LEGACY[stable_id]:
                raise ValueError(f'Legacy metatype changed for {ident}')
        elif legacy is not None:
            raise ValueError(f'A new entry cannot reuse a legacy type: {ident}')
        if entry['family'] == 'quantity' and entry.get('canonicalUnit') not in UNITS:
            raise ValueError(f'Unsupported canonical unit for {ident}: {entry.get("canonicalUnit")}')
        labels = entry.get('categoryValues', {})
        if not isinstance(labels, dict) or any(not re.fullmatch(r'-?\d+', str(k)) or
                not isinstance(v, str) or not v for k, v in labels.items()):
            raise ValueError(f'Invalid category labels for {ident}')
        ids.add(stable_id); identifiers.add(ident); symbols.add(symbol)
    if sorted(i for i in ids if i >= 21) != list(range(21, max(ids) + 1)):
        raise ValueError('New stable IDs must remain append-only, without holes')
    initial = sorted((entry['id'], entry['identifier']) for entry in entries if entry['id'] <= 229)
    identity_hash = hashlib.sha256(json.dumps(initial, separators=(',', ':')).encode()).hexdigest()
    if identity_hash != INITIAL_IDENTITY_HASH:
        raise ValueError('An existing catalog identifier was removed or assigned a different saved ID')
    aliases = data.get('aliases', {})
    if not isinstance(aliases, dict) or any(a in identifiers or target not in identifiers
            or a == target for a, target in aliases.items()):
        raise ValueError('Aliases must target one canonical catalog entry')
    sources = data.get('sources', [])
    if not sources or any(not re.fullmatch(r'[a-f0-9]{64}', source.get('sha256', ''))
                          or not source.get('url', '').startswith('https://') for source in sources):
        raise ValueError('SDK source provenance is missing')
    return sorted(entries, key=lambda e: e['id'])


def string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def sample_type(entry: dict) -> str | None:
    if entry['family'] in EXTERNAL:
        return None
    if entry.get('legacyType'):
        return entry['legacyType']
    wrapper = {'quantity': 'HealthQuantity', 'category': 'HealthCategory'}.get(entry['family'], 'HealthSpecializedSample')
    return f'{wrapper}<{entry["swiftName"]}>'


def descriptor(entry: dict) -> str:
    fields = [f'id: {entry["id"]}', f'identifier: {string(entry["identifier"])}',
              f'name: {string(entry["name"])}', f'group: {string(entry["group"])}',
              f'family: .{entry["family"]}', f'minimumOS: {string(entry["minimumOS"])}']
    if entry.get('canonicalUnit'):
        fields.append(f'canonicalUnit: {string(entry["canonicalUnit"])}')
    if entry.get('categoryValues'):
        labels = ', '.join(f'{int(k)}: {string(v)}' for k, v in sorted(entry['categoryValues'].items(), key=lambda p: int(p[0])))
        fields.append(f'categoryValues: [{labels}]')
    return 'HealthTypeDescriptor(' + ', '.join(fields) + ')'


def render(data: dict) -> tuple[str, str]:
    entries = validate(data)
    header = '// Generated by scripts/generate-healthkit-catalog.py; edit the versioned manifest instead.\n'
    body = [header, 'import Foundation\n\npublic enum HealthCatalogGenerated {\n']
    aliases = ', '.join(f'{string(key)}: {string(value)}' for key, value in sorted(data.get('aliases', {}).items()))
    body.append(f'    public static let aliases: [String: String] = [{aliases}]\n')
    chunks = [entries[i:i + 24] for i in range(0, len(entries), 24)]
    body.append('    public static let descriptors: [HealthTypeDescriptor] = ' +
                ' + '.join(f'descriptors{i}()' for i in range(len(chunks))) + '\n')
    body.append('    private static let byID: [Int16: HealthTypeDescriptor] = Dictionary(uniqueKeysWithValues: descriptors.map { ($0.id, $0) })\n')
    body.append('    public static func descriptor(for id: Int16) -> HealthTypeDescriptor {\n'
                '        guard let value = byID[id] else { preconditionFailure("Invalid generated catalog ID") }\n'
                '        return value\n    }\n')
    for index, chunk in enumerate(chunks):
        body.append(f'    private static func descriptors{index}() -> [HealthTypeDescriptor] {{ [\n')
        body.extend('        ' + descriptor(entry) + ',\n' for entry in chunk)
        body.append('    ] }\n')
    queryable = [entry for entry in entries if sample_type(entry)]
    registration_chunks = [queryable[i:i + 24] for i in range(0, len(queryable), 24)]
    body.append('    public static let registrations: [HealthCatalogRegistration] = ' +
                ' + '.join(f'registrations{i}()' for i in range(len(registration_chunks))) + '\n')
    for index, chunk in enumerate(registration_chunks):
        body.append(f'    private static func registrations{index}() -> [HealthCatalogRegistration] {{ [\n')
        body.extend(f'        HealthCatalogRegistration(descriptor: descriptor(for: {entry["id"]}), sampleType: {sample_type(entry)}.self),\n' for entry in chunk)
        body.append('    ] }\n')
    body.append('}\n\n')
    for entry in entries:
        body.append(f'public enum {entry["swiftName"]}: HealthCatalogDefinition {{\n'
                    f'    public static var catalogEntry: HealthTypeDescriptor {{ HealthCatalogGenerated.descriptor(for: {entry["id"]}) }}\n}}\n')
    query = [header, 'import Samples\n\n/// Builders preserve a distinct concrete query metatype per saved sample ID.\n'
             'enum HealthCatalogQueryRegistry {\n'
             '    private static let builders: [ObjectIdentifier: () -> Query] = {\n'
             '        var values: [ObjectIdentifier: () -> Query] = [:]\n']
    query.extend(f'        values[ObjectIdentifier({sample_type(entry)}.self)] = {{ CatalogHealthKitQuery<{sample_type(entry)}>() }}\n'
                 for entry in queryable if entry['id'] >= 21)
    query.append('        return values\n    }()\n'
                 '    static func makeQuery(for type: Sample.Type) -> Query? { builders[ObjectIdentifier(type)]?() }\n}\n')
    return ''.join(body), ''.join(query)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Fail if generated sources differ')
    args = parser.parse_args()
    try:
        samples, queries = render(json.loads(MANIFEST.read_text()))
        for path, value in [(SAMPLES, samples), (QUERIES, queries)]:
            if args.check:
                if not path.is_file() or path.read_text() != value:
                    raise ValueError(f'Generated catalog is stale: {path.relative_to(ROOT)}')
            else:
                path.write_text(value)
    except (ValueError, KeyError, OSError, TypeError) as error:
        print(str(error), file=sys.stderr)
        return 1
    print('HealthKit SDK 26.2 catalog sources are current.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
