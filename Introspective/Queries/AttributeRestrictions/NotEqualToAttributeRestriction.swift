//
//  NotEqualToAttributeRestriction.swift
//  Introspective
//
//  Created by Bryan Nova on 9/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class NotEqualToAttributeRestriction: AnyAttributeRestriction, Equatable {

	public static func ==(lhs: NotEqualToAttributeRestriction, rhs: NotEqualToAttributeRestriction) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override var name: String { return "Not equal to" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " ≠ " + valueText
		} catch {
			os_log("Could not convert current value (%@) to displayable string: %@", type: .error, String(describing: value), error.localizedDescription)
			return restrictedAttribute.name + " ≠ ?"
		}
	}

	public final var value: Any
	fileprivate final let valueAttribute: Attribute
	fileprivate final let areEqual: (Any, Any) throws -> Bool

	public init(restrictedAttribute: Attribute, value: Any, valueAttribute: Attribute, areEqual: @escaping (Any, Any) throws -> Bool) {
		self.value = value
		self.valueAttribute = valueAttribute
		self.areEqual = areEqual
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute: Attribute) {
		fatalError("This should never be called because this is an abstract base class")
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(valueAttribute) { return value }
		throw AttributeError.unknownAttribute
	}

	public override func set(attribute: Attribute, to value: Any) throws {
		if !attribute.equalTo(valueAttribute) { throw AttributeError.unknownAttribute }
		self.value = value
	}

	public override func samplePasses(_ sample: Sample) throws -> Bool {
		let actualValue = try sample.value(of: restrictedAttribute)
		return try areEqual(actualValue, value)
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
			os_log("Failed to check equality: %@", type: .error, error.localizedDescription)
			return false
		}
	}
}

public class TypedNotEqualToAttributeRestrictionBase<ValueType: Equatable>: NotEqualToAttributeRestriction {

	public static func ==(lhs: TypedNotEqualToAttributeRestrictionBase, rhs: TypedNotEqualToAttributeRestrictionBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute) {
		super.init(restrictedAttribute: restrictedAttribute, value: value, valueAttribute: valueAttribute) {
			guard let castedFirst = $0 as? ValueType else { throw AttributeError.typeMismatch }
			guard let castedSecond = $1 as? ValueType else { throw AttributeError.typeMismatch }
			return castedFirst == castedSecond
		}
	}

	public required init(restrictedAttribute: Attribute) {
		fatalError("This should never be called because this is an abstract base class")
	}

	public final override func set(attribute: Attribute, to value: Any) throws {
		if !attribute.equalTo(valueAttribute) { throw AttributeError.unknownAttribute }
		guard let castedValue = value as? ValueType else { throw AttributeError.typeMismatch }
		self.value = castedValue
	}

	public final override func samplePasses(_ sample: Sample) throws -> Bool {
		guard let castedValue = try sample.value(of: restrictedAttribute) as? ValueType else {
			throw AttributeError.typeMismatch
		}
		return try !areEqual(castedValue, value)
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
			os_log("Failed to check equality: %@", type: .error, error.localizedDescription)
			return  false
		}
	}
}

