//
//  EqualToNumericAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class EqualToNumericAttributeRestriction: NumericAttributeRestriction, PredicateAttributeRestriction, Equatable {

	fileprivate typealias Me = EqualToNumericAttributeRestriction

	public static func ==(lhs: EqualToNumericAttributeRestriction, rhs: EqualToNumericAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		valueAttribute,
	]

	public override var name: String { return "Equal to" }
	public override var description: String {
		return restrictedAttribute.name + " = " + String(value)
	}

	public var value: Double

	public required init(attribute: Attribute) {
		value = Double()
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
		return try getDoubleFrom(sample) < value
	}

	public func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K == %@", restrictedAttribute.variableName, String(value))
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToNumericAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EqualToNumericAttributeRestriction) { return false }
		let other = otherRestriction as! EqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public func equalTo(_ other: EqualToNumericAttributeRestriction) -> Bool {
		return value == other.value
	}
}
