# Activity recording

Tap an activity in **Record → Activities** to start it now, or to stop its most
recent running instance now. This keeps the existing one-tap behavior. Different
activities can run at the same time.

## Earlier times and switching

Swipe left on an activity and choose **Time / Switch**. **Start earlier…** and
**Stop earlier…** offer 5, 15 or 30 minutes ago and **Choose time…**, which opens
the existing date picker. A stop cannot precede that instance's start.

**Switch from…** or **Switch to…** ends one selected running activity and starts
the destination at the same instant, either now or at an earlier time. When
several activities are running, choose which one to end; the others keep running.
Both sides save together. Switching does not create another running instance
when the destination is already active. Existing auto-ignore and auto-note
settings still apply.

An explicit **N units ago** estimate clears every lower unit: minutes clear
seconds and fractions, hours also clear minutes, days use the local day's first
valid instant, and seconds clear fractions. Calendar arithmetic respects the
selected calendar and time zone, including daylight-saving changes. **Now**
retains full timestamp precision. The existing shared picker's manual-edit,
**Now**, **Last** and unchanged-value rules remain as described in
[Timestamp precision](timestamp-precision.md).

The Siri **Start activity X ago** action applies the requested offset and accepts
the supported singular or plural unit names. It no longer substitutes the last
activity's end time. The separate **Start activity from end of last** action keeps
that behavior.

## Home and Lock Screen widgets

Add the **Activity** widget, then edit it to choose a saved activity. Small and
medium Home Screen widgets and rectangular or circular Lock Screen widgets offer
Start or Stop for that activity. The rectangular and Home Screen layouts display
elapsed time while it runs. The medium widget also offers switching from other
running activities.

On iOS 18 or later, add the **Activity** control to Control Center or a Lock Screen
control slot, then select its activity. The control starts or stops the selected
activity. Add several widgets or controls to keep different activities available.

Recording requires device authentication. Widget content is privacy-sensitive.
Open Introspective once after installation or a database update: extensions use
the existing app-group store and do not initiate model migrations. An unavailable
or deleted selection must be chosen again. An old Stop button refers to its
original running instance and cannot stop a later restarted timer.

Activities have their own **ActivityWidget** extension, separate from
**MoodCheckInWidget**. Its bundle identifier is
`com.bnova.Introspective.ActivityWidget`, using the existing `group.Introspective`
app group. Distribution signing must provision that extension and app group.
The existing mood widget retains its original target and configuration.

When an activity is configured to ask for a note after stopping, Stop or Switch
from a widget or control opens its note editor in Introspective after saving.
Otherwise recording stays in the widget or control.

## Reviewing a day and catching up

Open **Review Activities** from the Timeline to review its selected day, or
**Review** from Record → Activities to start with yesterday. Use Today,
Yesterday, the date chooser, or the day arrows to move between dates.

**Still running now** includes timers that started on earlier days. Select one
and choose **End earlier…** to finish it at the time it actually ended. Only that
saved instance is stopped; other activities can keep running. **Stop now** and
the existing record editor are also available.

**No activity recorded** lists intervals with no saved coverage. These intervals
are unknown time. Select one, choose a saved activity, and save the portion you
remember. Start and end default to the exact neighboring record timestamps or
the local day's boundaries. Accepting those defaults preserves their precision;
explicitly changing a picker value uses the existing lower-unit zeroing rules.
The form checks for newly recorded overlaps before saving and leaves existing
records unchanged. Short explicit catch-up records are retained even when
automatic short-activity ignoring is enabled; Auto-Note still applies.

Overlapping activities remain separate entries. Gap calculations use their
combined coverage, respect local calendar days and daylight-saving changes,
and stop at now when reviewing today. A complete day is optional.

## Optional activity reminders

Open **Reminders** from Activity Review. Reminders start off; enabling them
requires notification permission. Choose 30 minutes, 1 hour, 2 hours (default),
or 4 hours, then tap Save.

Each running instance gets a generic **Still doing this?** notification without
its activity name or notes. **Continue** keeps its original start and schedules
another prompt after the chosen interval. **Stop now** ends only that instance,
applying its normal auto-ignore and Auto-Note settings. **End earlier**, or
opening the notification, opens that record for review. Notification recording
actions require authentication.

Ignoring a prompt does not create repeated reminders. A timer first discovered
after its interval gets a full interval from that refresh rather than an
immediate prompt. Activity reminders use at most eight pending notification
slots and preserve existing mood, stress and other notifications. Turning them
off removes their requests. Recording from the app, widgets, controls or Siri
refreshes the schedule; exact saved identities protect restarted timers from
old actions.

## Validation

Run `python3 scripts/test-activity-backdating.py` with Swift available to execute
the actual Foundation helper and the same backdating tests used by native CI.
These cover lower-unit zeroing, unit names, invalid input, calendar boundaries,
daylight-saving transitions and days without a midnight.

`ActivityQuickRecorderTests` exercises SQLite persistence, atomic switching,
concurrent activities, stale buttons, auto-ignore and auto-note, timestamp and
source preservation, legacy display-time conversion, and save-failure rollback.
Run `python3 scripts/test-activity-day-review.py` for the actual day model and
persisted notification routes, and `python3 scripts/test-activity-reminders.py`
for the reminder preferences and one-prompt planning rules. These scripts share
their production sources and test cases with native CI.

Native SQLite tests also exercise fresh gap checks, exact neighbor timestamps,
pending edits, reminder actions, scheduling races and authorization settings.
The UI suite covers filling a gap, ending one of several running timers, and
reviewing overlaps. Native and UI tests require macOS/iOS. Physical widget,
Lock Screen, cold-launch and notification checks remain **not executed** in the
Linux workspace; use the [device smoke procedure](activity-widget-device-check.md)
and record results against the installed build.
