//
//  AndExpression.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class AndExpression: BooleanExpression {

	// MARK: - Display Information

	public final var description: String {
		return expression1.description + " AND " + expression2.description
	}

	// MARK: - Instance Variables

	public final var expression1: BooleanExpression!
	public final var expression2: BooleanExpression!

	// MARK: - Initializers

	public init() {}

	public init(_ expression1: BooleanExpression, _ expression2: BooleanExpression) {
		self.expression1 = expression1
		self.expression2 = expression2
	}

	// MARK: - Functions

	public final func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool {
		let expression1Value = try expression1.evaluate(parameters)
		let expression2Value = try expression2.evaluate(parameters)
		return expression1Value && expression2Value
	}

	public final func equalTo(_ other: BooleanExpression) -> Bool {
		guard let otherAnd = other as? AndExpression else { return false }
		return expression1.equalTo(otherAnd.expression1) && expression2.equalTo(otherAnd.expression2)
	}
}
