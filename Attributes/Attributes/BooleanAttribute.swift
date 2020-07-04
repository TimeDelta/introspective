//
//  BooleanAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BooleanAttribute: AttributeBase<Bool> {
	override public final var typeName: String {
		"On / Off"
	}

	override public final func isValid(value: Any?) -> Bool {
		(value == nil && optional) || value as? Bool != nil
	}

	override public final func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Bool else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue ? "on" : "off"
	}

	override public final func typedValuesAreEqual(_ first: Bool, _ second: Bool) -> Bool {
		first == second
	}
}
