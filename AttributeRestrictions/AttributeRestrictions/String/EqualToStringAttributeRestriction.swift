//
//  EqualToStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes

public final class EqualToStringAttributeRestriction: TypedEqualToAttributeRestrictionBase<String> {

	private typealias Me = EqualToStringAttributeRestriction

	// MARK: - Attributes

	public static let valueAttribute = TextAttribute(name: "Value", pluralName: "Values")

	// MARK: - Initializers

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

	// MARK: - Attribute Restriction Functions

	public override func copy() -> AttributeRestriction {
		return EqualToStringAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! String)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K ==[cd] %@", variableName, value as! String)
	}
}
