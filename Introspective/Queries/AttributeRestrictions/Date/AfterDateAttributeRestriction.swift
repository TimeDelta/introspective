//
//  AfterDateAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AfterDateAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = AfterDateAttributeRestriction

	// MARK: - Static Variables

	public static let dateAttribute = DateOnlyAttribute()
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "After date" }
	public final override var description: String {
		do {
			let dateText = try Me.dateAttribute.convertToDisplayableString(from: date)
			return "After " + dateText
		} catch {
			log.error("Failed to convert date into displayable string: %@", errorInfo(error))
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .none
			return "After " + formatter.string(from: date)
		}
	}

	// MARK: - Instance Variables

	public final var date: Date {
		didSet {
			date = DependencyInjector.util.calendar.end(of: .day, in: date)
		}
	}
	private final let log = Log()

	// MARK: Initializers

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
		return sampleDate.isAfterDate(date, granularity: .second)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K > %@", restrictedAttribute.variableName!, date as NSDate)
	}

	// MARK: - Equality

	public static func ==(lhs: AfterDateAttributeRestriction, rhs: AfterDateAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is AfterDateAttributeRestriction) { return false }
		let other = otherAttributed as! AfterDateAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is AfterDateAttributeRestriction) { return false }
		let other = otherRestriction as! AfterDateAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: AfterDateAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
