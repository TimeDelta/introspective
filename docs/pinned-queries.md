# Pinned query dashboard

Open **Explore → Pinned Queries**, then **Pin Queries** to choose existing saved
queries. Save new queries in the query builder first. Keep up to twelve pins;
use Edit to reorder them or swipe left to unpin. Unpinning does not delete a
saved query or any records.

Each card shows the saved query's current name, its conditions, an exact count
of matching records available to the app, matching-record dates, and the time
at which its relative-date conditions were evaluated. Tap a ready card to fetch
current matching records and open the normal results screen. Opening a card
evaluates it again, so newly saved data can change its count.

Pins refer to the saved query's permanent database identity, rather than its
name. Renaming preserves the pin. A deleted, unsupported, or invalid query
stays explicitly unavailable until unpinned; creating another query with the
same name never substitutes it. A query definition changed while results are
opening causes an explicit refresh error rather than mixing old rows with a
new definition.

## Summary definitions

Counts describe records, not unique events, days, sleep sessions, or activity
duration. Health results include only records available to this app. Apple does
not reveal whether zero visible records mean no data or withheld read access.
Actual execution errors appear as unavailable, rather than zero.

Matching-record dates span the available start/end timestamps. They do not
claim a continuous query window or complete coverage. Disjoint conditions,
negation, subqueries, missing dates, and empty results make that distinction
necessary. Dates use the same display/time-zone conversion rules as query
evaluation. Relative conditions are resolved afresh against one captured time
per refresh; the stored query remains relative.

For mood, fatigue, and pain, the optional mean rating normalizes each valid
record to its own saved scale: `(rating − minimum) / (maximum − minimum)`.
Every valid record has equal weight. Finite, in-range ratings with a finite,
positive scale span contribute; missing/invalid values are counted separately
and do not become zeros. This is a per-record mean, whereas weekly mood review
also offers a day-balanced comparison. A higher normalized fatigue or pain
rating is not a claim of improvement.

Other data types show counts and dates without generic sums. Medication doses
can involve different drugs and units; Health quantities and sleep stages can
overlap; and activity intervals can overlap or still be running. Their record
counts remain useful without implying an unsupported aggregate.

## Refresh, privacy, and resources

Pull to refresh or use Refresh. The visible dashboard also coalesces saved-data
changes, Health updates for its pinned query types (including subqueries),
foreground activation, calendar-day changes, and time-zone changes. Health
observers stop when the dashboard is hidden or the app enters the background.

Cards run serially on a private managed-object queue against one pinned store
generation. Read-only clock/time-zone values are scoped to that queue; the
app's injected settings and UI context are not replaced. Only copied summaries
and permanent object identifiers cross back to the UI. Full result arrays are
released between cards. Each card has a bounded wait for asynchronous work;
navigation, editing, and newer refreshes cancel obsolete work and reject stale
callbacks. Core Data fetches already in progress cannot be interrupted.

The dashboard reads saved data, leaving unsaved edits in other screens alone.
Processing stays on-device. Pin preferences store only query identities and
fallback names in the app's local shared preferences, with no cached health
results or network service.

## Validation

The native suite covers preferences, independently calculated summaries,
private-context tag queries, scoped clocks and cancellation, actual SQLite
results and query identity, concurrent definition changes, Health observation,
and controller lifetime/navigation. The UI suite additionally covers pinning,
actual result values, unpinning without deleting saved queries, persistent
order, and newly recorded data.

On a Mac, `python3 scripts/test-dashboard-foundation.py` runs the actual
Foundation preference/summary XCTest sources without building the iOS app.
Full native, legacy unit/functional, both complete UI shards, and Release CI
remain required for changes to the feature.
