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
import DependencyInjection

// sourcery: AutoMockable
public protocol Database {
	/// - Note: `Transaction` objects are only needed for modifications to the database.
	func transaction() -> Transaction

	/// Set whether or not the CoreData persistence has been modified externally (i.e. by an app extension)
	func setModifiedExternally(_ modified: Bool)
	/// Refresh all objects in the CoreData `ManagedObjectContext`
	/// - Note: Necessary when i.e. an app extension modifies the persistence layer
	func refreshContext()

	func fetchedResultsController<Type: NSManagedObject>(
		type: Type.Type,
		sortDescriptors: [NSSortDescriptor],
		cacheName: String?
	) -> NSFetchedResultsController<Type>
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]
	func count<Type: NSManagedObject>(_ type: Type.Type) throws -> Int
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

	/// This is needed for the strong reference cycle between i.e. Activity <-> ActivityDefinition
	/// - Note: See [Apple's CoreData docs on Breaking Strong References Between Objects](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/MO_Lifecycle.html#//apple_ref/doc/uid/TP40001075-CH31-SW1) for more information
	func cleanUpManagedObjectWithStrongReferenceCycle<Type: NSManagedObject>(_ object: Type)
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
	private typealias Me = DatabaseImpl

	private static let signpost = Signpost(log: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Database"))
	private static let log = Log()

	private final var persistentContainer: NSPersistentContainer

	// MARK: - Initializers

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
			container.viewContext.retainsRegisteredObjects = false
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
		Me.signpost.begin(name: "Database Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		fetchRequest.shouldRefreshRefetchedObjects = true
		do {
			let result = try persistentContainer.viewContext.fetch(fetchRequest)
			Me.signpost.end(name: "Database Query", idObject: fetchRequest)
			return result
		} catch {
			Me.signpost.end(name: "Database Query", idObject: fetchRequest)
			throw error
		}
	}

	public final func count<Type: NSManagedObject>(_ type: Type.Type) throws -> Int {
		try count(Type.fetchRequest())
	}

	public final func count<Type: NSFetchRequestResult>(_ fetchRequest: NSFetchRequest<Type>) throws -> Int {
		Me.signpost.begin(name: "Database Count Query", idObject: fetchRequest, "%@", fetchRequest.debugDescription)
		do {
			let result = try persistentContainer.viewContext.count(for: fetchRequest)
			Me.signpost.end(name: "Database Count Query", idObject: fetchRequest)
			return result
		} catch {
			Me.signpost.end(name: "Database Count Query", idObject: fetchRequest)
			throw error
		}
	}

	public final func pull<Type: NSManagedObject>(savedObject: Type) throws -> Type {
		Me.signpost.begin(name: "Pull", idObject: savedObject)
		do {
			let object = try pull(savedObject: savedObject, fromContext: persistentContainer.viewContext)
			Me.signpost.end(name: "Pull", idObject: savedObject)
			return object
		} catch {
			Me.signpost.end(name: "Pull", idObject: savedObject)
			throw error
		}
	}

	public final func pull<Type: NSManagedObject>(
		savedObject: Type,
		fromSameContextAs otherObject: NSManagedObject
	) throws -> Type {
		Me.signpost.begin(name: "Pull", idObject: savedObject)
		do {
			guard let context = otherObject.managedObjectContext else {
				throw UnknownManagedObjectContext()
			}
			let object = try pull(savedObject: savedObject, fromContext: context)
			Me.signpost.end(name: "Pull", idObject: savedObject)
			return object
		} catch {
			Me.signpost.end(name: "Pull", idObject: savedObject)
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

	public final func setModifiedExternally(_ modified: Bool) {
		do {
			var sync = try getOrCreateSync()
			let myTransaction = transaction()
			sync = try myTransaction.pull(savedObject: sync)
			sync.externallyModified = modified
			try retryOnFail({ try myTransaction.commit() }, maxRetries: 2)
		} catch {
			Me.log.error("Unable to update core data sync", errorInfo(error))
		}
	}

	public final func refreshContext() {
		do {
			let sync = try getOrCreateSync()
			persistentContainer.viewContext.refresh(sync, mergeChanges: true)
			if !sync.externallyModified {
				return
			}
		} catch {
			Me.log.error("Failed to check if context should be refreshed: %@", errorInfo(error))
			// refresh all objects in context on failure
		}
		persistentContainer.viewContext.refreshAllObjects()
		injected(NotificationUtil.self).post(.persistenceLayerWasRefreshed, object: nil, qos: .userInteractive)
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

	public final func cleanUpManagedObjectWithStrongReferenceCycle<Type: NSManagedObject>(_ object: Type) {
		persistentContainer.viewContext.refresh(object, mergeChanges: false)
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
			Me.log.error("Could not cast managed object as %@: %@", objectTypeName, wasFault)
			throw FailedToInstantiateObject(objectTypeName: objectTypeName)
		}
		return castedObject
	}

	private final func getOrCreateSync() throws -> CoreDataSync {
		let syncRequest: NSFetchRequest<CoreDataSync> = CoreDataSync.fetchRequest()
		let syncs = try query(syncRequest)
		guard syncs.count > 0 else {
			let myTransaction = transaction()
			let sync = try myTransaction.new(CoreDataSync.self)
			try myTransaction.commit()
			return sync
		}
		return syncs[0]
	}
}
