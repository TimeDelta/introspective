//
//  StoredQuery.swift
//  Queries
//
//  Created by Bryan Nova on 6/29/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import BooleanAlgebra
import Common
import DependencyInjection
import Persistence
import Samples

public final class StoredQuery: NSManagedObject, CoreDataObject {
	private typealias Me = StoredQuery
	public static let entityName = "Query"

	public final func convert() throws -> Query {
		let sampleType = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		let query = try injected(QueryFactory.self).queryFor(sampleType)
		query.expression = try storedExpression.convert()
		return query
	}

	public final func populate(from other: Query, withName name: String) throws {
		guard let expression = other.expression else {
			throw GenericDisplayableError(title: "Invalid Query", description: "Query must be valid before saving")
		}
		self.name = name
		let sampleType = try injected(QueryFactory.self).sampleTypeFor(other)
		storedExpression = try expression.stored(for: sampleType)
	}
}

extension StoredQuery {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<StoredQuery> {
		NSFetchRequest<StoredQuery>(entityName: Me.entityName)
	}

	@NSManaged public var name: String
	/// See QueryFactory.sampleType(for id: Int16) -> Sample.Type
	@NSManaged public var sampleTypeId: Int16
	@NSManaged public var storedExpression: StoredBooleanExpression
}
