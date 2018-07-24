//
//  AggregationParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol AggregationParameter {

	var name: String { get }
	/// This is an explanation of this parameter that should be able to be presented to the user.
	var extendedDescription: String? { get }
	/// If this is nil, it means this parameter takes an open value
	var possibleValues: [String]? { get }

	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any
}
