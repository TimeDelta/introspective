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
	func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type]
	func save()
	func delete(_ object: NSManagedObject)
}

public class DatabaseImpl: Database {

	private final var persistentContainer: NSPersistentContainer

	private lazy final var backgroundContext: NSManagedObjectContext = {
		return self.persistentContainer.newBackgroundContext()
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

	public final func query<Type: NSManagedObject>(_ fetchRequest: NSFetchRequest<Type>) throws -> [Type] {
		return try persistentContainer.viewContext.fetch(fetchRequest)
	}

	public final func save() {
		if backgroundContext.hasChanges {
			do {
				try backgroundContext.save()
			} catch {
				// TODO - Tell the user something went wrong while saving their data instead of crashing the app
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	public final func delete(_ object: NSManagedObject) {
		persistentContainer.viewContext.delete(object)
	}
}
