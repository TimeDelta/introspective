//
//  MedicationDataTestUtil.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
@testable import Introspective

public class MedicationDataTestUtil {

	@discardableResult
	public static func createMedication(
		name: String = "",
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil,
		recordScreenIndex: Int16 = 0)
	-> Medication {
		let transaction = DependencyInjector.db.transaction()
		let medication = try! transaction.new(Medication.self)
		medication.name = name
		medication.frequency = frequency
		medication.dosage = dosage
		medication.startedOn = startedOn
		medication.notes = note
		medication.recordScreenIndex = recordScreenIndex
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: medication)
	}

	@discardableResult
	public static func createDose(medication: Medication = createMedication(), dosage: Dosage? = nil, timestamp: Date = Date()) -> MedicationDose {
		let transaction = DependencyInjector.db.transaction()
		let dose = try! transaction.new(MedicationDose.self)
		let sameContextMedication = try! transaction.pull(savedObject: medication)
		dose.medication = sameContextMedication
		dose.timestamp = timestamp
		dose.dosage = dosage
		sameContextMedication.addToDoses(dose)
		try! transaction.commit()
		return try! DependencyInjector.db.pull(savedObject: dose)
	}
}
