//
//  LessThanOrEqualToIntegerAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import DependencyInjection
import Persistence
import Samples

public final class LessThanOrEqualToIntegerAttributeRestriction:
	TypedLessThanOrEqualToAttributeRestrictionBase<Int>,
	IntegerAttributeRestriction
{
	private typealias Me = LessThanOrEqualToIntegerAttributeRestriction
	public static let valueAttribute = IntegerAttribute(id: 0, name: "Value", pluralName: "Values")

	public var typedValue: Int {
		return value
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0)
	}

	public init(restrictedAttribute: Attribute, value: Int = 0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		LessThanOrEqualToIntegerAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K <= %d", variableName, value)
	}

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredIntegerComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}
}
