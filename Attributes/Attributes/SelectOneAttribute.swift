//
//  SelectOneAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public protocol SelectOneAttribute: SelectAttribute {}

open class TypedSelectOneAttribute<Type>: AttributeBase<Type>, SelectOneAttribute {
	// MARK: - Instance Variables

	private final let _typedPossibleValues: [Type]?
	private final let possibleValuesFunction: (() -> [Type])?
	public final var possibleValues: [Any] { typedPossibleValues }
	public final var typedPossibleValues: [Type] {
		if let _typedPossibleValues = _typedPossibleValues {
			return _typedPossibleValues
		}
		if let possibleValuesFunction = possibleValuesFunction {
			return possibleValuesFunction()
		}
		Log().error("Unable to determine possible values for multiselect attribute")
		return []
	}

	private final let _typeName: String
	public final override var typeName: String {
		_typeName
	}

	public final let areEqual: (Type, Type) -> Bool

	private final let possibleValueToString: (Type) -> String

	// MARK: - Initializers

	public init(
		id: Int16,
		name: String,
		typeName: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String,
		areEqual: @escaping (Type, Type) -> Bool
	) {
		_typedPossibleValues = possibleValues
		possibleValuesFunction = nil
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		_typeName = typeName
		super.init(
			id: id,
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	public init(
		id: Int16,
		name: String,
		typeName: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: @escaping () -> [Type],
		possibleValueToString: @escaping (Type) -> String,
		areEqual: @escaping (Type, Type) -> Bool
	) {
		_typedPossibleValues = nil
		possibleValuesFunction = possibleValues
		self.possibleValueToString = possibleValueToString
		self.areEqual = areEqual
		_typeName = typeName
		super.init(
			id: id,
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	// MARK: - Select Attribute Functions

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? Type else { return nil }
		let values: [Type] = (values as? [Type]) ?? typedPossibleValues
		return values.firstIndex(where: { self.areEqual(castedValue, $0) })
	}

	// MARK: - Attribute Functions

	public final override func isValid(value: Any?) -> Bool {
		if let nonNilValue = value {
			return indexOf(possibleValue: nonNilValue) != nil
		}
		return optional
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		guard let castedValue = value as? Type else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return possibleValueToString(castedValue)
	}

	// MARK: - Select One Attribute Functions

	public final override func typedValuesAreEqual(_ first: Type, _ second: Type) -> Bool {
		areEqual(first, second)
	}

	// MARK: - Equality

	public final func equalTo(_ otherAttribute: Attribute) -> Bool {
		guard let other = otherAttribute as? TypedSelectOneAttribute<Type> else { return false }
		if !super.equalTo(otherAttribute) { return false }
		return (try? possibleValues.elementsEqual(other.possibleValues, by: valuesAreEqual)) ?? false
	}
}

public class TypedEquatableSelectOneAttribute<Type: Equatable>: TypedSelectOneAttribute<Type> {
	public init(
		id: Int16,
		name: String,
		typeName: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String
	) {
		super.init(
			id: id,
			name: name,
			typeName: typeName,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: possibleValues,
			possibleValueToString: possibleValueToString,
			areEqual: { $0 == $1 }
		)
	}
}
