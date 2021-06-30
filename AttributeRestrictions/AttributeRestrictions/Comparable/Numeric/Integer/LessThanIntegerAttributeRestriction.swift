//
//  LessThanIntegerAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes

public final class LessThanIntegerAttributeRestriction: TypedLessThanAttributeRestrictionBase<Int>,
	IntegerAttributeRestriction {
	private typealias Me = LessThanIntegerAttributeRestriction
	public static let valueAttribute = IntegerAttribute(id: 0, name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0)
	}

	public init(restrictedAttribute: Attribute, value: Int = 0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		LessThanIntegerAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K < %d", variableName, value)
	}
}
