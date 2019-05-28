//
//  Attribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol Attribute {

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

extension Attribute {

	public func equalTo(_ otherAttribute: Attribute) -> Bool {
		return type(of: self) == type(of: otherAttribute) &&
			name.lowercased() == otherAttribute.name.lowercased() &&
			extendedDescription == otherAttribute.extendedDescription &&
			variableName == otherAttribute.variableName &&
			optional == otherAttribute.optional
	}
}

public class AttributeBase<ValueType>: Attribute {

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
	public var typeName: String {
		log.error("Did not override typeName for %@", String(describing: type(of: self)))
		return ""
	}

	private final let log = Log()

	/// - Parameter pluralName: If nil, use `name` parameter.
	/// - Parameter description: If nil, no description is needed for the user to understand this attribute.
	/// - Parameter variableName: This should be usable by an NSPredicate to identify the associated variable. If nil, use `name` parameter.
	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		self.name = name
		self.pluralName = pluralName ?? name
		self.extendedDescription = description
		self.variableName = variableName
		self.optional = optional
	}

	public func isValid(value: Any?) -> Bool {
		return value != nil || optional
	}

	public func convertToDisplayableString(from value: Any?) throws -> String {
		throw NotOverriddenError(functionName: "convertToDisplayableString")
	}

	public final func valuesAreEqual(_ first: Any?, _ second: Any?) throws -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		guard let castedFirst = first as? ValueType else {
			log.error("Failed to cast first value when testing equality: %@", String(describing: first))
			return false
		}
		guard let castedSecond = second as? ValueType else {
			log.error("Failed to cast second value when testing equality: %@", String(describing: first))
			return false
		}
		return typedValuesAreEqual(castedFirst, castedSecond)
	}

	public func typedValuesAreEqual(_ first: ValueType, _ second: ValueType) -> Bool {
		Log().error("typedValuesAreEqual not overridden for %@", String(describing: type(of: self)))
		return true
	}
}
