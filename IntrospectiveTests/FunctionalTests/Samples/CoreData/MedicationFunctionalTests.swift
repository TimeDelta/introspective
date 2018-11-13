//
//  MedicationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class MedicationFunctionalTests: FunctionalTest {

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = DoubleAttribute(name: "this is not a real attribute")
		let medication = MedicationDataTestUtil.createMedication()

		// when
		XCTAssertThrowsError(try medication.value(of: unknownAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenNameAttribute_valueOf_returnsCorrectName() throws {
		// given
		let expectedName = "this is a name"
		let medication = MedicationDataTestUtil.createMedication(name: expectedName)

		// when
		let name = try medication.value(of: Medication.nameAttribute) as? String

		// then
		XCTAssertEqual(name, expectedName)
	}

	func testGivenDosageAttribute_valueOf_returnsCorrectDosage() throws {
		// given
		let expectedDosage = Dosage(23.5, "fdhsjlk")
		let medication = MedicationDataTestUtil.createMedication(dosage: expectedDosage)

		// when
		let dosage = try medication.value(of: Medication.dosage) as? Dosage

		// then
		XCTAssertEqual(dosage, expectedDosage)
	}

	func testGivenFrequencyAttribute_valueOf_returnsCorrectFrequency() throws {
		// given
		let expectedFrequency = Frequency(6.0, .day)
		let medication = MedicationDataTestUtil.createMedication(frequency: expectedFrequency)

		// when
		let frequency = try medication.value(of: Medication.frequency) as? Frequency

		// then
		XCTAssertEqual(frequency, expectedFrequency)
	}

	func testGivenStartedOnAttribute_valueOf_returnsCorrectStartedOn() throws {
		// given
		let expectedStartedOn = Date()
		let medication = MedicationDataTestUtil.createMedication(startedOn: expectedStartedOn)

		// when
		let startedOn = try medication.value(of: Medication.startedOn) as? Date

		// then
		XCTAssertEqual(startedOn, expectedStartedOn)
	}

	func testGivenNotesAttribute_valueOf_returnsCorrectNotes() throws {
		// given
		let expectedNotes = "this is some notes"
		let medication = MedicationDataTestUtil.createMedication(note: expectedNotes)

		// when
		let notes = try medication.value(of: Medication.notes) as? String

		// then
		XCTAssertEqual(notes, expectedNotes)
	}


	func testGivenNameAttribute_set_correctlySetsName() throws {
		// given
		let expectedName = "this is a name"
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.nameAttribute, to: expectedName)

		// then
		XCTAssertEqual(expectedName, medication.name)
	}

	func testGivenDosageAttribute_set_correctlySetsDosage() throws {
		// given
		let expectedDosage = Dosage(2, "ml")
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.dosage, to: expectedDosage)

		// then
		XCTAssertEqual(expectedDosage, medication.dosage)
	}

	func testGivenFrequencyAttribute_set_correctlySetsFrequency() throws {
		// given
		let expectedFrequency = Frequency(4, .weekOfYear)
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.frequency, to: expectedFrequency)

		// then
		XCTAssertEqual(expectedFrequency, medication.frequency)
	}

	func testGivenStartedOnAttribute_set_correctlySetsStartedOn() throws {
		// given
		let expectedStartedOn = Date()
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.startedOn, to: expectedStartedOn)

		// then
		XCTAssertEqual(expectedStartedOn, medication.startedOn)
	}

	func testGivenNotesAttribute_set_correctlySetsNotes() throws {
		// given
		let expectedNotes = "these are some notes about the medication"
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.notes, to: expectedNotes)

		// then
		XCTAssertEqual(expectedNotes, medication.notes)
	}
}
