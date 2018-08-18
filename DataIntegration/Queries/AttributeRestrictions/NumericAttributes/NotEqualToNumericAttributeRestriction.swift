//
//  NotEqualToNumericAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class NotEqualToNumericAttributeRestriction: NumericAttributeRestriction, PredicateAttributeRestriction {

	fileprivate typealias Me = NotEqualToNumericAttributeRestriction

	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")
	public static let attributes: [Attribute] = [
		valueAttribute,
	]

	public override var name: String { return "Not equal to" }
	public override var description: String {
		return restrictedAttribute.name + " does not equal " + String(value)
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
		return NSPredicate(format: "%@ != %@", restrictedAttribute.variableName, String(value))
	}
}
