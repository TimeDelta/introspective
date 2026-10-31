# Coverage-guided behavioral tests

The baseline is the complete, passing `CI-CD` legacy suite on master
`e00853a5`: [GitHub Actions run 41155218028](https://github.com/TimeDelta/introspective/actions/runs/41155218028),
artifact `coverage-priorities.json` / `coverage.md`. All 4,332 selected cases
passed without failures or skips.

Measurements belong to individual suites. Zero coverage here does not establish
that the native or UI suite never exercises a file. In particular, `MoodUtil.swift`
also contains Health exchange code covered by the separate native tests.

| Baseline file | Covered / executable lines in legacy suite | Added behavioral coverage |
| --- | ---: | --- |
| `TimelineTableViewController.swift` | 0 / 852 | Empty/loading state, enabled sources, inclusive date filtering, grouping and ordering, mood notes, paging, failed sources, concurrent fetches, controller release |
| `WithinXCalendarUnitsAfterSubQueryMatcher.swift` | 0 / 175 | Direction, unsorted references, nearest reference on the correct side, interval endpoints, latest-record selection, boundaries and invalid inputs |
| `WithinXCalendarUnitsBeforeSubQueryMatcher.swift` | 0 / 163 | Corresponding before-direction cases, including a query activity's end and fractional-second ordering |
| `MoodUtil.swift` | 24 / 245 | Negative/fractional scales, persisted endpoints, transaction isolation, identity and metadata preservation, fetch/commit errors and successful retry |

The 43 coverage-guided cases live in `IntrospectiveTests/Coverage`, with three
additional Core Data lifecycle regressions in `IntrospectiveTests/Test.swift`.
All run in the existing `IntrospectiveTests` target. Functional cases use the real in-memory Core Data
store, calendar utilities and matchers. Timeline cases load the real storyboard
and table cells, with controlled sample sources and completion expectations
instead of sleeps, Health authorization, or additional app launches.

These cases also guard fixes for a timeline wait group that was never released
after a fetch error, concurrent unsynchronized result appends, queued refreshes
retaining controllers, directional searches using the wrong reference/direction,
an extra commit after a successful bounded retry, and managed-object destructors
refreshing objects while Core Data removes them from its registry. Lifecycle
regressions cover main/private context deallocation and refaulting an object
through its owning context.

Three additional native tests cover activity-row timers: offscreen binding does
not start polling, detaching stops polling and reattaching refreshes current
data, and reuse clears the old definition before binding another. They fire the
actual timer callback directly without sleeps. The existing cell-release test
also exercises a timer started while attached to a window. The native inventory
increases from 109 to 112 cases; this measurement remains separate from legacy.

## Evaluating the next report

The full legacy run must pass all **4,378** selected cases without skips; the
existing 41 explicit exclusions remain unchanged. Read the new legacy artifact's
file and function measurements alongside this baseline. The matcher implementation
is shorter, so compare the exercised behaviors and functions as well as line
percentages. Do not average percentages from separate jobs or infer branch
coverage from line counts.

The next useful gaps are the timeline's remaining event types and edit actions,
and the uncovered result sorting/search-nearby paths. Check the native and UI
reports before adding tests for shared code that they may already cover.
