//
//  Parameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public enum ParameterError: Error {
	case typeMismatch
	case unsupportedValue
	case unknownParameter
}

public protocol Parameter {

	/// This is a name that should be understandable by the user
	var name: String { get }
	/// This is an explanation of this parameter that should be able to be presented to the user.
	var extendedDescription: String? { get }

	/// Is the specified value valid for this parameter?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
	func convertToString(from value: Any) throws -> String
	func convertToDisplayableString(from value: Any) throws -> String
}

extension Parameter {

	public func convertToDisplayableString(from value: Any) throws -> String {
		return try convertToString(from: value)
	}
}
