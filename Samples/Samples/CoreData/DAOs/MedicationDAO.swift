//
//  MedicationDAO.swift
//  Samples
//
//  Created by Bryan Nova on 6/19/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence

// sourcery: AutoMockable
public protocol MedicationDAO {
	func medicationExists(withName name: String, using transaction: Transaction?) throws -> Bool
	/// - Returns: The medication with the provided name if it exists. Otherwise, nil.
	func medicationNamed(_ name: String) throws -> Medication?
	@discardableResult
	func takeMedicationUsingDefaultDosage(_ medication: Medication) throws -> MedicationDose

	/// Get the most recently taken dose of the specified medication. If the specified medication has not been taken yet, returns `nil`.
	func mostRecentDoseOf(_ medication: Medication) throws -> MedicationDose?

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
	) throws -> Medication
	@discardableResult
	func createDose(
		medication: Medication,
		dosage: Dosage?,
		timestamp: Date,
		source: Sources.MedicationSourceNum,
		using transaction: Transaction?
	) throws -> MedicationDose
}

extension MedicationDAO {
	public func medicationExists(withName name: String, using transaction: Transaction? = nil) throws -> Bool {
		try medicationExists(withName: name, using: transaction)
	}

	@discardableResult
	public func createMedication(
		name: String,
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil,
		source: Sources.MedicationSourceNum = .introspective,
		recordScreenIndex: Int16? = nil,
		using transaction: Transaction? = nil
	) throws -> Medication {
		try createMedication(
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

	@discardableResult
	public func createDose(
		medication: Medication,
		dosage: Dosage? = nil,
		timestamp: Date = Date(),
		source: Sources.MedicationSourceNum = .introspective,
		using transaction: Transaction? = nil
	) throws -> MedicationDose {
		try createDose(
			medication: medication,
			dosage: dosage,
			timestamp: timestamp,
			source: source,
			using: transaction
		)
	}
}

public final class MedicationDAOImpl: MedicationDAO {
	public final func medicationExists(withName name: String, using transaction: Transaction?) throws -> Bool {
		let transaction = transaction ?? injected(Database.self).transaction()
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let medicationsWithSameName = try transaction.query(fetchRequest)
		return !medicationsWithSameName.isEmpty
	}

	public final func medicationNamed(_ name: String) throws -> Medication? {
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let medicationsWithSameName = try injected(Database.self).query(fetchRequest)
		guard !medicationsWithSameName.isEmpty else { return nil }
		return medicationsWithSameName[0]
	}

	public final func mostRecentDoseOf(_ medication: Medication) throws -> MedicationDose? {
		let fetchRequest: NSFetchRequest<MedicationDose> = MedicationDose.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "medication.name ==[cd] %@", medication.name)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
		let doses = try injected(Database.self).query(fetchRequest)
		return doses.first
	}

	@discardableResult
	public final func takeMedicationUsingDefaultDosage(_ medication: Medication) throws -> MedicationDose {
		try createDose(
			medication: medication,
			dosage: medication.dosage,
			timestamp: Date(),
			source: .introspective
		)
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
		let transaction = transaction ?? injected(Database.self).transaction()
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
			let numDefinitions = try injected(Database.self).query(Medication.fetchRequest()).count
			medication.recordScreenIndex = Int16(numDefinitions)
		}

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try injected(Database.self).pull(savedObject: medication)
	}

	@discardableResult
	public final func createDose(
		medication: Medication,
		dosage: Dosage?,
		timestamp: Date,
		source: Sources.MedicationSourceNum,
		using transaction: Transaction?
	) throws -> MedicationDose {
		let transaction = transaction ?? injected(Database.self).transaction()
		let dose = try transaction.new(MedicationDose.self)
		let sameContextMedication = try! transaction.pull(savedObject: medication)

		dose.medication = sameContextMedication
		dose.date = timestamp
		dose.dosage = dosage
		dose.setSource(source)
		sameContextMedication.addToDoses(dose)

		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		return try injected(Database.self).pull(savedObject: dose)
	}
}
