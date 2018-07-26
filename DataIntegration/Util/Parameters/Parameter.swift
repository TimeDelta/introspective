//
//  Parameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Parameter {

	/// This is a name that should be understandable by the user
	var name: String { get }
	/// This is an explanation of this parameter that should be able to be presented to the user.
	var extendedDescription: String? { get }
	/// If this is nil, it means this parameter takes an open value
	var possibleValues: [String]? { get }

	/// Is the specified value valid for this parameter?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
}
