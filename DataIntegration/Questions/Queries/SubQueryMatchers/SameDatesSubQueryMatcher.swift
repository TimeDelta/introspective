//
//  SameDatesSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameDatesSubQueryMatcher: SubQueryMatcher {

	fileprivate typealias Me = SameDatesSubQueryMatcher

	public static let genericDescription: String = "Start and end timestamps are the same as"

	public var description: String {
		return Me.genericDescription
	}

	public func getSamples<QuerySampleType: Sample, SubQuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [SubQuerySampleType])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()
		let subQuerySamplesSortedByStartDate = subQuerySamples.sorted { (s1: Sample, s2: Sample) -> Bool in
			return compare(s1, s2) == .orderedAscending
		}
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(for: sample, in: subQuerySamplesSortedByStartDate, compare: compare)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	fileprivate func compare(_ s1: Sample, _ s2: Sample) -> ComparisonResult {
		let start1 = s1.dates[.start]!
		let start2 = s2.dates[.start]!

		let startDateComparison = start1.compare(start2)
		if startDateComparison != .orderedSame {
			return startDateComparison
		}

		return DependencyInjector.util.calendarUtil.compare(s1.dates[.end], s2.dates[.end])
	}
}
