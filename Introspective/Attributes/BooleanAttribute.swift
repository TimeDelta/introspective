//
//  BooleanAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BooleanAttribute: AttributeBase {

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? Bool != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Bool else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue ? "on" : "off"
	}
}
