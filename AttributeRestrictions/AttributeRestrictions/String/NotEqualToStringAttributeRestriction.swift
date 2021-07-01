//
//  EqualToStringAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import DependencyInjection
import Persistence
import Samples

public final class NotEqualToStringAttributeRestriction:
	TypedNotEqualToAttributeRestrictionBase<String>,
	StringAttributeRestriction
{
	private typealias Me = NotEqualToStringAttributeRestriction

	// MARK: - Attributes

	public static let valueAttribute = TextAttribute(id: 0, name: "Value", pluralName: "Values")

	// MARK: - Instance Variables

	public final var typedValue: String? { value as? String }

	// MARK: - Initializers

	public required convenience init(restrictedAttribute: Attribute) {
		self.init(restrictedAttribute: restrictedAttribute, value: "")
	}

	public init(restrictedAttribute: Attribute, value: String = "") {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: Me.valueAttribute) {
			if ($0 == nil && $1?.isEmpty ?? false) || ($1 == nil && $0?.isEmpty ?? false) {
				return true
			}
			return $0?.localizedLowercase == $1?.localizedLowercase
		}
	}

	// MARK: - Attribute Restriction Functions

	public override func copy() -> AttributeRestriction {
		NotEqualToStringAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value as! String)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		guard let variableName = restrictedAttribute.variableName else { return nil }
		return NSPredicate(format: "%K !=[cd] %@", variableName, value as! String)
	}

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredStringOperationAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}
}
