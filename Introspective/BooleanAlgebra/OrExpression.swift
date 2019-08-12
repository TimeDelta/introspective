//
//  OrExpression.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

public final class OrExpression: BooleanExpression {

	// MARK: - Display Information

	public final var description: String {
		guard let left = expression1, let right = expression2 else { return "OR" }
		return left.description + " OR " + right.description
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
		return expression1Value || expression2Value
	}

	public final func copy() -> BooleanExpression {
		return OrExpression(expression1.copy(), expression2.copy())
	}

	public final func equalTo(_ other: BooleanExpression) -> Bool {
		guard let otherOr = other as? OrExpression else { return false }
		return expression1.equalTo(otherOr.expression1) && expression2.equalTo(otherOr.expression2)
	}

	public final func isValid() -> Bool {
		guard let left = expression1, let right = expression2 else {
			return false
		}
		return left.isValid() && right.isValid()
	}

	public final func predicate() -> NSPredicate? {
		guard let subPredicate1 = expression1.predicate() else { return nil }
		guard let subPredicate2 = expression2.predicate() else { return nil }
		return NSCompoundPredicate(orPredicateWithSubpredicates: [subPredicate1, subPredicate2])
	}
}
