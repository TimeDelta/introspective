//
//  InSameCalendarUnitSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class InSameCalendarUnitSubQueryMatcher: SubQueryMatcher {

	public static let genericDescription: String = "Within the same <time_unit> of"

	public var timeUnit: Calendar.Component = .day

	public var description: String {
		var text: String
		if timeUnit == .day {
			text = "On"
		} else {
			text = "In"
		}
		return text + " the same " + CalendarUtil.componentNames[timeUnit]!
	}

	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()
		let aggregatedSubQuerySamplesByStartDate = DependencyInjector.util.sampleUtil.aggregate(samples: subQuerySamples, by: timeUnit, dateType: .start)
		let aggregatedSubQuerySamplesByEndDate = DependencyInjector.util.sampleUtil.aggregate(samples: subQuerySamples, by: timeUnit, dateType: .end)
		for sample in querySamples {
			let aggregationDate = DependencyInjector.util.calendarUtil.start(of: timeUnit, in: sample.dates[.start]!)
			if aggregatedSubQuerySamplesByStartDate[aggregationDate] != nil || aggregatedSubQuerySamplesByEndDate[aggregationDate] != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}
}
