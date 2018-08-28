//
//  SameStartDateSubQueryMatcher.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameStartDatesSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: SameStartDatesSubQueryMatcher, rhs: SameStartDatesSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs as SubQueryMatcher)
	}

	public let name: String = "Starts on the same date at the same time as"
	public var description: String {
		var text = "Starts on the same date at the same time as"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly]
	public var mostRecentOnly: Bool = false

	public required init() {}

	public func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let subQuerySamplesSortedByStartDate = DependencyInjector.util.sampleUtil.sort(samples: applicableSubQuerySamples, by: .start, in: .orderedAscending)
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

	public func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
			mostRecentOnly = castedValue
		} else {
			throw AttributeError.unknownAttribute
		}
	}
}
