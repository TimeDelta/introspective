//
//  Attribute.swift
//  Introspective
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

	func equalTo(_ otherAttribute: Attribute) -> Bool
	func convertToDisplayableString(from value: Any) throws -> String
}

extension Attribute {

	public func equalTo(_ otherAttribute: Attribute) -> Bool {
		return name.lowercased() == otherAttribute.name.lowercased() && extendedDescription == otherAttribute.extendedDescription
	}
}

public class AttributeBase: NSObject, Attribute {

	/// This is a name that should be understandable by the user
	public final let name: String
	public final let pluralName: String
	/// This needs to be able to be used by an NSPredicate within a PredicateAttributeRestriction
	public final let variableName: String
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public final let extendedDescription: String?

	/// - Parameter pluralName: If nil, use `name` parameter.
	/// - Parameter description: If nil, no description is needed for the user to understand this attribute.
	/// - Parameter variableName: This should be usable by an NSPredicate to identify the associated variable. If nil, use `name` parameter.
	public init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
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

	public func convertToDisplayableString(from value: Any) throws -> String { fatalError("Must override convertToDisplayableString") }
}
