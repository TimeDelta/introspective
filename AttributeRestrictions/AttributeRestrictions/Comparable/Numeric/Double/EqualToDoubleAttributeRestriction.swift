//
//  EqualToDoubleAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import DependencyInjection
import Persistence
import Samples

public final class EqualToDoubleAttributeRestriction:
	TypedEqualToAttributeRestrictionBase<Double>,
	DoubleAttributeRestriction {
	private typealias Me = EqualToDoubleAttributeRestriction
	public static let valueAttribute = DoubleAttribute(id: 0, name: "Value", pluralName: "Values")

	public var typedValue: Double {
		value as! Double
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0.0)
	}

	public init(restrictedAttribute: Attribute, value: Double = 0.0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		EqualToDoubleAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! Double)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K == %f", variableName, value as! Double)
	}

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredDoubleComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		return stored
	}
}
