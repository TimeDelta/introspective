//
//  Transaction.swift
//  Introspective
//
//  Created by Bryan Nova on 1/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

//sourcery: AutoMockable
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

	/// Create a new instance of the specified object type that will not be permanently persisted until calling `commit()` on this `Transaction`
	func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type

	func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest
	func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult
	/// This method needs to be called when trying to update an object that wasn't created by this `Transaction`.
	/// - Note: Any changes made to the returned object will be saved when `commit()` is called on this `Transaction`.
	func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type

	func delete(_ object: NSManagedObject) throws
	func deleteAll(_ objects: [NSManagedObject]) throws
	func deleteAll(_ objectType: NSManagedObject.Type) throws
	func deleteAll(_ entityName: String) throws
}

public final class TransactionImpl: Transaction {

	// MARK: - Instance Variables

	private final var myContext: NSManagedObjectContext
	private final var mainContext: NSManagedObjectContext?
	private final var childTransactions = [Transaction]()

	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
	private final let log = Log()

	// MARK: - Initializers

	init(context: NSManagedObjectContext, mainContext: NSManagedObjectContext) {
		self.myContext = context
		self.mainContext = mainContext
	}

	private init(context: NSManagedObjectContext) {
		self.myContext = context
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
		signpost.begin(name: "Database Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		do {
			let result = try myContext.fetch(fetchRequest)
			signpost.end(name: "Database Query", idObject: fetchRequest)
			return result
		} catch {
			signpost.end(name: "Database Query", idObject: fetchRequest)
			throw error
		}
	}

	// MARK: - Creating

	public final func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type {
		signpost.begin(name: "New", idObject: objectType)
		let entity = NSEntityDescription.entity(forEntityName: objectType.entityName, in: myContext)!
		guard let newObject = NSManagedObject(entity: entity, insertInto: myContext) as? Type else {
			log.error("Could not cast new object as %@", objectType.entityName)
			signpost.end(name: "New", idObject: objectType)
			throw FailedToInstantiateObject(objectTypeName: objectType.entityName)
		}
		signpost.end(name: "New", idObject: objectType)
		return newObject
	}

	// MARK: - Updating

	public final func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest {
		let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: myContext)!
		return NSBatchUpdateRequest(entity: entity)
	}

	public final func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult {
		return try myContext.execute(request) as! NSBatchUpdateResult
	}

	public final func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
		return try DependencyInjector.db.pull(savedObject: savedObject, fromContext: myContext)
	}

	// MARK: - Deleting

	public final func delete(_ object: NSManagedObject) throws {
		signpost.begin(name: "Delete", idObject: object)
		let objectToDelete = try pull(savedObject: object, fromContext: myContext)
		myContext.delete(objectToDelete)
		signpost.end(name: "Delete", idObject: object)
	}

	public final func deleteAll(_ objects: [NSManagedObject]) throws {
		guard objects.count > 0 else { return }
		if objects[0].entity.relationshipsByName.count > 0 {
			try nonBatchDeleteAll(objects, from: myContext)
		} else {
			try batchDeleteAll(objects, from: myContext)
		}
	}

	public final func deleteAll(_ objectType: NSManagedObject.Type) throws {
		try deleteAll(objectType.entity().name!)
	}

	public final func deleteAll(_ entityName: String) throws {
		signpost.begin(name: "Delete all with entity name", idObject: entityName as AnyObject)
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
		do {
			try myContext.execute(batchDelete)
		} catch {
			signpost.end(name: "Delete all with entity name", idObject: entityName as AnyObject)
			throw error
		}
		signpost.end(name: "Delete all with entity name", idObject: entityName as AnyObject)
	}

	// MARK: - Helper Functions

	private final func pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext) throws -> Type {
		let savedObjectInSameContext = context.object(with: savedObject.objectID)
		return try getObject(savedObjectInSameContext, as: Type.self)
	}

	private final func saveContext(_ context: NSManagedObjectContext) throws {
		signpost.begin(name: "Save", idObject: context)
		var errorToThrow: Error? = nil
		context.performAndWait {
			if context.hasChanges {
				do {
					try context.save()
				} catch {
					errorToThrow = error
				}
			}
		}
		signpost.end(name: "Save", idObject: context)
		if let error = errorToThrow {
			throw error
		}
	}

	private final func nonBatchDeleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		signpost.begin(name: "Non-batch delete all with objects", idObject: objects as AnyObject)
		try objects.map{ try pull(savedObject: $0) }.forEach{ context.delete($0) }
		signpost.end(name: "Non-batch delete all with objects", idObject: objects as AnyObject)
	}

	/// - Note: This will throw an error if any of the objects have relationships
	private final func batchDeleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		signpost.begin(name: "Batch delete all with objects", idObject: objects as AnyObject)
		let ids = objects.map{ $0.objectID }
		if ids.count > 0 {
			let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: ids)
			do {
				try context.execute(batchDeleteRequest)
			} catch {
				signpost.end(name: "Batch delete all with objects", idObject: objects as AnyObject)
				throw error
			}
		}
		signpost.end(name: "Batch delete all with objects", idObject: objects as AnyObject)
	}

	private final func getObject<Type: NSManagedObject>(_ object: NSManagedObject, as type: Type.Type) throws -> Type {
		guard let castedObject = object as? Type else {
			var wasFault = "Object is "
			if !object.isFault {
				wasFault += "not "
			}
			wasFault += "a fault"
			let objectTypeName = type.entity().name ?? type.debugDescription()
			log.error("Could not cast managed object as %@: %@", objectTypeName)
			throw FailedToInstantiateObject(objectTypeName: objectTypeName)
		}
		return castedObject
	}
}
