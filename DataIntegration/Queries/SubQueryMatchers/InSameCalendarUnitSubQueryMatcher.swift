//
//  InSameCalendarUnitSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class InSameCalendarUnitSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: InSameCalendarUnitSubQueryMatcher, rhs: InSameCalendarUnitSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = InSameCalendarUnitSubQueryMatcher

	public static let timeUnit = CalendarComponentAttribute(name: "Time unit")
	public static let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly, timeUnit]

	public final let name: String = "Within the same <time_unit> of"
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

	public final let attributes: [Attribute] = Me.attributes
	public final var timeUnit: Calendar.Component = .day
	public final var mostRecentOnly: Bool = false

	public required init() {}

	public init(timeUnit: Calendar.Component = .day, mostRecentOnly: Bool = false) {
		self.timeUnit = timeUnit
		self.mostRecentOnly = mostRecentOnly
	}

	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let aggregatedSubQuerySamplesByStartDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .start)
		let aggregatedSubQuerySamplesByEndDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .end)
		for sample in querySamples {
			let startAggregationDate = DependencyInjector.util.calendarUtil.start(of: timeUnit, in: sample.dates()[.start]!)
			if aggregatedSubQuerySamplesByStartDate[startAggregationDate] != nil {
				matchingSamples.append(sample)
			} else if let endDate = sample.dates()[.end] {
				let endAggregationDate = DependencyInjector.util.calendarUtil.start(of: timeUnit, in: endDate)
				if aggregatedSubQuerySamplesByEndDate[endAggregationDate] != nil {
					matchingSamples.append(sample)
				}
			}
		}
		return matchingSamples
	}

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.timeUnit) {
			return timeUnit
		}
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(Me.timeUnit) {
			guard let castedValue = value as? Calendar.Component else { throw AttributeError.typeMismatch }
			timeUnit = castedValue
		} else if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
			mostRecentOnly = castedValue
		} else {
			throw AttributeError.unknownAttribute
		}
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
}
