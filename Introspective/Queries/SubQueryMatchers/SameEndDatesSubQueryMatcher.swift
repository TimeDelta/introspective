//
//  SameEndDatesSubQueryMatcher.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class SameEndDatesSubQueryMatcher: SubQueryMatcher, Equatable {

	// MARK: - Attributes

	public final let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly]

	// MARK: - Display Information

	public final let attributedName: String = "Ends on the same date at the same time as"
	public final var description: String {
		var text = "Ends on the same date at the same time as"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	// MARK: - Instance Variables

	public final var mostRecentOnly: Bool = false

	// MARK: - Initializers

	public required init() {}

	public init(mostRecentOnly: Bool = false) {
		self.mostRecentOnly = mostRecentOnly
	}

	// MARK: - SubQueryMatcher Functions

	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sample.sort(samples: subQuerySamples, by: .end, in: .orderedDescending)
			applicableSubQuerySamples = [subQuerySamples[0]]
		}

		let subQuerySamplesSortedByEndDate = DependencyInjector.util.sample.sort(samples: applicableSubQuerySamples, by: .end, in: .orderedAscending)
		for sample in querySamples {
			let matchingSampleIndex = DependencyInjector.util.search.binarySearch(
				for: sample,
				in: subQuerySamplesSortedByEndDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					return DependencyInjector.util.calendar.compare(s1.dates()[.end], s2.dates()[.end])
				}
			)
			if matchingSampleIndex != nil {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	// MARK: - Attribute Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			mostRecentOnly = castedValue
		} else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
	}

	// MARK: - Equality

	public static func ==(lhs: SameEndDatesSubQueryMatcher, rhs: SameEndDatesSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs as SubQueryMatcher)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is SameEndDatesSubQueryMatcher) { return false }
		let other = otherAttributed as! SameEndDatesSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is SameEndDatesSubQueryMatcher) { return false }
		let other = otherMatcher as! SameEndDatesSubQueryMatcher
		return equalTo(other)
	}

	public func equalTo(_ other: SameEndDatesSubQueryMatcher) -> Bool {
		return mostRecentOnly == other.mostRecentOnly
	}
}
