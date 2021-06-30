//
//  WithinXCalendarUnitsBeforeSubQueryMatcher.swift
//  Introspective
//
//  Created by Bryan Nova on 4/20/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class WithinXCalendarUnitsBeforeSubQueryMatcher: SubQueryMatcher, Equatable {
	private typealias Me = WithinXCalendarUnitsBeforeSubQueryMatcher

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

	public final let attributedName: String = "Within <number> <time_unit>s before"
	public final var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + timeUnit.description.lowercased() + "s before"
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

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` before a sub-query sample
	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample]
	) -> [QuerySampleType] {
		if subQuerySamples.isEmpty {
			return []
		}

		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = injected(SampleUtil.self)
			.sort(samples: subQuerySamples, by: .start, in: .orderedAscending)
		if mostRecentOnly {
			applicableSubQuerySamples = [applicableSubQuerySamples[applicableSubQuerySamples.count - 1]]
		}

		for sample in querySamples {
			// do binary search for the minimum distance since they are ordered by start date
			// and we only care about the before case
			// we do this by looking for the gradient change in distance to target sample
			var closestSubQuerySampleIndex = binarySearchForClosestSample(to: sample, in: applicableSubQuerySamples)
			var closestDistance = distance(
				querySample: sample,
				subQuerySample: subQuerySamples[closestSubQuerySampleIndex]
			)

			if closestDistance > 0 && closestSubQuerySampleIndex > 0 {
				closestSubQuerySampleIndex -= 1 // previous index will have negative distance, meaning BEFORE
				closestDistance = distance(
					querySample: sample,
					subQuerySample: subQuerySamples[closestSubQuerySampleIndex]
				)
			}

			if closestDistance < 0 && abs(closestDistance) <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	private func binarySearchForClosestSample(to targetSample: Sample, in items: [Sample]) -> Int {
		var lowerIndex = 0
		var upperIndex = items.count - 1

		var closestDistance = Int.max
		var closestDistanceIndex = 0

		// use iterative version instead of recursive to avoid stack overflow
		while true {
			let currentIndex = (lowerIndex + upperIndex) / 2
			let distanceToTargetSample = distance(querySample: targetSample, subQuerySample: items[currentIndex])

			if distanceToTargetSample == 0 {
				return currentIndex
			}

			if abs(distanceToTargetSample) < abs(closestDistance) {
				closestDistance = distanceToTargetSample
				closestDistanceIndex = currentIndex
			}

			if lowerIndex > upperIndex {
				return closestDistanceIndex
			}

			if distanceToTargetSample > 0 {
				upperIndex = currentIndex - 1
			} else {
				lowerIndex = currentIndex + 1
			}
		}
	}

	private final func distance(querySample: Sample, subQuerySample: Sample) -> Int {
		let querySampleStart = querySample.dates()[.start]!
		let subQuerySampleStart = subQuerySample.dates()[.start]!

		guard let startDistance = try? injected(CalendarUtil.self)
			.distance(from: querySampleStart, to: subQuerySampleStart, in: timeUnit) else {
			return Int.max
		}

		if let querySampleEnd = querySample.dates()[.end] {
			guard let endDistance = try? injected(CalendarUtil.self)
				.distance(from: querySampleEnd, to: subQuerySampleStart, in: timeUnit) else {
				return startDistance
			}
			if abs(endDistance) < abs(startDistance) {
				return endDistance
			}
		}
		return startDistance
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
		lhs: WithinXCalendarUnitsBeforeSubQueryMatcher,
		rhs: WithinXCalendarUnitsBeforeSubQueryMatcher
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		guard let other = otherAttributed as? WithinXCalendarUnitsBeforeSubQueryMatcher else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		guard let other = otherMatcher as? WithinXCalendarUnitsBeforeSubQueryMatcher else {
			return false
		}
		return equalTo(other)
	}

	public final func equalTo(_ other: WithinXCalendarUnitsBeforeSubQueryMatcher) -> Bool {
		numberOfTimeUnits == other.numberOfTimeUnits && timeUnit == other.timeUnit && mostRecentOnly == other
			.mostRecentOnly
	}
}
