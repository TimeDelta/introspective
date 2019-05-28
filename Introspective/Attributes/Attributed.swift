//
//  Attributed.swift
//  Introspective
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Attributed: class, CustomStringConvertible, CustomDebugStringConvertible {

	var attributedName: String { get }
	var attributes: [Attribute] { get }

	func attributeValuesAreValid() -> Bool
	func value(of attribute: Attribute) throws -> Any?
	func set(attribute: Attribute, to value: Any?) throws

	func equalTo(_ otherAttributed: Attributed) -> Bool
}

extension Attributed {

	public var debugDescription: String { return description }

	public func attributeValuesAreValid() -> Bool {
		for attribute in attributes {
			do {
				if !attribute.isValid(value: try value(of: attribute)) {
					return false
				}
			} catch {
				Log().error(
					"Failed to get value of %@ from %@ while validating attribute values: %@",
					attribute.name,
					attributedName,
					errorInfo(error))
				return false
			}
		}
		return true
	}

	#warning("does this allow equality with Optional version?")
	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if type(of: self) != type(of: otherAttributed) { return false }
		if attributedName != otherAttributed.attributedName { return false }
		return true
	}
}
