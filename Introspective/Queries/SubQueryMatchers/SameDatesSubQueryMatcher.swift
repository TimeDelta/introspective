//
//  SameDatesSubQueryMatch.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SameDatesSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: SameDatesSubQueryMatcher, rhs: SameDatesSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final let name: String = "Start and end timestamps are the same as"
	public final var description: String {
		var text = "Start and end timestamps are the same as"
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
			applicableSubQuerySamples = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
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

	public final func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any) throws {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
			mostRecentOnly = castedValue
		} else {
			throw AttributeError.unknownAttribute
		}
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is SameDatesSubQueryMatcher) { return false }
		let other = otherAttributed as! SameDatesSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is SameDatesSubQueryMatcher) { return false }
		let other = otherMatcher as! SameDatesSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ other: SameDatesSubQueryMatcher) -> Bool {
		return mostRecentOnly == other.mostRecentOnly
	}

	private final func compare(_ s1: Sample, _ s2: Sample) -> ComparisonResult {
		let start1 = s1.dates()[.start]!
		let start2 = s2.dates()[.start]!

		let startDateComparison = start1.compare(start2)
		if startDateComparison != .orderedSame {
			return startDateComparison
		}

		return DependencyInjector.util.calendarUtil.compare(s1.dates()[.end], s2.dates()[.end])
	}
}
