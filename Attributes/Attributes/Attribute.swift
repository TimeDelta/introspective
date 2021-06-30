//
//  Attribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

// sourcery: AutoMockable
public protocol Attribute {
	/// An unchanging value that can be used to differentiate this attribute from the other attributes for a given sample type in the persistence layer
	var id: Int16 { get }
	/// This is a name that should be understandable by the user
	var name: String { get }
	var pluralName: String { get }
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	var variableName: String? { get }
	/// This is an explanation of this attribute that should be able to be presented to the user.
	var extendedDescription: String? { get }
	/// This represents whether or not this attribute is optional
	var optional: Bool { get }
	var valueType: Any.Type { get }
	/// This should be presentable to the user to understand what type of attribute this is
	var typeName: String { get }

	func isValid(value: Any?) -> Bool
	func equalTo(_ otherAttribute: Attribute) -> Bool
	func convertToDisplayableString(from value: Any?) throws -> String
	func valuesAreEqual(_ first: Any?, _ second: Any?) throws -> Bool
}

public extension Attribute {
	func equalTo(_ otherAttribute: Attribute) -> Bool {
		type(of: self) == type(of: otherAttribute) &&
			name.lowercased() == otherAttribute.name.lowercased() &&
			extendedDescription == otherAttribute.extendedDescription &&
			variableName == otherAttribute.variableName &&
			optional == otherAttribute.optional
	}
}

open class AttributeBase<ValueType>: Attribute {
	/// An unchanging value that can be used to differentiate this attribute from the other attributes for a given sample type in the persistence layer
	public final var id: Int16
	/// This is a name that should be understandable by the user
	public final let name: String
	public final let pluralName: String
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	public final let variableName: String?
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public final let extendedDescription: String?
	/// This represents whether or not this attribute is optional
	public final let optional: Bool
	public let valueType: Any.Type = ValueType.self
	/// This should be presentable to the user to understand what type of attribute this is
	open var typeName: String {
		Log().error("Did not override typeName for %@", String(describing: type(of: self)))
		return ""
	}

	/// - Parameter pluralName: If nil, use `name` parameter.
	/// - Parameter description: If nil, no description is needed for the user to understand this attribute.
	/// - Parameter variableName: This should be usable by an NSPredicate to identify the associated variable. If nil, use `name` parameter.
	public init(
		id: Int16,
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false
	) {
		self.id = id
		self.name = name
		self.pluralName = pluralName ?? name
		extendedDescription = description
		self.variableName = variableName
		self.optional = optional
	}

	open func isValid(value: Any?) -> Bool {
		value != nil || optional
	}

	open func convertToDisplayableString(from _: Any?) throws -> String {
		throw NotOverriddenError(functionName: "convertToDisplayableString")
	}

	public final func valuesAreEqual(_ first: Any?, _ second: Any?) throws -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		guard let castedFirst = first as? ValueType else {
			Log().error("Failed to cast first value when testing equality: %@", String(describing: first))
			return false
		}
		guard let castedSecond = second as? ValueType else {
			Log().error("Failed to cast second value when testing equality: %@", String(describing: first))
			return false
		}
		return typedValuesAreEqual(castedFirst, castedSecond)
	}

	open func typedValuesAreEqual(_: ValueType, _: ValueType) -> Bool {
		Log().error("typedValuesAreEqual not overridden for %@", String(describing: type(of: self)))
		return true
	}
}
