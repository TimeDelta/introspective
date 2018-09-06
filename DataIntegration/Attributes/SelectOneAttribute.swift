//
//  SelectOneAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SelectOneAttribute: SelectAttribute {
}

public class TypedSelectOneAttribute<Type>: AttributeBase, SelectOneAttribute {

	public final var possibleValues: [Any] { return typedPossibleValues }
	public final let typedPossibleValues: [Type]

	private final let possibleValueToString: (Type) -> String
	private final let areEqual: (Type, Type) -> Bool

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String,
		areEqual: @escaping (Type, Type) -> Bool)
	{
		self.typedPossibleValues = possibleValues
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final func indexOf(possibleValue: Any) -> Int? {
		guard let castedValue = possibleValue as? Type else {
			return nil
		}
		return typedPossibleValues.index(where: { self.areEqual(castedValue, $0) })
	}

	public final override func convertToDisplayableString(from value: Any) throws -> String {
		guard let castedValue = value as? Type else { throw AttributeError.typeMismatch }
		return possibleValueToString(castedValue)
	}
}
