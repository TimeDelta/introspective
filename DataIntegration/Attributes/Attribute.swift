//
//  Attribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum AttributeError: Error {
	case typeMismatch
	case unsupportedValue
	case unknownAttribute
}

//sourcery: AutoMockable
public protocol Attribute {

	/// This is a name that should be understandable by the user
	var name: String { get }
	var pluralName: String { get }
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	var variableName: String { get }
	/// This is an explanation of this attribute that should be able to be presented to the user.
	var extendedDescription: String? { get }

	/// - Parameter pluralName: If nil, use `name` parameter.
	/// - Parameter description: If nil, no description is needed for the user to understand this attribute.
	/// - Parameter variableName: This should be usable by an NSPredicate to identify the associated variable. If nil, use `name` parameter.
	init(name: String, pluralName: String?, description: String?, variableName: String?)

	/// Is the specified value valid for this attribute?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
	func convertToString(from value: Any) throws -> String
	func convertToDisplayableString(from value: Any) throws -> String
	func equalTo(_ otherAttribute: Attribute) -> Bool
}

extension Attribute {

	public init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
		self.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public func equalTo(_ otherAttribute: Attribute) -> Bool {
		return name.lowercased() == otherAttribute.name.lowercased() && extendedDescription == otherAttribute.extendedDescription
	}
}

public class AttributeBase: Attribute {

	/// This is a name that should be understandable by the user
	public final let name: String
	public final let pluralName: String
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	public final let variableName: String
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public final let extendedDescription: String?

	public required init(name: String, pluralName: String?, description: String?, variableName: String?) {
		self.name = name
		self.pluralName = pluralName ?? name
		self.extendedDescription = description
		if variableName == nil {
			let words = name.split(separator: " ")
			var defaultValue: String = String(words[0])
			for word in words[1...] {
				defaultValue += String(word).localizedCapitalized
			}
			self.variableName = defaultValue
		} else {
			self.variableName = variableName!
		}
	}

	public func isValid(value: String) -> Bool { fatalError("Must override") }
	public func errorMessageFor(invalidValue: String) -> String { fatalError("Must override") }
	public func convertToValue(from strValue: String) throws -> Any { fatalError("Must override") }
	public func convertToString(from value: Any) throws -> String { fatalError("Must override") }

	public func convertToDisplayableString(from value: Any) throws -> String {
		return try convertToString(from: value)
	}
}
