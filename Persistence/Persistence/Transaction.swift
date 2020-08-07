//
//  Transaction.swift
//  Introspective
//
//  Created by Bryan Nova on 1/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import os

import Common
import DependencyInjection

// sourcery: AutoMockable
public protocol Transaction {
	func childTransaction() -> Transaction
	/// Save all changes done in this transaction.
	/// - Note: This only needs to be called on the topmost `Transaction`. All child transactions will automatically commit when this transaction commits
	func commit() throws
	/// Clear all uncommited changes from this `Transaction`.
	/// - Note: This is mostly useful in the case that you want to reuse a `Transaction` object.
	func reset()

	/// - Note: Use this query method over `Database.query(...)` when you want to include updates within this `Transaction` in the query results.
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]
	func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int

	/// Create a new instance of the specified object type that will not be permanently persisted until calling `commit()` on this `Transaction`
	func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type

	func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest
	func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult
	/// This method needs to be called when trying to update an object that wasn't created by this `Transaction`.
	/// - Note: Any changes made to the returned object will be saved when `commit()` is called on this `Transaction`.
	func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type

	func delete(_ coreDataObject: CoreDataObject) throws
	func deleteAll(_ objects: [NSManagedObject]) throws
	func deleteAll(_ objectType: NSManagedObject.Type) throws
	func deleteAll(_ entityName: String) throws
}

internal final class TransactionImpl: Transaction {
	// MARK: - Static Variables

	private typealias Me = TransactionImpl

	private static let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
	private static let log = Log()

	// MARK: - Instance Variables

	private final var myContext: NSManagedObjectContext
	private final var mainContext: NSManagedObjectContext?
	private final var childTransactions = [Transaction]()

	// MARK: - Initializers

	init(context: NSManagedObjectContext, mainContext: NSManagedObjectContext) {
		myContext = context
		self.mainContext = mainContext
	}

	private init(context: NSManagedObjectContext) {
		myContext = context
	}

	// MARK: - Transaction Functions

	public final func childTransaction() -> Transaction {
		let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		childContext.parent = myContext
		let childTransaction = TransactionImpl(context: childContext)
		childTransactions.append(childTransaction)
		return childTransaction
	}

	/// Save everything done in this transaction.
	public final func commit() throws {
		for transaction in childTransactions {
			try transaction.commit()
		}
		try saveContext(myContext)
		// if the main context is not saved then data will not be persisted after app terminates
		if let mainContext = mainContext { // only applicable for outermost transaction
			try saveContext(mainContext)
		}
	}

	public final func reset() {
		myContext.undo()
	}

	// MARK: - Fetching

	public final func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
		Me.signpost.begin(name: "Transaction Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		fetchRequest.shouldRefreshRefetchedObjects = true
		do {
			let result = try myContext.fetch(fetchRequest)
			Me.signpost.end(name: "Transaction Query", idObject: fetchRequest)
			return result
		} catch {
			Me.signpost.end(name: "Transaction Query", idObject: fetchRequest)
			throw error
		}
	}

	public final func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int {
		Me.signpost.begin(name: "Transaction Count Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		do {
			let result = try myContext.count(for: fetchRequest)
			Me.signpost.end(name: "Transaction Count Query", idObject: fetchRequest)
			return result
		} catch {
			Me.signpost.end(name: "Transaction Count Query", idObject: fetchRequest)
			throw error
		}
	}

	// MARK: - Creating

	public final func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type {
		Me.signpost.begin(name: "New", idObject: objectType)
		let entity = NSEntityDescription.entity(forEntityName: objectType.entityName, in: myContext)!
		guard let newObject = NSManagedObject(entity: entity, insertInto: myContext) as? Type else {
			Me.log.error("Could not cast new object as %@", objectType.entityName)
			Me.signpost.end(name: "New", idObject: objectType)
			throw FailedToInstantiateObject(objectTypeName: objectType.entityName)
		}
		Me.signpost.end(name: "New", idObject: objectType)
		return newObject
	}

	// MARK: - Updating

	public final func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest {
		let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: myContext)!
		return NSBatchUpdateRequest(entity: entity)
	}

	public final func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult {
		try myContext.execute(request) as! NSBatchUpdateResult
	}

	public final func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
		try injected(Database.self).pull(savedObject: savedObject, fromContext: myContext)
	}

	// MARK: - Deleting

	public final func delete(_ coreDataObject: CoreDataObject) throws {
		guard let object = coreDataObject as? NSManagedObject else {
			throw GenericError("Tried to delete non NSManagedObject")
		}
		Me.signpost.begin(name: "Delete", idObject: object)
		let objectToDelete = try pull(savedObject: object, fromContext: myContext)
		myContext.delete(objectToDelete)
		Me.signpost.end(name: "Delete", idObject: object)
	}

	public final func deleteAll(_ objects: [NSManagedObject]) throws {
		guard !objects.isEmpty else { return }
		if !objects[0].entity.relationshipsByName.isEmpty {
			try nonBatchDeleteAll(objects, from: myContext)
		} else {
			try batchDeleteAll(objects, from: myContext)
		}
	}

	public final func deleteAll(_ objectType: NSManagedObject.Type) throws {
		try deleteAll(objectType.entity().name!)
	}

	public final func deleteAll(_ entityName: String) throws {
		Me.signpost.begin(name: "Delete all with entity name", idObject: entityName as AnyObject)
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
		do {
			try myContext.execute(batchDelete)
		} catch {
			Me.signpost.end(name: "Delete all with entity name", idObject: entityName as AnyObject)
			throw error
		}
		Me.signpost.end(name: "Delete all with entity name", idObject: entityName as AnyObject)
	}

	// MARK: - Helper Functions

	private final func pull<Type: NSManagedObject>(
		savedObject: Type,
		fromContext context: NSManagedObjectContext
	) throws -> Type {
		let savedObjectInSameContext = context.object(with: savedObject.objectID)
		return try getObject(savedObjectInSameContext, as: Type.self)
	}

	private final func saveContext(_ context: NSManagedObjectContext) throws {
		Me.signpost.begin(name: "Save", idObject: context)
		var errorToThrow: Error?
		context.performAndWait {
			// NOTE: if getting an error here that this coordinator has no persistent stores,
			//       probably just pressed "Delete all CoreData" button and need to re-run app
			if context.hasChanges {
				do {
					try context.save()
				} catch {
					errorToThrow = error
				}
			}
		}
		Me.signpost.end(name: "Save", idObject: context)
		if let error = errorToThrow {
			throw error
		}
	}

	private final func nonBatchDeleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		Me.signpost.begin(name: "Non-batch delete all with objects", idObject: objects as AnyObject)
		try objects.map { try pull(savedObject: $0) }.forEach { context.delete($0) }
		Me.signpost.end(name: "Non-batch delete all with objects", idObject: objects as AnyObject)
	}

	/// - Note: This will throw an error if any of the objects have relationships
	private final func batchDeleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		Me.signpost.begin(name: "Batch delete all with objects", idObject: objects as AnyObject)
		let ids = objects.map { $0.objectID }
		if !ids.isEmpty {
			let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: ids)
			do {
				try context.execute(batchDeleteRequest)
			} catch {
				Me.signpost.end(name: "Batch delete all with objects", idObject: objects as AnyObject)
				throw error
			}
		}
		Me.signpost.end(name: "Batch delete all with objects", idObject: objects as AnyObject)
	}

	private final func getObject<Type: NSManagedObject>(_ object: NSManagedObject, as type: Type.Type) throws -> Type {
		guard let castedObject = object as? Type else {
			var wasFault = "Object is "
			if !object.isFault {
				wasFault += "not "
			}
			wasFault += "a fault"
			let objectTypeName = type.entity().name ?? type.debugDescription()
			Me.log.error("Could not cast managed object as %@: %@", objectTypeName)
			throw FailedToInstantiateObject(objectTypeName: objectTypeName)
		}
		return castedObject
	}
}
