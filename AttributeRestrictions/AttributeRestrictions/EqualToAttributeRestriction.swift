//
//  EqualToAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Attributes
import Common
import Samples

public class EqualToAttributeRestriction: AnyAttributeRestriction, Equatable {
	// MARK: Instance Variables

	override public final var attributedName: String { "Equal to" }
	override public final var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " = " + valueText
		} catch {
			log.error(
				"Could not convert current value (%@) to displayable string: %@",
				String(describing: value),
				errorInfo(error)
			)
			return restrictedAttribute.name + " = ?"
		}
	}

	public final var value: Any?
	// need this to be visible for EqualToSelectOneAttributeRestriction.copy()
	final let valueAttribute: Attribute
	fileprivate final let areEqual: (Any?, Any?) throws -> Bool

	fileprivate final let log = Log()

	// MARK: Initializers

	public init(
		restrictedAttribute: Attribute,
		value: Any?,
		valueAttribute: Attribute,
		areEqual: @escaping (Any?, Any?) throws -> Bool
	) {
		self.value = value
		self.valueAttribute = valueAttribute
		self.areEqual = areEqual
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute: Attribute) {
		log.error("This should never be called because this is an abstract base class")
		valueAttribute = restrictedAttribute
		value = nil
		areEqual = { _, _ in true }
		super.init(restrictedAttribute: restrictedAttribute, attributes: [])
	}

	// MARK: Attributed Functions

	override public final func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(valueAttribute) { return value }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	override public func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		_ = try valueAttribute.convertToDisplayableString(from: value)
		self.value = value
	}

	// MARK: Attribute Restriction Functions

	override public func samplePasses(_ sample: Sample) throws -> Bool {
		let actualValue = try sample.value(of: restrictedAttribute)
		return try areEqual(actualValue, value)
	}

	override public func copy() -> AttributeRestriction {
		EqualToAttributeRestriction(
			restrictedAttribute: restrictedAttribute,
			value: value,
			valueAttribute: valueAttribute,
			areEqual: areEqual
		)
	}

	// MARK: Equality

	public static func == (lhs: EqualToAttributeRestriction, rhs: EqualToAttributeRestriction) -> Bool {
		lhs.equalTo(rhs)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToAttributeRestriction
		return equalTo(other)
	}

	override public func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is EqualToAttributeRestriction) { return false }
		let other = otherRestriction as! EqualToAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: EqualToAttributeRestriction) -> Bool {
		do {
			let valuesEqual = try areEqual(value, other.value)
			return restrictedAttribute.equalTo(other.restrictedAttribute) && valuesEqual
		} catch {
			log.error("Failed to check equality: %@", errorInfo(error))
			return false
		}
	}
}

// MARK: - TypedEqualToAttributeRestrictionBase

public class TypedEqualToAttributeRestrictionBase<ValueType: Equatable>: EqualToAttributeRestriction {
	/// for copy purposes
	private final let typedAreEqual: (ValueType?, ValueType?) -> Bool

	// MARK: Initializers

	public init(restrictedAttribute: Attribute, value: ValueType?, valueAttribute: Attribute) {
		typedAreEqual = { $0 == $1 }
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute) {
			if !($0 is ValueType?) || !($1 is ValueType?) {
				throw TypeMismatchError(attribute: restrictedAttribute, wasA: type(of: value))
			}
			let castedFirst = $0 as! ValueType?
			let castedSecond = $1 as! ValueType?
			return castedFirst == castedSecond
		}
	}

	public init(
		restrictedAttribute: Attribute,
		value: ValueType?,
		valueAttribute: Attribute,
		areEqual: @escaping (ValueType?, ValueType?) -> Bool
	) {
		typedAreEqual = areEqual
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute) {
			if !($0 is ValueType?) || !($1 is ValueType?) {
				throw TypeMismatchError(attribute: restrictedAttribute, wasA: type(of: value))
			}
			let castedFirst = $0 as! ValueType?
			let castedSecond = $1 as! ValueType?
			return areEqual(castedFirst, castedSecond)
		}
	}

	public required init(restrictedAttribute: Attribute) {
		typedAreEqual = { _, _ in true }
		super.init(restrictedAttribute: restrictedAttribute)
		log.error("This should never be called because this is an abstract base class")
	}

	// MARK: Attributed Functions

	override public func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		if !(
			(restrictedAttribute.optional && value is ValueType?) ||
				(!restrictedAttribute.optional && value is ValueType)
		) {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		let castedValue = value as! ValueType?
		self.value = castedValue
	}

	// MARK: Attribute Restriction Functions

	override public func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil {
			if !restrictedAttribute.optional {
				log.error(
					"Value of non-optional attribute named '%@' in %@ sample is nil",
					restrictedAttribute.name,
					sample.attributedName
				)
			}
			return value == nil || (value is String && (value as! String).isEmpty)
		}
		// sampleValue cannot be nil here
		guard let castedValue = sampleValue as? ValueType else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return try areEqual(castedValue, value)
	}

	override public func copy() -> AttributeRestriction {
		TypedEqualToAttributeRestrictionBase<ValueType>(
			restrictedAttribute: restrictedAttribute,
			value: value as? ValueType,
			valueAttribute: valueAttribute,
			areEqual: typedAreEqual
		)
	}

	// MARK: Equality

	public static func == (
		lhs: TypedEqualToAttributeRestrictionBase<ValueType>,
		rhs: TypedEqualToAttributeRestrictionBase<ValueType>
	)
		-> Bool {
		lhs.equalTo(rhs)
	}

	override public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedEqualToAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	override public final func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is TypedEqualToAttributeRestrictionBase) { return false }
		let other = otherRestriction as! TypedEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final func equalTo(_ other: TypedEqualToAttributeRestrictionBase) -> Bool {
		do {
			let valuesEqual = try areEqual(value, other.value)
			return restrictedAttribute.equalTo(other.restrictedAttribute) && valuesEqual
		} catch {
			log.error("Failed to check equality: %@", errorInfo(error))
			return false
		}
	}
}
