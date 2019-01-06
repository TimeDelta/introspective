//
//  InSameCalendarUnitSubQueryMatch.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class InSameCalendarUnitSubQueryMatcher: SubQueryMatcher, Equatable {

	private typealias Me = InSameCalendarUnitSubQueryMatcher

	// MARK: - Attributes

	public static let timeUnit = CalendarComponentAttribute(name: "Time unit", possibleValues: [
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
	public static let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly, timeUnit]
	public final let attributes: [Attribute] = Me.attributes

	// MARK: - Display Information

	public final let attributedName: String = "Within the same <time_unit> of"
	public final var description: String {
		var text: String
		if timeUnit == .day {
			text = "On"
		} else {
			text = "In"
		}
		text += " the same " + timeUnit.description.lowercased() + " as"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	// MARK: - Instance Variables

	public final var timeUnit: Calendar.Component = .day
	public final var mostRecentOnly: Bool = false

	// MARK: - Initializers

	public required init() {}

	public init(timeUnit: Calendar.Component = .day, mostRecentOnly: Bool = false) {
		self.timeUnit = timeUnit
		self.mostRecentOnly = mostRecentOnly
	}

	// MARK: - SubQueryMatcher Functions

	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	throws -> [QuerySampleType] {
		if subQuerySamples.count == 0 { return [] }

		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sample.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [applicableSubQuerySamples[0]]
		}

		var startDateAttribute = CommonSampleAttributes.startDate
		if !sample(applicableSubQuerySamples[0], has: startDateAttribute) {
			startDateAttribute = CommonSampleAttributes.timestamp
		}
		let aggregatedSubQuerySamplesByStartDate = try DependencyInjector.util.sample.aggregate(
			samples: applicableSubQuerySamples,
			by: timeUnit,
			for: startDateAttribute)
		for currentSample in querySamples {
			let startAggregationDate = DependencyInjector.util.calendar.start(of: timeUnit, in: currentSample.dates()[.start]!)
			if aggregatedSubQuerySamplesByStartDate[startAggregationDate] != nil {
				matchingSamples.append(currentSample)
			} else if
				let endDate = currentSample.dates()[.end],
				sample(applicableSubQuerySamples[0], has: CommonSampleAttributes.endDate)
			{
				let aggregatedSubQuerySamplesByEndDate = try DependencyInjector.util.sample.aggregate(
					samples: applicableSubQuerySamples,
					by: timeUnit,
					for: CommonSampleAttributes.endDate)

				let endAggregationDate = DependencyInjector.util.calendar.start(of: timeUnit, in: endDate)
				if aggregatedSubQuerySamplesByEndDate[endAggregationDate] != nil {
					matchingSamples.append(currentSample)
				}
			}
		}
		return matchingSamples
	}

	// MARK: - Attribute Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnit) {
			return timeUnit
		}
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.timeUnit) {
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

	public static func ==(lhs: InSameCalendarUnitSubQueryMatcher, rhs: InSameCalendarUnitSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is InSameCalendarUnitSubQueryMatcher) { return false }
		let other = otherAttributed as! InSameCalendarUnitSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is InSameCalendarUnitSubQueryMatcher) { return false }
		let other = otherMatcher as! InSameCalendarUnitSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ other: InSameCalendarUnitSubQueryMatcher) -> Bool {
		return timeUnit == other.timeUnit && mostRecentOnly == other.mostRecentOnly
	}

	// MARK: - Helper Functions

	private final func sample(_ sample: Sample, has attribute: Attribute) -> Bool {
		return sample.attributes.filter{ $0.equalTo(attribute) }.count > 0
	}
}
