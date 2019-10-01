//
//  BooleanExpressionGroup.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common

public final class BooleanExpressionGroup: BooleanExpression {

	// MARK: - Display Information

	public final var description: String {
		guard let expression = subExpression else { return "()" }
		return "(" + expression.description + ")"
	}

	// MARK: - Instance Variables

	public final var subExpression: BooleanExpression!

	// MARK: - Initializers

	public init() {}

	public init(_ subExpression: BooleanExpression) {
		self.subExpression = subExpression
	}

	// MARK: - Functions

	public final func evaluate(_ parameters: [UserInfoKey: Any]?) throws -> Bool {
		return try subExpression.evaluate(parameters)
	}

	public final func copy() -> BooleanExpression {
		return BooleanExpressionGroup(subExpression.copy())
	}

	public final func equalTo(_ other: BooleanExpression) -> Bool {
		guard let otherGroup = other as? BooleanExpressionGroup else { return false }
		return subExpression.equalTo(otherGroup.subExpression)
	}

	public final func isValid() -> Bool {
		guard let expression = subExpression else {
			return false
		}
		return expression.isValid()
	}

	public final func predicate() -> NSPredicate? {
		return subExpression.predicate()
	}
}
