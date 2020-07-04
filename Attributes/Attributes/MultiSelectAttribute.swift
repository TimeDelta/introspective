//
//  MultiSelectAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import Common

// MARK: - MultiSelectAttribute

public protocol MultiSelectAttribute: SelectAttribute {
	func valueAsArray(_ value: Any) throws -> [Any]
	func valueFromArray(_ value: [Any]) throws -> Any
	func convertPossibleValueToDisplayableString(_ value: Any) throws -> String
}

// MARK: - TypedMultiSelectAttribute

open class TypedMultiSelectAttribute<ValueType: Hashable>: AttributeBase<ValueType>, MultiSelectAttribute {
	// MARK: Instance Variables

	private final let _typedPossibleValues: [ValueType]?
	private final let possibleValuesFunction: (() -> [ValueType])?
	public final var possibleValues: [Any] { typedPossibleValues }
	public final var typedPossibleValues: [ValueType] {
		if let _typedPossibleValues = _typedPossibleValues {
			return _typedPossibleValues
		}
		if let possibleValuesFunction = possibleValuesFunction {
			return possibleValuesFunction()
		}
		log.error("Unable to determine possible values for multiselect attribute")
		return []
	}

	fileprivate final let possibleValueToString: (ValueType) -> String

	private final let log = Log()

	// MARK: Initializers

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [ValueType] = [ValueType](),
		possibleValueToString: @escaping (ValueType) -> String
	) {
		_typedPossibleValues = possibleValues
		possibleValuesFunction = nil
		self.possibleValueToString = possibleValueToString
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: @escaping () -> [ValueType],
		possibleValueToString: @escaping (ValueType) -> String
	) {
		_typedPossibleValues = nil
		possibleValuesFunction = possibleValues
		self.possibleValueToString = possibleValueToString
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional
		)
	}

	// MARK: MultiSelectAttribute Functions

	public final func valueAsArray(_ value: Any) throws -> [Any] {
		if let castedValue = value as? Set<ValueType> {
			return castedValue.map { $0 }
		}
		if let castedValue = value as? [ValueType] {
			return castedValue
		}
		throw UnsupportedValueError(attribute: self, is: value)
	}

	public final func valueFromArray(_ value: [Any]) throws -> Any {
		guard let castedValue = value as? [ValueType] else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return Set<ValueType>(castedValue)
	}

	// MARK: SelectAttribute Functions

	override public final func isValid(value: Any?) -> Bool {
		if let nonNilValue = value {
			if let castedValues = nonNilValue as? [ValueType] {
				return allValuesArePossible(castedValues)
			} else if let castedValues = value as? Set<ValueType> {
				return allValuesArePossible(castedValues)
			}
			return false
		}
		return optional
	}

	private final func allValuesArePossible<C: Collection>(_ values: C) -> Bool where C.Element == ValueType {
		if values.isEmpty {
			return optional
		}
		for currentValue in values {
			if indexOf(possibleValue: currentValue) == nil {
				return false
			}
		}
		return true
	}

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? ValueType else {
			return nil
		}
		let values: [ValueType] = (values as? [ValueType]) ?? typedPossibleValues
		return values.index(of: castedValue)
	}

	public func convertPossibleValueToDisplayableString(_ value: Any) throws -> String {
		guard let castedValue = value as? ValueType else {
			throw TypeMismatchError(attribute: self, wasA: type(of: value))
		}
		return possibleValueToString(castedValue)
	}

	// MARK: Attribute Functions

	override public final func typedValuesAreEqual(_ first: ValueType, _ second: ValueType) -> Bool {
		first == second
	}

	override open func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		if let castedValue = value as? Set<ValueType> {
			let arrayOfTypes = castedValue.map { $0 }
			return convertTypesIntoDisplayString(arrayOfTypes)
		}
		if let castedValue = value as? [ValueType] {
			return convertTypesIntoDisplayString(castedValue)
		}
		if let castedValue = value as? ValueType {
			return possibleValueToString(castedValue)
		}
		throw TypeMismatchError(attribute: self, wasA: type(of: value))
	}

	fileprivate final func convertTypesIntoDisplayString(_ sortedTypes: [ValueType]) -> String {
		var text = ""
		let valueStrings = sortedTypes.map { possibleValueToString($0) }
		for index in 0 ..< valueStrings.count {
			if index > 0 && index < valueStrings.count - 1 {
				text += ", "
			}
			if index == valueStrings.count - 1 && valueStrings.count > 1 {
				text += " or "
			}
			text += valueStrings[index]
		}
		return text
	}
}

// MARK: - ComparableTypedMultiSelectAttribute

public class ComparableTypedMultiSelectAttribute<Type: Hashable & Comparable>: TypedMultiSelectAttribute<Type> {
	override public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String
	) {
		super.init(
			name: name,
			pluralName: pluralName,
			description: description,
			variableName: variableName,
			optional: optional,
			possibleValues: possibleValues,
			possibleValueToString: possibleValueToString
		)
	}

	override public final func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if !optional && value == nil { throw UnsupportedValueError(attribute: self, is: nil) }
		if let castedValue = value as? Set<Type> {
			let sortedTypes = castedValue.sorted(by: { $0 < $1 })
			return convertTypesIntoDisplayString(sortedTypes)
		}
		if let castedValue = value as? [Type] {
			let sortedTypes = castedValue.sorted(by: { $0 < $1 })
			return convertTypesIntoDisplayString(sortedTypes)
		}
		if let castedValue = value as? Type {
			return possibleValueToString(castedValue)
		}
		throw TypeMismatchError(attribute: self, wasA: type(of: value))
	}
}
