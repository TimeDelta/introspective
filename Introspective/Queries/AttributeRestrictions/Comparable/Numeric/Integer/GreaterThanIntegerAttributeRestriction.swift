//
//  GreaterThanIntegerAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class GreaterThanIntegerAttributeRestriction: TypedGreaterThanAttributeRestrictionBase<Int>, IntegerAttributeRestriction, PredicateAttributeRestriction {

	private typealias Me = GreaterThanIntegerAttributeRestriction
	public static let valueAttribute = IntegerAttribute(name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0)
	}

	public init(restrictedAttribute: Attribute, value: Int = 0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K > %d", restrictedAttribute.variableName!, value)
	}
}
