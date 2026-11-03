# Explain and inspect queries

Choose **Explain** in the query builder, or **Explain Query** in Results, to see
the interpretation of the actual expression tree. AND, OR, NOT and parentheses
keep their nesting. Reference queries have their own conditions and an explicit
date relationship to the outer query. Generated on-device drafts open this
interpretation before execution; unsupported requests remain errors. In
particular, most-recent-only requests are rejected before constructing a draft,
so they cannot silently become a query returning all matching records.

Opening the explanation does not read sample records. **Inspect Counts** is an
explicit request to read all visible records for the query's data types and
compare its conditions. It leaves the builder, saved query and Results unchanged.
Cancel stops the inspection and discards partial results. Leaving the screen or
changing the query also cancels; a late completion cannot replace a newer report.

Swipe a result from the left and choose **Why matched?** to include that record's
membership beside each condition, group and complete query. This is a fresh
inspection, so a record that changed, was deleted, became invisible, or aged out
of a relative period may no longer match. Stored records use permanent object
identities. Apple Health records use the UUID of the original Health sample;
an unsaved, manually constructed Health wrapper has no inspectable identity.
Records with identical dates and values remain distinct.

## What the counts mean

Each condition/group count covers the same population of visible records for
that data type. It is independent, rather than a cumulative funnel. An OR group
counts each record once; its children can overlap and must not be added. An AND
group can have zero matches even when every child separately has matches.

Counts execute the actual query engine. A Core Data expression that supports a
database predicate uses that predicate, including its missing-value behavior.
When the complete tree requires in-memory evaluation, its inspected children
use that evaluator too. NOT counts are measured directly and are never inferred
by subtracting a child count. In particular, a missing optional value need not
behave like a present value that failed a comparison. Matching record labels
mean membership in the measured condition/group, not a guessed logical inverse.

The complete query count includes its actual subquery matcher. Counts for the
reference query describe reference records, not outer result records. No counts
are added across sample types. Empty-result diagnostics distinguish no visible
records, an empty condition tree result, and records removed by a subquery date
relationship. They suggest checks without removing restrictions or substituting
an approximate query.

## Snapshot, dates and units

An inspection uses a private managed-object context, one concrete Core Data store
generation, one captured evaluation date, and one captured time-zone-conversion
setting. It does not include unsaved edits in another context. All condition
counts share that generation; the context is not reset between reads.
If the device calendar or time zone changes during inspection, the report is
discarded so its conditions cannot mix different calendar boundaries.

Health sample reads are captured and reused once per data type, including pending
same-type root/reference reads. The captured wrappers and their numeric values
are reused for every condition. HealthKit does not provide a transaction shared
with Core Data, or an atomic snapshot across different Health data types. The
interpretation discloses that limit. A zero Health count can mean no data or data
the app cannot read: HealthKit deliberately does not reveal read denial.

The explanation describes the evaluator's actual strict/inclusive date bounds,
calendar periods, attributes and measurement units. Calendar-unit relationships
are not interchangeable with exact elapsed-time windows. Relative periods are
resolved at the displayed inspection date; another inspection may have different
results. The existing root `mostRecentEntryOnly` flag is currently not applied by
the engine, and the explanation says so. Matcher-specific most-recent-reference
selection is applied and described separately.

Work runs on the private context queue. Cancellation suppresses publication and
stops cancellable Health queries; an already-running synchronous Core Data fetch
cannot be interrupted. The inspection has a bounded lifetime, releases its
captured records when finished, and never sends query text or records to an
online service or logs their contents.
