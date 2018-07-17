//
//  SameEndDatesSubQueryMatcher.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameEndDatesSubQueryMatcher: SubQueryMatcher {

	fileprivate typealias Me = SameEndDatesSubQueryMatcher

	public static let genericDescription: String = "Ends on the same date at the same time as"

	public var description: String {
		return Me.genericDescription
	}

	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()
		let subQuerySamplesSortedByStartDate = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .end)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByStartDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendarUtil.compare(s1.dates[.end], s2.dates[.end])
				}
			)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}
}
