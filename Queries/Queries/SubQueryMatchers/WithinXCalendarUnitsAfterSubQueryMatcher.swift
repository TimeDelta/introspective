//
//  WithinXCalendarUnitsAfterSubQueryMatcher.swift
//  Queries
//
//  Created by Bryan Nova on 4/21/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class WithinXCalendarUnitsAfterSubQueryMatcher: SubQueryMatcher, Equatable {
	private typealias Me = WithinXCalendarUnitsAfterSubQueryMatcher

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

	public final let attributedName: String = "Within <number> <time_unit>s after"
	public final var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + timeUnit.description.lowercased() + "s after"
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

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` after a sub-query sample
	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample]
	) -> [QuerySampleType] {
		directionalCalendarMatches(querySamples, subQuerySamples, numberOfTimeUnits: numberOfTimeUnits,
			timeUnit: timeUnit, mostRecentOnly: mostRecentOnly, after: true)
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

	public static func == (
		lhs: WithinXCalendarUnitsAfterSubQueryMatcher,
		rhs: WithinXCalendarUnitsAfterSubQueryMatcher
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		guard let other = otherAttributed as? WithinXCalendarUnitsAfterSubQueryMatcher else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		guard let other = otherMatcher as? WithinXCalendarUnitsAfterSubQueryMatcher else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ other: WithinXCalendarUnitsAfterSubQueryMatcher) -> Bool {
		numberOfTimeUnits == other.numberOfTimeUnits && timeUnit == other.timeUnit && mostRecentOnly == other
			.mostRecentOnly
	}
}

/// Direction is determined by actual instants; proximity uses the existing whole
/// calendar-unit distance contract. Search only the nearest endpoint on that side.
internal func directionalCalendarMatches<T: Sample>(_ querySamples: [T], _ references: [Sample],
    numberOfTimeUnits: Int, timeUnit: Calendar.Component, mostRecentOnly: Bool, after: Bool) -> [T] {
    guard numberOfTimeUnits > 0, !querySamples.isEmpty, !references.isEmpty else { return [] }
    var endpoints = [(start: Date, anchor: Date)]()
    for sample in references {
        let dates = sample.dates()
        guard let start = dates[.start] else { continue }
        endpoints.append((start, after ? (dates[.end] ?? start) : start))
    }
    if mostRecentOnly, let latest = endpoints.max(by: { $0.start < $1.start }) {
        endpoints = [latest]
    }
    let anchors = endpoints.map { $0.anchor }.sorted()
    guard !anchors.isEmpty else { return [] }
    let calendar = injected(CalendarUtil.self)
    return querySamples.filter { sample in
        let dates = sample.dates()
        guard let start = dates[.start] else { return false }
        let date = after ? start : (dates[.end] ?? start)
        var lower = 0
        var upper = anchors.count
        while lower < upper {
            let middle = lower + (upper - lower) / 2
            // For before, skip equal instants; equality has no direction.
            if after ? anchors[middle] < date : anchors[middle] <= date {
                lower = middle + 1
            } else {
                upper = middle
            }
        }
        let index = after ? lower - 1 : lower
        guard anchors.indices.contains(index) else { return false }
        let earlier = after ? anchors[index] : date
        let later = after ? date : anchors[index]
        guard let gap = try? calendar.distance(from: earlier, to: later, in: timeUnit) else { return false }
        return gap >= 0 && gap <= numberOfTimeUnits
    }
}
