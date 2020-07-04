//
//  NotEqualToIntegerAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes

public final class NotEqualToIntegerAttributeRestriction: TypedNotEqualToAttributeRestrictionBase<Int>,
	IntegerAttributeRestriction {
	private typealias Me = NotEqualToIntegerAttributeRestriction
	public static let valueAttribute = IntegerAttribute(name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0)
	}

	public init(restrictedAttribute: Attribute, value: Int = 0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	override public func copy() -> AttributeRestriction {
		NotEqualToIntegerAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! Int)
	}

	override public func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K != %d", variableName, value as! Int)
	}
}
