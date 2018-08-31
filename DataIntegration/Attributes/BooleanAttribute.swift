//
//  BooleanAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/20/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class BooleanAttribute: AttributeBase {

	public required init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func isValid(value: String) -> Bool {
		return Bool(value) != nil
	}

	public final override func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not on or off"
	}

	public final override func convertToValue(from strValue: String) throws -> Any {
		if !isValid(value: strValue) { throw  AttributeError.unsupportedValue }
		return Bool(strValue)!
	}

	public final override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Bool else { throw AttributeError.typeMismatch }
		return castedValue ? "on" : "off"
	}
}
