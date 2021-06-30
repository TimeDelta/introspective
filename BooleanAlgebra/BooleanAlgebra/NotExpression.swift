//
//  NotExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 7/31/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

public final class NotExpression: BooleanExpression {
	// MARK: - Display Information

	public final var description: String {
		guard let subExpression = subExpression else { return "NOT" }
		return "NOT " + subExpression.description
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
		!(try subExpression.evaluate(parameters))
	}

	public final func copy() -> BooleanExpression {
		NotExpression(subExpression.copy())
	}

	public final func equalTo(_ other: BooleanExpression) -> Bool {
		guard let other = other as? NotExpression else { return false }
		return subExpression.equalTo(other.subExpression)
	}

	public final func isValid() -> Bool {
		guard let subExpression = subExpression else {
			return false
		}
		return subExpression.isValid()
	}

	public final func predicate() -> NSPredicate? {
		guard let subPredicate = subExpression.predicate() else { return nil }
		return NSCompoundPredicate(notPredicateWithSubpredicate: subPredicate)
	}

	public final func stored() throws -> StoredBooleanExpression {
		let transaction = injected(Database.self).transaction()
		let stored = try transaction.new(StoredNotExpression.self)
		try stored.populate(from: self)
		try transaction.commit()
		return stored
	}
}
