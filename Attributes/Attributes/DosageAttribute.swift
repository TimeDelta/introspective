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
	override public final var typeName: String {
		"Dosage"
	}

	override public init(
		name: String = "Dosage",
		pluralName: String? = "Dosages",
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false
	) {
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	override public final func isValid(value: Any?) -> Bool {
		(value == nil && optional) || value as? Dosage != nil
	}

	override public final func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Dosage else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}

	override public final func typedValuesAreEqual(_ first: Dosage, _ second: Dosage) -> Bool {
		first == second
	}
}
