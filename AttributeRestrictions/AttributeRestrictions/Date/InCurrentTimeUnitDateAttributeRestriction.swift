//
//  InCurrentTimeUnitDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class InCurrentTimeUnitDateAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Attributes

	private typealias Me = InCurrentTimeUnitDateAttributeRestriction
	public static let timeUnitAttribute = CalendarComponentAttribute(
		id: 0,
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
	public static let attributes = [
		timeUnitAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "In current <time unit>" }
	public final override var description: String {
		restrictedAttribute.name + " is in the current " + timeUnit.description
	}

	// MARK: - Instance Variables

	public final var timeUnit: Calendar.Component

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, .day)
	}

	public init(restrictedAttribute: Attribute, _ timeUnit: Calendar.Component) {
		self.timeUnit = timeUnit
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnitAttribute) {
			return timeUnit
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		guard attribute.equalTo(Me.timeUnitAttribute) else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Calendar.Component else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		timeUnit = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		let now = Date()
		let minDate = injected(CalendarUtil.self).start(of: timeUnit, in: now)
		let maxDate = injected(CalendarUtil.self).end(of: timeUnit, in: now)
		return minDate <= sampleDate && sampleDate <= maxDate
	}

	public override func copy() -> AttributeRestriction {
		InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restrictedAttribute, timeUnit)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard !injected(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		let now = Date()
		let minDate = injected(CalendarUtil.self).start(of: timeUnit, in: now)
		let maxDate = injected(CalendarUtil.self).end(of: timeUnit, in: now)
		return NSPredicate(
			format: "%K >= %@ && %K <= %@",
			variableName,
			minDate as NSDate,
			variableName,
			maxDate as NSDate
		)
	}

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredInCurrentTimeUnitAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}

	// MARK: - Equality

	public static func == (
		lhs: InCurrentTimeUnitDateAttributeRestriction,
		rhs: InCurrentTimeUnitDateAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is InCurrentTimeUnitDateAttributeRestriction) { return false }
		let other = otherAttributed as! InCurrentTimeUnitDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is InCurrentTimeUnitDateAttributeRestriction) { return false }
		let other = otherRestriction as! InCurrentTimeUnitDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: InCurrentTimeUnitDateAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && timeUnit == other.timeUnit
	}
}
