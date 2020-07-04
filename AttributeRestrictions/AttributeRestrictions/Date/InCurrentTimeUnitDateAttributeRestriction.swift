//
//  InCurrentTimeUnitDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples
import Settings

public final class InCurrentTimeUnitDateAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Attributes

	private typealias Me = InCurrentTimeUnitDateAttributeRestriction
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
	public static let attributes = [
		timeUnitAttribute,
	]

	// MARK: - Display Information

	override public final var attributedName: String { "In current <time unit>" }
	override public final var description: String {
		restrictedAttribute.name + " is in the current " + timeUnit.description
	}

	// MARK: - Instance Variables

	public final var timeUnit: Calendar.Component

	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, .day)
	}

	public init(restrictedAttribute: Attribute, _ timeUnit: Calendar.Component) {
		self.timeUnit = timeUnit
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(Me.timeUnitAttribute) {
			return timeUnit
		}
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		guard attribute.equalTo(Me.timeUnitAttribute) else {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Calendar.Component else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		timeUnit = castedValue
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		let now = Date()
		let minDate = DependencyInjector.get(CalendarUtil.self).start(of: timeUnit, in: now)
		let maxDate = DependencyInjector.get(CalendarUtil.self).end(of: timeUnit, in: now)
		return minDate <= sampleDate && sampleDate <= maxDate
	}

	override public func copy() -> AttributeRestriction {
		InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: restrictedAttribute, timeUnit)
	}

	// MARK: - Boolean Expression Functions

	override public func predicate() -> NSPredicate? {
		guard !DependencyInjector.get(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		let now = Date()
		let minDate = DependencyInjector.get(CalendarUtil.self).start(of: timeUnit, in: now)
		let maxDate = DependencyInjector.get(CalendarUtil.self).end(of: timeUnit, in: now)
		return NSPredicate(
			format: "%K >= %@ && %K <= %@",
			variableName,
			minDate as NSDate,
			variableName,
			maxDate as NSDate
		)
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

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is InCurrentTimeUnitDateAttributeRestriction) { return false }
		let other = otherRestriction as! InCurrentTimeUnitDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: InCurrentTimeUnitDateAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && timeUnit == other.timeUnit
	}
}
