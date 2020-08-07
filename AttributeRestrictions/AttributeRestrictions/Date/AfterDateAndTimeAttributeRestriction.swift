//
//  AfterDateAndTimeAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples
import Settings

public final class AfterDateAndTimeAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Static Variables

	private typealias Me = AfterDateAndTimeAttributeRestriction

	private static let log = Log()

	// MARK: - Attributes

	public static let dateAttribute = DateTimeAttribute(name: "Date", format: "MMMM d yyyy 'at' H:mm")
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "After date and time" }
	public final override var description: String {
		do {
			let dateText = try Me.dateAttribute.convertToDisplayableString(from: date)
			return "After " + dateText
		} catch {
			Me.log.error("Failed to convert date into displayable string: %@", errorInfo(error))
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .short
			return "After " + formatter.string(from: date)
		}
	}

	// MARK: - Instance Variables

	public final var date: Date

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, date: Date())
	}

	public init(restrictedAttribute: Attribute, date: Date = Date()) {
		self.date = date
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.dateAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return date
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.dateAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Date else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		date = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate.isAfterDate(date, granularity: .nanosecond)
	}

	public override func copy() -> AttributeRestriction {
		AfterDateAndTimeAttributeRestriction(restrictedAttribute: restrictedAttribute, date: date)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard !injected(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K > %@", variableName, date as NSDate)
	}

	// MARK: - Equality

	public static func == (
		lhs: AfterDateAndTimeAttributeRestriction,
		rhs: AfterDateAndTimeAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterDateAndTimeAttributeRestriction) { return false }
		let other = otherAttributed as! AfterDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterDateAndTimeAttributeRestriction) { return false }
		let other = otherRestriction as! AfterDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: AfterDateAndTimeAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
