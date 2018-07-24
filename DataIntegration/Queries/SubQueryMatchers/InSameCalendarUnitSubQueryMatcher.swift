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

	fileprivate static let timeUnit = 0

	public static let genericDescription: String = "Within the same <time_unit> of"
	public static let parameters: [(id: Int, type: ParamType)] = [
		(id: timeUnit, type: .timeUnit),
	]

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

	public var timeUnit: Calendar.Component = .day
	public var mostRecentOnly: Bool = false

	public required init() {} // do nothing

	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let aggregatedSubQuerySamplesByStartDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .start)
		let aggregatedSubQuerySamplesByEndDate = DependencyInjector.util.sampleUtil.aggregate(samples: applicableSubQuerySamples, by: timeUnit, dateType: .end)
		for sample in querySamples {
			let aggregationDate = DependencyInjector.util.calendarUtil.start(of: timeUnit, in: sample.dates[.start]!)
			if aggregatedSubQuerySamplesByStartDate[aggregationDate] != nil || aggregatedSubQuerySamplesByEndDate[aggregationDate] != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public func setParameter<T>(id: Int, value: T) throws {
		if id == Me.timeUnit {
			if T.self != Calendar.Component.self {
				throw ParamErrors.typeMismatch
			}
			timeUnit = (value as! Calendar.Component)
		} else {
			throw ParamErrors.invalidIdentifier
		}
	}

	public func getParameterValue<T>(id: Int) throws -> T {
		if id == Me.timeUnit {
			if T.self != Calendar.Component.self {
				throw ParamErrors.typeMismatch
			}
			return timeUnit as! T
		} else {
			throw ParamErrors.invalidIdentifier
		}
	}
}
