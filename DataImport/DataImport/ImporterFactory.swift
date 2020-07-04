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

// sourcery: AutoMockable
public protocol ImporterFactory {
	// MARK: Moods

	func wellnessMoodImporter() throws -> WellnessMoodImporter
	func introspectiveMoodImporter() throws -> IntrospectiveMoodImporter

	// MARK: Medications

	func easyPillMedicationImporter() throws -> EasyPillMedicationImporter
	func easyPillMedicationDoseImporter() throws -> EasyPillMedicationDoseImporter
	func introspectiveMedicationImporter() throws -> IntrospectiveMedicationImporter

	// MARK: Activities

	func aTrackerActivityImporter() throws -> ATrackerActivityImporter
	func introspectiveActivityImporter() throws -> IntrospectiveActivityImporter
}

public final class ImporterFactoryImpl: ImporterFactory {
	// MARK: - Moods

	public final func wellnessMoodImporter() throws -> WellnessMoodImporter {
		let importers = try DependencyInjector.get(Database.self).query(WellnessMoodImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: WellnessMoodImporterImpl = try transaction.new(WellnessMoodImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func introspectiveMoodImporter() throws -> IntrospectiveMoodImporter {
		let importers = try DependencyInjector.get(Database.self).query(IntrospectiveMoodImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: IntrospectiveMoodImporterImpl = try transaction.new(IntrospectiveMoodImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	// MARK: - Medications

	public final func easyPillMedicationImporter() throws -> EasyPillMedicationImporter {
		let importers = try DependencyInjector.get(Database.self).query(EasyPillMedicationImporterImpl.fetchRequest())
		if !importers.isEmpty {
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
		let importers = try DependencyInjector.get(Database.self)
			.query(EasyPillMedicationDoseImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: EasyPillMedicationDoseImporterImpl = try transaction.new(EasyPillMedicationDoseImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func introspectiveMedicationImporter() throws -> IntrospectiveMedicationImporter {
		let importers = try DependencyInjector.get(Database.self)
			.query(IntrospectiveMedicationImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: IntrospectiveMedicationImporterImpl = try transaction
			.new(IntrospectiveMedicationImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	// MARK: - Activities

	public final func aTrackerActivityImporter() throws -> ATrackerActivityImporter {
		let importers = try DependencyInjector.get(Database.self).query(ATrackerActivityImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: ATrackerActivityImporterImpl = try transaction.new(ATrackerActivityImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}

	public final func introspectiveActivityImporter() throws -> IntrospectiveActivityImporter {
		let importers = try DependencyInjector.get(Database.self)
			.query(IntrospectiveActivityImporterImpl.fetchRequest())
		if !importers.isEmpty {
			return importers[0]
		}

		let transaction = DependencyInjector.get(Database.self).transaction()
		let importer: IntrospectiveActivityImporterImpl = try transaction.new(IntrospectiveActivityImporterImpl.self)
		try transaction.commit()
		// must pull from main database context or context will go out of scope and get deleted,
		// causing CoreData to be unable to fulfill a fault
		return try DependencyInjector.get(Database.self).pull(savedObject: importer)
	}
}
