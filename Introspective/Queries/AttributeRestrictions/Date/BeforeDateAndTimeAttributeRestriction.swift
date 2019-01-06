//
//  BeforeDateAndTimeAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BeforeDateAndTimeAttributeRestriction: DateAttributeRestriction, PredicateAttributeRestriction, Equatable {

	// MARK: - Static Variables

	private typealias Me = BeforeDateAndTimeAttributeRestriction
	public static let dateAttribute = DateTimeAttribute(name: "Date", format: "MMMM d yyyy 'at' H:mm")
	public static var attributes: [Attribute] = [
		dateAttribute,
	]

	// MARK: - Display Information

	public final override var attributedName: String { return "Before date and time" }
	public final override var description: String {
		do {
			let dateText = try Me.dateAttribute.convertToDisplayableString(from: date)
			return "Before " + dateText
		} catch {
			log.error("Failed to convert date into displayable string: %@", errorInfo(error))
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			formatter.timeStyle = .short
			return "Before " + formatter.string(from: date)
		}
	}

	// MARK: - Instance Variables

	public var date: Date
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
		return sampleDate.isBeforeDate(date, granularity: .nanosecond)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K < %@", restrictedAttribute.variableName!, date as NSDate)
	}

	// MARK: - Equality

	public static func ==(lhs: BeforeDateAndTimeAttributeRestriction, rhs: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherAttributed as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is BeforeDateAndTimeAttributeRestriction) { return false }
		let other = otherRestriction as! BeforeDateAndTimeAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: BeforeDateAndTimeAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && date == other.date
	}
}
