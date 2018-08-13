//
//  IntegerAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class IntegerAttribute: AnyAttribute, NumericAttribute {

	public required init(name: String, pluralName: String? = nil, description: String? = nil) {
		super.init(name: name, pluralName: pluralName, description: description)
	}

	public override func isValid(value: String) -> Bool {
		return Int(value) != nil
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\(invalidValue) is not an integer"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		if !isValid(value: strValue) { throw  AttributeError.unsupportedValue }
		return Int(strValue)!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? Int else { throw AttributeError.typeMismatch }
		return String(castedValue)
	}
}
