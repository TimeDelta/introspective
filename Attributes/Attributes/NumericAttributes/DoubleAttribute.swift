//
//  DoubleAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class DoubleAttribute: AttributeBase<Double>, NumericAttribute {
	override public final var typeName: String {
		"Number"
	}

	public final func isValid(value: String) -> Bool {
		(optional && value == "") || Double(value) != nil
	}

	public final func errorMessageFor(invalidValue: String) -> String {
		if !optional && invalidValue == "" {
			return "\(name) is required"
		}
		return "\(invalidValue) is not a number"
	}

	override public final func isValid(value: Any?) -> Bool {
		(value == nil && optional) || value as? Double != nil
	}

	public final func convertToValue(from strValue: String) throws -> Any? {
		if optional && strValue == "" { return nil }
		guard isValid(value: strValue), let doubleValue = Double(strValue) else {
			throw UnsupportedValueError(attribute: self, is: strValue)
		}
		return doubleValue
	}

	override public final func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let nonNilValue = value else {
			throw UnsupportedValueError(attribute: self, is: nil)
		}
		guard let castedValue = nonNilValue as? Double else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return String(castedValue)
	}

	override public final func typedValuesAreEqual(_ first: Double, _ second: Double) -> Bool {
		first == second
	}

	public final func graphableValueFor(_ value: Any) throws -> Double {
		guard let castedValue = value as? Double else {
			throw GenericError("Passed \(String(describing: value)) to graphableValueFor()")
		}
		return castedValue
	}
}
