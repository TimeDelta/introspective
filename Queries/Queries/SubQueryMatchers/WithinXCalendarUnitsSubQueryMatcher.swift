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
		if subQuerySamples.isEmpty {
			return []
		}

		var matchingSamples = [QuerySampleType]()

		var subQuerySamplesByStart = injected(SampleUtil.self)
			.sort(samples: subQuerySamples, by: .start, in: .orderedAscending)
		var subQuerySamplesByEnd = injected(SampleUtil.self)
			.sort(samples: subQuerySamples, by: .end, in: .orderedAscending)
		if mostRecentOnly {
			subQuerySamplesByStart = [subQuerySamplesByStart[0]]
			subQuerySamplesByEnd = [subQuerySamplesByStart[0]]
		}

		for sample in querySamples {
			let closestSubQuerySampleIndexByStart = injected(SearchUtil.self)
				.binarySearchForClosest(to: sample, in: subQuerySamplesByStart) {
					let distanceToStart = try! injected(CalendarUtil.self)
						.distance(from: sample.dates()[.start]!, to: $1.dates()[.start]!, in: timeUnit)
					if let endDate = sample.dates()[.end] {
						let distanceToEnd = try! injected(CalendarUtil.self)
							.distance(from: endDate, to: $1.dates()[.start]!, in: timeUnit)
						if abs(distanceToEnd) < abs(distanceToStart) {
							return distanceToEnd
						}
					}
					return distanceToStart
				}
			let closestSubQuerySampleIndexByEnd = injected(SearchUtil.self)
				.binarySearchForClosest(to: sample, in: subQuerySamplesByEnd) {
					guard let subQuerySampleEndDate = $1.dates()[.end] else {
						return Int.max
					}
					let distanceToStart = try! injected(CalendarUtil.self)
						.distance(from: sample.dates()[.start]!, to: subQuerySampleEndDate, in: timeUnit)
					if let endDate = sample.dates()[.end] {
						let distanceToEnd = try! injected(CalendarUtil.self)
							.distance(from: endDate, to: subQuerySampleEndDate, in: timeUnit)
						if abs(distanceToEnd) < abs(distanceToStart) {
							return distanceToEnd
						}
					}
					return distanceToStart
				}

			let distanceToStart = injected(SampleUtil.self)
				.distance(between: sample, and: subQuerySamplesByStart[closestSubQuerySampleIndexByStart], in: timeUnit)
			let distanceToEnd = injected(SampleUtil.self)
				.distance(between: sample, and: subQuerySamplesByEnd[closestSubQuerySampleIndexByEnd], in: timeUnit)
			let distance = min(distanceToStart, distanceToEnd)

			if distance <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
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
