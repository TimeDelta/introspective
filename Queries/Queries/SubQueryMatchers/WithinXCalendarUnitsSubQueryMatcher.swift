//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  Introspective
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class WithinXCalendarUnitsSubQueryMatcher: SubQueryMatcher, Equatable {
	private typealias Me = WithinXCalendarUnitsSubQueryMatcher

	// MARK: - Attributes

	public static let amountOfTime = IntegerAttribute(id: 0, name: "Number of time units")
	public static let timeUnit = CalendarComponentAttribute(id: 1, name: "Time unit", possibleValues: [
		.year,
		.quarter,
		.month,
		.weekOfMonth,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
		.nanosecond,
	])
	public static let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly, amountOfTime, timeUnit]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Display Information

	public final let attributedName: String = "Within <number> <time_unit>s of"
	public final var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + timeUnit.description.lowercased() + "s of"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	// MARK: - Instance Variables

	public final var numberOfTimeUnits: Int = 5
	public final var timeUnit: Calendar.Component = .minute
	public final var mostRecentOnly: Bool = false

	// MARK: - Initializers

	public required init() {}

	public init(numberOfTimeUnits: Int = 5, timeUnit: Calendar.Component = .minute, mostRecentOnly: Bool = false) {
		self.numberOfTimeUnits = numberOfTimeUnits
		self.timeUnit = timeUnit
		self.mostRecentOnly = mostRecentOnly
	}

	// MARK: - SubQueryMatcher Functions

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample]
	) -> [QuerySampleType] {
		guard !querySamples.isEmpty, !subQuerySamples.isEmpty, numberOfTimeUnits >= 0 else { return [] }

		var referenceDates = [Date]()
		if mostRecentOnly {
			// Recency follows the latest start. Keep both endpoints of that record.
			var latest: (start: Date, end: Date?)?
			for sample in subQuerySamples {
				let dates = sample.dates()
				guard let start = dates[.start] else { continue }
				if let current = latest, start <= current.start { continue }
				latest = (start, dates[.end])
			}
			if let latest = latest {
				referenceDates.append(latest.start)
				if let end = latest.end { referenceDates.append(end) }
			}
		} else {
			referenceDates.reserveCapacity(subQuerySamples.count * 2)
			for sample in subQuerySamples {
				let dates = sample.dates()
				if let start = dates[.start] { referenceDates.append(start) }
				if let end = dates[.end] { referenceDates.append(end) }
			}
		}
		referenceDates.sort()
		guard !referenceDates.isEmpty else { return [] }
		let calendar = injected(CalendarUtil.self)
		return querySamples.filter { sample in
			let dates = sample.dates()
			if let start = dates[.start], isWithinWindow(start, of: referenceDates, using: calendar) { return true }
			if let end = dates[.end], isWithinWindow(end, of: referenceDates, using: calendar) { return true }
			return false
		}
	}

	private final func isWithinWindow(_ date: Date, of sortedDates: [Date], using calendar: CalendarUtil) -> Bool {
		// Search each query endpoint separately: the minimum of two signed
		// endpoint distances is not monotonic and cannot guide a binary search.
		var lower = 0
		var upper = sortedDates.count
		while lower < upper {
			let middle = lower + (upper - lower) / 2
			if sortedDates[middle] < date { lower = middle + 1 } else { upper = middle }
		}
		// Calendar distance from a fixed date is monotonic on each side. Only
		// adjacent endpoints can be closer; compute at most two calendar distances.
		if lower < sortedDates.count,
			abs(try! calendar.distance(from: date, to: sortedDates[lower], in: timeUnit)) <= numberOfTimeUnits { return true }
		if lower > 0,
			abs(try! calendar.distance(from: date, to: sortedDates[lower - 1], in: timeUnit)) <= numberOfTimeUnits { return true }
		return false
	}

	// MARK: - Attribute Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.amountOfTime) {
			return numberOfTimeUnits
		}
		if attribute.equalTo(Me.timeUnit) {
			return timeUnit
		}
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.amountOfTime) {
			guard let castedValue = value as? Int else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			numberOfTimeUnits = castedValue
		} else if attribute.equalTo(Me.timeUnit) {
			guard let castedValue = value as? Calendar.Component else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timeUnit = castedValue
		} else if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			mostRecentOnly = castedValue
		} else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
	}

	// MARK: - Equality

	public static func == (lhs: WithinXCalendarUnitsSubQueryMatcher, rhs: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherAttributed as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherMatcher as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ other: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		numberOfTimeUnits == other.numberOfTimeUnits && timeUnit == other.timeUnit && mostRecentOnly == other
			.mostRecentOnly
	}
}
