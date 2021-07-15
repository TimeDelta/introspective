//
//  StoredAndExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/27/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredAndExpression: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredAndExpression
	public static let entityName = "AndExpression"

	public override func convert() throws -> BooleanExpression {
		AndExpression(try storedExpression1.convert(), try storedExpression2.convert())
	}

	public func populate(
		from other: AndExpression,
		for sampleType: Sample.Type,
		using transaction: Transaction
	) throws {
		storedExpression1 = try other.expression1.stored(for: sampleType, using: transaction)
		storedExpression2 = try other.expression2.stored(for: sampleType, using: transaction)
	}
}

extension StoredAndExpression {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredAndExpression> {
		NSFetchRequest<StoredAndExpression>(entityName: Me.entityName)
	}

	@NSManaged var storedExpression1: StoredBooleanExpression
	@NSManaged var storedExpression2: StoredBooleanExpression
}
