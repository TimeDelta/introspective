//
//  EqualToDosageAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public final class EqualToDosageAttributeRestriction: TypedEqualToAttributeRestrictionBase<Dosage> {
	private typealias Me = EqualToDosageAttributeRestriction
	public static let valueAttribute = DosageAttribute(name: "Target Dosage", pluralName: "Target Dosages")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Dosage(0, ""))
	}

	public init(restrictedAttribute: Attribute, value: Dosage = Dosage(0, "")) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	override public func copy() -> AttributeRestriction {
		EqualToDosageAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! Dosage)
	}

	override public func predicate() -> NSPredicate? { nil }
}
