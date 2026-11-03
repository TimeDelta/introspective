//
//  SameStartDateSubQueryMatcher.swift
//  Introspective
//
//  Created by Bryan Nova on 7/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class SameStartDatesSubQueryMatcher: SubQueryMatcher, Equatable {
	// MARK: - Attributes

	public final let attributes: [Attribute] = [CommonSubQueryMatcherAttributes.mostRecentOnly]

	// MARK: - Display Information

	public final let attributedName: String = "Starts on the same date at the same time as"
	public final var description: String {
		var text = "Starts on the same date at the same time as"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	// MARK: - Instance Variables

	public final var mostRecentOnly: Bool = false

	// MARK: Initializers

	public required init() {}

	public init(mostRecentOnly: Bool = false) {
		self.mostRecentOnly = mostRecentOnly
	}

	// MARK: - SubQueryMatcher Functions

	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample]
	) -> [QuerySampleType] {
		guard !querySamples.isEmpty, !subQuerySamples.isEmpty else { return [] }
		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			let calendar = injected(CalendarUtil.self)
			var newest = subQuerySamples[0]
			var newestDate = newest.dates()[.start]
			for candidate in subQuerySamples.dropFirst() {
				let date = candidate.dates()[.start]
				if calendar.compare(date, newestDate) == .orderedDescending {
					newest = candidate; newestDate = date
				}
			}
			applicableSubQuerySamples = [newest]
		}

		let subQuerySamplesSortedByStartDate = injected(SampleUtil.self)
			.sort(samples: applicableSubQuerySamples, by: .start, in: .orderedAscending)
		for sample in querySamples {
			let matchingSampleIndex = injected(SearchUtil.self).binarySearch(
				for: sample,
				in: subQuerySamplesSortedByStartDate,
				compare: { (s1: Sample, s2: Sample) -> ComparisonResult in
					injected(CalendarUtil.self).compare(s1.dates()[.start], s2.dates()[.start])
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

	public static func == (lhs: SameStartDatesSubQueryMatcher, rhs: SameStartDatesSubQueryMatcher) -> Bool {
		lhs.equalTo(rhs)
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
		mostRecentOnly == other.mostRecentOnly
	}
}
