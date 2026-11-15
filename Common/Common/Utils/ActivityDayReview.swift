import Foundation

/// Stored activity instants, copied before crossing a managed-object context's queue.
public struct ActivityReviewRecord: Equatable {
	public let id: String
	public let definitionID: String
	public let name: String
	public let start: Date
	public let end: Date?

	public init(id: String, definitionID: String, name: String, start: Date, end: Date? = nil) {
		self.id = id; self.definitionID = definitionID; self.name = name
		self.start = start; self.end = end
	}
}

public struct ActivityDayReviewError: LocalizedError, Equatable {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
}

/// Gaps describe missing recordings. They do not imply inactivity or alter overlaps.
public struct ActivityDayReview: Equatable {
	/// The complete selected calendar day, including 23/25-hour DST days.
	public let dayInterval: DateInterval
	/// The part of that day which has happened as of this snapshot.
	public let reviewInterval: DateInterval
	/// Original records and original timestamps; only coverage calculations are clipped.
	public let records: [ActivityReviewRecord]
	public let coveredIntervals: [DateInterval]
	public let gaps: [DateInterval]
	public var runningRecords: [ActivityReviewRecord] { records.filter { $0.end == nil } }
	public var recordedDuration: TimeInterval { coveredIntervals.reduce(0) { $0 + $1.duration } }
	public var unrecordedDuration: TimeInterval { gaps.reduce(0) { $0 + $1.duration } }

	public init(records input: [ActivityReviewRecord], day: Date, asOf: Date = Date(),
		calendar: Calendar = .autoupdatingCurrent) throws {
		guard day.timeIntervalSinceReferenceDate.isFinite, asOf.timeIntervalSinceReferenceDate.isFinite,
			day >= .distantPast, day <= .distantFuture, asOf >= .distantPast, asOf <= .distantFuture,
			let interval = calendar.dateInterval(of: .day, for: day),
			interval.start.timeIntervalSinceReferenceDate.isFinite,
			interval.end.timeIntervalSinceReferenceDate.isFinite, interval.duration > 0 else {
			throw ActivityDayReviewError("Choose a valid activity review day.")
		}
		dayInterval = interval
		let cutoff = min(interval.end, max(interval.start, asOf))
		reviewInterval = DateInterval(start: interval.start, end: cutoff)
		guard interval.start <= asOf else {
			records = []; coveredIntervals = []; gaps = []
			return
		}

		records = input.filter { record in
			guard record.start.timeIntervalSinceReferenceDate.isFinite,
				record.end?.timeIntervalSinceReferenceDate.isFinite != false,
				record.start < interval.end, record.start <= cutoff else { return false }
			// Keep zero-length and invalid-end entries that began on this day
			// available for editing; they never contribute positive coverage.
			return record.start >= interval.start || record.end == nil || record.end! > interval.start
		}.sorted {
			$0.start == $1.start ? $0.id < $1.id : $0.start < $1.start
		}

		let clipped = records.compactMap { record -> DateInterval? in
			let start = max(interval.start, record.start)
			let end = min(cutoff, record.end ?? cutoff)
			guard end > start else { return nil }
			return DateInterval(start: start, end: end)
		}.sorted { $0.start == $1.start ? $0.end < $1.end : $0.start < $1.start }

		var covered: [DateInterval] = []
		for entry in clipped {
			if let previous = covered.last, entry.start <= previous.end {
				covered[covered.count - 1] = DateInterval(start: previous.start, end: max(previous.end, entry.end))
			} else { covered.append(entry) }
		}
		coveredIntervals = covered
		var missing: [DateInterval] = []
		var cursor = interval.start
		for entry in covered {
			if entry.start > cursor { missing.append(DateInterval(start: cursor, end: entry.start)) }
			cursor = entry.end
		}
		if cursor < cutoff { missing.append(DateInterval(start: cursor, end: cutoff)) }
		gaps = missing
	}
}

/// A saved activity definition that actually touches one or both gap boundaries.
public struct ActivityGapNeighbor: Equatable {
	public let definitionID: String
	public let before: Bool
	public let after: Bool

	public init(definitionID: String, before: Bool, after: Bool) {
		self.definitionID = definitionID; self.before = before; self.after = after
	}
}

/// Context helps choose an activity; it never chooses one or changes the interval.
public struct ActivityGapChoices: Equatable {
	public let neighbors: [ActivityGapNeighbor]
	public let recentDefinitionIDs: [String]

	public init(interval: DateInterval, records: [ActivityReviewRecord], availableDefinitionIDs: [String],
		recentDefinitionIDs: [String], asOf: Date = Date(), maximumRecent: Int = 5) throws {
		guard asOf.timeIntervalSinceReferenceDate.isFinite,
			interval.start.timeIntervalSinceReferenceDate.isFinite,
			interval.end.timeIntervalSinceReferenceDate.isFinite,
			interval.duration.isFinite, interval.duration > 0, interval.end <= asOf else {
			throw ActivityDayReviewError("Choose a valid past activity interval.")
		}
		var available = Set<String>()
		let ordered = availableDefinitionIDs.filter { !$0.isEmpty && available.insert($0).inserted }
		var before = Set<String>(), after = Set<String>()
		for record in records {
			guard available.contains(record.definitionID), record.start.timeIntervalSinceReferenceDate.isFinite,
				record.start <= asOf else { continue }
			if let end = record.end {
				guard end.timeIntervalSinceReferenceDate.isFinite, end > record.start, end <= asOf else { continue }
				if end == interval.start { before.insert(record.definitionID) }
			}
			if record.start == interval.end { after.insert(record.definitionID) }
		}
		neighbors = ordered.filter { before.contains($0) || after.contains($0) }.map {
			ActivityGapNeighbor(definitionID: $0, before: before.contains($0), after: after.contains($0))
		}
		var seen = before.union(after)
		let limit = min(5, max(0, maximumRecent))
		var recent: [String] = []
		if limit > 0 {
			for id in recentDefinitionIDs where available.contains(id) && seen.insert(id).inserted {
				recent.append(id)
				if recent.count == limit { break }
			}
		}
		self.recentDefinitionIDs = recent
	}
}
