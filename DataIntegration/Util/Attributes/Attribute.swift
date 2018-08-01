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

public protocol Attribute {

	/// This is a name that should be understandable by the user
	var name: String { get }
	/// This is an explanation of this attribute that should be able to be presented to the user.
	var extendedDescription: String? { get }

	init(name: String, description: String?)

	/// Is the specified value valid for this attribute?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
	func convertToString(from value: Any) throws -> String
	func convertToDisplayableString(from value: Any) throws -> String
}

extension Attribute {

	/// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (lhs: Attribute, rhs: Attribute) -> Bool {
		return lhs.name == rhs.name && lhs.extendedDescription == rhs.extendedDescription
	}
}

public class AnyAttribute: Attribute {

	/// This is a name that should be understandable by the user
	public fileprivate(set) var name: String
	/// This is an explanation of this attribute that should be able to be presented to the user.
	public fileprivate(set) var extendedDescription: String?

	public required init(name: String, description: String?) {
		self.name = name
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
