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

	public static func createMedication(
		name: String = "",
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil,
		recordScreenIndex: Int16 = 0)
	-> Medication {
		let medication = try! DependencyInjector.db.new(objectType: Medication.self)
		medication.name = name
		medication.frequency = frequency
		medication.dosage = dosage
		medication.startedOn = startedOn
		medication.notes = note
		medication.recordScreenIndex = recordScreenIndex
		DependencyInjector.db.save()
		return medication
	}

	public static func createDose(medication: Medication = createMedication(), dosage: Dosage? = nil, timestamp: Date = Date()) -> MedicationDose {
		let dose = DependencyInjector.sample.medicationDose()
		dose.medication = try! DependencyInjector.db.pull(savedObject: medication, fromSameContextAs: dose)
		dose.timestamp = timestamp
		dose.dosage = dosage
		return dose
	}
}
