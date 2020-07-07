//
//  FunctionalTestDatabase.swift
//  Persistence
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

internal class FunctionalTestDatabase: DatabaseImpl {
	private final let persistentContainer: NSPersistentContainer

	public override init(_ objectModel: NSManagedObjectModel) {
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false // make it simpler for tests
		description.shouldMigrateStoreAutomatically = true
		description.shouldInferMappingModelAutomatically = true

		// Need to allow object model to be merged from external source because static
		// context of this class and FunctionalTest seems to reset with each test class
		persistentContainer = SharedPersistentContainer(name: "Introspective", managedObjectModel: objectModel)

		persistentContainer.persistentStoreDescriptions = [description]
		persistentContainer.loadPersistentStores { description, error in
			precondition(description.type == NSInMemoryStoreType)
			if let error = error {
				fatalError("Failed to create an in-memory coordinator \(error)")
			}
		}
		persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
		super.init(persistentContainer)
	}

	final func flushData(_ types: CoreDataObject.Type...) {
		for type in types {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
			let objs = try! persistentContainer.viewContext.fetch(fetchRequest)
			for case let obj as NSManagedObject in objs {
				persistentContainer.viewContext.delete(obj)
			}
		}
		try! persistentContainer.viewContext.save()
	}

	final func numberOfItemsInDatabase(_ type: CoreDataObject.Type) -> Int {
		let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: type.entityName)
		return try! persistentContainer.viewContext.fetch(request).count
	}
}
