//
//  NotEqualToSelectOneAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common

public final class NotEqualToSelectOneAttributeRestriction: NotEqualToAttributeRestriction {
	// MARK: - Instance Variables

	private final var selectOneAttribute: SelectOneAttribute

	private final let log = Log()

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, value: Any?, valueAttribute: SelectOneAttribute) {
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
		NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restrictedAttribute,
			value: value,
			valueAttribute: valueAttribute as! SelectOneAttribute
		)
	}

	// MARK: - Boolean Expression Functions

	public override func predicate() -> NSPredicate? {
		#warning("can use TypedSelectOneAttribute<Type> to return predicate for certain cases")
		return nil
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
			log.error("Failed to check for possible value: %@", errorInfo(error))
		}
	}

	// MARK: - Equality

	public static func == (
		lhs: NotEqualToSelectOneAttributeRestriction,
		rhs: NotEqualToSelectOneAttributeRestriction
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final override func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is NotEqualToSelectOneAttributeRestriction) { return false }
		let other = otherAttributed as! NotEqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is NotEqualToSelectOneAttributeRestriction) { return false }
		let other = otherRestriction as! NotEqualToSelectOneAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: NotEqualToSelectOneAttributeRestriction) -> Bool {
		if !restrictedAttribute.equalTo(other.restrictedAttribute) { return false }
		do {
			return try selectOneAttribute.valuesAreEqual(value, other.value)
		} catch {
			log.error("Failed to check if values are equal: %@", errorInfo(error))
			return false
		}
	}
}
