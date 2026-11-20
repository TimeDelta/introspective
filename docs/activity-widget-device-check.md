# Activity device smoke test

**Status: NOT EXECUTED on a physical device.** The implementation workspace is
Linux, has no connected USB devices, and has no Xcode or iPhone device tools.
Source review, native CI and simulator tests do not establish the results below.
Record actual outcomes against the installed build before marking this complete.

| Test identity | Recorded value |
| --- | --- |
| Commit, app version and build number | |
| Installation method | |
| iPhone model and iOS version | |
| Date, time zone and tester | |
| Authentication and notification settings | |
| Overall result and evidence location | |

## Preparation

Use iOS 18 or later and a signed build containing
`com.bnova.Introspective.ActivityWidget` with the `group.Introspective` entitlement.

Use clearly named test activities: **Device A** with Auto-Note off and **Device B**
with Auto-Note on. Record the starting activity counts. Disable the existing
short-activity auto-ignore rule for these checks so quick test records remain
inspectable; restore its original setting afterward. Keep unrelated records.

Open the installed app once to finish store setup. Add the separate **Activity**
Home Screen widget, a circular or rectangular Lock Screen widget, and an
**Activity** control in Control Center or a Lock Screen control slot. Select
Device A. Use the medium Home widget when checking switching.

After each recording action, inspect Activity Review or activity history for
the expected instance count and start/end times. Capture the relevant screen
and any error. A displayed timer alone does not prove the record was saved.

## Widgets, controls and app launch

| Check | Action | Expected saved result |
| --- | --- | --- |
| Basic recording | Start Device A from each configured surface, then stop it. | Each deliberate Start/Stop pair produces one completed instance; the app and other surfaces eventually show its stopped state. |
| Authentication | Lock the phone, attempt an action and cancel authentication. Repeat and authenticate successfully. | Cancellation leaves records unchanged. A successful action changes only its selected activity once. The system may authenticate through Face ID without a separate visible prompt. |
| Lock Screen content | Review the locked display with the phone's configured preview/privacy settings. | Activity content respects the system's privacy-sensitive rendering; no note text appears. Record the actual presentation and settings. |
| App terminated | Terminate the app, then start and stop Device A from its widget/control. | The extension can use the existing compatible shared store; opening the app shows the saved record. Ordinary recording need not open the app. |
| Cold extension | Reboot, unlock once, and use the widget before opening the app. | Recording works against the existing compatible store. Force-quitting the app alone is not evidence of a cold extension. |
| Protected store | After a reboot, try an action before the first unlock, then unlock and retry deliberately. | An unavailable protected store produces no partial record. A later successful action creates only the intended record. |
| Setup unavailable | On a separate fresh test installation, try a widget before the first app launch. | It asks for app setup and creates no records. The extension does not initiate a model migration. |
| Repeated Start | Repeat Start while the surface still displays the same Start action. | Exactly one running Device A instance exists. Once the surface changes to Stop, that is a different action. |
| Stale Stop | Keep an old Stop surface visible. End its instance in the app, start a new Device A instance, then invoke the old Stop action. | The newer instance keeps running. No extra completed instance is created. |
| Intentional overlap | Run Device A and Device B together. Stop A from its control. | B continues with its original start time. |
| Explicit switching | With A running and B stopped, use the medium widget's switch-from-A action for B. | A ends exactly when B starts; other concurrent activities are unchanged. |
| Rename and deletion | Rename the selected definition and refresh its surface. Then delete that test definition and invoke its old action. | Renaming keeps its identity and shows the new name. A deleted selection cannot create a replacement definition or affect another activity; it must be selected again. |
| Auto-Note handoff | Select Device B, start it, terminate the app, then stop it from a widget/control. | The stop saves once and the foreground editor opens that stopped B instance with its note ready. Saving a note does not restart or duplicate B. Repeat while the app is already open. |

## Catch-up recording

Open **Review Activities** from the Timeline for the chosen day. The **Review**
entry on the activity recorder defaults to yesterday. Check Today, Yesterday,
Previous day, Next day and the review-date chooser against the phone's calendar.

1. Create a test activity that began yesterday and is still running. Choose
   **End earlier…** and supply its actual end time. Confirm its original start
   is retained, its end is the selected time, and another running activity is
   unchanged. Cancelling the picker must leave the record running.
2. Create completed records for yesterday from 09:00–10:00 and 10:30–11:00.
   Tap the **No activity recorded** interval between them. **Record Past Activity**
   should default to 10:00–10:30. Choose a saved activity and save once. Confirm
   one new completed record with those boundaries and unchanged neighboring
   records. The gap should disappear after refresh.
3. Add overlapping records, such as 09:00–10:00 and 09:30–10:30. Both original
   records must remain visible and unchanged. There must be no gap inside their
   combined 09:00–10:30 coverage. Unrecorded time is not labeled as idle time.
4. Open a gap form, then use an existing Shortcut to create an overlapping
   backdated activity before saving that form. Saving the stale form must report
   the conflict without a partial or duplicate new record.
5. Change a manual start/end time in the existing picker and verify the stored
   whole-minute value. Defaults accepted unchanged retain their original
   boundaries; automatic Now captures retain their available precision.

## Undo recording in the app

Keep the overall status **NOT EXECUTED** until these steps run on an installed
device build. Native persistence tests do not establish toolbar, keyboard,
navigation, widget refresh or Lock Screen behavior.

1. Start Device A from the Activities list while Device B is already running.
   Tap **Undo** in the bottom toolbar. A's new record should disappear and B
   should retain its original start. Start A again to confirm the normal row
   action still takes one tap.
2. Stop A and use Undo. Its original start, notes and tags should remain, and
   it should be running again. Repeating Undo must not create another record.
3. Switch A to another stopped activity with **Time / Switch**, then Undo.
   A should resume with its original stored start; only the timer created by
   that switch should disappear. Other concurrent activities keep running.
4. Stop an activity configured for Auto-Note, save a changed note, and return
   to the list. Undo must preserve the saved edit, either by declining the
   changed record or by no longer offering that action.
5. Temporarily enable auto-ignore with an interval long enough for a short
   test. Start and quickly stop A, then Undo. Confirm exactly one restored
   running record with its original start. A stale widget Stop for the deleted
   instance must not stop the restored record before the widget refreshes.
6. After each Undo, verify the app, Home Screen widget, Lock Screen widget and
   control update to the saved state. With reminders enabled, verify reminders
   follow the restored running instance. Restore the original settings.

## Optional running-activity reminders

Reminders start **off**. Enabling them requests notification authorization.
The default interval is 120 minutes; choices are 30, 60, 120 and 240 minutes.
Use the shortest offered interval for a device check, letting it elapse during
normal phone use rather than changing the system clock.

| Check | Expected result |
| --- | --- |
| Disabled or authorization denied | No activity reminders are scheduled; activity records remain unchanged. |
| Running instance reaches its interval | One generic “Still doing this?” prompt appears without activity names or notes. It refers to that exact running instance. |
| Continue | The same instance remains running with its original start time. Its next reminder is deferred by the chosen interval. |
| Stop now | Only the referenced instance ends. Existing auto-ignore and Auto-Note behavior applies. |
| End earlier | The app opens review for the referenced instance. It stays running until an end time is explicitly saved. |
| Ignore a delivered prompt | It does not repeatedly reschedule itself. Continue is the explicit request for another reminder. |
| End or switch elsewhere | The old instance's pending reminder is removed after reconciliation. A stale delivered action cannot stop a newly restarted instance of the same activity. |
| Disable reminders | Activity reminder requests are removed. Existing mood/stress reminder requests remain unaffected. |
| Reopen after an overdue timer was discovered | There is no immediate notification burst; the next prompt is scheduled relative to the refresh time. |

Record pass/fail and evidence for every applicable row. Keep unavailable or
unexecuted checks explicit; do not replace device results with simulator results.
Restore the original reminder and auto-ignore settings afterward, and remove
only the clearly identified smoke-test records when they are no longer needed.
