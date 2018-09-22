//
//  IntegerAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class IntegerAttribute: AttributeBase, NumericAttribute {

	public final func isValid(value: String) -> Bool {
		return Int(value) != nil
	}

	public final func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not an integer"
	}

	public final func convertToValue(from strValue: String) throws -> Any {
		if !isValid(value: strValue) { throw  AttributeError.unsupportedValue }
		return Int(strValue)!
	}

	public final override func convertToDisplayableString(from value: Any) throws -> String {
		guard let castedValue = value as? Int else { throw AttributeError.typeMismatch }
		return String(castedValue)
	}
}
