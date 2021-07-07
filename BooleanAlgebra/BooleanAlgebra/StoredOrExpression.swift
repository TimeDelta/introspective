//
//  StoredOrExpression.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/29/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredOrExpression: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredOrExpression
	public static let entityName = "OrExpression"

	public override func convert() throws -> BooleanExpression {
		OrExpression(try storedExpression1.convert(), try storedExpression2.convert())
	}

	public func populate(from other: OrExpression, for sampleType: Sample.Type) throws {
		storedExpression1 = try other.expression1.stored(for: sampleType)
		storedExpression2 = try other.expression2.stored(for: sampleType)
	}
}

extension StoredOrExpression {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredOrExpression> {
		NSFetchRequest<StoredOrExpression>(entityName: Me.entityName)
	}

	@NSManaged public var storedExpression1: StoredBooleanExpression
	@NSManaged public var storedExpression2: StoredBooleanExpression
}
