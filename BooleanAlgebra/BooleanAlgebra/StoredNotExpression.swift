//
//  StoredNotExpression.swift
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

public final class StoredNotExpression: StoredBooleanExpression, CoreDataObject {

	private typealias Me = StoredNotExpression
	public static let entityName = "NotExpression"

	public override func convert() throws -> BooleanExpression {
		NotExpression(try storedSubExpression.convert())
	}

	public func populate(from other: NotExpression, for sampleType: Sample.Type) throws {
		storedSubExpression = try other.subExpression.stored(for: sampleType)
	}
}

extension StoredNotExpression {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredNotExpression> {
		return NSFetchRequest<StoredNotExpression>(entityName: Me.entityName)
	}

	@NSManaged public var storedSubExpression: StoredBooleanExpression
}
