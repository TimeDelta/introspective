//
//  MedicationDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

public class MedicationDataTestUtil {

	@discardableResult
	public static func createMedication(
		name: String = "",
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil,
		source: Sources.MedicationSourceNum = .introspective,
		recordScreenIndex: Int16 = 0)
	-> Medication {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let medication = try! transaction.new(Medication.self)
		medication.name = name
		medication.frequency = frequency
		medication.dosage = dosage
		medication.startedOn = startedOn
		medication.notes = note
		medication.recordScreenIndex = recordScreenIndex
		medication.setSource(source)
		try! transaction.commit()
		return try! DependencyInjector.get(Database.self).pull(savedObject: medication)
	}

	@discardableResult
	public static func createDose(
		medication: Medication = createMedication(),
		dosage: Dosage? = nil,
		timestamp: Date = Date(),
		source: Sources.MedicationSourceNum = .introspective)
	-> MedicationDose {
		let transaction = DependencyInjector.get(Database.self).transaction()
		let dose = try! transaction.new(MedicationDose.self)
		let sameContextMedication = try! transaction.pull(savedObject: medication)
		dose.medication = sameContextMedication
		dose.date = timestamp
		dose.dosage = dosage
		dose.setSource(source)
		sameContextMedication.addToDoses(dose)
		try! transaction.commit()
		return try! DependencyInjector.get(Database.self).pull(savedObject: dose)
	}

	@discardableResult
	public static func createDose(
		name: String,
		dosage: Dosage? = nil,
		timestamp: Date = Date(),
		source: Sources.MedicationSourceNum = .introspective)
	-> MedicationDose {
		return createDose(medication: createMedication(name: name), dosage: dosage, timestamp: timestamp)
	}
}
