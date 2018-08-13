//
//  Attributed.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Attributed: CustomStringConvertible {

	var name: String { get }
	var attributes: [Attribute] { get }

	func value(of attribute: Attribute) throws -> Any
	func set(attribute: Attribute, to value: Any) throws
}
