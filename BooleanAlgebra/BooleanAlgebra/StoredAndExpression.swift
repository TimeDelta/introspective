//
//  StoredAndExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/27/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence

public final class StoredAndExpression: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredAndExpression
	public static let entityName = "AndExpression"

	public override func convert() throws -> BooleanExpression {
		AndExpression(try storedExpression1.convert(), try storedExpression2.convert())
	}

	public func populate(from other: AndExpression) throws {
		storedExpression1 = try other.expression1.stored()
		storedExpression2 = try other.expression2.stored()
	}
}

extension StoredAndExpression {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredAndExpression> {
		return NSFetchRequest<StoredAndExpression>(entityName: Me.entityName)
	}

	@NSManaged var storedExpression1: StoredBooleanExpression
	@NSManaged var storedExpression2: StoredBooleanExpression
}
