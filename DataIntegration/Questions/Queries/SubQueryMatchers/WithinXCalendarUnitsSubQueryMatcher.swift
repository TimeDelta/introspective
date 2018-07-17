//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class WithinXCalendarUnitsSubQueryMatcher: SubQueryMatcher {

	public static let genericDescription: String = "Within <number> <time_unit> of"

	public var description: String {
		get {
			return "Within " + String(numberOfTimeUnits) + " " + CalendarUtil.componentNames[timeUnit]!.lowercased() + "s"
		}
	}

	public var numberOfTimeUnits: Int = 5
	public var timeUnit: Calendar.Component = .minute

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()
		for sample in querySamples {
			let closestQuerySample = DependencyInjector.util.sampleUtil.closestInTimeTo(sample: sample, in: querySamples)
			if DependencyInjector.util.sampleUtil.distance(between: sample, and: closestQuerySample, in: timeUnit) <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}
}
