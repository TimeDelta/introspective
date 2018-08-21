//
//  InSameCalendarUnitSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class InSameCalendarUnitSubQueryMatcher: SubQueryMatcher {

	fileprivate typealias Me = InSameCalendarUnitSubQueryMatcher

	public static let timeUnit = CalendarComponentAttribute(name: "Time unit")
	public static let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly, timeUnit]

	public let name: String = "Within the same <time_unit> of"
	public var description: String {
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

	public let attributes: [Attribute] = Me.attributes
	public var timeUnit: Calendar.Component = .day
	public var mostRecentOnly: Bool = false

	public required init() {}

	public func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let aggregatedSubQuerySamplesByStartDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .start)
		let aggregatedSubQuerySamplesByEndDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .end)
		for sample in querySamples {
			let aggregationDate = DependencyInjector.util.calendarUtil.start(of: timeUnit, in: sample.dates()[.start]!)
			if aggregatedSubQuerySamplesByStartDate[aggregationDate] != nil || aggregatedSubQuerySamplesByEndDate[aggregationDate] != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(Me.timeUnit) {
			return timeUnit
		}
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
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
}
