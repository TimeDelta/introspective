//
//  StoredBooleanExpressionGroup.swift
//  BooleanAlgebra
//
//  Created by Bryan Nova on 6/30/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredBooleanExpressionGroup: StoredBooleanExpression, CoreDataObject {
	private typealias Me = StoredBooleanExpressionGroup
	public static let entityName = "BooleanExpressionGroup"

	public override func convert() throws -> BooleanExpression {
		NotExpression(try storedSubExpression.convert())
	}

	public func populate(
		from other: BooleanExpressionGroup,
		for sampleType: Sample.Type,
		using transaction: Transaction
	) throws {
		storedSubExpression = try other.subExpression.stored(for: sampleType, using: transaction)
	}
}

extension StoredBooleanExpressionGroup {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredBooleanExpressionGroup> {
		NSFetchRequest<StoredBooleanExpressionGroup>(entityName: Me.entityName)
	}

	@NSManaged public var storedSubExpression: StoredBooleanExpression
}
