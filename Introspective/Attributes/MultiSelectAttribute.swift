//
//  MultiSelectAttribute.swift
//  Introspective
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol MultiSelectAttribute: SelectAttribute {

	func valueAsArray(_ value: Any) throws -> [Any]
	func valueFromArray(_ value: [Any]) throws -> Any
	func convertPossibleValueToDisplayableString(_ value: Any) throws -> String
}

public class TypedMultiSelectAttribute<Type: Hashable>: AttributeBase, MultiSelectAttribute {

	public final var possibleValues: [Any] { return typedPossibleValues }
	public final let typedPossibleValues: [Type]

	fileprivate final let possibleValueToString: (Type) -> String

	public init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String)
	{
		self.typedPossibleValues = possibleValues
		self.possibleValueToString = possibleValueToString
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional)
	}

	public final func valueAsArray(_ value: Any) throws -> [Any] {
		if let castedValue = value as? Set<Type> {
			return castedValue.map { v in return v }
		}
		if let castedValue = value as? [Type] {
			return castedValue
		}
		throw AttributeError.unsupportedValue
	}

	public final func valueFromArray(_ value: [Any]) throws -> Any {
		guard let castedValue = value as? [Type] else { throw AttributeError.typeMismatch }
		return Set<Type>(castedValue)
	}

	public final func indexOf(possibleValue: Any, in values: [Any]? = nil) -> Int? {
		guard let castedValue = possibleValue as? Type else {
			return nil
		}
		let values: [Type] = (values as? [Type]) ?? typedPossibleValues
		return values.index(of: castedValue)
	}

	public func convertPossibleValueToDisplayableString(_ value: Any) throws -> String {
		guard let castedValue = value as? Type else { throw AttributeError.typeMismatch }
		return possibleValueToString(castedValue)
	}

	public override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
		if let castedValue = value as? Set<Type> {
			let arrayOfTypes = castedValue.map{ $0 }
			return convertTypesIntoDisplayString(arrayOfTypes)
		}
		if let castedValue = value as? [Type] {
			return convertTypesIntoDisplayString(castedValue)
		}
		if let castedValue = value as? Type {
			return possibleValueToString(castedValue)
		}
		throw AttributeError.typeMismatch
	}

	fileprivate final func convertTypesIntoDisplayString(_ sortedTypes: [Type]) -> String {
		var text = ""
		let valueStrings = sortedTypes.map{ possibleValueToString($0) }
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

public class ComparableTypedMultiSelectAttribute<Type: Hashable & Comparable>: TypedMultiSelectAttribute<Type> {

	public override init(
		name: String,
		pluralName: String? = nil,
		description: String? = nil,
		variableName: String? = nil,
		optional: Bool = false,
		possibleValues: [Type] = [Type](),
		possibleValueToString: @escaping (Type) -> String)
	{
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName, optional: optional, possibleValues: possibleValues, possibleValueToString: possibleValueToString)
	}

	public final override func convertToDisplayableString(from value: Any?) throws -> String {
		if optional && value == nil { return "" }
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
		throw AttributeError.typeMismatch
	}
}
