//
//  AttributeSelectAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class AttributeSelectAttribute: AttributeBase, SelectOneAttribute {

	public final let possibleValues: [Any]

	public required init(name: String = "Attribute", pluralName: String? = "Attributes", description: String? = nil, variableName: String? = nil) {
		self.possibleValues = [Attribute]()
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public init(name: String = "Attribute", pluralName: String? = "Attributes", description: String? = nil, variableName: String? = nil, attributes: [Attribute]) {
		self.possibleValues = attributes
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	/// Is the specified value valid for this attribute?
	public final override func isValid(value: String) -> Bool {
		return possibleValues.contains(where: { a in return (a as! Attribute).name == value })
	}

	public final override func errorMessageFor(invalidValue: String) -> String {
		return "\"\(invalidValue)\" is not an acceptable attribute"
	}

	public final override func convertToValue(from strValue: String) throws -> Any {
		let attribute = (possibleValues as! [Attribute]).first(where: { attribute in return attribute.name == strValue })
		if attribute == nil {
			throw AttributeError.unsupportedValue
		}
		return attribute!
	}

	public final override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? AttributeBase else { throw AttributeError.typeMismatch }
		return castedValue.name
	}

	public final func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? AttributeBase else { return nil }
		return (possibleValues as! [Attribute]).index(where: { attribute in return attribute.name == castedValue.name })
	}
}
