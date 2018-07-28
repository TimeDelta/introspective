//
//  MultiSelectParameter.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol MultiSelectParameter: SelectParameter {

	// this is not static so that it can be used in a default implementation in the below extension
	var separator: Character { get }

	func splitMultiSelect(value: String) -> [String]
	func combineMultiSelect(values: [String]) -> String
	func valueAsArray(_ value: Any) throws -> [Any]
	func valueFromArray(_ value: [Any]) throws -> Any
}

extension MultiSelectParameter {

	public func isValid(value: String) -> Bool {
		let possibleValueStrings = possibleValues.map { value in return try! convertToString(from: value) }
		let setOfPossibleValues = Set<String>(possibleValueStrings)
		for subValue in value.split(separator: separator) {
			if !setOfPossibleValues.contains(String(subValue)) {
				return false
			}
		}
		return true
	}

	public func splitMultiSelect(value: String) -> [String] {
		return value.split(separator: separator).map { v in return String(v) }
	}

	public func combineMultiSelect(values: [String]) -> String {
		return values.joined(separator: String(separator))
	}
}
