//
//  BeforeDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import DependencyInjection
import Samples
import Settings

public final class BeforeDateAttributeRestriction: DateAttributeRestriction, Equatable {
	// MARK: - Static Variables

	private typealias Me = BeforeDateAttributeRestriction
	public static let dateAttribute = DateOnlyAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	// MARK: - Display Information

	override public final var attributedName: String { "Before date" }
	override public final var description: String {
		do {
			let dateText = try Me.dateAttribute.convertToDisplayableString(from: date)
			return "Before " + dateText
		} catch {
			log.error("Failed to convert date into displayable string: %@", errorInfo(error))
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .none
			return "Before " + formatter.string(from: date)
		}
	}

	// MARK: - Instance Variables

	public final var date: Date {
		didSet {
			date = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: date)
		}
	}

	private final let log = Log()

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, date: Date())
	}

	public init(restrictedAttribute: Attribute, date: Date = Date()) {
		self.date = date
		super.init(restrictedAttribute: restrictedAttribute, attributes: Me.attributes)
	}

	// MARK: - Attribute Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if !attribute.equalTo(Me.dateAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		return date
	}

	override public final func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(Me.dateAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? Date else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		date = castedValue
	}

	// MARK: - Attribute Restriction Functions

	override public final func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let sampleDate = sampleValue as? Date else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return sampleDate.isBeforeDate(date, granularity: .second)
	}

	override public func copy() -> AttributeRestriction {
		BeforeDateAttributeRestriction(restrictedAttribute: restrictedAttribute, date: date)
	}

	// MARK: - Boolean Expression Functions

	override public func predicate() -> NSPredicate? {
		guard !DependencyInjector.get(Settings.self).convertTimeZones else { return nil }
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K < %@", variableName, date as NSDate)
	}

	// MARK: - Equality

	public static func == (lhs: BeforeDateAttributeRestriction, rhs: BeforeDateAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeDateAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeDateAttributeRestriction
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeDateAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeDateAttributeRestriction) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
