//
//  GreaterThanDurationAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public final class GreaterThanDurationAttributeRestriction: TypedGreaterThanAttributeRestrictionBase<Duration> {
	private typealias Me = GreaterThanDurationAttributeRestriction
	public static let valueAttribute = DurationAttribute(name: "Target Duration", pluralName: "Target Durations")

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Duration(0))
	}

	public init(restrictedAttribute: Attribute, value: Duration = Duration(0)) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		GreaterThanDurationAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public override func predicate() -> NSPredicate? { nil }
}
