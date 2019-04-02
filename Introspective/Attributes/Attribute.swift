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

	func isValid(value: Any?) -> Bool
	func equalTo(_ otherAttribute: Attribute) -> Bool
	func convertToDisplayableString(from value: Any?) throws -> String
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

public class AttributeBase: Attribute {

	/// This is a name that should be understandable by the user
	public final let name: String
	public final let pluralName: String
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	public final let variableName: String?
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public final let extendedDescription: String?
	/// This represents whether or not this attribute is optional
	public final let optional: Bool

	/// - Parameter pluralName: If nil, use `name` parameter.
	/// - Parameter description: If nil, no description is needed for the user to understand this attribute.
	/// - Parameter variableName: This should be usable by an NSPredicate to identify the associated variable. If nil, use `name` parameter.
	public init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil, optional: Bool = false) {
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
}
