//
//  LessThanOrEqualToDoubleAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class LessThanOrEqualToDoubleAttributeRestriction: TypedLessThanOrEqualToAttributeRestrictionBase<Double>, DoubleAttributeRestriction, PredicateAttributeRestriction {

	private typealias Me = LessThanOrEqualToDoubleAttributeRestriction
	public static let valueAttribute = DoubleAttribute(name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0.0)
	}

	public init(restrictedAttribute: Attribute, value: Double = 0.0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K <= %f", restrictedAttribute.variableName!, value)
	}
}
