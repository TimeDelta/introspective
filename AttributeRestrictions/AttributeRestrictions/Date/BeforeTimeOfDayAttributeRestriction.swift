//
//  BeforeTimeOfDayAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 8/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class BeforeTimeOfDayAttributeRestriction:
	DateAttributeRestriction,
	TimeOfDayAttributeRestriction,
	Equatable
{
	// MARK: - Static Variables

	private typealias Me = BeforeTimeOfDayAttributeRestriction

	private static let log = Log()

	// MARK: - Attributes

	public static let timeAttribute = TimeOfDayAttribute(
		id: 0,
		name: "Time",
		pluralName: "Times",
		description: "The time of day before which a date must occur to pass this restriction"
	)
	public static var attributes: [Attribute] = [
		timeAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "Before time of day" }
	public final override var description: String {
		do {
			let timeText = try Me.timeAttribute.convertToDisplayableString(from: timeOfDay)
			return "Before " + timeText
		} catch {
			Me.log.error("Failed to convert time of day to displayable string: %@", errorInfo(error))
			return "Before " + timeOfDay.toString()
		}
	}

	// MARK: - Instance Variables

	public final var timeOfDay: TimeOfDay

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, timeOfDay: TimeOfDay())
	}

	public init(restrictedAttribute: Attribute, timeOfDay: TimeOfDay = TimeOfDay()) {
		self.timeOfDay = timeOfDay
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return timeOfDay
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.timeAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? TimeOfDay else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		timeOfDay = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate < timeOfDay
	}

	public override func copy() -> AttributeRestriction {
		BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restrictedAttribute, timeOfDay: timeOfDay)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? { nil }

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredTimeOfDayComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}

	// MARK: - Equality

	public static func == (lhs: BeforeTimeOfDayAttributeRestriction, rhs: BeforeTimeOfDayAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeTimeOfDayAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeTimeOfDayAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeTimeOfDayAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeTimeOfDayAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && timeOfDay == other.timeOfDay
	}
}
