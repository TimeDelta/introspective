//
//  FrequencyAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 10/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class FrequencyAttribute: AttributeBase, ComparableAttribute {

	public override init(
		name: String = "Frequency",
		pluralName: String? = "Frequencies",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Frequency else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}
}
