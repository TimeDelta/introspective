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
	public static let parameters: [(id: Int, type: ParamType)] = []

	public var description: String {
		var text = Me.genericDescription
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public var mostRecentOnly: Bool = false

	public required init() {} // do nothing

	public func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let subQuerySamplesSortedByStartAndEndDates = applicableSubQuerySamples.sorted { (s1: Sample, s2: Sample) -> Bool in
			return compare(s1, s2) == .orderedAscending
		}
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(for: sample, in: subQuerySamplesSortedByStartAndEndDates, compare: compare)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	fileprivate func compare(_ s1: Sample, _ s2: Sample) -> ComparisonResult {
		let start1 = s1.dates()[.start]!
		let start2 = s2.dates()[.start]!

		let startDateComparison = start1.compare(start2)
		if startDateComparison != .orderedSame {
			return startDateComparison
		}

		return DependencyInjector.util.calendarUtil.compare(s1.dates()[.end], s2.dates()[.end])
	}

	public func setParameter<T>(id: Int, value: T) throws {
		throw ParamErrors.invalidIdentifier // no paremeters
	}

	public func getParameterValue<T>(id: Int) throws -> T {
		throw ParamErrors.invalidIdentifier // no paremeters
	}
}
