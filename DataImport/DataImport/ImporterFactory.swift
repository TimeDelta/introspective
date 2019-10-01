//
//  ImporterFactory.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation

import DependencyInjection
import Persistence

//sourcery: AutoMockable
public protocol ImporterFactory {

	func wellnessMoodImporter() throws -> WellnessMoodImporter
	func easyPillMedicationImporter() throws -> EasyPillMedicationImporter
	func easyPillMedicationDoseImporter() throws -> EasyPillMedicationDoseImporter
	func aTrackerActivityImporter() throws -> ATrackerActivityImporter
}

public final class ImporterFactoryImpl: ImporterFactory {

	public final func wellnessMoodImporter() throws -> WellnessMoodImporter {
		let importers = try DependencyInjector.get(Database.self).query(WellnessMoodImporterImpl.fetchRequest())
		if importers.count > 0 {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: WellnessMoodImporterImpl = try transaction.new(WellnessMoodImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func easyPillMedicationImporter() throws -> EasyPillMedicationImporter {
		let importers = try DependencyInjector.get(Database.self).query(EasyPillMedicationImporterImpl.fetchRequest())
		if importers.count > 0 {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: EasyPillMedicationImporterImpl = try transaction.new(EasyPillMedicationImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func easyPillMedicationDoseImporter() throws -> EasyPillMedicationDoseImporter {
		let importers = try DependencyInjector.get(Database.self).query(EasyPillMedicationDoseImporterImpl.fetchRequest())
		if importers.count > 0 {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: EasyPillMedicationDoseImporterImpl = try transaction.new(EasyPillMedicationDoseImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func aTrackerActivityImporter() throws -> ATrackerActivityImporter {
		let importers = try DependencyInjector.get(Database.self).query(ATrackerActivityImporterImpl.fetchRequest())
		if importers.count > 0 {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: ATrackerActivityImporterImpl = try transaction.new(ATrackerActivityImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}
}
