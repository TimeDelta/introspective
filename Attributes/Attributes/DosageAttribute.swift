//
//  DosageAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class DosageAttribute: AttributeBase<Dosage>, ComparableAttribute {

	public final override var typeName: String {
		return "Dosage"
	}

	public override init(
		name: String = "Dosage",
		pluralName: String? = "Dosages",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final override func isValid(value: Any?) -> Bool {
		return (value == nil && optional) || value as? Dosage != nil
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Dosage else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}

	public final override func typedValuesAreEqual(_ first: Dosage, _ second: Dosage) -> Bool {
		return first == second
	}
}
