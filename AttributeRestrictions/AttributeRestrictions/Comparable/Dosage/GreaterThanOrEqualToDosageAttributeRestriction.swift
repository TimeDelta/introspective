//
//  GreaterThanOrEqualToADosagettributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class GreaterThanOrEqualToDosageAttributeRestriction:
	TypedGreaterThanOrEqualToAttributeRestrictionBase<Dosage>,
	DosageAttributeRestriction {
	private typealias Me = GreaterThanOrEqualToDosageAttributeRestriction
	public static let valueAttribute = DosageAttribute(id: 0, name: "Target Dosage", pluralName: "Target Dosages")

	public var typedValue: Dosage {
		value
	}

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: Dosage(0, ""))
	}

	public init(restrictedAttribute: Attribute, value: Dosage = Dosage(0, "")) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute)
	}

	public override func copy() -> AttributeRestriction {
		GreaterThanOrEqualToDosageAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value)
	}

	public override func predicate() -> NSPredicate? { nil }

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredDosageComparisonAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		return stored
	}
}
