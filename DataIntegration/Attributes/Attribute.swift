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
	/// This is an explanation of this attribute that should be able to be presented to the user.
	var extendedDescription: String? { get }

	init(name: String, pluralName: String?, description: String?)

	/// Is the specified value valid for this attribute?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
	func convertToString(from value: Any) throws -> String
	func convertToDisplayableString(from value: Any) throws -> String
	func equalTo(_ otherAttribute: Attribute) -> Bool
}

extension Attribute {

	public func equalTo(_ otherAttribute: Attribute) -> Bool {
		return name == otherAttribute.name && extendedDescription == otherAttribute.extendedDescription
	}
}

public class AnyAttribute: Attribute {

	/// This is a name that should be understandable by the user
	public fileprivate(set) var name: String
	public fileprivate(set) var pluralName: String
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public fileprivate(set) var extendedDescription: String?

	public required init(name: String, pluralName: String? = nil, description: String? = nil) {
		self.name = name
		if pluralName == nil {
			self.pluralName = name
		} else {
			self.pluralName = pluralName!
		}
		self.extendedDescription = description
	}

	public func isValid(value: String) -> Bool { fatalError("Must override") }
	public func errorMessageFor(invalidValue: String) -> String { fatalError("Must override") }
	public func convertToValue(from strValue: String) throws -> Any { fatalError("Must override") }
	public func convertToString(from value: Any) throws -> String { fatalError("Must override") }
	public func convertToDisplayableString(from value: Any) throws -> String {
		return try convertToString(from: value)
	}
}