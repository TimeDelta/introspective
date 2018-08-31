//
//  MultiSelectAttribute.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol MultiSelectAttribute: SelectAttribute {

	// this is not static so that it can be used in a default implementation in the below extension
	var separator: Character { get }

	func splitMultiSelect(value: String) -> [String]
	func combineMultiSelect(values: [String]) -> String
	func valueAsArray(_ value: Any) throws -> [Any]
	func valueFromArray(_ value: [Any]) throws -> Any
}

public class AnyMultiSelectAttribute: AttributeBase, MultiSelectAttribute {

	public final let separator: Character
	public final let possibleValues: [Any]

	public required convenience init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil) {
		self.init(name: name, pluralName: pluralName, description: description, variableName: variableName, separator: " ")
	}

	public init(name: String, pluralName: String? = nil, description: String? = nil, variableName: String? = nil, separator: Character = ";", possibleValues: [Any] = [Any]()) {
		self.separator = separator
		self.possibleValues = possibleValues
		super.init(name: name, pluralName: pluralName, description: description, variableName: variableName)
	}

	public final override func isValid(value: String) -> Bool {
		let possibleValueStrings = possibleValues.map { value in return try! convertToString(from: value) }
		let setOfPossibleValues = Set<String>(possibleValueStrings)
		for subValue in value.split(separator: separator) {
			if !setOfPossibleValues.contains(String(subValue)) {
				return false
			}
		}
		return true
	}

	public final func splitMultiSelect(value: String) -> [String] {
		return value.split(separator: separator).map { v in return String(v) }
	}

	public final func combineMultiSelect(values: [String]) -> String {
		return values.joined(separator: String(separator))
	}

	public func valueAsArray(_ value: Any) throws -> [Any] { fatalError("Must override") }
	public func valueFromArray(_ value: [Any]) throws -> Any { fatalError("Must override") }
	public func indexOf(possibleValue: Any) -> Int? { fatalError("Must override") }
}
