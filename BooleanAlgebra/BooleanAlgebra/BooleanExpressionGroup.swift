//
//  BooleanExpressionGroup.swift
//  Introspective
//
//  Created by Bryan Nova on 4/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation

import Common
import DependencyInjection
import Persistence
import Samples

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
		try subExpression.evaluate(parameters)
	}

	public final func copy() -> BooleanExpression {
		BooleanExpressionGroup(subExpression.copy())
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
		subExpression.predicate()
	}

	public final func stored(
		for sampleType: Sample.Type,
		using transaction: Transaction?
	) throws -> StoredBooleanExpression {
		let transaction = transaction ?? injected(Database.self).transaction()
		let stored = try transaction.new(StoredBooleanExpressionGroup.self)
		try stored.populate(from: self, for: sampleType, using: transaction)
		try transaction.commit()
		return stored
	}
}
