import Foundation

/// Values copied on a sample's owning queue before dashboard calculation.
public struct PinnedQuerySummaryRecord {
	public let start: Date?
	public let end: Date?
	public let rating: Double?
	public let minimum: Double?
	public let maximum: Double?

	public init(start: Date?, end: Date? = nil, rating: Double? = nil,
		minimum: Double? = nil, maximum: Double? = nil) {
		self.start = start; self.end = end
		self.rating = rating; self.minimum = minimum; self.maximum = maximum
	}
}

/// Describes matching records, not the date restrictions or coverage of a query.
public struct PinnedQuerySummary {
	public let count: Int
	public let earliestDate: Date?
	public let latestDate: Date?
	/// Per-record mean position in each record's original scale, from zero to one.
	public let meanRatingPosition: Double?
	public let validRatingCount: Int
	public let excludedRatingCount: Int
	public let evaluatedAt: Date

	public init(records: [PinnedQuerySummaryRecord], evaluatedAt: Date, includeRatings: Bool) {
		count = records.count
		self.evaluatedAt = evaluatedAt
		var first: Date?, last: Date?
		var valid = 0, excluded = 0
		var mean = 0.0
		func include(_ date: Date?) {
			guard let date = date, date.timeIntervalSinceReferenceDate.isFinite else { return }
			if first == nil || date < first! { first = date }
			if last == nil || date > last! { last = date }
		}
		for record in records {
			include(record.start); include(record.end)
			guard includeRatings else { continue }
			guard let rating = record.rating, let minimum = record.minimum, let maximum = record.maximum,
				rating.isFinite, minimum.isFinite, maximum.isFinite,
				maximum > minimum, (maximum - minimum).isFinite,
				rating >= minimum, rating <= maximum else {
				excluded += 1; continue
			}
			let position = (rating - minimum) / (maximum - minimum)
			guard position.isFinite else { excluded += 1; continue }
			valid += 1
			// Positions are bounded; incremental averaging avoids a growing sum.
			mean += (position - mean) / Double(valid)
		}
		earliestDate = first; latestDate = last
		validRatingCount = valid; excludedRatingCount = excluded
		meanRatingPosition = valid > 0 ? mean : nil
	}
}
