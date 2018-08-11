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

		let subQuerySamplesSortedByStartDate = DependencyInjector.util.sampleUtil.sort(samples: applicableSubQuerySamples, by: .start)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.searchUtil.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByStartDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendarUtil.compare(s1.dates()[.start], s2.dates()[.start])
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
