//
//  OnDayOfWeekAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples

public final class OnDayOfWeekAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Static Variables

	private typealias Me = OnDayOfWeekAttributeRestriction
	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	// MARK: - Display Information

	override public final var attributedName: String { "On day(s) of the week" }
	override public final var description: String {
		do {
			let daysOfWeekText = try Me.daysOfWeekAttribute.convertToDisplayableString(from: daysOfWeek)
			return "On a " + daysOfWeekText
		} catch {
			log.error("Failed to convert days of week to displayable string: %@", errorInfo(error))
			var daysOfWeekText = ""
			var index = 0
			for day in daysOfWeek {
				daysOfWeekText += day.abbreviation
				if index == daysOfWeek.count - 2 && daysOfWeek.count > 1 {
					daysOfWeekText += " or "
				} else if index < daysOfWeek.count - 1 {
					daysOfWeekText += ", "
				}
				index += 1
			}
			return "On a " + daysOfWeekText
		}
	}

	// MARK: - Instance Variables

	public final var daysOfWeek: Set<DayOfWeek>
	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, daysOfWeek: Set<DayOfWeek>())
	}

	public required init(restrictedAttribute: Attribute, daysOfWeek: Set<DayOfWeek> = Set<DayOfWeek>()) {
		self.daysOfWeek = daysOfWeek
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.daysOfWeekAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return daysOfWeek
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.daysOfWeekAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		if let castedValue = value as? [DayOfWeek] {
			daysOfWeek = Set(castedValue)
		} else if let castedValue = value as? Set<DayOfWeek> {
			daysOfWeek = castedValue
		} else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return DependencyInjector.get(CalendarUtil.self).date(sampleDate, isOnOneOf: daysOfWeek)
	}

	override public func copy() -> AttributeRestriction {
		OnDayOfWeekAttributeRestriction(restrictedAttribute: restrictedAttribute, daysOfWeek: daysOfWeek)
	}

	// MARK: - Boolean Expression Functions

	override public func predicate() -> NSPredicate? {
		nil
	}

	// MARK: - Equality

	public static func == (lhs: OnDayOfWeekAttributeRestriction, rhs: OnDayOfWeekAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherAttributed as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherRestriction as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: OnDayOfWeekAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && daysOfWeek == other.daysOfWeek
	}
}
