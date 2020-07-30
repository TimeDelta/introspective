//
//  TypedLessThanOrEqualToAttributeRestrictionBase.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public class TypedLessThanOrEqualToAttributeRestrictionBase<ValueType: Comparable>: AnyAttributeRestriction, Equatable {
	// MARK: - Display Information

	public final override var attributedName: String { "Less than or equal to" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " ≤ " + valueText
		} catch {
			Log().error(
				"Could not convert current value (%@) to displayable string: %@",
				String(describing: value),
				errorInfo(error)
			)
			return restrictedAttribute.name + " ≤ ?"
		}
	}

	// MARK: - Instance Variables

	public final var value: ValueType
	private final var valueAttribute: Attribute

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute) {
		self.value = value
		self.valueAttribute = valueAttribute
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute _: Attribute) {
		// can't do anything to initialize value member variable
		fatalError("This should never be called because this is an abstract base class")
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(valueAttribute) { return value }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		guard let castedValue = value as? ValueType else {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		self.value = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let castedValue = sampleValue as? ValueType else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return castedValue <= value
	}

	public override func copy() -> AttributeRestriction {
		TypedLessThanOrEqualToAttributeRestrictionBase<ValueType>(
			restrictedAttribute: restrictedAttribute,
			value: value,
			valueAttribute: valueAttribute
		)
	}

	// MARK: - Equality

	public static func == (
		lhs: TypedLessThanOrEqualToAttributeRestrictionBase,
		rhs: TypedLessThanOrEqualToAttributeRestrictionBase
	) -> Bool {
		lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedLessThanOrEqualToAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedLessThanOrEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is TypedLessThanOrEqualToAttributeRestrictionBase) { return false }
		let other = otherRestriction as! TypedLessThanOrEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final func equalTo(_ other: TypedLessThanOrEqualToAttributeRestrictionBase) -> Bool {
		restrictedAttribute.equalTo(other.restrictedAttribute) && value == other.value
	}
}
