//
//  MedicationDAO.swift
//  Samples
//
//  Created by Bryan Nova on 6/19/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence

//sourcery: AutoMockable
public protocol MedicationDAO {

	func medicationExists(withName name: String, using transaction: Transaction?) throws -> Bool

	@discardableResult
	func createMedication(
		name: String,
		frequency: Frequency?,
		dosage: Dosage?,
		startedOn: Date?,
		note: String?,
		source: Sources.MedicationSourceNum,
		recordScreenIndex: Int16?,
		using transaction: Transaction?
	) -> Medication
	@discardableResult
	func createDose(
		medication: Medication,
		dosage: Dosage?,
		timestamp: Date,
		source: Sources.MedicationSourceNum,
		using transaction: Transaction?
	) -> MedicationDose
}

extension MedicationDAO {

	public func medicationExists(withName name: String, using transaction: Transaction? = nil) throws -> Bool {
		return try medicationExists(withName: name, using: transaction)
	}

	public func createMedication(
		name: String,
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil,
		source: Sources.MedicationSourceNum = .introspective,
		recordScreenIndex: Int16? = nil,
		using transaction: Transaction? = nil
	) -> Medication {
		return createMedication(
			name: name,
			frequency: frequency,
			dosage: dosage,
			startedOn: startedOn,
			note: note,
			source: source,
			recordScreenIndex: recordScreenIndex,
			using: transaction
		)
	}

	public func createDose(
		medication: Medication,
		dosage: Dosage? = nil,
		timestamp: Date = Date(),
		source: Sources.MedicationSourceNum = .introspective,
		using transaction: Transaction? = nil
	) -> MedicationDose {
		return createDose(
			medication: medication,
			dosage: dosage,
			timestamp: timestamp,
			source: source,
			using: transaction
		)
	}
}

public final class MedicationDAOImpl: MedicationDAO {

	private final let log = Log()

	public final func medicationExists(withName name: String, using transaction: Transaction?) throws -> Bool {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let medicationsWithSameName = try transaction.query(fetchRequest)
		return medicationsWithSameName.count > 0
	}

	@discardableResult
	public final func createMedication(
		name: String,
		frequency: Frequency?,
		dosage: Dosage?,
		startedOn: Date?,
		note: String?,
		source: Sources.MedicationSourceNum = .introspective,
		recordScreenIndex: Int16?,
		using transaction: Transaction?
	) throws -> Medication {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let medication = try! transaction.new(Medication.self)

		medication.name = name
		medication.frequency = frequency
		medication.dosage = dosage
		medication.startedOn = startedOn
		medication.notes = note
		medication.setSource(source)

		if let recordScreenIndex = recordScreenIndex {
			medication.recordScreenIndex = recordScreenIndex
		} else {
			let numDefinitions = try DependencyInjector.get(Database.self).query(Medication.fetchRequest()).count
			medication.recordScreenIndex = Int16(numDefinitions)
		}

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try DependencyInjector.get(Database.self).pull(savedObject: medication)
	}

	@discardableResult
	public final func createDose(
		medication: Medication,
		dosage: Dosage?,
		timestamp: Date,
		source: Sources.MedicationSourceNum,
		using transaction: Transaction?
	) throws -> MedicationDose {
		let transaction = transaction ?? DependencyInjector.get(Database.self).transaction()
		let dose = try transaction.new(MedicationDose.self)
		let sameContextMedication = try! transaction.pull(savedObject: medication)

		dose.medication = sameContextMedication
		dose.date = timestamp
		dose.dosage = dosage
		dose.setSource(source)
		sameContextMedication.addToDoses(dose)

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try DependencyInjector.get(Database.self).pull(savedObject: dose)
	}
}