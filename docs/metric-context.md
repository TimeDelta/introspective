# Dated context for activity measurements and lost items

In **Explore → Activity Levels**, each measurement explains its specific
limitations. Tap Active Energy, Steps, or Workouts to review or add context for
that measurement. The **Context** button opens context across all metrics.
In **Record → Lost Items**, use **Context and limitations** beneath the summary.

Use **+** to record illness, travel, unusual exercise, a device not being worn,
a routine change, a medication change, or another circumstance. Choose the metric
it applies to, or **All metrics**, and add a note if useful. A start without an end
marks a single moment; enabling an end records a period. Context is stored locally.
It annotates the measurements without changing the Health data or lost/found counts.

Tap a context entry to edit it, or swipe to delete it after confirmation. Edits
remain a draft until Save. The context list initially follows the period selected
on the originating screen. Switch to **All time** to include other dates while
keeping the metric filter. Global context appears for each relevant metric.
The list loads at most 200 recent entries and reports the total matching count.

**Metric Context** is also available in the query builder, with category, metric,
note, timestamp and optional end-date restrictions. These queries can be saved,
reopened and combined with other query types. Query result rows display both
boundaries and open the same editor; saved-query results refresh after an edit.

The limitations cover device wear and energy estimates, carrying a device and
false or missed steps, workout detection and duplicate records, and opportunities
to lose or find items. These descriptive measurements are not an ADHD severity or
restfulness score. Phone motion is not collected.

## Date handling and storage

Manual date/time wheel changes clear seconds and fractional seconds. **Now** and
untouched existing dates retain their precision. Toggling an existing end off and
back on preserves its original value. Equal start and end boundaries are stored
as a point. Invalid or reversed ranges cannot be saved.

Period filtering includes points at the start and excludes points at the end.
An interval appears when it overlaps the selected period; an interval ending
exactly at the period's start does not overlap. Historical ranges stay fixed;
live periods can include entries added while the context screen is open.

The `MetricContext` model adds one entity and preserves all existing entities and
all five earlier model versions. Sample type ID 18 and the category/metric order
are stable identifiers used by saved queries. Regression tests cover migration
from the previous model, disk reopen, edits/deletion, filtering, saved queries,
CSV encoding, actual editor callbacks, bounded lists and per-metric explanations.

## CSV exports

In **Settings → Export Data**, choose **Metric Context** or **Lost Item Events**.
The context CSV includes the timestamp, optional end, category, metric key, and
note. The lost-item CSV includes the timestamp, signed change (`1` lost, `-1`
found), and note. Dates use UTC ISO 8601 with milliseconds; quoted fields preserve
commas, quotation marks, Unicode, and line breaks.

Both exports include all saved records, in chronological order. They read a
snapshot taken when export starts, so edits during export do not change its rows.
Large exports read at most 200 managed records at a time. The existing Active
Exports controls support pausing, continuing, cancelling, and sharing the file.
Cancelling or encountering a write error removes the incomplete file.
