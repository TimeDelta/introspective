//
//  EqualToNumericAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class EqualToNumericAttributeRestriction: NumericAttributeRestriction, PredicateAttributeRestriction, Equatable {

	private typealias Me = EqualToNumericAttributeRestriction

	public static func ==(lhs: EqualToNumericAttributeRestriction, rhs: EqualToNumericAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		valueAttribute,
	]

	public final override var name: String { return "Equal to" }
	public final override var description: String {
		return restrictedAttribute.name + " = " + String(value)
	}

	public final var value: Double

	public required convenience init(attribute: Attribute) {
		self.init(attribute: attribute, value: 0.0)
	}

	public init(attribute: Attribute, value: Double = 0.0) {
		self.value = value
		super.init(attribute: attribute, attributes: Me.attributes)
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.name == Me.valueAttribute.name { return try numericValueOfRestrictedAttribute(value) }
		throw AttributeError.unknownAttribute
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if attribute.name != Me.valueAttribute.name { throw AttributeError.unknownAttribute }
		self.value = try getDoubleFrom(value: value)
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		return try getDoubleFrom(sample) == value
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K == %f", restrictedAttribute.variableName, value)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToNumericAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EqualToNumericAttributeRestriction) { return false }
		let other = otherRestriction as! EqualToNumericAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EqualToNumericAttributeRestriction) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && value == other.value
	}
}
