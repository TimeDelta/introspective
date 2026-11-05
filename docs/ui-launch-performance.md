# UI launch performance

Keep a fresh application process and SQLite database for every case. The full
suite has 115 distinct cases and 14 additional preflight executions; launch
optimizations must preserve their assertions, coverage, and isolation.

## Measured baseline

[Run 41959803201](https://github.com/TimeDelta/introspective/actions/runs/41959803201)
at `d6260c4e5caff1fd7e7f4585b5726183cb7594e6` passed every check. All 129
launch traces paired with complete application profiles. The 115 full-suite
launches spent 1,144.263 cumulative seconds inside `XCUIApplication.launch()`:

| Interval | Cumulative seconds |
| --- | ---: |
| Launch call to first will-finish callback | 796.546 |
| Will-finish callback to recorded ready | 220.914 |
| Recorded ready to launch return | 126.803 |

Recorded ready is the latest of did-finish completion, application activation,
and the initial Record screen's appearance callback. It does not prove that
the first frame rendered. These are cumulative durations across launches,
not workflow wall time or a controlled speed comparison.

Correlating each trace with its own XCTest transcript locates the first row:

| Transcript interval | Approximate cumulative seconds | Median seconds |
| --- | ---: | ---: |
| Launch activity to automation-session activity | 274.360 | 1.760 |
| Automation-session activity to idle-wait activity | 500.390 | 4.270 |
| Idle-wait activity to will-finish callback | 21.796 | 0.125 |

All 115 full-suite callbacks follow the printed idle-wait entry, including a
conservative alignment allowance of up to 40 milliseconds per launch. Activity
timestamps have centisecond precision. Three of 14 preflight callbacks instead
precede idle-wait entry by 0.31–0.63 seconds. Activity names therefore cannot
identify which process owns elapsed time. Termination, runtime loading, UIKit,
automation setup, and simulator scheduling can overlap these boundaries.

The UI scheme already runs without LLDB or Main Thread Checker. Code coverage
stays enabled. Moving termination into teardown would move a timestamp unless
total case time also improved; it would not establish a speedup.

## Earlier application boundaries

Debug UI-test launches additionally record `process_entry` from the explicit
Swift main body and `delegate_initialized` after AppDelegate initialization.
The entry point invokes the same public `UIApplicationMain` function. Release
launches do not activate or call the recorder.

The timing report retains its original bootstrap definition and reports these
additional intervals separately:

- Launch call to the recorded main-body marker.
- Main-body marker to delegate initialization.
- Delegate initialization to will-finish entry.
- Recorded ready to launch return.

The first interval includes runtime work before Swift main and may include
termination, XCTest, and scheduling. It is not a measurement of dyld alone.
The main marker follows the opt-in recorder setup, so it is not the first
machine instruction in main. Missing or old markers produce unavailable data,
never zero. Partial results sum only their explicitly counted valid pairs.

## Initial Record controls

Continuous mood, pain, and fatigue controls previously rendered twice during
`awakeFromNib`: `reset()` assigned `rating`, triggering `didSet`, and then
`awakeFromNib` explicitly rendered again. Each render also formatted the same
rating separately for the button title and accessibility value.

Removing the second render and sharing that string reduces formatting calls
from eight to three per initialized control, or 24 to nine if all three load.
This removes redundant formatter construction and UI updates while preserving
setting notifications, rating changes, accessibility, and save/reset behavior.
It addresses application work after will-finish, not the larger preceding
interval. Its effect on elapsed time must be measured in subsequent CI profiles.
