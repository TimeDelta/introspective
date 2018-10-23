//
//  Database.swift
//  Data Integration
//
//  Created by Bryan Nova on 6/22/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

public enum DatabaseError: Error {
	case failedToInstantiateObject
}

//sourcery: AutoMockable
public protocol Database {

	func new<Type: NSManagedObject & CoreDataObject>(objectType: Type.Type) throws -> Type
	func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, cacheName: String?) -> NSFetchedResultsController<Type>
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]
	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type
	func save()
	func delete(_ object: NSManagedObject)
	func deleteAll(_ objects: [NSManagedObject]) throws
	func deleteAll(_ objectType: NSManagedObject.Type) throws
	func deleteAll(_ entityName: String) throws
}

extension Database {
	func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, cacheName: String? = nil) -> NSFetchedResultsController<Type> {
		return fetchedResultsController(type: type, cacheName: cacheName)
	}
}

public class DatabaseImpl: Database {

	private final var persistentContainer: NSPersistentContainer

	private lazy final var backgroundContext: NSManagedObjectContext = {
		let background = self.persistentContainer.newBackgroundContext()
		background.automaticallyMergesChangesFromParent = true
		return background
	}()

	public init(_ container: NSPersistentContainer? = nil) {
		persistentContainer = container ?? {
			let container = NSPersistentContainer(name: "Introspective")
			container.loadPersistentStores(completionHandler: { (storeDescription, error) in
				if let error = error as NSError? {
					// TODO - tell the user something went wrong with accessing their data instead of crashing the app

					/*
					Typical reasons for an error here include:
					* The parent directory does not exist, cannot be created, or disallows writing.
					* The persistent store is not accessible, due to permissions or data protection when the device is locked.
					* The device is out of space.
					* The store could not be migrated to the current model version.
					Check the error message to determine what the actual problem was.
					*/
					fatalError("Unresolved error \(error), \(error.userInfo)")
				}
			})
			container.viewContext.automaticallyMergesChangesFromParent = true
			return container
		}()
	}

	public final func new<Type: NSManagedObject & CoreDataObject>(objectType: Type.Type) throws -> Type {
		let entity = NSEntityDescription.entity(forEntityName: objectType.entityName, in: backgroundContext)!
		guard let newObject = NSManagedObject(entity: entity, insertInto: backgroundContext) as? Type else {
			os_log("Could not cast new object as %@", type: .error, objectType.entityName)
			throw DatabaseError.failedToInstantiateObject
		}
		return newObject
	}

	public final func fetchedResultsController<Type: NSManagedObject>(type: Type.Type, cacheName: String? = nil) -> NSFetchedResultsController<Type> {
		return NSFetchedResultsController<Type>(
			fetchRequest: type.fetchRequest() as! NSFetchRequest<Type>,
			managedObjectContext: persistentContainer.viewContext,
			sectionNameKeyPath: nil,
			cacheName: cacheName)
	}

	public final func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
		return try persistentContainer.viewContext.fetch(fetchRequest)
	}

	/// This method needs to be called when trying to establish a relationship between two objects in different contexts.
	/// This will happen if one object has already been saved and the other hasn't been saved yet.
	public final func pull<Type: NSManagedObject>(savedObject: Type, fromSameContextAs otherObject: NSManagedObject) throws -> Type {
		let savedObjectInSameContext = otherObject.managedObjectContext!.object(with: savedObject.objectID)
		guard let castedObject = savedObjectInSameContext as? Type else {
			var wasFault = "Object is "
			if !savedObjectInSameContext.isFault {
				wasFault += "not "
			}
			wasFault += "a fault"
			os_log("Could not cast saved object as %@: %@", type: .error, savedObject.entity.name!)
			throw DatabaseError.failedToInstantiateObject
		}
		return castedObject
	}

	public final func save() {
		saveContext(backgroundContext)
	}

	public final func delete(_ object: NSManagedObject) {
		if context(persistentContainer.viewContext, contains: object) {
			persistentContainer.viewContext.delete(object)
			saveContext(persistentContainer.viewContext)
		}
		if context(backgroundContext, contains: object) {
			backgroundContext.delete(object)
			saveContext(backgroundContext)
		}
	}

	public final func deleteAll(_ objects: [NSManagedObject]) throws {
		try deleteAll(objects, from: persistentContainer.viewContext)
		try deleteAll(objects, from: backgroundContext)
	}

	public final func deleteAll(_ objectType: NSManagedObject.Type) throws {
		try deleteAll(objectType.entity().name!)
	}

	public final func deleteAll(_ entityName: String) throws {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
		try persistentContainer.viewContext.execute(batchDelete)
		try backgroundContext.execute(batchDelete)
	}

	// MARK: - Helper Functions

	private final func context(_ context: NSManagedObjectContext, contains object: NSManagedObject) -> Bool {
		let fetchedObject = context.object(with: object.objectID)
		return !fetchedObject.isFault
	}

	private final func saveContext(_ context: NSManagedObjectContext) {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// TODO - Tell the user something went wrong while saving their data instead of crashing the app
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	private final func deleteAll(_ objects: [NSManagedObject], from context: NSManagedObjectContext) throws {
		let ids = objects.filter{ self.context(context, contains: $0) }.map{ $0.objectID }
		if ids.count > 0 {
			let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: ids)
			try context.execute(batchDeleteRequest)
		}
	}
}
