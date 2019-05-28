//
//  NotEqualToAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class NotEqualToAttributeRestriction: AnyAttributeRestriction, Equatable {

	// MARK: - Instance Variables

	public final override var attributedName: String { return "Not equal to" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " ≠ " + valueText
		} catch {
			log.error("Could not convert current value (%@) to displayable string: %@", String(describing: value), errorInfo(error))
			return restrictedAttribute.name + " ≠ ?"
		}
	}

	public final var value: Any?
	// need this to be visible for NotEqualToSelectOneAttributeRestriction.copy()
	final let valueAttribute: Attribute
	fileprivate final let areEqual: (Any?, Any?) throws -> Bool

	fileprivate final let log = Log()

	// MARK: - Initializers

	public init(restrictedAttribute: Attribute, value: Any?, valueAttribute: Attribute, areEqual: @escaping (Any?, Any?) throws -> Bool) {
		self.value = value
		self.valueAttribute = valueAttribute
		self.areEqual = areEqual
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute: Attribute) {
		log.error("This should never be called because this is an abstract base class")
		self.valueAttribute = restrictedAttribute
		self.value = nil
		self.areEqual = { _,_  in true }
		super.init(restrictedAttribute: restrictedAttribute, attributes: [])
	}

	// MARK: - Attributed Functions

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(valueAttribute) { return value }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public override func set(attribute: Attribute, to value: Any?) throws {
		let _ = try valueAttribute.convertToDisplayableString(from: value)
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		self.value = value as Any
	}

	// MARK: - Attribute Restriction Functions

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let actualValue = try sample.value(of: restrictedAttribute)
		return try !areEqual(actualValue as Any?, value)
	}

	public override func copy() -> AttributeRestriction {
		return EqualToAttributeRestriction(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute, areEqual: areEqual)
	}

	// MARK: - Equality

	public static func ==(lhs: NotEqualToAttributeRestriction, rhs: NotEqualToAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is NotEqualToAttributeRestriction) { return false }
		let other = otherAttributed as! NotEqualToAttributeRestriction
		return equalTo(other)
	}

	public override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is NotEqualToAttributeRestriction) { return false }
		let other = otherRestriction as! NotEqualToAttributeRestriction
		return equalTo(other)
	}

	public final func equalTo(_ other: NotEqualToAttributeRestriction) -> Bool {
		do {
			let valuesEqual = try areEqual(value, other.value)
			return restrictedAttribute.equalTo(other.restrictedAttribute) && valuesEqual
		} catch {
			log.error("Failed to check equality: %@", errorInfo(error))
			return false
		}
	}
}

public class TypedNotEqualToAttributeRestrictionBase<ValueType: Equatable>: NotEqualToAttributeRestriction {

	/// for copy purposes
	final private let typedAreEqual: (ValueType?, ValueType?) -> Bool

	// MARK: - Initializers

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
		areEqual: @escaping (ValueType?, ValueType?) -> Bool)
	{
		typedAreEqual = areEqual
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute) {
			if !($0 is ValueType?) || !($1 is ValueType?) {
				throw TypeMismatchError(attribute: restrictedAttribute, wasA: type(of: $0))
			}
			let castedFirst = $0 as! ValueType?
			let castedSecond = $1 as! ValueType?
			return areEqual(castedFirst, castedSecond)
		}
	}

	public required init(restrictedAttribute: Attribute) {
		typedAreEqual = { _,_  in true }
		super.init(restrictedAttribute: restrictedAttribute)
		log.error("This should never be called because this is an abstract base class")
	}

	// MARK: - Attributed Functions

	public override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		if !((restrictedAttribute.optional && value is ValueType?) || (!restrictedAttribute.optional && value is ValueType)) {
			throw TypeMismatchError(attribute: attribute, of: self, wasA: type(of: value))
		}
		let castedValue = value as! ValueType?
		self.value = castedValue
	}

	// MARK: - Attribute Restriction Functions

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil {
			if !restrictedAttribute.optional {
				log.error("Value of non-optional attribute named '%@' in %@ sample is nil", restrictedAttribute.name, sample.attributedName)
			}
			return value != nil && !(value is String && (value as! String).isEmpty)
		}
		// sampleValue cannot be nil here
		guard let castedValue = sampleValue as? ValueType else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: self, wasA: type(of: sampleValue))
		}
		return try !areEqual(castedValue, value)
	}

	public override func copy() -> AttributeRestriction {
		return TypedNotEqualToAttributeRestrictionBase<ValueType>(
			restrictedAttribute: restrictedAttribute,
			value: value as? ValueType,
			valueAttribute: valueAttribute,
			areEqual: typedAreEqual)
	}

	// MARK: - Equality

	public static func ==(lhs: TypedNotEqualToAttributeRestrictionBase, rhs: TypedNotEqualToAttributeRestrictionBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedNotEqualToAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedNotEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is TypedNotEqualToAttributeRestrictionBase) { return false }
		let other = otherRestriction as! TypedNotEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final func equalTo(_ other: TypedNotEqualToAttributeRestrictionBase) -> Bool {
		do {
			let valuesEqual = try areEqual(value, other.value)
			return restrictedAttribute.equalTo(other.restrictedAttribute) && valuesEqual
		} catch {
			log.error("Failed to check equality: %@", errorInfo(error))
			return  false
		}
	}
}

