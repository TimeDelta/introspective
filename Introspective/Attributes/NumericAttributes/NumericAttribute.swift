//
//  NumericAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import HealthKit

public protocol NumericAttribute: Attribute {

	/// Is the specified value valid for this attribute?
	func isValid(value: String) -> Bool
	func errorMessageFor(invalidValue: String) -> String
	func convertToValue(from strValue: String) throws -> Any?
}
