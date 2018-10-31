//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  Introspective
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class WithinXCalendarUnitsSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: WithinXCalendarUnitsSubQueryMatcher, rhs: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	private typealias Me = WithinXCalendarUnitsSubQueryMatcher

	public static let amountOfTime = IntegerAttribute(name: "Number of time units")
	public static let timeUnit = CalendarComponentAttribute(name: "Time unit")
	public static let attributes = [CommonSubQueryMatcherAttributes.mostRecentOnly, amountOfTime, timeUnit]

	public final let attributedName: String = "Within <number> <time_unit>s of"
	public final var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + timeUnit.description.lowercased() + "s of"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public final let attributes: [Attribute] = Me.attributes
	public final var numberOfTimeUnits: Int = 5
	public final var timeUnit: Calendar.Component = .minute
	public final var mostRecentOnly: Bool = false

	public required init() {}

	public init(numberOfTimeUnits: Int = 5, timeUnit: Calendar.Component = .minute, mostRecentOnly: Bool = false) {
		self.numberOfTimeUnits = numberOfTimeUnits
		self.timeUnit = timeUnit
		self.mostRecentOnly = mostRecentOnly
	}

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public final func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		if subQuerySamples.count == 0 {
			return []
		}

		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sample.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [applicableSubQuerySamples[0]]
		}

		for sample in querySamples {
			let closestSubQuerySample = DependencyInjector.util.search.closestItem(to: sample, in: applicableSubQuerySamples) { (sample1, sample2) in
				return DependencyInjector.util.sample.distance(between: sample1, and: sample2, in: self.timeUnit)
			}
			let distance = DependencyInjector.util.sample.distance(between: sample, and: closestSubQuerySample, in: timeUnit)
			if distance <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.amountOfTime) {
			return numberOfTimeUnits
		}
		if attribute.equalTo(Me.timeUnit) {
			return timeUnit
		}
		if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			return mostRecentOnly
		}
		throw AttributeError.unknownAttribute
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.amountOfTime) {
			guard let castedValue = value as? Int else { throw AttributeError.typeMismatch }
			numberOfTimeUnits = castedValue
		} else if attribute.equalTo(Me.timeUnit) {
			guard let castedValue = value as? Calendar.Component else { throw AttributeError.typeMismatch }
			timeUnit = castedValue
		} else if attribute.equalTo(CommonSubQueryMatcherAttributes.mostRecentOnly) {
			guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
			mostRecentOnly = castedValue
		} else {
			throw AttributeError.unknownAttribute
		}
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherAttributed as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherMatcher as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public final func equalTo(_ other: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		return numberOfTimeUnits == other.numberOfTimeUnits && timeUnit == other.timeUnit && mostRecentOnly == other.mostRecentOnly
	}
}
