//
//  FrequencyAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 10/8/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class FrequencyAttribute: AttributeBase<Frequency>, ComparableAttribute {
	public final override var typeName: String {
		"Frequency"
	}

	public override init(
		id: Int16,
		name: String = "Frequency",
		pluralName: String? = "Frequencies",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false
	) {
		super.init(
			id: id,
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	public final override func isValid(value: Any?) -> Bool {
		(value == nil && optional) || value as? Frequency != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Frequency else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}

	public final override func typedValuesAreEqual(_ first: Frequency, _ second: Frequency) -> Bool {
		first == second
	}
}
