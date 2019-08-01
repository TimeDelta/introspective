//
//  IntegerAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class IntegerAttribute: AttributeBase<Int>, NumericAttribute {

	public final override var typeName: String {
		return "Integer Number"
	}

	public final func isValid(value: String) -> Bool {
		return (optional && value == "") || Int(value) != nil
	}

	public final func errorMessageFor(invalidValue: String) -> String {
		if !optional && invalidValue == "" {
			return "\(name) is required"
		}
		return "\(invalidValue) is not an integer"
	}

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? Int != nil
	}

	public final func convertToValue(from strValue: String) throws -> Any? {
		if optional && strValue == "" { return nil }
		guard isValid(value: strValue), let intValue = Int(strValue) else {
			throw UnsupportedValueError(attribute: self, is: strValue)
		}
		return intValue
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let nonNilValue = value else {
			throw UnsupportedValueError(attribute: self, is: nil)
		}
		guard let castedValue = nonNilValue as? Int else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return String(castedValue)
	}

	public final override func typedValuesAreEqual(_ first: Int, _ second: Int) -> Bool {
		return first == second
	}

	public final func graphableValueFor(_ value: Any) throws -> Double {
		guard let castedValue = value as? Int else {
			throw GenericError("Passed \(String(describing: value)) to graphableValueFor()")
		}
		return Double(castedValue)
	}
}
