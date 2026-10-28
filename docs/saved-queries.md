# Saved queries

In **Explore → Query**, build a query and tap **Save**. Give it a name; leading/trailing whitespace is removed, and names must be unique ignoring case and accents.

Tap **Load** to browse saved queries alphabetically and open one in the editor. Its conditions, Boolean groups/NOT operations, subquery chain/matcher options, and most-recent settings are restored. Running it evaluates the conditions against the current data, including relative date restrictions.

After editing a loaded query, **Save** offers **Update saved query** or **Save as new query**. Updates retain the saved query's identity and replace its expression/subquery graph atomically. Swipe a row in the saved-query browser to **Rename** or **Delete**; deleting a saved query removes its stored condition graph and leaves recorded samples intact.

Saving a data type without restrictions is supported. A malformed or unsupported stored query reports a loading error without replacing the current editor draft. Tag restrictions store persistent tag identities, preserve activity-definition tag behavior, and survive tag renames and semicolons in names. Deleted referenced tags produce an error instead of silently broadening the query.

## Persistence and validation

This builds on `saved-queries-merge`. The released `Introspective` and `HealthMood` Core Data models are retained unchanged. `LegacySavedQueries` retains the exact schema from the old branch; `SavedQueries` is the new current version. Sample/attribute IDs and matcher type IDs are persisted: append new IDs and never renumber existing ones.

The independent persistence test target exercises disk reopen, actual restored query execution, nested conditions/subqueries, all sample types and matcher kinds, atomic updates, naming/rename/deletion, tag identity, editor expression semantics, rollback, and migration preserving mood/Health identity. Existing Health exchange tests remain enabled. The legacy mock-based suite is separate and remains unverified.
