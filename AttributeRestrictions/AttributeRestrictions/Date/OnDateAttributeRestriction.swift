//
//  OnDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import SwiftDate

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples
import Settings

public final class OnDateAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Static Variables

	private typealias Me = OnDateAttributeRestriction

	private static let log = Log()

	// MARK: - Attributes

	public static let dateAttribute = DateOnlyAttribute(id: 0)
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { "On a specific date" }
	public final override var description: String {
		do {
			let dateText = try Me.dateAttribute.convertToDisplayableString(from: date)
			return "On " + dateText
		} catch {
			Me.log.error("Failed to convert date into displayable string: %@", errorInfo(error))
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .none
			return "On " + formatter.string(from: date)
		}
	}

	// MARK: - Instance Variables

	public final var date: Date

	public override var typedValue: Date? { date }

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
		return injected(CalendarUtil.self).date(sampleDate, occursOnSame: .day, as: date)
	}

	public override func copy() -> AttributeRestriction {
		OnDateAttributeRestriction(restrictedAttribute: restrictedAttribute, date: date)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard !injected(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		let minDate = injected(CalendarUtil.self).start(of: .day, in: date)
		let maxDate = injected(CalendarUtil.self).end(of: .day, in: date)
		return NSPredicate(
			format: "%K >= %@ && %K <= %@",
			variableName,
			minDate as NSDate,
			variableName,
			maxDate as NSDate
		)
	}

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredDateOperationAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		return stored
	}

	// MARK: - Equality

	public static func == (lhs: OnDateAttributeRestriction, rhs: OnDateAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is OnDateAttributeRestriction) { return false }
		let other = otherAttributed as! OnDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is OnDateAttributeRestriction) { return false }
		let other = otherRestriction as! OnDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: OnDateAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
