//
//  Database.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import NotificationBannerSwift
import os

//sourcery: AutoMockable
public protocol Database {

	func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type

	func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, sortDescriptors: [NSSortDescriptor], cacheName: String?) -> NSFetchedResultsController<Type>
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]

	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type
	func getUpdated<Type: NSManagedObject>(object: Type) throws -> Type

	func save() throws
	/// Use this cautiously as it will rollback unsaved stuff created from other tabs also
	func clearUnsavedChanges()

	func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest
	func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult

	func delete(_ object: NSManagedObject) throws
	func deleteAll(_ objects: [NSManagedObject]) throws
	func deleteAll(_ objectType: NSManagedObject.Type) throws
	func deleteAll(_ entityName: String) throws
}

extension Database {
	func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, sortDescriptors: [NSSortDescriptor], cacheName: String? = nil) -> NSFetchedResultsController<Type> {
		return fetchedResultsController(type: type, sortDescriptors: sortDescriptors, cacheName: cacheName)
	}
}

public class DatabaseImpl: Database {

	private final var persistentContainer: NSPersistentContainer
	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
	private final let log = Log(OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))

	private lazy final var backgroundContext: NSManagedObjectContext = {
		let background = self.persistentContainer.newBackgroundContext()
		background.automaticallyMergesChangesFromParent = true
		return background
	}()

	public init(_ container: NSPersistentContainer? = nil) {
		persistentContainer = container ?? {
			let container = NSPersistentContainer(name: "Introspective")
			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error {
					/*
					Typical reasons for an error here include:
					* The parent directory does not exist, cannot be created, or disallows writing.
					* The persistent store is not accessible, due to permissions or data protection when the device is locked.
					* The device is out of space.
					* The store could not be migrated to the current model version.
					Check the error message to determine what the actual problem was.
					*/
					Log(OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
						.fault("Unresolved error while loading persistent stores: %@", errorInfo(error))
					NotificationBanner(
						title: "Failed to load saved data",
						subtitle: "App functionality will be limited.",
						style: .danger
					).show()
				}
			})
			container.viewContext.automaticallyMergesChangesFromParent = true
			return container
		}()
	}

	// MARK: - Creating

	public final func new<Type: NSManagedObject & CoreDataObject>(_ objectType: Type.Type) throws -> Type {
		signpost.begin(name: "New", idObject: objectType)
		let entity = NSEntityDescription.entity(forEntityName: objectType.entityName, in: backgroundContext)!
		guard let newObject = NSManagedObject(entity: entity, insertInto: backgroundContext) as? Type else {
			log.error("Could not cast new object as %@", objectType.entityName)
			signpost.end(name: "New", idObject: objectType)
			throw FailedToInstantiateObject(objectTypeName: objectType.entityName)
		}
		signpost.end(name: "New", idObject: objectType)
		return newObject
	}

	// MARK: - Fetching

	public final func fetchedResultsController<Type: NSManagedObject>(
		type: Type.Type,
		sortDescriptors: [NSSortDescriptor],
		cacheName: String? = nil)
	-> NSFetchedResultsController<Type> {
		let fetchRequest = type.fetchRequest() as! NSFetchRequest<Type>
		fetchRequest.sortDescriptors = sortDescriptors
		return NSFetchedResultsController<Type>(
			fetchRequest: fetchRequest,
			managedObjectContext: persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: cacheName)
	}

	public final func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
		signpost.begin(name: "Database Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		do {
			let result = try persistentContainer.viewContext.fetch(fetchRequest)
			signpost.end(name: "Database Query", idObject: fetchRequest)
			return result
		} catch {
			signpost.end(name: "Database Query", idObject: fetchRequest)
			throw error
		}
	}

	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	public final func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type {
		signpost.begin(name: "Pull", idObject: savedObject)
		do {
			guard let context = otherObject.managedObjectContext else {
				throw UnknownManagedObjectContext()
			}
			let object = try pull(savedObject: savedObject, fromContext: context)
			signpost.end(name: "Pull", idObject: savedObject)
			return object
		} catch {
			signpost.end(name: "Pull", idObject: savedObject)
			throw error
		}
	}

	public final func getUpdated<Type: NSManagedObject>(object: Type) throws -> Type {
		guard let context = object.managedObjectContext else {
			throw UnknownManagedObjectContext()
		}
		return try getObject(context.object(with: object.objectID), as: Type.self)
	}

	// MARK: - Updating

	public final func save() throws {
		try saveContext(backgroundContext)
		try saveContext(persistentContainer.viewContext)
	}

	public final func clearUnsavedChanges() {
		backgroundContext.undo()
		persistentContainer.viewContext.undo()
	}

	public final func batchUpdateRequest<Type: CoreDataObject>(for type: Type.Type) -> NSBatchUpdateRequest {
		let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: backgroundContext)!
		return NSBatchUpdateRequest(entity: entity)
	}

	public final func batchUpdate(_ request: NSBatchUpdateRequest) throws -> NSBatchUpdateResult {
		return try backgroundContext.execute(request) as! NSBatchUpdateResult
	}

	// MARK: - Deleting

	public final func delete(_ object: NSManagedObject) throws {
		signpost.begin(name: "Delete", idObject: object)
		// delete from background context first in case deletion from main one fails
		// because it will be confusing to user if they see an error that something
		// wasn't deleted but it doesn't show up anymore
		if context(backgroundContext, contains: object) {
			let objectToDelete = try pull(savedObject: object, fromContext: backgroundContext)
			backgroundContext.delete(objectToDelete)
			try saveContext(backgroundContext)
		}
		if context(persistentContainer.viewContext, contains: object) {
			let objectToDelete = try pull(savedObject: object, fromContext: persistentContainer.viewContext)
			persistentContainer.viewContext.delete(objectToDelete)
			try saveContext(persistentContainer.viewContext)
		}
		signpost.end(name: "Delete", idObject: object)
	}

	public final func deleteAll(_ objects: [NSManagedObject]) throws {
		try deleteAll(objects, from: persistentContainer.viewContext)
		try deleteAll(objects, from: backgroundContext)
	}

	public final func deleteAll(_ objectType: NSManagedObject.Type) throws {
		try deleteAll(objectType.entity().name!)
	}

	public final func deleteAll(_ entityName: String) throws {
		signpost.begin(name: "Delete all with entity name", idObject: entityName as AnyObject)
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
		do {
			try persistentContainer.viewContext.execute(batchDelete)
			try backgroundContext.execute(batchDelete)
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

	private final func context(_ context: NSManagedObjectContext, contains object: NSManagedObject) -> Bool {
		signpost.begin(name: "Context contains object", idObject: object)
		let fetchedObject = context.object(with: object.objectID)
		let result = !fetchedObject.isFault
		signpost.end(name: "Context contains object", idObject: object)
		return result
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

	private final func deleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		signpost.begin(name: "Delete all with objects", idObject: objects as AnyObject)
		let ids = objects.filter{ self.context(context, contains: $0) }.map{ $0.objectID }
		if ids.count > 0 {
			let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: ids)
			do {
				try context.execute(batchDeleteRequest)
			} catch {
				signpost.end(name: "Delete all with objects", idObject: objects as AnyObject)
				throw error
			}
		}
		signpost.end(name: "Delete all with objects", idObject: objects as AnyObject)
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
