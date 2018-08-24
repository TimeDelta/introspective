//
//  NumericAttributeRestriction.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public class NumericAttributeRestriction: AnyAttributeRestriction {

	override func isValid(attribute: Attribute) -> Bool {
		return attribute is NumericAttribute
	}

	func getDoubleFrom(_ sample: Sample) throws -> Double {
		let sampleValue = try sample.value(of: restrictedAttribute)
		return try getDoubleFrom(value: sampleValue)
	}

	func getDoubleFrom(value: Any) throws -> Double {
		switch (restrictedAttribute) {
			case is IntegerAttribute:
				return Double(value as! Int)
			case is DoubleAttribute:
				 return value as! Double
			default:
				throw AttributeError.typeMismatch
		}
	}

	func numericValueOfRestrictedAttribute(_ value: Double) throws -> Any {
		switch (restrictedAttribute) {
			case is IntegerAttribute:
				return Int(value)
			case is DoubleAttribute:
				return value
			default:
				os_log("Unknown type of NumericAttribute: $@", type: .error, String(describing: type(of: restrictedAttribute)))
				throw SampleError.typeMismatch
		}
	}
}
