//
//  SelectOneAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import os

public protocol SelectOneAttribute: SelectAttribute {

	func valuesAreEqual(_ first: Any?, _ second: Any?) -> Bool
}

public class TypedSelectOneAttribute<Type>: AttributeBase, SelectOneAttribute {

	public final var possibleValues: [Any] { return typedPossibleValues }
	public final let typedPossibleValues: [Type]

	public final let areEqual: (Type, Type) -> Bool

	private final let possibleValueToString: (Type) -> String

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String,
		areEqual: @escaping (Type, Type) -> Bool)
	{
		self.typedPossibleValues = possibleValues
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? Type else { return nil }
		return typedPossibleValues.index(where: { self.areEqual(castedValue, $0) })
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		guard let castedValue = value as? Type else { throw AttributeError.typeMismatch }
		return possibleValueToString(castedValue)
	}

	public final func valuesAreEqual(_ first: Any?, _ second: Any?) -> Bool {
		guard let castedFirst = first as? Type else {
			os_log("Failed to cast first value when testing equality: %@", type: .error, String(describing: first))
			return false
		}
		guard let castedSecond = second as? Type else {
			os_log("Failed to cast second value when testing equality: %@", type: .error, String(describing: first))
			return false
		}
		return areEqual(castedFirst, castedSecond)
	}
}
