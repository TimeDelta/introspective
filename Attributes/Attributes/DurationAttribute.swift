//
//  DurationAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 11/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class DurationAttribute: AttributeBase<Duration>, ComparableAttribute, GraphableAttribute {
	override public final var typeName: String {
		"Duration"
	}

	// MARK: - Initializers

	override public init(
		name: String = "Duration",
		pluralName: String? = "Durations",
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

	// MARK: - Attribute Functions

	override public final func isValid(value: Any?) -> Bool {
		(value == nil && optional) || value as? Duration != nil
	}

	override public final func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Duration else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return castedValue.description
	}

	override public final func typedValuesAreEqual(_ first: Duration, _ second: Duration) -> Bool {
		first == second
	}

	// MARK: - GraphableAttribute Functions

	public final func graphableValueFor(_ value: Any) throws -> Double {
		guard let duration = value as? Duration else {
			throw GenericError("Passed \(String(describing: value)) to graphableValueFor()")
		}
		return duration.inUnit(.hour)
	}
}
