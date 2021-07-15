//
//  EmptyStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 3/13/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import DependencyInjection
import Persistence
import Samples

public final class EmptyStringAttributeRestriction: AnyAttributeRestriction, StringAttributeRestriction {
	// MARK: - Display Information

	public final override var attributedName: String { "Empty" }
	public final override var description: String {
		restrictedAttribute.name.localizedCapitalized + " is empty"
	}

	// MARK: - Instance Variables

	public final var typedValue: String? { nil }

	// MARK: - Initializers

	public required init(restrictedAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute)
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return true }
		guard let value = sampleValue as? String else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return value.isEmpty
	}

	public override func copy() -> AttributeRestriction {
		EmptyStringAttributeRestriction(restrictedAttribute: restrictedAttribute)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K.length == 0", variableName)
	}

	public override func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredStringOperationAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		return stored
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to _: Any?) throws {
		throw UnknownAttributeError(attribute: attribute, for: self)
	}
}
