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

	public func populate(from other: BooleanExpressionGroup, for sampleType: Sample.Type) throws {
		storedSubExpression = try other.subExpression.stored(for: sampleType)
	}
}

extension StoredBooleanExpressionGroup {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredBooleanExpressionGroup> {
		return NSFetchRequest<StoredBooleanExpressionGroup>(entityName: Me.entityName)
	}

	@NSManaged public var storedSubExpression: StoredBooleanExpression
}
