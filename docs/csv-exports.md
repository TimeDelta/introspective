# CSV exports

Use **Settings → Export Data** to export Activities, Medication Doses, Moods,
Metric Context, or Lost Item Events. Completed files can be shared from Active
Exports. Pause and Continue retain the original export's position; cancelling
removes the incomplete file. A failed write reports an error and removes the
incomplete file so it cannot be shared as a completed export.

All five exporters read saved records on a private Core Data queue. SQLite
exports pin a snapshot when work starts, including related definitions and tags,
so subsequent edits, insertions, or deletions do not change the remaining rows.
The time-zone conversion preference used by activity and medication date fields
is captured when the exporter is created. Changing Settings during an export
does not change that preference halfway through the file.

Activity rows remain ordered by start time; other rows use their timestamps.
Each fetch contains at most 200 primary records. Activity definitions, tags, and
medications are prefetched for each batch and faulted afterwards, releasing their
materialized values even while an export is paused. Completed, cancelled, and
failed exports release the reader and its store reference.

## Compatibility

Existing column names, order, quoted fields, source descriptions, custom mood
scales, and date formats are retained. Activity tag lists use the existing `|`
separator and now have stable alphabetical ordering. Commas, quotation marks,
Unicode, and line breaks in notes remain quoted correctly.

Medication rows now write the **Record Screen Index** value already declared by
their header. Earlier exports omitted this value and shifted the subsequent dose
fields under the wrong headings. Default medication dosage and individual dose
values remain in their original column positions.

The original export functional cases still run in the complete legacy suite.
Additional SQLite/file regressions check 405-record histories, relationship and
settings snapshots, pause/resume, concurrent execution rejection, cancellation,
and a stream failure after writing has begun. A paused activity export also
checks that its registered records and related objects have become faults.
In-memory functional fixtures use the same private reader; query-generation
snapshots are a SQLite feature.
