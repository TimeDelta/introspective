# Apple Health data catalog

Introspective can read and explore the public HealthKit data types cataloged
from the iOS 26.2 SDK. The app requires iOS 18 or later; each catalog entry has
its own availability check. Medication dose events and the medication list
require iOS 26, and hypertension events require iOS 26.2. Unavailable types do
not appear in the current device's choices.

The checked-in catalog contains **221 descriptors**: 120 quantities, 69
categories and 32 entries across other record families. It adds 209 permanent
IDs, **21–229**, including **199 new dated sample metatypes**. Existing sample
IDs **0–20** keep their original meanings. There are 211 dated sample
registrations in total; the remaining 10 descriptors use dedicated readers or
parent-record access. A descriptor does not imply that the device contains
records or that Health will share them with this app.

## Browse, query and graph

Open **Explore → Health Data** to browse available types, grouped by subject.
Search matches names, groups, record families and HealthKit identifiers, without
reading Health data or requesting access. Select a readable type to request
its access and read the records visible to the app. The attachments entry
instead explains how to open a parent record. Pull to refresh or use the
refresh button after changing access in Health. An empty result can mean no
matching records or limited access; Health does not reveal whether read
permission was denied.

For dated samples, use **Explore → Query** and choose a data type. The type
chooser's **Search** button provides grouped results and matches every entered
search term without case or accent sensitivity. The wheel and search select
the same permanent type. Saved queries, conditions and custom graphs use the
available attributes for that type. Numeric graphs require a suitable numeric
attribute; a document or prescription is not reduced to an invented health
score. Query evaluation and graph processing run on-device.

The Timeline currently supports its existing registered fetchers, a smaller
set than the catalog. Its type chooser lists only those supported types. Use
queries, custom graphs or Health Data for the expanded catalog.

Opening a dated result shows its recorded values and provenance. Tap a field
to read its full text. **Measurements** reads ECG voltages, heartbeat offsets,
workout-route locations or quantity-series intervals when present. **More**
provides attachments, original CDA document content or routes belonging to a
workout, as applicable. The share action exports the displayed field snapshot
as JSON; separately loaded measurement screens are not automatically included
in the parent snapshot. This is not a complete Health database backup. Data
stays on-device unless you explicitly share or export it.

## Values and timestamps

New quantity types expose **Value** in the manifest's fixed canonical unit.
Saved query thresholds keep that unit even if display preferences change.
For example, distance values use metres. HealthKit percent quantities use
fractions: oxygen saturation `0.95` means 95%, so a threshold of `95` would have
a different meaning. The value attribute labels this convention. The original
Health quantity remains available in record details.

Categories expose a text label and a separate **Raw Health Category Code**.
Codes are identifiers for exact comparisons and diagnostics, not continuous
clinical scores. Unknown codes retain their raw value instead of being changed
to a known category. Recorded GAD-7/PHQ-9 scores, risks and answers are shown as
recorded; the app does not diagnose a condition from them. Medication dose
quantities retain their medication concept and unit rather than being averaged
across different medicines or units.

Health samples retain their original UUID, start/end instants, source revision,
device and available metadata. Detail fields include readable timestamps and
raw **reference seconds** measured from 2001-01-01 00:00:00 UTC. Raw values
preserve the stored `Date` precision, including fractional seconds; readable
ISO timestamps can have coarser precision. Use the raw value to reconstruct an
instant with `Date(timeIntervalSinceReferenceDate:)`. Do not round imported
Health timestamps to mark them as estimated. The separate
[manual timestamp picker rules](timestamp-precision.md) describe when manual
edits clear seconds or fractions.

Profile values and medication-list entries have no fabricated event dates.
Date of birth remains the components returned by Health rather than an
invented timestamp. Activity summaries retain their calendar day and calendar
context. Series retain recorded order, intervals, missing values and heartbeat
gap flags; the reader does not fill gaps, interpolate voltages or infer route
points. Workout and correlation details retain the available component data
and provenance.

## Record families and access limits

| Family | Available inspection |
| --- | --- |
| Quantities and categories | Dated values, labels/codes, duration and provenance; quantity series when present. |
| Correlations | Blood pressure and food, including the original component measurements. |
| Workouts and series | Workout events, activities and statistics; associated routes; ECG and heartbeat measurements. |
| Hearing, vision and mental health | Audiogram frequencies/tests, glasses or contact-lens prescriptions, State of Mind and recorded GAD-7/PHQ-9 assessments. |
| Clinical records | Allergy, clinical note, condition, coverage, immunization, laboratory result, medication, procedure and vital-sign records, with available original FHIR content. |
| Documents | CDA metadata, with original content requested separately for the selected document. |
| Health profile and activity summaries | Six characteristics and daily activity summaries through their dedicated public APIs. |
| Medications | Dated dose events and the separate, undated user-annotated medication list on iOS 26+. |
| Verifiable clinical records | Records explicitly selected through Apple's credential selection flow. |
| Attachments | Metadata and file previews accessed through an authorized parent Health record. |

Authorization is requested for the selected type and required related types,
without a catalog-wide prompt or new write permissions. Correlations require
access to their component quantity types, and workout routes require workout
and route access. Types requiring per-object access, such as vision
prescriptions, use Apple's object-selection authorization UI.

Clinical reads require Health Records support on the device and a provisioned
app with the **HealthKit → Clinical Health Records** capability. The app
entitlements include `com.apple.developer.healthkit.access = [health-records]`,
and `NSHealthClinicalHealthRecordsShareUsageDescription` explains on-device
review and exploration of chosen records. A build or simulator test alone
does not establish that clinical access works for a particular account, region,
provider or signed distribution build.

Verifiable credentials use Apple's user selection flow for the public COVID-19,
immunization, laboratory and recovery kinds from supported SMART Health Card
and EU Digital COVID Certificate sources. They are not an unrestricted clinical
record query. Attachments likewise have no standalone global query: open an
individual Health record, then **More → Attachments**. Files are streamed to a
temporary local file for preview.

The medication list exposes only the public fields returned by HealthKit:
display text, nickname, concept identifier/domain, general form, related
clinical codings, archived status and whether a schedule exists. It does not
expose the full schedule or imply a complete prescription history. Medication
dose events retain their available status, schedule information, quantities,
unit and medication concept identifier.

The expansion adds read-only types. It adds no recording forms or raw-record
correction/deletion actions; make changes in Health or the originating app.
Existing local recording and the separately documented
[manual State of Mind import/export](health-mood-exchange.md) remain distinct
workflows. Coverage is limited to the versioned public API catalog and the
records Health makes available; it does not include private Apple APIs or
every field visible in the Health app.

## Catalog maintenance and validation

[scripts/healthkit-catalog.json](../scripts/healthkit-catalog.json) is the source
of truth for identifiers, permanent IDs, families, minimum OS versions, labels,
canonical units and category codes. It records source-header URLs and SHA-256
hashes for the reviewed SDK. The deprecated audio-exposure identifier resolves
to the environmental-audio-exposure entry without a duplicate ID.

After deliberately updating the versioned manifest, regenerate the sample
definitions and query registry from the repository root:

```sh
python3 scripts/generate-healthkit-catalog.py
```

Check that checked-in output matches the manifest and run the generator tests:

```sh
python3 scripts/generate-healthkit-catalog.py --check
python3 -m unittest discover -s scripts/tests -p 'test_healthkit_catalog.py' -v
```

Generation uses the checked-in manifest without querying a device or downloading
SDK documentation. Validation rejects removed or reassigned initial IDs,
duplicate identifiers, invalid units and stale generated sources. Future
entries must append IDs above 229; list order and OS filtering must never
renumber saved queries. A new SDK version requires an explicit generator and
manifest review.

The focused native `MoodHealthTests` target also contains catalog, query,
authorization, fidelity, series, external-reader and Health Data UI tests.
Create it with `ruby scripts/prepare-mood-health-tests.rb` after the setup
described in [Mood exchange validation](health-mood-exchange.md#validation),
then run it in Xcode on a supported simulator. Real-device checks are still
needed for permission sheets, Health Records provisioning, actual credential
selection, attachment previews and newer OS-specific records.
