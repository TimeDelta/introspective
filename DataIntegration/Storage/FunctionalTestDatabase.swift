//
//  FunctionalTestDatabase.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

final class FunctionalTestDatabase: DatabaseImpl {

	private final let persistentContainer: NSPersistentContainer

	public init() {
		persistentContainer = NSPersistentContainer(name: "Introspective")
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		description.shouldAddStoreAsynchronously = false // make it simpler for tests

		persistentContainer.persistentStoreDescriptions = [description]
		persistentContainer.loadPersistentStores { (description, error) in
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
