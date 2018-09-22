//
//  TypedGreaterThanAttributeRestrictionBase.swift
//  Introspective
//
//  Created by Bryan Nova on 9/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class TypedGreaterThanAttributeRestrictionBase<ValueType: Comparable>: AnyAttributeRestriction, Equatable {

	public static func ==(lhs: TypedGreaterThanAttributeRestrictionBase, rhs: TypedGreaterThanAttributeRestrictionBase) -> Bool {
		return lhs.equalTo(rhs)
	}

	public final override var name: String { return "Greater than" }
	public final override var description: String {
		do {
			let valueText = try restrictedAttribute.convertToDisplayableString(from: value)
			return restrictedAttribute.name + " > " + valueText
		} catch {
			os_log("Could not convert current value (%@) to displayable string: %@", type: .error, String(describing: value), error.localizedDescription)
			return restrictedAttribute.name + " > ?"
		}
	}

	public final var value: ValueType
	private final var valueAttribute: Attribute

	public init(restrictedAttribute: Attribute, value: ValueType, valueAttribute: Attribute) {
		self.value = value
		self.valueAttribute = valueAttribute
		super.init(restrictedAttribute: restrictedAttribute, attributes: [valueAttribute])
	}

	public required init(restrictedAttribute: Attribute) {
		fatalError("This should never be called because this is an abstract base class")
	}

	public final override func value(of attribute: Attribute) throws -> Any {
		if attribute.equalTo(valueAttribute) { return value }
		throw AttributeError.unknownAttribute
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
		return castedValue > value
	}

	public final func equalTo(_ otherAttributed: Attributed) -> Bool {
		if !(otherAttributed is TypedGreaterThanAttributeRestrictionBase) { return false }
		let other = otherAttributed as! TypedGreaterThanAttributeRestrictionBase
		return equalTo(other)
	}

	public final override func equalTo(_ otherRestriction: AttributeRestriction) -> Bool {
		if !(otherRestriction is TypedGreaterThanAttributeRestrictionBase) { return false }
		let other = otherRestriction as! TypedGreaterThanAttributeRestrictionBase
		return equalTo(other)
	}

	public final func equalTo(_ other: TypedGreaterThanAttributeRestrictionBase) -> Bool {
		return restrictedAttribute.equalTo(other.restrictedAttribute) && value == other.value
	}
}
