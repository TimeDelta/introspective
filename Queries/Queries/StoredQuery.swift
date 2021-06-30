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
import DependencyInjection
import Persistence
import Samples

public final class StoredQuery: NSManagedObject, CoreDataObject {

	public static let entityName = "Query"

	public final func convert() throws -> Query {
		let sampleType = injected(SampleFactory.self).sampleType(for: sampleTypeId)
		let query = try injected(QueryFactory.self).queryFor(sampleType)
		query.expression = try storedExpression.convert()
		return query
	}
}

extension StoredQuery {

	@NSManaged public var name: String
	/// See QueryFactory.sampleType(for id: Int16) -> Sample.Type
	@NSManaged public var sampleTypeId: Int16
	@NSManaged public var storedExpression: StoredBooleanExpression
}
