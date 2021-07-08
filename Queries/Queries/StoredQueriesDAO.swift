//
//  StoredQueriesDAO.swift
//  Queries
//
//  Created by Bryan Nova on 7/3/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import DependencyInjection
import Persistence

public protocol StoredQueriesDAO {
	func getQueryWith(name: String) throws -> StoredQuery?
	func getAllQueries() throws -> [StoredQuery]
}

public final class StoredQueriesDAOImpl: StoredQueriesDAO {
	public func getQueryWith(name: String) throws -> StoredQuery? {
		let request: NSFetchRequest<StoredQuery> = StoredQuery.fetchRequest()
		request.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let transaction = injected(Database.self).transaction()
		let queries = try transaction.query(request)
		guard queries.count > 0 else { return nil }
		return queries[0]
	}

	public func getAllQueries() throws -> [StoredQuery] {
		let transaction = injected(Database.self).transaction()
		return try transaction.query(StoredQuery.fetchRequest())
	}
}
