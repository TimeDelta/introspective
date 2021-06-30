//
//  StoredOrExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/29/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence

public final class StoredOrExpression: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredOrExpression
	public static let entityName = "OrExpression"

	public override func convert() throws -> BooleanExpression {
		return OrExpression(try storedExpression1.convert(), try storedExpression2.convert())
	}

	public func populate(from other: OrExpression) throws {
		storedExpression1 = try other.expression1.stored()
		storedExpression2 = try other.expression2.stored()
	}
}

extension StoredOrExpression {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredOrExpression> {
		return NSFetchRequest<StoredOrExpression>(entityName: Me.entityName)
	}

	@NSManaged public var storedExpression1: StoredBooleanExpression
	@NSManaged public var storedExpression2: StoredBooleanExpression
}
