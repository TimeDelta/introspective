import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

public protocol StoredQueriesDAO {
	func getQueryWith(name: String) throws -> StoredQuery?
	func getAllQueries() throws -> [StoredQuery]
	func save(_ query: Query, name: String) throws
	func rename(_ query: StoredQuery, to name: String) throws
	func delete(_ query: StoredQuery) throws
}

public final class StoredQueriesDAOImpl: StoredQueriesDAO {
	public init() {}

	public static func validName(_ value: String) throws -> String {
		let name = value.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !name.isEmpty else { throw GenericError("Enter a name for the query.") }
		return name
	}

	public func getQueryWith(name: String) throws -> StoredQuery? {
		let request = StoredQuery.fetchRequest()
		request.predicate = NSPredicate(format: "parentQuery == nil AND name ==[cd] %@", try Self.validName(name))
		return try injected(Database.self).query(request).first
	}

	public func getAllQueries() throws -> [StoredQuery] {
		let request = StoredQuery.fetchRequest()
		request.predicate = NSPredicate(format: "parentQuery == nil")
		request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
		return try injected(Database.self).query(request)
	}

	public func save(_ query: Query, name: String) throws {
		let name = try Self.validName(name)
		guard try getQueryWith(name: name) == nil else { throw GenericError("A saved query already has that name.") }
		let transaction = injected(Database.self).transaction()
		_ = try query.stored(withName: name, using: transaction)
		try transaction.commit()
	}

	public func rename(_ query: StoredQuery, to name: String) throws {
		let name = try Self.validName(name)
		if let existing = try getQueryWith(name: name), existing.objectID != query.objectID {
			throw GenericError("A saved query already has that name.")
		}
		let transaction = injected(Database.self).transaction()
		try transaction.pull(savedObject: query).name = name
		try transaction.commit()
	}

	public func delete(_ query: StoredQuery) throws {
		let transaction = injected(Database.self).transaction()
		try transaction.delete(transaction.pull(savedObject: query))
		try transaction.commit()
	}
}
