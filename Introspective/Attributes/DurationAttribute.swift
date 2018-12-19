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

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		guard let castedValue = value as? Duration else {
			throw AttributeError.typeMismatch
		}
		return castedValue.description
	}
}