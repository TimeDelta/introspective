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

		let subQuerySamplesSortedByEndDate = DependencyInjector.util.sampleUtil.sort(samples: applicableSubQuerySamples, by: .end)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByEndDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendarUtil.compare(s1.dates()[.end], s2.dates()[.end])
				}
			)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public func setParameter<T>(id: Int, value: T) throws {
		throw ParamErrors.invalidIdentifier // no paremeters
	}

	public func getParameterValue<T>(id: Int) throws -> T {
		throw ParamErrors.invalidIdentifier // no paremeters
	}
}
