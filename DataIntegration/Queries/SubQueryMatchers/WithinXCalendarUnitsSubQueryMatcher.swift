//
//  WithinXCalendarUnitsSubQueryMatch.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/16/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class WithinXCalendarUnitsSubQueryMatcher: SubQueryMatcher, Equatable {

	public static func ==(lhs: WithinXCalendarUnitsSubQueryMatcher, rhs: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		return lhs.equalTo(rhs)
	}

	fileprivate typealias Me = WithinXCalendarUnitsSubQueryMatcher

	public static let amountOfTime = IntegerAttribute(name: "Number of time units")
	public static let timeUnit = CalendarComponentAttribute(name: "Time unit")
	public static let attributes = [CommonSubQueryMatcherAttributes.mostRecentOnly, amountOfTime, timeUnit]

	public let name: String = "Within <number> <time_unit>s of"
	public var description: String {
		var text = "Within " + String(numberOfTimeUnits) + " " + timeUnit.description.lowercased() + "s of"
		if mostRecentOnly {
			text += " most recent"
		}
		return text
	}

	public let attributes: [Attribute] = Me.attributes
	public var numberOfTimeUnits: Int = 5
	public var timeUnit: Calendar.Component = .minute
	public var mostRecentOnly: Bool = false

	public required init() {}

	public init(numberOfTimeUnits: Int = 5, timeUnit: Calendar.Component = .minute, mostRecentOnly: Bool = false) {
		self.numberOfTimeUnits = numberOfTimeUnits
		self.timeUnit = timeUnit
		self.mostRecentOnly = mostRecentOnly
	}

	/// Grab only the provided samples that start within `numberOfCalendarUnits` `calendarUnit` of a sub-query sample
	public func getSamples<QuerySampleType: Sample>(
		from querySamples: [QuerySampleType],
		matching subQuerySamples: [Sample])
	-> [QuerySampleType] {
		if subQuerySamples.count == 0 {
			return []
		}

		var matchingSamples = [QuerySampleType]()

		var applicableSubQuerySamples = subQuerySamples
		if mostRecentOnly {
			applicableSubQuerySamples = DependencyInjector.util.sampleUtil.sort(samples: subQuerySamples, by: .start, in: .orderedDescending)
			applicableSubQuerySamples = [applicableSubQuerySamples[0]]
		}

		for sample in querySamples {
			let closestSubQuerySample = DependencyInjector.util.searchUtil.closestItem(to: sample, in: applicableSubQuerySamples) { (sample1, sample2) in
				return DependencyInjector.util.sampleUtil.distance(between: sample1, and: sample2, in: self.timeUnit)
			}
			let distance = DependencyInjector.util.sampleUtil.distance(between: sample, and: closestSubQuerySample, in: timeUnit)
			if distance <= numberOfTimeUnits {
				matchingSamples.append(sample)
			}
		}
		return matchingSamples
	}

	public func value(of attribute: Attribute) throws -> Any {
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

	public func set(attribute: Attribute, to value: Any) throws {
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

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherAttributed as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public func equalTo(_ otherMatcher: SubQueryMatcher) -> Bool {
		if !(otherMatcher is WithinXCalendarUnitsSubQueryMatcher) { return false }
		let other = otherMatcher as! WithinXCalendarUnitsSubQueryMatcher
		return equalTo(other)
	}

	public func equalTo(_ other: WithinXCalendarUnitsSubQueryMatcher) -> Bool {
		return numberOfTimeUnits == other.numberOfTimeUnits && timeUnit == other.timeUnit && mostRecentOnly == other.mostRecentOnly
	}
}
