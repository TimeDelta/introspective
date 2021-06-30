//
//  InSameCalendarUnitSubQueryMatch.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class InSameCalendarUnitSubQueryMatcher: SubQueryMatcher, Equatable {
	private typealias Me = InSameCalendarUnitSubQueryMatcher

	private static let log = Log()

	// MARK: - Attributes

	public static let timeUnit = CalendarComponentAttribute(id: 0, name: "Time unit", possibleValues: [
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
		matching subQuerySamples: [Sample]
	) throws -> [QuerySampleType] {
		if subQuerySamples.isEmpty { return [] }

		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = injected(SampleUtil.self)
				.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [applicableSubQuerySamples[0]]
		}

		let startDateAttribute = getStartDateAttribute(for: applicableSubQuerySamples[0])
		let aggregatedSubQuerySamplesByStartDate = try injected(SampleUtil.self).aggregate(
			samples: applicableSubQuerySamples,
			by: timeUnit,
			for: startDateAttribute
		)
		for currentSample in querySamples {
			let startAggregationDate = injected(CalendarUtil.self)
				.start(of: timeUnit, in: currentSample.dates()[.start]!)
			if aggregatedSubQuerySamplesByStartDate[startAggregationDate] != nil {
				matchingSamples.append(currentSample)
			} else if
				let endDate = currentSample.dates()[.end],
				let endDateAttribute = getEndDateAttribute(for: currentSample) {
				let aggregatedSubQuerySamplesByEndDate = try injected(SampleUtil.self).aggregate(
					samples: applicableSubQuerySamples,
					by: timeUnit,
					for: endDateAttribute
				)

				let endAggregationDate = injected(CalendarUtil.self).start(of: timeUnit, in: endDate)
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

	public static func == (lhs: InSameCalendarUnitSubQueryMatcher, rhs: InSameCalendarUnitSubQueryMatcher) -> Bool {
		lhs.equalTo(rhs)
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
		timeUnit == other.timeUnit && mostRecentOnly == other.mostRecentOnly
	}

	// MARK: - Helper Functions

	private final func sample(_ sample: Sample, has attribute: Attribute) -> Bool {
		!sample.attributes.filter { $0.equalTo(attribute) }.isEmpty
	}

	private final func getStartDateAttribute(for _sample: Sample) -> Attribute {
		let startAttributes = [
			CommonSampleAttributes.startDate,
			CommonSampleAttributes.healthKitStartDate,
			CommonSampleAttributes.timestamp,
			CommonSampleAttributes.healthKitTimestamp,
		]
		for attribute in startAttributes {
			if sample(_sample, has: attribute) {
				return attribute
			}
		}
		Me.log.error("Unable to find start date attribute for sample type: %@", _sample.attributedName)
		return CommonSampleAttributes.startDate
	}

	private final func getEndDateAttribute(for _sample: Sample) -> Attribute? {
		if sample(_sample, has: CommonSampleAttributes.endDate) {
			return CommonSampleAttributes.endDate
		}
		if sample(_sample, has: CommonSampleAttributes.healthKitEndDate) {
			return CommonSampleAttributes.healthKitEndDate
		}
		if sample(_sample, has: CommonSampleAttributes.optionalEndDate) {
			return CommonSampleAttributes.optionalEndDate
		}
		return nil
	}
}
