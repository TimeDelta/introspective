# Timestamp precision, accuracy estimates and forgetfulness proxies

Manual timestamp edits deliberately remove precision that the user did not
specify. The resulting pattern provides an inexpensive signal that an event
time may have been estimated. Preserving this distinction supports the app's
**Estimated Dates (%)** information and the interpretation of recording-delay
or forgetfulness proxy metrics.

Numerical precision describes the timestamp's resolution. Accuracy describes
how closely it matches the actual event. A timestamp with fractional seconds
can still be an inaccurate recollection; a manually selected minute can be an
accurate estimate. The app must preserve the precision signal without treating
it as proof of accuracy or forgetting.

## Picker rules

These rules apply when storing an event time, including activity, mood, pain,
fatigue and stress check-ins where the corresponding picker is used.

| Action | Precision retained |
| --- | --- |
| Automatic capture or import | The supplied timestamp's available precision; do not round it to mark an estimate. |
| Shared picker **Now** or **Last** | All available precision. Last reuses the selected record's precision; it does not invent fractional seconds. |
| Shared date-and-time picker opened and accepted without changing its initial value | All available precision. Opening an editor alone must not mark an existing timestamp as estimated. |
| Manual date/time wheel changes, quick minute adjustments, or explicit minute/hour/day/week/month adjustments | Minute precision: seconds and fractional seconds become zero. Adding an hour still clears seconds and fractions rather than rounding to the start of the hour. |
| Explicit **Seconds** adjustment | Whole-second precision: retain the resulting seconds and clear only fractional seconds. |
| Date-only selection | The first valid instant of the chosen local calendar day. The shared picker's date-only mode takes precedence over Now/Today, Last and an unchanged initial value. |

For example, an automatically captured `14:25:36.123` remains unchanged by
opening and accepting its date-and-time editor. An ordinary manual minute edit
produces `14:25:00.000`. A Seconds adjustment that results in second 36 produces
`14:25:36.000`.

Calendar operations use the applicable calendar and time zone. Do not subtract
fixed 24-hour periods to construct days. On a daylight-saving transition where
midnight does not exist, a date-only choice starts at the day's first valid
instant, which can be 01:00 rather than 00:00.

The stress time editor follows the same distinction: Now preserves full
precision, a changed manual time is reduced to the start of its minute, and Done
without changing the picker preserves the existing timestamp. Manually edited
date/time attributes also clear seconds and fractions. Enabled date-range bounds
are normalized to minutes, or to local day starts in date-only mode, when
accepted. Query range bounds are selection criteria, not recorded events, and
must not be counted as estimated event timestamps.

## Using the estimated-time signal

The existing **Estimated Dates (%)** metric counts selected date values whose
seconds **and** nanoseconds are exactly zero, divided by the number of available
date values. It evaluates the selected date attribute in the current device
calendar. Missing dates are not zero-valued timestamps and do not contribute to
that denominator.

This is a heuristic with possible false positives and false negatives:

- An automatic capture can naturally fall on a minute boundary. Imported data
  can already have minute or date-only precision.
- A Seconds adjustment normally has zero fractions but nonzero seconds, so it
  will not usually match the existing minute-based estimate heuristic.
- Now can be used when recording an event late. Last can reuse an already
  estimated time. Full precision therefore does not prove contemporaneous entry.

The zeroing rules make manual estimates recognizable, but do not establish a
measured precision, recall or error probability for the classifier. Describe
results as possible estimated times, not a count of inaccurate records.

## Interpreting forgetfulness proxies

Timestamp coarseness can help contextualize backfilled records. It cannot by
itself establish a recording delay or a forgotten event. Deliberate retrospective
journaling, convenience, source precision and changes in recording habits can
produce the same pattern.

Activities already have optional **Start Date Set At** and **End Date Set At**
metadata, with **Start Date Offset**, **End Date Offset** and **Total Date Offset**
attributes. These provide more direct timing context when populated. Missing
set-at metadata is unknown, not a zero delay. Future-dated event times can also
produce negative offsets; these must not silently become evidence of forgetting.

**Total Date Offset** requires a start offset and falls back to that start offset
when the end offset is unavailable. It can therefore be partial. Check both
set-at fields before interpreting it as a complete recording-delay measure.

Mood and stress check-ins do not currently have a general, separate entry-time
or timestamp-edit provenance field. A dependable cross-data-type delay metric
would need event time, entry/set-at time and explicit edit/source provenance.
The creation date of a stressor definition is configuration metadata, not the
entry time of its later check-ins. Neither timestamp precision nor recording
delay alone establishes ADHD severity or a clinical memory problem.

## Preserve the evidence

Keep stored instants, their available subsecond precision and relevant source
and time-zone metadata. Apply the zeroing rule at the manual edit boundary;
do not round automatic records, unchanged historical values or every record
during a migration. Grouping into calendar days for a review must not rewrite
the original timestamps. Formatting a label without seconds must not change
the saved value.

Stress check-in and individual response CSV files include **Timestamp Reference
Seconds**, appended after Note. This is the stored `Date` value's reference
seconds as a round-trippable decimal number, measured from **2001-01-01
00:00:00 UTC**. Reconstruct it with
`Date(timeIntervalSinceReferenceDate: Double(field)!)` after validating the field.
Use this raw column for precision analysis; the readable ISO timestamp can show
only milliseconds. Both rows belonging to the same check-in share the raw time.

To express the value as Unix seconds, add `978307200`. Keep the original reference
seconds for lossless reconstruction: converting epochs with floating-point
arithmetic can lose low-order precision. Other, older CSV formats may also omit
fractional seconds. Re-importing a coarser representation cannot recover the
original precision signal and can turn an automatic time near a minute boundary
into an apparent estimate.

Use stored dates, an available raw export value and consistent calendar/source
rules for reproducible analysis. Disclose any lost subsecond precision, and
retain the record's original rating and scale independently of timestamp edits.

Implementation references: [shared picker](../Introspective/UI/Util/SelectDateViewController.swift),
[calendar normalization](../Common/Common/Utils/CalendarUtil.swift),
[estimated-date metric](../SampleGroupInformation/SampleGroupInformation/DateAttributes/EstimatedDatesInformation.swift),
and [stress time editor](../Introspective/UI/RecordData/Stress/StressCheckInViewController.swift).
