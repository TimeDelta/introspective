//
//  EqualToSelectOneAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class EqualToSelectOneAttributeRestriction: EqualToAttributeRestriction, SelectOneAttributeRestriction {
	// MARK: - Static Variables

	private typealias Me = EqualToSelectOneAttributeRestriction

	private static let log = Log()

	// MARK: - Instance Variables

	public final var selectOneAttribute: SelectOneAttribute

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, value: Any, valueAttribute: SelectOneAttribute) {
		selectOneAttribute = valueAttribute
		super.init(
			restrictedAttribute: restrictedAttribute,
			value: value,
			valueAttribute: valueAttribute,
			areEqual: {
				try valueAttribute.valuesAreEqual($0, $1)
			}
		)
	}

	public required convenience init(restrictedAttribute: Attribute) {
		let selectAttribute = restrictedAttribute as! SelectOneAttribute
		let initialValue = selectAttribute.possibleValues[0]
		self.init(restrictedAttribute: restrictedAttribute, value: initialValue, valueAttribute: selectAttribute)
	}

	// MARK: - Attribute Restriction Functions

	public override func copy() -> AttributeRestriction {
		EqualToSelectOneAttributeRestriction(
			restrictedAttribute: restrictedAttribute,
			value: value as Any,
			valueAttribute: valueAttribute as! SelectOneAttribute
		)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		nil
	}

	public override func stored(for sampleType: Sample.Type) throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredSelectOneAttributeRestriction.self)
		try stored.populate(from: self, for: sampleType)
		try transaction.commit()
		return stored
	}

	// MARK: - Other

	public final override func restrictedAttributeWasSet() {
		selectOneAttribute = restrictedAttribute as! SelectOneAttribute
		do {
			let index = try selectOneAttribute.possibleValues
				.firstIndex { try selectOneAttribute.valuesAreEqual($0, value) }
			if index == nil {
				value = selectOneAttribute.possibleValues[0]
			}
		} catch {
			Me.log.error("Failed to check for possible value: %@", errorInfo(error))
		}
	}

	// MARK: - Equality

	public static func == (
		lhs: EqualToSelectOneAttributeRestriction,
		rhs: EqualToSelectOneAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final override func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToSelectOneAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EqualToSelectOneAttributeRestriction) { return false }
		let other = otherRestriction as! EqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EqualToSelectOneAttributeRestriction) -> Bool {
		if !restrictedAttribute.equalTo(other.restrictedAttribute) { return false }
		do {
			return try selectOneAttribute.valuesAreEqual(value, other.value)
		} catch {
			Me.log.error("Failed to check if values are equal: %@", errorInfo(error))
			return false
		}
	}
}
