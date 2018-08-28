//
//  SameEndDatesSubQueryMatcher.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class SameEndDatesSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: SameEndDatesSubQueryMatcher, rhs: SameEndDatesSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs as SubQueryMatcher)
	}

	public let name: String = "Ends on the same date at the same time as"
	public var description: String {
		var text = "Ends on the same date at the same time as"
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
			applicableSubQuerySamples = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .end, in: .orderedDescending)
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let subQuerySamplesSortedByEndDate = DependencyInjector.util.sampleUtil.sort(samples: applicableSubQuerySamples, by: .end, in: .orderedAscending)
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
