//
//  SameStartDateSubQueryMatcher.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SameStartDatesSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: SameStartDatesSubQueryMatcher, rhs: SameStartDatesSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final let attributedName: String = "Starts on the same date at the same time as"
	public final var description: String {
		var text = "Starts on the same date at the same time as"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public final let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly]
	public final var mostRecentOnly: Bool = false

	public required init() {}

	public init(mostRecentOnly: Bool = false) {
		self.mostRecentOnly = mostRecentOnly
	}

	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sample.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let subQuerySamplesSortedByStartDate = DependencyInjector.util.sample.sort(samples: applicableSubQuerySamples, by: .start, in: .orderedAscending)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.search.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByStartDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendar.compare(s1.dates()[.start], s2.dates()[.start])
				}
			)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
			mostRecentOnly = castedValue
		} else {
			throw AttributeError.unknownAttribute
		}
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is SameStartDatesSubQueryMatcher) { return false }
		let other = otherAttributed as! SameStartDatesSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is SameStartDatesSubQueryMatcher) { return false }
		let other = otherMatcher as! SameStartDatesSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ other: SameStartDatesSubQueryMatcher) -> Bool {
		return mostRecentOnly == other.mostRecentOnly
	}
}
