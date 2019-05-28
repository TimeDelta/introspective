//
//  BooleanExpression.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public protocol BooleanExpression: CustomStringConvertible {

	func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool
	func isValid() -> Bool
	/// create and return a deep copy of this object
	func copy() -> BooleanExpression
	func equalTo(_ other: BooleanExpression) -> Bool
}

extension BooleanExpression {

	public func evaluate() throws -> Bool {
		return try evaluate(nil)
	}
}
