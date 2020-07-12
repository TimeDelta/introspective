//
//  Database.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation
import NotificationBannerSwift
import os

import Common

// sourcery: AutoMockable
public protocol Database {
	/// - Note: `Transaction` objects are only needed for modifications to the database.
	func transaction() -> Transaction

	func refreshContext()

	func fetchedResultsController<Type: NSManagedObject>(
		type: Type.Type,
		sortDescriptors: [NSSortDescriptor],
		cacheName: String?
	) -> NSFetchedResultsController<Type>
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]
	func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int
	/// Pull the specified managed object fresh from the root view context. Need to call this for any newly objects created after transaction is committed.
	func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type
	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type
	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	func pull<Type: NSManagedObject>(savedObject: Type, fromContext context: NSManagedObjectContext) throws -> Type

	/// This will completely destroy the persistent store, permanently deleting everything in the entire database.
	func deleteEverything() throws
}

public extension Database {
	func fetchedResultsController<Type: NSManagedObject>(
		type: Type.Type,
		sortDescriptors: [NSSortDescriptor],
		cacheName: String? = nil
	) -> NSFetchedResultsController<Type> {
		fetchedResultsController(type: type, sortDescriptors: sortDescriptors, cacheName: cacheName)
	}
}

internal class DatabaseImpl: Database {
	private final var persistentContainer: NSPersistentContainer
	private final let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
	private final let log = Log()

	public init(_ container: NSPersistentContainer) {
		persistentContainer = container
	}

	public init(_ objectModel: NSManagedObjectModel) {
		persistentContainer = {
			let container = SharedPersistentContainer(name: "Introspective", managedObjectModel: objectModel)
			container.loadPersistentStores(completionHandler: { _, error in
				if let error = error {
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					Log().fault("Unresolved error while loading persistent stores: %@", errorInfo(error))
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

	// MARK: - Fetching

	public final func fetchedResultsController<Type: NSManagedObject>(
		type: Type.Type,
		sortDescriptors: [NSSortDescriptor],
		cacheName: String? = nil
	) -> NSFetchedResultsController<Type> {
		let fetchRequest = type.fetchRequest() as! NSFetchRequest<Type>
		fetchRequest.sortDescriptors = sortDescriptors
		fetchRequest.shouldRefreshRefetchedObjects = true
		return NSFetchedResultsController<Type>(
			fetchRequest: fetchRequest,
			managedObjectContext: persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: cacheName
		)
	}

	public final func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
		signpost.begin(name: "Database Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		fetchRequest.shouldRefreshRefetchedObjects = true
		do {
			let result = try persistentContainer.viewContext.fetch(fetchRequest)
			signpost.end(name: "Database Query", idObject: fetchRequest)
			return result
		} catch {
			signpost.end(name: "Database Query", idObject: fetchRequest)
			throw error
		}
	}

	public final func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int {
		signpost.begin(name: "Database Count Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		do {
			let result = try persistentContainer.viewContext.count(for: fetchRequest)
			signpost.end(name: "Database Count Query", idObject: fetchRequest)
			return result
		} catch {
			signpost.end(name: "Database Count Query", idObject: fetchRequest)
			throw error
		}
	}

	public final func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
		signpost.begin(name: "Pull", idObject: savedObject)
		do {
			let object = try pull(savedObject: savedObject, fromContext: persistentContainer.viewContext)
			signpost.end(name: "Pull", idObject: savedObject)
			return object
		} catch {
			signpost.end(name: "Pull", idObject: savedObject)
			throw error
		}
	}

	public final func pull<Type: NSManagedObject>(
		savedObject: Type,
		fromSameContextAs otherObject: NSManagedObject
	) throws -> Type {
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

	public final func pull<Type: NSManagedObject>(
		savedObject: Type,
		fromContext context: NSManagedObjectContext
	) throws -> Type {
		let savedObjectInGivenContext = context.object(with: savedObject.objectID)
		return try getObject(savedObjectInGivenContext, as: Type.self)
	}

	// MARK: - Other

	public final func transaction() -> Transaction {
		let backgroundContext = persistentContainer.newBackgroundContext()
		backgroundContext.automaticallyMergesChangesFromParent = true
		backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
		return TransactionImpl(context: backgroundContext, mainContext: persistentContainer.viewContext)
	}

	public final func refreshContext() {
		persistentContainer.viewContext.refreshAllObjects()
	}

	public final func deleteEverything() throws {
		for store in persistentContainer.persistentStoreCoordinator.persistentStores {
			try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(
				at: store.url!,
				ofType: NSSQLiteStoreType,
				options: nil
			)
		}
	}

	// MARK: - Helper Functions

	private final func getObject<Type: NSManagedObject>(_ object: NSManagedObject, as type: Type.Type) throws -> Type {
		guard let castedObject = object as? Type else {
			var wasFault = "Object is "
			if !object.isFault {
				wasFault += "not "
			}
			wasFault += "a fault"
			let objectTypeName = type.entity().name ?? type.debugDescription()
			log.error("Could not cast managed object as %@: %@", objectTypeName, wasFault)
			throw FailedToInstantiateObject(objectTypeName: objectTypeName)
		}
		return castedObject
	}
}
