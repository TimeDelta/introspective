//
//  DayOfWeekSampleGrouper.swift
//  Introspective
//
//  Created by Bryan Nova on 7/29/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class DayOfWeekSampleGrouper: SampleGrouper {
	// MARK: - Static Variables

	private typealias Me = DayOfWeekSampleGrouper

	private static let log = Log()

	// MARK: - Display Information

	public static var userVisibleDescription: String = "Group By Day Of Week"
	public let attributedName: String = "Group By Day Of Week"
	public var description: String {
		guard let groupByAttribute = groupByAttribute else {
			return attributedName
		}
		return "Group by day of week for \(groupByAttribute.name.localizedLowercase)"
	}

	// MARK: - Attributes

	public final let attributes: [Attribute]
	public final let attributeSelectAttribute: AttributeSelectAttribute

	// MARK: - Instance Variables

	public final var groupByAttribute: Attribute?

	// MARK: - Initializers

	public required convenience init(sampleType: Sample.Type) {
		self.init(attributes: sampleType.attributes)
	}

	public required init(attributes: [Attribute]) {
		let applicableAttributes = attributes.filter {
			$0 is DateAttribute || $0 is DayOfWeekAttribute || $0 is DaysOfWeekAttribute
		}
		groupByAttribute = applicableAttributes.first
		if groupByAttribute == nil {
			Me.log.error("No date or day of week attributes provided to DayOfWeekSampleGrouper")
		}
		attributeSelectAttribute = AttributeSelectAttribute(attributes: applicableAttributes)
		self.attributes = [attributeSelectAttribute]
	}

	private init(groupByAttribute: Attribute?, attributeSelectAttribute: AttributeSelectAttribute) {
		self.groupByAttribute = groupByAttribute
		self.attributeSelectAttribute = attributeSelectAttribute
		attributes = [attributeSelectAttribute]
	}

	// MARK: - Grouper Functions

	public final func group(samples: [Sample]) throws -> [(Any, [Sample])] {
		let groupByAttribute = try getGroupByAttribute(methodName: "group(samples:)")
		guard !samples.isEmpty else { return [] }
		var groups = [(Any, [Sample])]()
		for sample in samples {
			let daysOfWeek = try getDaysOfWeekForSample(sample, forAttribute: groupByAttribute)
			for dayOfWeek in daysOfWeek {
				if let index = groups.firstIndex(where: { $0.0 as? DayOfWeek == dayOfWeek }) {
					groups[index].1.append(sample)
				} else {
					groups.append((dayOfWeek, [sample]))
				}
			}
		}
		return groups
	}

	public final func groupNameFor(value: Any) throws -> String {
		let groupByAttribute = try getGroupByAttribute(methodName: "groupNameFor(value:)")
		let dayName: String
		if let dayOfWeek = value as? DayOfWeek {
			dayName = dayOfWeek.fullDayName
		} else if let str = value as? String {
			dayName = str
		} else {
			let valueDescription = String(describing: value)
			throw GenericError("Unknown value type for tag group with value: \(valueDescription)")
		}
		if groupByAttribute is DateAttribute {
			return "\(groupByAttribute.name) is on a \(dayName)"
		} else if groupByAttribute is DayOfWeekAttribute {
			return "\(groupByAttribute.name) is \(dayName)"
		} else if groupByAttribute is DaysOfWeekAttribute {
			return "\(groupByAttribute.name) contains \(dayName)"
		} else {
			throw GenericError(
				"Unknown type of attribute in DayOfWeekSampleGrouper for attribute named \(groupByAttribute.name)"
			)
		}
	}

	public final func groupValuesAreEqual(_ first: Any, _ second: Any) throws -> Bool {
		if let dayOfWeek1 = first as? DayOfWeek, let dayOfWeek2 = second as? DayOfWeek {
			return dayOfWeek1 == dayOfWeek2
		} else if let name1 = first as? String, let name2 = second as? String {
			return name1 == name2
		}
		let value1Description = String(describing: first)
		let value2Description = String(describing: second)
		throw GenericError("Unknown group value types: '\(value1Description)','\(value2Description)'")
	}

	public final func copy() -> SampleGrouper {
		DayOfWeekSampleGrouper(
			groupByAttribute: groupByAttribute,
			attributeSelectAttribute: attributeSelectAttribute
		)
	}

	// MARK: - Attributed Functions

	public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(attributeSelectAttribute) {
			return groupByAttribute
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(attributeSelectAttribute) {
			guard let castedValue = value as? Attribute else {
				throw TypeMismatchError(attribute: attributeSelectAttribute, of: self, wasA: type(of: value))
			}
			if let _ = attributeSelectAttribute.indexOf(possibleValue: castedValue) {
				groupByAttribute = castedValue
				return
			}
			throw GenericError("Provided attribute was not one of the allowed values")
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Helper Functions

	private final func getDaysOfWeekForSample(
		_ sample: Sample,
		forAttribute attribute: Attribute
	) throws -> [DayOfWeek] {
		if attribute is DateAttribute {
			let sampleValue = try sample.value(of: attribute)
			guard let date = sampleValue as? Date else {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: sampleValue))
			}
			return [DependencyInjector.get(CalendarUtil.self).dayOfWeek(forDate: date)]
		} else if attribute is DayOfWeekAttribute {
			let sampleValue = try sample.value(of: attribute)
			guard let dayOfWeek = sampleValue as? DayOfWeek else {
				throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: sampleValue))
			}
			return [dayOfWeek]
		} else if attribute is DaysOfWeekAttribute {
			let sampleValue = try sample.value(of: attribute)
			if let daysOfWeek = sampleValue as? [DayOfWeek] {
				return daysOfWeek
			} else if let daysOfWeek = sampleValue as? Set<DayOfWeek> {
				return daysOfWeek.map { $0 }
			}
			throw TypeMismatchError(attribute: attribute, of: sample, wasA: type(of: sampleValue))
		}
		let attributeType = String(describing: type(of: attribute))
		throw GenericError("Unknown type of tag attribute: \(attributeType)")
	}

	private final func getGroupByAttribute(methodName: String) throws -> Attribute {
		guard let groupByAttribute = groupByAttribute else {
			throw GenericError("Called \(methodName) before groupByAttribute was set")
		}
		return groupByAttribute
	}

	// MARK: - Equality

	public final func equalTo(_ otherGrouper: SampleGrouper) -> Bool {
		guard let sameValueGrouper = otherGrouper as? DayOfWeekSampleGrouper else { return false }
		if groupByAttribute == nil && sameValueGrouper.groupByAttribute == nil {
			return true
		}
		if
			let groupByAttribute = groupByAttribute,
			let otherGroupByAttribute = sameValueGrouper.groupByAttribute {
			return groupByAttribute.equalTo(otherGroupByAttribute)
		}
		return false
	}
}
