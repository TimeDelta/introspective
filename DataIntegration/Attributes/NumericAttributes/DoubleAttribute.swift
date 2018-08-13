//
//  DoubleAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class DoubleAttribute: AnyAttribute, NumericAttribute {

	public required init(name: String, pluralName: String? = nil, description: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return Double(value) != nil
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not a number"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		if !isValid(value: strValue) { throw  AttributeError.unsupportedValue }
		return Double(strValue)!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Double else { throw AttributeError.typeMismatch }
		return String(castedValue)
	}
}
