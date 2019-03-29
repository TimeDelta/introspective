//
//  SelectOneAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol SelectOneAttribute: SelectAttribute {

	func valuesAreEqual(_ first: Any?, _ second: Any?) -> Bool
}

public class TypedSelectOneAttribute<Type>: AttributeBase, SelectOneAttribute {

	// MARK: - Instance Variables

	private final let _typedPossibleValues: [Type]?
	private final let possibleValuesFunction: (() -> [Type])?
	public final var possibleValues: [Any] { return typedPossibleValues }
	public final var typedPossibleValues: [Type] {
		if let _typedPossibleValues = _typedPossibleValues {
			return _typedPossibleValues
		}
		if let possibleValuesFunction = possibleValuesFunction {
			return possibleValuesFunction()
		}
		log.error("Unable to determine possible values for multiselect attribute")
		return []
	}

	public final let areEqual: (Type, Type) -> Bool

	private final let possibleValueToString: (Type) -> String

	private final let log = Log()

	// MARK: - Initializers

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
		_typedPossibleValues = possibleValues
		possibleValuesFunction = nil
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: @escaping () -> [Type],
		possibleValueToString: @escaping (Type) -> String,
		areEqual: @escaping (Type, Type) -> Bool)
	{
		_typedPossibleValues = nil
		possibleValuesFunction = possibleValues
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		super.init( name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	// MARK: - Select Attribute Functions

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? Type else { return nil }
		let values: [Type] = (values as? [Type]) ?? typedPossibleValues
		return values.index(where: { self.areEqual(castedValue, $0) })
	}

	// MARK: - Attribute Functions

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Type else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return possibleValueToString(castedValue)
	}

	// MARK: - Select One Attribute Functions

	public final func valuesAreEqual(_ first: Any?, _ second: Any?) -> Bool {
		guard let first = first else { return second == nil }
		guard let second = second else { return false }
		guard let castedFirst = first as? Type else {
			log.error("Failed to cast first value when testing equality: %@", String(describing: first))
			return false
		}
		guard let castedSecond = second as? Type else {
			log.error("Failed to cast second value when testing equality: %@", String(describing: first))
			return false
		}
		return areEqual(castedFirst, castedSecond)
	}

	// MARK: - Equality

	public final func equalTo(_ otherAttribute: Attribute) -> Bool {
		guard let other = otherAttribute as? TypedSelectOneAttribute<Type> else { return false }
		return super.equalTo(otherAttribute) &&
			possibleValues.elementsEqual(other.possibleValues, by: valuesAreEqual)
	}
}

public class TypedEquatableSelectOneAttribute<Type: Equatable>: TypedSelectOneAttribute<Type> {

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String)
	{
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: possibleValues,
			possibleValueToString: possibleValueToString,
			areEqual: { $0 == $1 })
	}
}
