//
//  EasyPillMedicationDoseImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import SwiftyMocky
import Hamcrest

@testable import Introspective
@testable import Common
@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

final class EasyPillMedicationDoseImporterFunctionalTests: ImporterTest {

	// MARK: - Test Setup

	private typealias Me = EasyPillMedicationDoseImporterFunctionalTests

	private static let medicationName1 = ",f,new,ou"
	private static let date1Text = "4/4/18"
	private static let time1 = "13:43"
	private static let date1 = CalendarUtilImpl().date(from: date1Text + " " + time1, format: "M/d/yy HH:mm")!

	private static let medicationName2 = "jhfiu"
	private static let date2Text = "6/23/17"
	private static let time2 = "02:54"
	private static let date2 = CalendarUtilImpl().date(from: date2Text + " " + time2, format: "M/d/yy HH:mm")!

	private static let medicationName3 = medicationName1
	private static let date3Text = "5/22/12"
	private static let time3 = "12:53"
	private static let date3 = CalendarUtilImpl().date(from: date3Text + " " + time3, format: "M/d/yy HH:mm")!

	private static let headerRow = "Pill name,Taken on,Time"

	private static let validImportFileText = """
\(headerRow)
\(medicationName1),\(date1Text),\(time1)
\(medicationName2),\(date2Text),\(time2)
\(medicationName3),\(date3Text),\(time3)
"""

	private final var importer: EasyPillMedicationDoseImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! injected(ImporterFactory.self).easyPillMedicationDoseImporter() as! EasyPillMedicationDoseImporterImpl
	}

	// MARK: - importData() - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date3
		importer.importOnlyNewData = false
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssert(try doseWasImported(for: Me.medicationName3, at: Me.date3))
		XCTAssertEqual(importer.lastImport, Me.date1)
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date3
		importer.importOnlyNewData = true
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssertFalse(try doseWasImported(for: Me.medicationName3, at: Me.date3))
		XCTAssertEqual(importer.lastImport, Me.date1)
	}

	func testGivenNeverImportedBefore_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssert(try doseWasImported(for: Me.medicationName3, at: Me.date3))
		XCTAssertEqual(importer.lastImport, Me.date1)
	}

	func testGivenImportCancelled_importData_startsNewImport() throws {
		// given
		createAllMedications()
		useInput(Me.validImportFileText)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let originalPercentComplete = importer.percentComplete()

		// when
		try importer.importData(from: url)

		// then
		XCTAssertGreaterThan(importer.percentComplete(), originalPercentComplete)
		XCTAssertFalse(importer.isCancelled)
	}

	// MARK: - importData() - Invalid Data

	func testGivenMedicationNameDoesNotExist_importData_throwsDisplayableError() throws {
		// given
		useInput(Me.validImportFileText)

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenInvalidTimeFormat_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidInput = "\n\(Me.medicationName1),\(Me.date1Text),jrw"
		useInput(invalidInput)

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenErrorThrownAfterValidDosesCreated_importData_deletesDosesFromCurrentImport() throws {
		// given
		useInput("""
\(Me.headerRow)
\(Me.medicationName1),\(Me.date1Text),\(Me.time1)
abc,,
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssertFalse(try! doseWasImported(for: Me.medicationName1, at: Me.date1))
		}
	}

	func testGivenInvalidData_importData_doesNotDeleteDosesNotPartOfImport() throws {
		// given
		useInput("fdhj\n\n")
		let existingMedicationName = "fdsjho"
		let existingDoseDate = Date()
		let dose = MedicationDataTestUtil.createDose(
			medication: MedicationDataTestUtil.createMedication(name: existingMedicationName),
			timestamp: existingDoseDate
		)

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			assertThat(MedicationDoseInfo(dose), exists(MedicationDose.self))
		}
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		importer = try injected(Database.self).pull(savedObject: importer)
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - cancel()

	func testGivenNotImporting_cancel_setsIsCancelledToTrue() {
		// when
		importer.cancel()

		// then
		XCTAssert(importer.isCancelled)
	}

	func testGivenCurrentlyImporting_cancel_stopsImportAndSetsIsCancelledToTrue() {
		// given
		useInput(Me.validImportFileText)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}

		// when
		while importer.percentComplete() == 0 {}
		importer.cancel()

		// then
		XCTAssertLessThanOrEqual(importer.percentComplete(), 1)
		XCTAssert(importer.isCancelled)
	}

	// MARK: - resume()

	func testGivenImportCancelled_resume_doesNotContinue() throws {
		// given
		useInput(Me.validImportFileText)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let expectedPerentComplete = importer.percentComplete()

		// when
		try importer.resume()

		// then
		XCTAssertEqual(importer.percentComplete(), expectedPerentComplete)
	}

	// MARK: - Helper Functions

	private final func createAllMedications() {
		let _ = MedicationDataTestUtil.createMedication(name: Me.medicationName1)
		let _ = MedicationDataTestUtil.createMedication(name: Me.medicationName2)
	}

	private final func doseWasImported(for medicationName: String, at date: Date) throws -> Bool {
		return try dose(named: medicationName, at: date) != nil
	}

	private final func dose(named medicationName: String, at date: Date) throws -> MedicationDose? {
		let doses = try getDosesForMedicationNamed(medicationName)
		for dose in doses {
			if dose.date == date {
				return dose
			}
		}
		return nil
	}

	private final func getDosesForMedicationNamed(_ name: String) throws -> [MedicationDose] {
		let medications = try getMedicationsWith(name: name)
		var doses = [MedicationDose]()
		for medication in medications {
			doses.append(contentsOf: medication.doses.map{ $0 as! MedicationDose })
		}
		return doses
	}

	private final func getMedicationsWith(name: String) throws -> [Medication] {
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		return try injected(Database.self).query(medicationsWithCurrentNameFetchRequest)
	}
}
