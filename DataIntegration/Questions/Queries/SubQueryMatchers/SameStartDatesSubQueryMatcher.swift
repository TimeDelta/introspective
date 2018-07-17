//
//  SameStartDateSubQueryMatcher.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameStartDatesSubQueryMatcher: SubQueryMatcher {

	fileprivate typealias Me = SameStartDatesSubQueryMatcher

	public static let genericDescription: String = "Starts on the same date at the same time as"

	public var description: String {
		return Me.genericDescription
	}

	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()
		let subQuerySamplesSortedByStartDate = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .start)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByStartDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendarUtil.compare(s1.dates[.start], s2.dates[.start])
				}
			)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}
}
