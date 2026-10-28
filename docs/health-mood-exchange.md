# Mood exchange with Apple Health

On iOS 18 or later, open **Settings → Mood → Health** and choose **Import from Health** or **Export to Health**. Health asks for State of Mind access. Earlier iOS versions continue to support local moods and CSV exchange.

Import adds daily moods and momentary emotions as timestamped local ratings. With “scale moods on import” enabled, Health's −1…1 valence is mapped to your saved minimum/maximum; otherwise it stays on −1…1. Existing imported sample IDs are skipped. Health does not reveal whether read access was denied: zero imported records can mean no permitted new records, not necessarily an empty Health history.

Export maps each local mood's original rating range to −1…1 and writes a momentary emotion. Invalid or zero-width rating ranges must be corrected first. Imported Health records and previously exported records are skipped. Stable sync identifiers protect against repeated writes after an interrupted transfer. Original timestamps are used without display-time zone conversion.

Transfers are manual and additive. Edits and deletions after transfer are not synchronized. Notes, emotion labels, and associations are not transferred. Imported Health data should be managed in Health if its original labels or daily/momentary distinction matter.

## Validation

CI builds an unsigned Release app and runs the focused `MoodHealthExchangeFunctionalTests` on an iPhone simulator. These tests exercise valence conversion/invalid ranges, import timestamps and deduplication, scaling and feedback prevention, export timestamps/identifiers, and old-store migration. They do not claim to validate Health authorization or real Health writes.

For local simulator tests, run `pod install --deployment`, then `python3 scripts/patch-swiftymocky-for-current-xcode.py`, generate `Common/Common/GitVersion.swift` with the existing script, and run the CI-CD scheme's `IntrospectiveTests/MoodHealthExchangeFunctionalTests` on an iOS 18+ simulator. The narrow SwiftyMocky backport applies upstream's Optional-conformance fix to the pinned source; it does not change the app's dependency versions.

Before release, on an iPhone with iOS 18+:

1. Confirm permission denial produces a useful result and exporting works after enabling State of Mind write access.
2. Export known minimum, midpoint, and maximum ratings. Verify their dates and valences in Health; export again and check for duplicates.
3. Create a daily mood and a momentary emotion in Health. Import twice and verify timestamps, scaling, and single local records.
4. Confirm exported records are not imported back and imported records are not exported again.
5. Update an installation containing existing moods and verify its records survive migration. Check older iOS versions retain their existing behavior without a Health action.
