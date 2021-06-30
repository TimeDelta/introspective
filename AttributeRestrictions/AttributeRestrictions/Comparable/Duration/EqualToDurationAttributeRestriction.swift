//
//  EqualToDurationAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public final class EqualToDurationAttributeRestriction: TypedEqualToAttributeRestrictionBase<TimeDuration> {
	private typealias Me = EqualToDurationAttributeRestriction
	public static let valueAttribute = DurationAttribute(id: 0, name: "Target TimeDuration", pluralName: "Target Durations")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: TimeDuration(0))
	}

	public init(restrictedAttribute: Attribute, value: TimeDuration = TimeDuration(0)) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		EqualToDurationAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! TimeDuration)
	}

	public override func predicate() -> NSPredicate? { nil }
}
