//
//  MedicationDAOFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/7/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import Common
@testable import Samples

class MedicationDAOFunctionalTests: FunctionalTest {

	// MARK: Test Setup

	private typealias Me = MedicationDAOFunctionalTests

	private static let medicationInfo = MedicationInfo(
		name: "med name",
		dosage: Dosage("2 mg"),
		frequency: Frequency(2, .day),
		startedOn: Date(),
		startedOnTimeZone: TimeZone.autoupdatingCurrent,
		notes: "this is a note",
		source: Sources.MedicationSourceNum.introspective,
		recordScreenIndex: 0)

	private var dao: MedicationDAOImpl!

	public override final func setUp() {
		super.setUp()
		dao = MedicationDAOImpl()
	}

	// MARK: - medicationExists(withName: using:)

	func testGivenMedicationWithNameExists_medicationExists_returnsTrue() throws {
		// given
		let medicationName = "fnrejiqbnveiruq"
		MedicationDataTestUtil.createMedication(name: medicationName)

		// when
		let exists = try dao.medicationExists(withName: medicationName)

		// then
		XCTAssertTrue(exists)
	}

	func testGivenOnlyMedicationWithDifferentNameExists_medicationExists_returnsFalse() throws {
		// given
		let medicationName = "fnrejiqbnveiruq"
		MedicationDataTestUtil.createMedication(name: medicationName + "other stuff")

		// when
		let exists = try dao.medicationExists(withName: medicationName)

		// then
		XCTAssertFalse(exists)
	}

	func testGivenNoMedicationsExist_medicationExists_returnsFalse() throws {
		// given - no medications exist

		// when
		let exists = try dao.medicationExists(withName: "fnewjo")

		// then
		XCTAssertFalse(exists)
	}

	func testGivenMedicationExistsOnlyInPassedTransaction_medicationExists_returnsTrue() throws {
		// given
		let medicationName = "fnrejiqbnveiruq"
		let transaction = database.transaction()
		let medication = try transaction.new(Medication.self)
		medication.name = medicationName

		// when
		let exists = try dao.medicationExists(withName: medicationName, using: transaction)

		// then
		XCTAssertTrue(exists)
	}

	func testGivenMedicationWasDeletedInPassedTransaction_medicationExists_returnsFalse() throws {
		// given
		let medicationName = "fnrejiqbnveiruq"
		let medication = MedicationDataTestUtil.createMedication(name: medicationName)
		let transaction = database.transaction()
		try transaction.delete(medication)

		// when
		let exists = try dao.medicationExists(withName: medicationName, using: transaction)

		// then
		XCTAssertFalse(exists)
	}

	// MARK: - medicationNamed(_)

	func testGivenMedicationWithNameExists_medicationNamed_returnsExistingMedication() throws {
		// given
		let medicationName = "gfnuieq"
		let existingMedication = MedicationDataTestUtil.createMedication(name: medicationName)

		// when
		let returnedMedication = try dao.medicationNamed(medicationName)

		// then
		assertThat(returnedMedication, equals(existingMedication))
	}

	func testGivenOnlyMedicationWithDifferentNameExists_medicationNamed_returnsNil() throws {
		// given
		let medicationName = "hfuirwq"
		MedicationDataTestUtil.createMedication(name: medicationName + "other stuff")

		// when
		let medication = try dao.medicationNamed(medicationName)

		// then
		assertThat(medication, nilValue())
	}

	func testGivenNoMedicationsExist_medicationNamed_returnsNil() throws {
		// given - no medications exist

		// when
		let medication = try dao.medicationNamed("fnjik")

		// then
		assertThat(medication, nilValue())
	}

	// MARK: - takeMedicationUsingDefaultDosage(_)

	func testGivenValidInput_takeMedicationUsingDefaultDosage_createsMedicationDoseUsingDefaultDosgage() throws {
		// given
		let medicationDoseInfo = MedicationDoseInfo(
			medication: Me.medicationInfo,
			dosage: Me.medicationInfo.dosage,
			timestamp: Date(),
			timeZone: TimeZone.autoupdatingCurrent,
			source: .introspective)
		let medication = MedicationDataTestUtil.createMedication(Me.medicationInfo)

		// when
		try dao.takeMedicationUsingDefaultDosage(medication)

		// then
		assertThat(medicationDoseInfo, exists(MedicationDose.self))
	}

	// MARK: - createMedication()

	func testGivenValidInput_createMedication_correctlyCreatesMedication() throws {
		// given - medication does not already exist

		// when
		try dao.createMedication(
			name: Me.medicationInfo.name,
			frequency: Me.medicationInfo.frequency,
			dosage: Me.medicationInfo.dosage,
			startedOn: Me.medicationInfo.startedOn,
			note: Me.medicationInfo.notes,
			recordScreenIndex: Me.medicationInfo.recordScreenIndex)

		// then
		assertThat(Me.medicationInfo, exists(Medication.self))
	}

	// MARK: - createDose()

	func testGivenValidInput_createDose_correctlyCreatesDose() throws {
		// given
		let medicationDoseInfo = MedicationDoseInfo(
			medication: Me.medicationInfo,
			dosage: Me.medicationInfo.dosage,
			timestamp: Date(),
			timeZone: TimeZone.autoupdatingCurrent,
			source: .introspective)
		let medication = MedicationDataTestUtil.createMedication(Me.medicationInfo)

		// when
		try dao.createDose(
			medication: medication,
			dosage: medicationDoseInfo.dosage,
			timestamp: medicationDoseInfo.timestamp,
			source: medicationDoseInfo.source)

		// then
		assertThat(medicationDoseInfo, exists(MedicationDose.self))
	}
}
