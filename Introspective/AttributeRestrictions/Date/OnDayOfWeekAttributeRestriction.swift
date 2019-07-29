//
//  OnDayOfWeekAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class OnDayOfWeekAttributeRestriction: DateAttributeRestriction, Equatable {

	// MARK: - Static Variables

	private typealias Me = OnDayOfWeekAttributeRestriction
	public static let daysOfWeekAttribute = DaysOfWeekAttribute()
	public static var attributes: [Attribute] = [
		daysOfWeekAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "On day(s) of the week" }
	public final override var description: String {
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
				} else if index < daysOfWeek.count - 1  {
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

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.daysOfWeekAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return daysOfWeek
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.daysOfWeekAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Set<DayOfWeek> else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		daysOfWeek = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return DependencyInjector.util.calendar.date(sampleDate, isOnOneOf: daysOfWeek)
	}

	public override func copy() -> AttributeRestriction {
		return OnDayOfWeekAttributeRestriction(restrictedAttribute: restrictedAttribute, daysOfWeek: daysOfWeek)
	}

	// MARK: - Equality

	public static func ==(lhs: OnDayOfWeekAttributeRestriction, rhs: OnDayOfWeekAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherAttributed as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is OnDayOfWeekAttributeRestriction) { return false }
		let other = otherRestriction as! OnDayOfWeekAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: OnDayOfWeekAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && daysOfWeek == other.daysOfWeek
	}
}