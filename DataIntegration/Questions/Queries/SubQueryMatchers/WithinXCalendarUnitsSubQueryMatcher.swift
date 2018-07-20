//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class WithinXCalendarUnitsSubQueryMatcher: SubQueryMatcher {

	fileprivate typealias Me = WithinXCalendarUnitsSubQueryMatcher

	fileprivate static let amountOfTime = 0
	fileprivate static let timeUnit = 1

	public static let genericDescription: String = "Within <number> <time_unit> of"
	public static let parameters: [(id: Int, type: ParamType)] = [
		(id: amountOfTime, type: .integer),
		(id: timeUnit, type: .timeUnit),
	]

	public var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + CalendarUtil.componentNames[timeUnit]!.lowercased() + "s of"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public var numberOfTimeUnits: Int = 5
	public var timeUnit: Calendar.Component = .minute
	public var mostRecentOnly: Bool = false

	public required init() {} // do nothing

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		for sample in querySamples {
			let closestSubQuerySample = DependencyInjector.util.sampleUtil.closestInTimeTo(sample: sample, in: applicableSubQuerySamples)
			if DependencyInjector.util.sampleUtil.distance(between: sample, and: closestSubQuerySample, in: timeUnit) <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public func setParameter<T>(id: Int, value: T) throws {
		if id == Me.amountOfTime {
			if T.self != Int.self {
				throw ParamErrors.typeMismatch
			}
			numberOfTimeUnits = (value as! Int)
		} else if id == Me.timeUnit {
			if T.self != Calendar.Component.self {
				throw ParamErrors.typeMismatch
			}
			timeUnit = (value as! Calendar.Component)
		} else {
			throw ParamErrors.invalidIdentifier
		}
	}

	public func getParameterValue<T>(id: Int) throws -> T {
		if id == Me.amountOfTime {
			if T.self != Int.self {
				throw ParamErrors.typeMismatch
			}
			return numberOfTimeUnits as! T
		} else if id == Me.timeUnit {
			if T.self != Calendar.Component.self {
				throw ParamErrors.typeMismatch
			}
			return timeUnit as! T
		} else {
			throw ParamErrors.invalidIdentifier
		}
	}
}
