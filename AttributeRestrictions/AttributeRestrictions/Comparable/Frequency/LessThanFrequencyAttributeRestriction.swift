//
//  LessThanFrequencyAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public final class LessThanFrequencyAttributeRestriction: TypedLessThanAttributeRestrictionBase<Frequency> {
	private typealias Me = LessThanFrequencyAttributeRestriction
	public static let valueAttribute = FrequencyAttribute(name: "Target Frequency", pluralName: "Target Frequencies")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Frequency(0, .day)!)
	}

	public init(restrictedAttribute: Attribute, value: Frequency = Frequency(0, .day)!) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	override public func copy() -> AttributeRestriction {
		LessThanFrequencyAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	override public func predicate() -> NSPredicate? { nil }
}
