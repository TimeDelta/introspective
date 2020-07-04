//
//  AfterTimeOfDayAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public final class AfterTimeOfDayAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Static Variables

	private typealias Me = AfterTimeOfDayAttributeRestriction
	public static let timeAttribute = TimeOfDayAttribute(
		name: "Time",
		pluralName: "Times",
		description: "The time of day after which a date must occur to pass this constraint"
	)
	public static var attributes: [Attribute] = [
		timeAttribute,
	]

	// MARK: - Display Information

	override public final var attributedName: String { "After time of day" }
	override public final var description: String {
		do {
			let timeText = try Me.timeAttribute.convertToDisplayableString(from: timeOfDay)
			return "After " + timeText
		} catch {
			log.error("Failed to convert time of day to displayable string: %@", errorInfo(error))
			return "After " + timeOfDay.toString()
		}
	}

	// MARK: - Instance Variables

	public final var timeOfDay: TimeOfDay
	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, timeOfDay: TimeOfDay())
	}

	public init(restrictedAttribute: Attribute, timeOfDay: TimeOfDay = TimeOfDay()) {
		self.timeOfDay = timeOfDay
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return timeOfDay
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? TimeOfDay else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		timeOfDay = castedValue
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate > timeOfDay
	}

	override public func copy() -> AttributeRestriction {
		AfterTimeOfDayAttributeRestriction(restrictedAttribute: restrictedAttribute, timeOfDay: timeOfDay)
	}

	// MARK: - Boolean Expression Functions

	override public func predicate() -> NSPredicate? {
		nil
	}

	// MARK: - Equality

	public static func == (lhs: AfterTimeOfDayAttributeRestriction, rhs: AfterTimeOfDayAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherAttributed as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterTimeOfDayAttributeRestriction) { return false }
		let other = otherRestriction as! AfterTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: AfterTimeOfDayAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && timeOfDay == other.timeOfDay
	}
}
