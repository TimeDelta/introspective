//
//  GreaterThanOrEqualToDoubleAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class GreaterThanOrEqualToDoubleAttributeRestriction: TypedGreaterThanOrEqualToAttributeRestrictionBase<Double>, DoubleAttributeRestriction, PredicateAttributeRestriction {

	private typealias Me = GreaterThanOrEqualToDoubleAttributeRestriction
	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0.0)
	}

	public init(restrictedAttribute: Attribute, value: Double = 0.0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		return GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K >= %f", restrictedAttribute.variableName!, value)
	}
}
