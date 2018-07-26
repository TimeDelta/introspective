//
//  Parameterized.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

public protocol Parameterized: CustomStringConvertible {

	static var name: String { get }
	static var parameters: [Parameter] { get }

	init()

	func get(parameter: Parameter) throws -> String
	func set(parameter: Parameter, to value: Any) throws
}
