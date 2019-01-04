//
//  TypedLessThanAttributeRestrictionBase.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class TypedLessThanAttributeRestrictionBase<ValueType: Comparable>: AnyAttributeRestriction, Equatable {

	// MARK: - Display Information

	public final override var attributedName: String { return "Less than" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " < " + valueText
		} catch {
			log.error("Could not convert current value (%@) to displayable string: %@", String(describing: value), errorInfo(error))
			return restrictedAttribute.name + " < ?"
		}
	}

	// MARK: - Instance Variables

	public final var value: ValueType
	private final var valueAttribute: Attribute

	private final let log = Log()

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute) {
		self.value = value
		self.valueAttribute = valueAttribute
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute: Attribute) {
		// can't do anything to initialize value member variable
		fatalError("This should never be called because this is an abstract base class")
	}

	// MARK: - Attribute Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(valueAttribute) { return value }
		throw AttributeError.unknownAttribute
	}

	public final override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? ValueType else { throw AttributeError.typeMismatch }
		self.value = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil { return false }
		guard let castedValue = sampleValue as? ValueType else { throw AttributeError.typeMismatch }
		return castedValue < value
	}

	// MARK: - Equality

	public static func ==(lhs: TypedLessThanAttributeRestrictionBase, rhs: TypedLessThanAttributeRestrictionBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedLessThanAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedLessThanAttributeRestrictionBase
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is TypedLessThanAttributeRestrictionBase) { return false }
		let other = otherRestriction as! TypedLessThanAttributeRestrictionBase
		return equalTo(other)
	}

	public final func equalTo(_ other: TypedLessThanAttributeRestrictionBase) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && value == other.value
	}
}
