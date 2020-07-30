//
//  InThePastXTimeUnitsDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

import Attributes
import Common
import DependencyInjection
import Samples
import Settings

public final class InThePastXTimeUnitsDateAttributeRestriction: DateAttributeRestriction {
	// MARK: - Attributes

	private typealias Me = InThePastXTimeUnitsDateAttributeRestriction
	public static let numberOfTimeUnitsAttribute = IntegerAttribute(name: "Number of time units")
	public static let timeUnitAttribute = CalendarComponentAttribute(
		name: "Time unit",
		possibleValues: [
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
	)
	public static var attributes: [Attribute] = [
		numberOfTimeUnitsAttribute,
		timeUnitAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "In the past <number> <time unit>s" }
	public final override var description: String {
		var text = restrictedAttribute.name + " is in the past \(numberOfTimeUnits) \(timeUnit.description)"
		if numberOfTimeUnits != 1 {
			text += "s"
		}
		return text
	}

	// MARK: - Instance Variables

	public final var numberOfTimeUnits: Int
	public final var timeUnit: Calendar.Component

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, 1, .weekOfYear)
	}

	public init(restrictedAttribute: Attribute, _ numberOfTimeUnits: Int, _ timeUnit: Calendar.Component) {
		self.numberOfTimeUnits = numberOfTimeUnits
		self.timeUnit = timeUnit
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnitAttribute) {
			return timeUnit
		}
		if attribute.equalTo(Me.numberOfTimeUnitsAttribute) {
			return numberOfTimeUnits
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if attribute.equalTo(Me.timeUnitAttribute) {
			guard let castedValue = value as? Calendar.Component else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			timeUnit = castedValue
			return
		}
		if attribute.equalTo(Me.numberOfTimeUnitsAttribute) {
			guard let castedValue = value as? Int else {
				throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
			}
			numberOfTimeUnits = castedValue
			return
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		let now = Date()
		let minDate = now - getMinDateComponents()
		return now.isAfterDate(sampleDate, orEqual: true, granularity: .nanosecond) &&
			minDate.isBeforeDate(sampleDate, orEqual: true, granularity: .nanosecond)
	}

	public override func copy() -> AttributeRestriction {
		InThePastXTimeUnitsDateAttributeRestriction(
			restrictedAttribute: restrictedAttribute,
			numberOfTimeUnits,
			timeUnit
		)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard !DependencyInjector.get(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		let now = Date()
		let minDate = now - getMinDateComponents()
		return NSPredicate(
			format: "%K >= %@ && %K <= %@",
			variableName,
			minDate as NSDate,
			variableName,
			now as NSDate
		)
	}

	// MARK: - Equality

	public static func == (
		lhs: InThePastXTimeUnitsDateAttributeRestriction,
		rhs: InThePastXTimeUnitsDateAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is InThePastXTimeUnitsDateAttributeRestriction) { return false }
		let other = otherAttributed as! InThePastXTimeUnitsDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is InThePastXTimeUnitsDateAttributeRestriction) { return false }
		let other = otherRestriction as! InThePastXTimeUnitsDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: InThePastXTimeUnitsDateAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) &&
			numberOfTimeUnits == other.numberOfTimeUnits &&
			timeUnit == other.timeUnit
	}

	// MARK: - Helper Functions

	private final func getMinDateComponents() -> DateComponents {
		var dateComponents = DateComponents()
		dateComponents.setValue(numberOfTimeUnits, for: timeUnit)
		return dateComponents
	}
}
