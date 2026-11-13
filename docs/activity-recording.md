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

## Validation

Run `python3 scripts/test-activity-backdating.py` with Swift available to execute
the actual Foundation helper and the same backdating tests used by native CI.
These cover lower-unit zeroing, unit names, invalid input, calendar boundaries,
daylight-saving transitions and days without a midnight.

`ActivityQuickRecorderTests` exercises SQLite persistence, atomic switching,
concurrent activities, stale buttons, auto-ignore and auto-note, timestamp and
source preservation, legacy display-time conversion, and save-failure rollback.
Those tests require the macOS/iOS native test target. Widget interaction and Lock
Screen authentication also require platform validation.
