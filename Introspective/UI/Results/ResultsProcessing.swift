import Foundation

import AttributeRestrictions
import Attributes
import BooleanAlgebra
import Common
import Queries
import Samples

/// Cancellation is shared with a worker; controller state remains on main.
internal final class ResultsWork {
	private let lock = NSLock()
	private var cancelled = false
	var isCancelled: Bool {
		lock.lock(); defer { lock.unlock() }
		return cancelled
	}
	func cancel() {
		lock.lock(); defer { lock.unlock() }
		cancelled = true
	}
}

/// Read each attribute once on its owning context's queue. Workers compare only
/// copied values and return indices, never access managed objects or UIKit.
internal struct ResultsSortSnapshot {
	private let orderedIndices: (ResultsWork) throws -> [Int]?

	init(samples: [Sample], attribute: Attribute?, order: ComparisonResult) throws {
		guard let attribute = attribute else {
			let count = samples.count
			orderedIndices = { $0.isCancelled ? nil : Array(0 ..< count) }
			return
		}
		let values = try samples.map { try $0.value(of: attribute) }
		let ascending = order == .orderedAscending
		switch attribute {
		case is IntegerAttribute:
			orderedIndices = Self.sorter(values.map { $0 as? Int }, ascending: ascending)
		case is DoubleAttribute:
			orderedIndices = Self.sorter(values.map { Self.number($0 as? Double) }, ascending: ascending)
		case is TextAttribute:
			orderedIndices = Self.sorter(values.map { $0 as? String }, ascending: ascending)
		case is DateAttribute:
			orderedIndices = Self.sorter(values.map { Self.number(($0 as? Date)?.timeIntervalSinceReferenceDate) }, ascending: ascending)
		case is DayOfWeekAttribute:
			orderedIndices = Self.sorter(values.map { ($0 as? DayOfWeek)?.intValue }, ascending: ascending)
		case is TimeOfDayAttribute:
			// A private copy preserves lexicographic hour/minute/second semantics.
			let times = values.map { value -> TimeOfDay? in
				guard let time = value as? TimeOfDay else { return nil }
				let copy = TimeOfDay()
				copy.hour = time.hour; copy.minute = time.minute; copy.second = time.second
				return copy
			}
			orderedIndices = Self.sorter(times, ascending: ascending)
		case is DurationAttribute:
			orderedIndices = Self.sorter(values.map { Self.number(($0 as? TimeDuration)?.inUnit(.second)) }, ascending: ascending)
		case is FrequencyAttribute:
			let rates = try values.map { value -> Double? in
				guard let frequency = value as? Frequency else { return nil }
				return Self.number(try frequency.per(.minute))
			}
			orderedIndices = Self.sorter(rates, ascending: ascending)
		case is DosageAttribute:
			orderedIndices = Self.sorter(values.map { Self.number(($0 as? Dosage)?.getBaseUnitAmount()) }, ascending: ascending)
		default:
			throw GenericError("Unsupported results sort attribute")
		}
	}

	func sort(using work: ResultsWork) throws -> [Int]? { try orderedIndices(work) }

	private enum Cancelled: Error { case sort }
	private static func number(_ value: Double?) -> Double? {
		guard let value = value, !value.isNaN else { return nil }
		return value
	}
	private static func sorter<T: Comparable>(_ keys: [T?], ascending: Bool) -> (ResultsWork) throws -> [Int]? {
		return { work in
			guard !work.isCancelled else { return nil }
			var comparisons = 0
			do {
				let result = try keys.indices.sorted { left, right in
					comparisons += 1
					if comparisons % 256 == 0 && work.isCancelled { throw Cancelled.sort }
					switch (keys[left], keys[right]) {
					case (nil, nil): break
					case (nil, _): return true // Missing values stay first in either direction.
					case (_, nil): return false
					case let (lhs?, rhs?):
						if lhs < rhs { return ascending }
						if rhs < lhs { return !ascending }
					}
					return left < right // Stable ties, including two missing values.
				}
				return work.isCancelled ? nil : result
			} catch Cancelled.sort { return nil }
		}
	}
}

internal enum NearbyResultsQuery {
	/// Preserve the query builder's strict containment window for both timestamp
	/// and interval target types. Invalid input must never run an unrestricted query.
	static func configure(_ query: Query, type: Sample.Type, dates: [DateType: Date], duration: TimeDuration) throws {
		let seconds = duration.inUnit(.second)
		guard seconds.isFinite, seconds >= 0, let start = dates[.start],
			let startAttribute = type.dateAttributes[.start] else {
			throw GenericDisplayableError(title: "Unable to search nearby", description: "Choose an entry with a timestamp and a valid duration.")
		}
		let end = dates[.end] ?? start
		let minimum = start.addingTimeInterval(-seconds)
		let maximum = end.addingTimeInterval(seconds)
		guard end >= start, minimum.timeIntervalSinceReferenceDate.isFinite,
			maximum.timeIntervalSinceReferenceDate.isFinite else {
			throw GenericDisplayableError(title: "Unable to search nearby", description: "The selected date range is invalid.")
		}
		query.expression = AndExpression(
			AfterDateAndTimeAttributeRestriction(restrictedAttribute: startAttribute, date: minimum),
			BeforeDateAndTimeAttributeRestriction(restrictedAttribute: type.dateAttributes[.end] ?? startAttribute, date: maximum)
		)
	}
}

internal enum ResultsQuerySnapshot {
	/// Refreshes must not share a query's mutable callback/cancellation state.
	static func copy(_ query: Query, using factory: QueryFactory) throws -> Query {
		try copy(query, using: factory, visited: [])
	}
	private static func copy(_ query: Query, using factory: QueryFactory, visited: Set<ObjectIdentifier>) throws -> Query {
		let identifier = ObjectIdentifier(query)
		guard !visited.contains(identifier) else { throw GenericError("A query cannot contain itself") }
		let fresh = try factory.queryFor(factory.sampleTypeFor(query))
		guard fresh !== query else { throw GenericError("Query factory did not create an independent query") }
		fresh.expression = query.expression?.copy()
		fresh.mostRecentEntryOnly = query.mostRecentEntryOnly
		if let subQuery = query.subQuery {
			let matcher = type(of: subQuery.matcher).init()
			for attribute in subQuery.matcher.attributes {
				try matcher.set(attribute: attribute, to: subQuery.matcher.value(of: attribute))
			}
			fresh.subQuery = (matcher, try copy(subQuery.query, using: factory, visited: visited.union([identifier])))
		}
		return fresh
	}
}

internal func resultsOnMain(_ action: @escaping () -> Void) {
	if Thread.isMainThread { action() }
	else { DispatchQueue.main.async(execute: action) }
}
