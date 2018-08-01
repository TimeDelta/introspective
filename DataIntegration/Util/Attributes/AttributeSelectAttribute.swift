//
//  AttributeSelectAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/31/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public class AttributeSelectAttribute: AnyAttribute, SelectOneAttribute {

	public fileprivate(set) var possibleValues: [Any]

	public required init(name: String, description: String? = nil) {
		self.possibleValues = [Attribute]()
		super.init(name: name, description: description)
	}

	public init(name: String, description: String? = nil, attributes: [Attribute]) {
		self.possibleValues = attributes
		super.init(name: name, description: description)
	}

	/// Is the specified value valid for this attribute?
	public override func isValid(value: String) -> Bool {
		return possibleValues.contains(where: { a in return (a as! Attribute).name == value })
	}

	public override func errorMessageFor(invalidValue: String) -> String {
		return "\"\(invalidValue)\" is not an acceptable attribute"
	}

	public override func convertToValue(from strValue: String) throws -> Any {
		let attribute = (possibleValues as! [Attribute]).first(where: { attribute in return attribute.name == strValue })
		if attribute == nil {
			throw AttributeError.unsupportedValue
		}
		return attribute!
	}

	public override func convertToString(from value: Any) throws -> String {
		guard let castedValue = value as? AnyAttribute else { throw AttributeError.typeMismatch }
		return castedValue.name
	}

	public func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? AnyAttribute else { return nil }
		return (possibleValues as! [Attribute]).firstIndex(where: { attribute in return attribute.name == castedValue.name })
	}
}
