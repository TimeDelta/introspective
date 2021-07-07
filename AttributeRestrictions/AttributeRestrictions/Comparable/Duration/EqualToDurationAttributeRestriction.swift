//
//  EqualToDurationAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class EqualToDurationAttributeRestriction:
	TypedEqualToAttributeRestrictionBase<TimeDuration>,
	DurationAttributeRestriction {
	private typealias Me = EqualToDurationAttributeRestriction
	public static let valueAttribute = DurationAttribute(
		id: 0,
		name: "Target TimeDuration",
		pluralName: "Target Durations"
	)

	public var typedValue: TimeDuration {
		value as! TimeDuration
	}

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

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredDurationComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}
}
