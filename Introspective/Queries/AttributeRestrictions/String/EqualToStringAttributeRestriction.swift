//
//  EqualToStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class EqualToStringAttributeRestriction: TypedEqualToAttributeRestrictionBase<String>, PredicateAttributeRestriction {

	private typealias Me = EqualToStringAttributeRestriction
	public static let valueAttribute = TextAttribute(name: "Value", pluralName: "Values")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: "")
	}

	public init(restrictedAttribute: Attribute, value: String = "") {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute) {
			if ($0 == nil && $1?.isEmpty ?? false) || ($1 == nil && $0?.isEmpty ?? false) {
				return true
			}
			return $0?.localizedLowercase == $1?.localizedLowercase
		}
	}

	public final func toPredicate() -> NSPredicate {
		return NSPredicate(format: "%K == %@", restrictedAttribute.variableName!, value as! String)
	}
}
