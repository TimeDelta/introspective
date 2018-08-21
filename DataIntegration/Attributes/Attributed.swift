//
//  Attributed.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Attributed: class, CustomStringConvertible {

	var name: String { get }
	var attributes: [Attribute] { get }

	func value(of attribute: Attribute) throws -> Any
	func set(attribute: Attribute, to value: Any) throws

	func equalTo(_ otherAttributed: Attributed) -> Bool
}

extension Attributed {

	public func equalTo(_ otherAttributed: Attributed) -> Bool {
		if type(of: self) != type(of: otherAttributed) { return false }
		if name != otherAttributed.name { return false }
		return true
	}
}
