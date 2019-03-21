//
//  DoubleAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DoubleAttribute: AttributeBase, NumericAttribute {

	public final func isValid(value: String) -> Bool {
		return (optional && value == "") || Double(value) != nil
	}

	public final func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not a number"
	}

	public final func convertToValue(from strValue: String) throws -> Any? {
		if optional && strValue == "" { return nil }
		guard isValid(value: strValue), let doubleValue = Double(strValue) else {
			throw UnsupportedValueError(attribute: self, is: strValue)
		}
		return doubleValue
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let nonNilValue = value else {
			throw UnsupportedValueError(attribute: self, is: nil)
		}
		guard let castedValue = nonNilValue as? Double else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return String(castedValue)
	}
}
