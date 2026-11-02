# Mood check-ins and weekly review

Open **Record → Check-ins** for Weekly Review, Check-in Presets and Reminders.
The existing **Mood History** remains the place to add a missed check-in or edit
an existing one.

## Weekly review

The default compares the last seven complete calendar days, ending yesterday,
with the seven days immediately before them. **Include Today** instead compares
the seven days through today with their preceding seven days. Today is then
incomplete; future-dated entries are excluded. Every date uses the stored instant
in the device's current calendar and time zone. Periods have inclusive starts
and exclusive ends, so midnight records belong to exactly one period. Calendar
arithmetic handles daylight-saving changes rather than assuming 24-hour days.

Each valid rating is normalized using its own saved scale:

`position = (rating − original minimum) / (original maximum − original minimum)`

The review displays positions as percentages. It preserves all original ratings
and scales. Non-finite values, invalid ranges and out-of-range ratings are
excluded from rating statistics, with separate counts shown under coverage.
They still count as recorded check-ins and recorded days.

- **Daily average:** average each day's valid positions, then give each day with
  valid ratings equal weight. More check-ins on one day do not give that day
  extra weight. Missing days are omitted, never replaced by zero.
- **Per-check-in average:** every valid check-in has equal weight. For example,
  one minimum rating on one day and three maximum ratings on another produce a
  50% daily average and a 75% per-check-in average.
- **Matched weekdays:** compare daily averages only for weekday pairs with valid
  ratings in both periods. The number of available pairs is shown. With no pairs,
  this comparison is unavailable, even if both periods have other recorded days.
- **Distributions:** both periods show counts and percentages in five bins:
  [0%,20%), [20%,40%), [40%,60%), [60%,80%), [80%,100%]. Percentages use each
  period's valid-rating count. Empty periods have unavailable percentages.
- **Median and middle 50%:** percentiles use linear interpolation at `(n − 1) × p`
  in the sorted valid positions. One rating has a median and quartiles equal to
  that rating; an empty period has none.
- **Variation:** sample standard deviation uses `n − 1`, and is unavailable for
  fewer than two valid ratings. It is displayed in percentage points. Changes in
  averages are also percentage points, not relative percentage changes.

Coverage reports recorded days, days with valid ratings, valid and excluded
check-ins, and source counts. Day-by-day rows retain missing days explicitly.
Tap a period to inspect its actual entries. Enable **Show dated context** to
review overlapping mood context and context marked for all metrics, including
intervals that started before the review window. Context can also be added from
the review. It is not automatically interpreted as the cause of a change.

These are descriptive summaries of the entries recorded, not clinical scores,
diagnoses, significance tests or causal estimates. Recording frequency, missing
days, sources and changes in how the scale is used can affect comparisons.
Imported Health daily moods and momentary emotions currently share the local
rating history; the review cannot distinguish those kinds until Health exchange
preserves that metadata.

The UI snapshots managed-object values on their owning queue, calculates
statistics on a worker queue, and rejects stale completions after a new request
or navigation. Notification observers and in-flight calculations do not retain
the review screen. No data or analytics are sent to a service.

## Check-in presets and widgets

Add a preset with a name, rating, original scale, optional note and optional
dated context selections. Tap its row to record immediately at the current time.
Tap its info button to edit; use **Edit** to reorder and swipe to delete. Removing
a preset retains previously recorded data. A preset keeps its saved scale when
the app's recording settings change. A check-in and its selected mood context
are saved in one transaction. Automatic capture retains full timestamp precision.

The first three presets are available to the **Mood Check-in** WidgetKit widget
on iOS 17 or later. Add it from the Home or Lock Screen widget picker. Small
widgets show two presets, medium widgets show three, and Lock Screen accessories
use the first. Buttons record directly without opening the app; the setup link
opens the preset list. Preset content is marked privacy-sensitive and recording
requires authentication. Notes and recent mood history are not displayed in the
widget. The existing Today extension remains available for older installations.

The widget shares the existing app-group database. Open the app at least once
after installation or an update before using it; an extension does not initiate
a database migration. Its bundle identifier is
`com.bnova.Introspective.MoodCheckInWidget`, with the existing
`group.Introspective` entitlement. Distribution signing must include that target
and app group, alongside the app and existing extensions.

## Optional reminders

Reminders start off. Choose up to three local daily times, optional quiet hours
and whether to skip days already recorded, then tap **Save**. iOS authorization
is requested when enabling them. Notifications contain only generic check-in
text, without ratings, preset names or notes. Tapping one opens the preset list.

The app schedules the next **14 days**, refreshing when it opens or a check-in
is recorded. Reopen it at least every 14 days to continue reminders, and after
travel to refresh for the new time zone. This bounded schedule permits cancelling
today's remaining prompts without cancelling future days and leaves space below
iOS's pending-notification limit. Disabling reminders removes only these requests.

Quiet hours can cross midnight; their start is included and their end excluded.
A time that falls inside quiet hours must be changed before enabling reminders.
A nonexistent DST time moves to the next valid local time, unless that would
enter quiet hours; a repeated time is scheduled only once. Past times are skipped.
A backdated check-in does not suppress today's prompts. Deleting or changing a
check-in refreshes suppression while the app is running. Presets, widgets, Siri
and the legacy mood widget also refresh enabled reminders after recording.

## Validation

On macOS, run `python3 scripts/test-mood-analytics.py` for the same Foundation
analytics, planner and preferences XCTest source used by the iOS target. It
builds a temporary local Swift package from the actual production files, without
remote packages or a separate implementation. It tests independent mathematical
expectations, 14,000 unevenly sampled records, boundaries, invalid data, mixed
scales, sparse/matched weekdays, DST, time zones and preference persistence.

Full iOS CI additionally validates SQLite persistence/context, actual controllers,
notification ordering/failure recovery and screen lifetime. Three UI regressions
exercise period drill-down, preset creation → recording → query results, and
optional reminder configuration. Real widget interaction, authorization and
distribution provisioning require platform validation beyond the Foundation run.
