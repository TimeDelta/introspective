//
//  ImporterUtil.swift
//  Introspective
//
//  Created by Bryan Nova on 12/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

//sourcery: AutoMockable
public protocol ImporterUtil {

	func deleteImportedEntities<Type: NSManagedObject>(fetchRequest: NSFetchRequest<Type>) throws
	func cleanUpImportedData<Type: NSManagedObject & CoreDataObject & Importable>(forType type: Type.Type) throws
}

public final class ImporterUtilImpl: ImporterUtil {

	private final let log = Log()

	public final func deleteImportedEntities<Type: NSManagedObject>(fetchRequest: NSFetchRequest<Type>) throws {
		fetchRequest.predicate = NSPredicate(format: "partOfCurrentImport == true")
		let entities = try DependencyInjector.db.query(fetchRequest)
		// db.deleteAll() can fail and throw because batch deletes don't
		// update relationships according to delete rule before end of transaction
		for entity in entities {
			try DependencyInjector.db.delete(entity)
		}
	}

	public final func cleanUpImportedData<Type: NSManagedObject & CoreDataObject & Importable>(forType type: Type.Type) throws {
		// the in-memory datastore type that is used for functional tests does not support batch updates
		if !testing {
			// IMPORTANT: must do manual testing of this if updated
			let updateRequest = DependencyInjector.db.batchUpdateRequest(for: type)
			updateRequest.predicate = NSPredicate(format: "partOfCurrentImport == true")
			updateRequest.resultType = .statusOnlyResultType
			updateRequest.propertiesToUpdate = ["partOfCurrentImport": false]
			let result = try DependencyInjector.db.batchUpdate(updateRequest)
			if result.result as? Bool == false {
				log.error("Failed to clean up imported data for %@", type.entityName)
			}
		} else {
			let fetchRequest = NSFetchRequest<Type>(entityName: type.entityName)
			fetchRequest.predicate = NSPredicate(format: "partOfCurrentImport == true")
			let importedEntities = try DependencyInjector.db.query(fetchRequest)
			for var entity in importedEntities {
				entity.partOfCurrentImport = false
			}
			try DependencyInjector.db.save()
		}
	}
}
