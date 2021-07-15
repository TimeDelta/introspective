//
//  GreaterThanIntegerAttributeRestriction.swift
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

public final class GreaterThanIntegerAttributeRestriction: TypedGreaterThanAttributeRestrictionBase<Int>,
	IntegerAttributeRestriction {
	private typealias Me = GreaterThanIntegerAttributeRestriction
	public static let valueAttribute = IntegerAttribute(id: 0, name: "Value", pluralName: "Values")

	public var typedValue: Int {
		value
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: 0)
	}

	public init(restrictedAttribute: Attribute, value: Int = 0) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		GreaterThanIntegerAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K > %d", variableName, value)
	}

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredIntegerComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		return stored
	}
}
