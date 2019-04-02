//
//  DurationAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public final class DurationAttribute: AttributeBase, ComparableAttribute {

	// MARK: - Initializers

	public override init(
		name: String = "Duration",
		pluralName: String? = "Durations",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	// MARK: - Attribute Functions

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? Duration != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Duration else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}
}
