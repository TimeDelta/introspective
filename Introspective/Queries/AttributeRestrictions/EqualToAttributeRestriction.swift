//
//  EqualToAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class EqualToAttributeRestriction: AnyAttributeRestriction, Equatable {

	public static func ==(lhs: EqualToAttributeRestriction, rhs: EqualToAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override var attributedName: String { return "Equal to" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " = " + valueText
		} catch {
			log.error("Could not convert current value (%@) to displayable string: %@", String(describing: value), errorInfo(error))
			return restrictedAttribute.name + " = ?"
		}
	}

	public final var value: Any?
	fileprivate final let valueAttribute: Attribute
	fileprivate final let areEqual: (Any?, Any?) throws -> Bool

	fileprivate final let log = Log()

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

	public final override func value(of attribute: Attribute) throws -> Any? {
		if attribute.equalTo(valueAttribute) { return value }
		throw UnknownAttributeError(attribute: attribute, for: self)
	}

	public override func set(attribute: Attribute, to value: Any?) throws {
		if !attribute.equalTo(valueAttribute) {
			throw UnknownAttributeError(attribute: attribute, for: self)
		}
		self.value = value
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let actualValue = try sample.value(of: restrictedAttribute)
		return try areEqual(actualValue, value)
	}

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is EqualToAttributeRestriction) { return false }
		let other = otherAttributed as! EqualToAttributeRestriction
		return equalTo(other)
	}

	public override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
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

public class TypedEqualToAttributeRestrictionBase<ValueType: Equatable>: EqualToAttributeRestriction {

	public static func ==(lhs: TypedEqualToAttributeRestrictionBase, rhs: TypedEqualToAttributeRestrictionBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute) {
			if !($0 is ValueType?) || !($1 is ValueType?) {
				throw TypeMismatchError(attribute: restrictedAttribute, wasA: type(of: value))
			}
			let castedFirst = $0 as! ValueType?
			let castedSecond = $1 as! ValueType?
			return castedFirst == castedSecond
		}
	}

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute, areEqual: @escaping (ValueType?, ValueType?) -> Bool) {
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
		super.init(restrictedAttribute: restrictedAttribute)
		log.error("This should never be called because this is an abstract base class")
	}

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

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let sampleValue = try sample.value(of: restrictedAttribute)
		if sampleValue == nil {
			if !restrictedAttribute.optional {
				log.error("Value of non-optional attribute named '%@' in %@ sample is nil", restrictedAttribute.name, sample.attributedName)
			}
			return value == nil || (value is String && (value as! String).isEmpty)
		}
		// sampleValue cannot be nil here
		guard let castedValue = sampleValue as? ValueType else {
			throw TypeMismatchError(attribute: restrictedAttribute, of: sample, wasA: type(of: sampleValue))
		}
		return try areEqual(castedValue, value)
	}

	public final override func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedEqualToAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedEqualToAttributeRestrictionBase
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
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
			return  false
		}
	}
}
