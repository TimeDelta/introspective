//
//  EasyPillMedicationImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import SwiftyMocky
@testable import Introspective

final class EasyPillMedicationImporterFunctionalTests: ImporterTest {

	private typealias Me = EasyPillMedicationImporterFunctionalTests

	private static let name1 = "Bupropion"
	private static let notes1 = "hello, world"
	private static let dosage1Text = "50mg"
	private static let dosage1 = Dosage(50, "mg")
	private static let frequency1Text = "daily"
	private static let frequency1 = Frequency(1, .day)
	private static let startedOn1Text = "4/4/18"
	private static let startedOn1 = CalendarUtilImpl().date(from: startedOn1Text, format: "M/d/yy")!

	private static let name2 = ",92$igeg"
	private static let notes2 = ",,,"
	private static let dosage2Text = "@$3786(ifb"
	private static let dosage2: Dosage? = nil
	private static let frequency2Text = "every 2,5 hours"
	private static let frequency2 = Frequency(1.0 / 2.5, .hour)
	private static let startedOn2Text = "10/29/18"
	private static let startedOn2 = CalendarUtilImpl().date(from: startedOn2Text, format: "M/d/yy")!

	private static let validImportFileText = """
Pill name,Notes,Dosage,Frequency,How many times per day,How many days,Starting,Ending,Completed,Doses taken,Taking consistency,Quantity per dose,Current quantity,Required quantity,Pills will last until
\(name1),\(notes1),\(dosage1Text),\(frequency1Text),1,ongoing,\(startedOn1Text),-,-,206,98%,,,,
\(name2),\(notes2),\(dosage2Text),\(frequency2Text),1,10,\(startedOn2Text),11/7/18,5%,0,0%,,,,
"""

	private final var importer: EasyPillMedicationImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.db.new(EasyPillMedicationImporterImpl.self)
	}

	// MARK: - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.importOnlyNewData = false
		try createMedication1()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		try verifyMedication1Imported()
		try verifyMedication2Imported()
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.importOnlyNewData = true
		try createMedication1()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try medication1WasNotImported())
		try verifyMedication2Imported()
	}

	// MARK: - Invalid Data

	func testGivenInvalidInputWithValidNameAndFrequency_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidFileContents = """
Pill name,Notes,Dosage,Frequency,How many times per day,How many days,Starting,Ending,Completed,Doses taken,Taking consistency,Quantity per dose,Current quantity,Required quantity,Pills will last until
a,,,as needed
"""
		useInput(invalidFileContents)

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenInvalidInputWithNothingValid_importData_throwsInvalidFileFormatError() throws {
		let invalidFileContents = "\n\n"
		useInput(invalidFileContents)

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - Helper Functions

	private final func createMedication1() throws {
		let _ = MedicationDataTestUtil.createMedication(name: Me.name1)
	}

	private final func createMedication2() throws {
		let _ = MedicationDataTestUtil.createMedication(name: Me.name2)
	}

	private final func verifyMedication1Imported() throws {
		try verifyMedicationImported(name: Me.name1, startedOn: Me.startedOn1, frequency: Me.frequency1, dosage: Me.dosage1, notes: Me.notes1)
	}

	private final func verifyMedication2Imported() throws {
		try verifyMedicationImported(name: Me.name2, startedOn: Me.startedOn2, frequency: Me.frequency2, dosage: Me.dosage2, notes: Me.notes2)
	}

	private final func medication1WasNotImported() throws -> Bool {
		return try medicationWasNotImported(name: Me.name1, startedOn: Me.startedOn1, frequency: Me.frequency1, dosage: Me.dosage1, notes: Me.notes1)
	}

	private final func medication2WasNotImported() throws -> Bool {
		return try medicationWasNotImported(name: Me.name2, startedOn: Me.startedOn2, frequency: Me.frequency2, dosage: Me.dosage2, notes: Me.notes2)
	}

	private final func verifyMedicationImported(name: String, startedOn: Date?, frequency: Frequency?, dosage: Dosage?, notes: String?) throws {
		let medications = try getMedicationsWith(name: name)
		if medications.count == 0 {
			XCTFail("Medication named '\(name)' was not imported")
		} else if medications.count > 1 {
			XCTFail("Found \(medications.count) medication records with name '\(name)'")
		} else {
			let medication = medications[0]
			XCTAssertEqual(medication.startedOn, startedOn, name)
			XCTAssertEqual(medication.frequency, frequency, name)
			XCTAssertEqual(medication.dosage, dosage, name)
			XCTAssertEqual(medication.notes, notes, name)
		}
	}

	private final func medicationWasNotImported(name: String, startedOn: Date?, frequency: Frequency?, dosage: Dosage?, notes: String?) throws -> Bool {
		let medications = try getMedicationsWith(name: name)
		if medications.count != 0 {
			for medication in medications {
				if medication.startedOn == startedOn && medication.frequency == frequency && medication.dosage == dosage && medication.notes == notes {
					return false
				}
			}
		}
		return true
	}

	private final func getMedicationsWith(name: String) throws -> [Medication] {
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		return try DependencyInjector.db.query(medicationsWithCurrentNameFetchRequest)
	}
}
