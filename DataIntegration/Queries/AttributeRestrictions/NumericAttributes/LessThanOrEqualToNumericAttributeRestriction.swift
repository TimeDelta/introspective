//
//  LessThanOrEqualToNumericAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class LessThanOrEqualToNumericAttributeRestriction: NumericAttributeRestriction, PredicateAttributeRestriction, Equatable {

	fileprivate typealias Me = LessThanOrEqualToNumericAttributeRestriction

	public static func ==(lhs: LessThanOrEqualToNumericAttributeRestriction, rhs: LessThanOrEqualToNumericAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		valueAttribute,
	]

	public override var name: String { return "Less than or equal to" }
	public override var description: String {
		return restrictedAttribute.name + " ≤ " + String(value)
	}

	public var value: Double

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, value: 0.0)
	}

	public init(attribute: Attribute, value: Double = 0.0) {
		self.value = value
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.valueAttribute.name { return try numericValueOfRestrictedAttribute(value) }
		throw AttributeError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.valueAttribute.name { throw AttributeError.unknownAttribute }
		self.value = try getDoubleFrom(value: value)
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		return try getDoubleFrom(sample) <= value
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K <= %f", restrictedAttribute.variableName, value)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is LessThanOrEqualToNumericAttributeRestriction) { return false }
		let other = otherAttributed as! LessThanOrEqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is LessThanOrEqualToNumericAttributeRestriction) { return false }
		let other = otherRestriction as! LessThanOrEqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ other: LessThanOrEqualToNumericAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && value == other.value
	}
}
