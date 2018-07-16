//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class WithinXCalendarUnitsSubQueryMatch: SubQueryMatch {

	public var description: String {
		get {
			return "Within " + String(numberOfCalendarUnits) + " " + CalendarUtil.componentNames[calendarUnit]!.lowercased() + "s"
		}
	}

	public var numberOfCalendarUnits: Int = 5
	public var calendarUnit: Calendar.Component = .minute

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public func getSamples<SampleType: Sample>(from querySamples: [SampleType], matching subQuerySamples: [SampleType]) -> [SampleType] {
		var matchingSamples = [SampleType]()
		for sample in querySamples {
			let closestQuerySample = DependencyInjector.util.sampleUtil.closestInTimeTo(sample: sample, in: querySamples)
			if DependencyInjector.util.sampleUtil.distance(between: sample, and: closestQuerySample, in: calendarUnit) <= numberOfCalendarUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}
}
