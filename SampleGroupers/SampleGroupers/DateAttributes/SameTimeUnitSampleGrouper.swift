//
//  SameTimeUnitSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

import SwiftDate

import Attributes
import Common
import DependencyInjection
import Samples

public final class SameTimeUnitSampleGrouper: SampleGrouper {
	private typealias Me = SameTimeUnitSampleGrouper

	// MARK: - Attributes

	private static let supportedTimeUnits: [Calendar.Component] = [
		.year,
		.quarter,
		.month,
		.weekOfMonth,
		.weekOfYear,
		.day,
		.hour,
		.minute,
		.second,
		.nanosecond,
	]

	public static let timeUnitAttribute = CalendarComponentAttribute(
		description: "Combine all samples within the same time unit",
		possibleValues: supportedTimeUnits
	)
	public final let attributes: [Attribute]
	public final let attributeSelectAttribute: AttributeSelectAttribute

	// MARK: - Display Information

	public static let userVisibleDescription: String = "Same time unit (not across days, etc.)"
	public final let attributedName = "Same time unit (not across days, etc.)"
	public final var description: String {
		"per " + timeUnit.description.localizedLowercase
	}

	// MARK: - Instance Variables

	public final var groupByAttribute: DateAttribute?
	public final var timeUnit: Calendar.Component = .day

	private final let signpost =
		Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SameTimeUnitSampleGrouper"))

	// MARK: - Initializers

	public required convenience init(sampleType: Sample.Type) {
		self.init(attributes: sampleType.attributes)
	}

	public required convenience init(attributes: [Attribute]) {
		self.init(attributes: attributes, .hour)
	}

	public init(attributes: [Attribute], _ timeUnit: Calendar.Component, _ attribute: DateAttribute? = nil) {
		let dateAttributesForSampleType = attributes.filter { $0 is DateAttribute }.map { $0 as! DateAttribute }
		groupByAttribute = attribute ?? dateAttributesForSampleType.first
		attributeSelectAttribute = AttributeSelectAttribute(attributes: dateAttributesForSampleType)
		self.attributes = [
			attributeSelectAttribute,
			Me.timeUnitAttribute,
		]
		self.timeUnit = timeUnit
	}

	private init(
		groupByAttribute: DateAttribute?,
		attributeSelectAttribute: AttributeSelectAttribute,
		_ timeUnit: Calendar.Component
	) {
		self.groupByAttribute = groupByAttribute
		self.attributeSelectAttribute = attributeSelectAttribute
		attributes = [
			attributeSelectAttribute,
			Me.timeUnitAttribute,
		]
		self.timeUnit = timeUnit
	}

	// MARK: - Grouper Functions

	public final func group(samples: [Sample]) throws -> [(Any, [Sample])] {
		guard let attribute = groupByAttribute else {
			throw GenericError("Called group on SameTimeUnitSampleGrouper before grouper ready")
		}
		signpost.begin(name: "Aggregation", "Aggregating %d samples", samples.count)
		let samplesByTimeUnit = try injected(SampleUtil.self)
			.aggregate(samples: samples, by: timeUnit, for: attribute)
		signpost.end(
			name: "Aggregation",
			"Aggregated %d samples into %d groups",
			samples.count,
			samplesByTimeUnit.count
		)

		signpost.begin(name: "Sort aggregated samples")
		let sortedSamplesByTimeUnit = samplesByTimeUnit
			.sorted(by: { entry1, entry2 in entry1.key.isBeforeDate(entry2.key, granularity: timeUnit) })
		signpost.end(name: "Sort aggregated samples")

		let finalGroupings = addMissingTimeUnits(sortedSamplesByTimeUnit)
		return finalGroupings.map { key, value in (key, value) }
	}

	public final func groupNameFor(value: Any) throws -> String {
		if let dateString = value as? String {
			return dateString
		}
		guard let date = value as? Date else {
			throw GenericError("Expected date or string for group value but got \(String(describing: value))")
		}
		return injected(CalendarUtil.self).string(for: date, dateStyle: .medium, timeStyle: .medium)
	}

	public final func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
		if
			let dateString1 = first as? String,
			let dateString2 = second as? String
		// swiftformat:disable all
		{
			return dateString1 == dateString2
		}
		// swiftformat:enable all

		if
			let date1 = first as? Date,
			let date2 = second as? Date
		// swiftformat:disable all
		{
			return date1 == date2
		}
		// swiftformat:enable all

		let firstStr = String(describing: first)
		let secondStr = String(describing: first)
		throw GenericError("Expected either date or string for group values but got '\(firstStr)' and '\(secondStr)'")
	}

	public final func copy() -> SampleGrouper {
		SameTimeUnitSampleGrouper(
			groupByAttribute: groupByAttribute,
			attributeSelectAttribute: attributeSelectAttribute,
			timeUnit
		)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnitAttribute) {
			return timeUnit
		}
		if attribute.equalTo(attributeSelectAttribute) {
			return groupByAttribute
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.timeUnitAttribute) {
			guard let castedValue = value as? Calendar.Component else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timeUnit = castedValue
			return
		}
		if attribute.equalTo(attributeSelectAttribute) {
			guard let castedValue = value as? DateAttribute else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			groupByAttribute = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let sameTimeUnitGrouper = otherGrouper as? SameTimeUnitSampleGrouper else { return false }
		var groupByAttributesEqual: Bool
		if groupByAttribute == nil && sameTimeUnitGrouper.groupByAttribute == nil {
			groupByAttributesEqual = true
		} else if
			let groupByAttribute = groupByAttribute,
			let otherGroupByAttribute = sameTimeUnitGrouper.groupByAttribute {
			groupByAttributesEqual = groupByAttribute.equalTo(otherGroupByAttribute)
		} else {
			groupByAttributesEqual = false
		}
		return sameTimeUnitGrouper.timeUnit == timeUnit && groupByAttributesEqual
	}

	// MARK: - Helper Functions

	private final func addMissingTimeUnits(
		_ sortedSamplesByTimeUnit: [(key: Date, value: [Sample])]
	) -> [(key: Date, value: [Sample])] {
		var results = sortedSamplesByTimeUnit
		let minDate = sortedSamplesByTimeUnit[0].key
		let maxDate = sortedSamplesByTimeUnit[sortedSamplesByTimeUnit.count - 1].key

		var currentDate = minDate
		var index = 0
		let lessThanDayComponents: Set<Calendar.Component> = Set([.hour, .minute, .second, .nanosecond])
		while currentDate.isBeforeDate(maxDate, granularity: timeUnit) {
			if results[index].key.compare(toDate: currentDate, granularity: timeUnit) != .orderedSame {
				let dstOffset = TimeZone.autoupdatingCurrent.daylightSavingTimeOffset(for: currentDate)
				var dateToAdd = currentDate
				if !lessThanDayComponents.contains(timeUnit) && dstOffset == 0 {
					dateToAdd = currentDate.addingTimeInterval(TimeZone.autoupdatingCurrent.daylightSavingTimeOffset())
				}
				results.insert((key: dateToAdd, value: []), at: index)
			}
			currentDate = currentDate.dateByAdding(1, timeUnit).date
			index += 1
		}

		return results
	}
}
