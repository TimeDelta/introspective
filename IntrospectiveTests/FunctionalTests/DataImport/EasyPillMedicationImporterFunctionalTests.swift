//
//  EasyPillMedicationImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
import CoreData
@testable import Introspective
@testable import Common
@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

final class EasyPillMedicationImporterFunctionalTests: ImporterTest {

	private typealias Me = EasyPillMedicationImporterFunctionalTests

	private static let dosage1Text = "50mg"
	private static let frequency1Text = "daily"
	private static let startedOn1Text = "4/4/18"
	private static let medInfo1 = MedInfo(
		name: "Bupropion",
		notes: "hello, world",
		dosage: Dosage(50, "mg"),
		frequency: Frequency(1, .day)!,
		startedOn: CalendarUtilImpl().date(from: startedOn1Text, format: "M/d/yy")!)

	private static let dosage2Text = "@$3786(ifb"
	private static let frequency2Text = "every 2,5 hours"
	private static let startedOn2Text = "10/29/18"
	private static let medInfo2 = MedInfo(
		name: ",92$igeg",
		notes: ",,,",
		dosage: nil,
		frequency: Frequency(1.0 / 2.5, .hour)!,
		startedOn: CalendarUtilImpl().date(from: startedOn2Text, format: "M/d/yy")!)

	private static let validImportFileText = """
Pill name,Notes,Dosage,Frequency,How many times per day,How many days,Starting,Ending,Completed,Doses taken,Taking consistency,Quantity per dose,Current quantity,Required quantity,Pills will last until
\(medInfo1.name),\(medInfo1.notes ?? ""),\(dosage1Text),\(frequency1Text),1,ongoing,\(startedOn1Text),-,-,206,98%,,,,
\(medInfo2.name),\(medInfo2.notes ?? ""),\(dosage2Text),\(frequency2Text),1,10,\(startedOn2Text),11/7/18,5%,0,0%,,,,
"""

	private final var importer: EasyPillMedicationImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.get(ImporterFactory.self).easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
	}

	// MARK: - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.importOnlyNewData = false
		createMedication1()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.medInfo1, isImported())
		assertThat(Me.medInfo2, isImported())
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.importOnlyNewData = true
		createMedication1()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.medInfo1, not(isImported()))
		assertThat(Me.medInfo2, isImported())
	}

	/// failure of this test can (but is not guaranteed to) cause weird re-ordering bug on record screen
	func testGivenOtherMedicationsCreatedOutsideOfImport_importData_correctlySetsRecordScreenIndexes() throws {
		// given
		var existingMedication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		var existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)
		useInput(Me.validImportFileText)
		importer.pauseOnRecord = 2

		// when
		try importer.importData(from: url)

		var medicationCreatedDuringImport1 = MedicationDataTestUtil.createMedication(
			name: "med 1 created during import",
			recordScreenIndex: 2)
		var medicationCreatedDuringImport2 = MedicationDataTestUtil.createMedication(
			name: "med 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		// then
		existingMedication1 = try database.pull(savedObject: existingMedication1)
		existingMedication2 = try database.pull(savedObject: existingMedication2)
		medicationCreatedDuringImport1 = try database.pull(savedObject: medicationCreatedDuringImport1)
		medicationCreatedDuringImport2 = try database.pull(savedObject: medicationCreatedDuringImport2)

		let medsWithImported1Name = try getMedicationsWith(name: Me.medInfo1.name)
		assertThat(medsWithImported1Name, hasCount(1))
		let medsWithImported2Name = try getMedicationsWith(name: Me.medInfo2.name)
		assertThat(medsWithImported2Name, hasCount(1))

		XCTAssertEqual(existingMedication1.recordScreenIndex, 0)
		XCTAssertEqual(existingMedication2.recordScreenIndex, 1)
		XCTAssertEqual(medicationCreatedDuringImport1.recordScreenIndex, 2)
		XCTAssertEqual(medicationCreatedDuringImport2.recordScreenIndex, 3)
		if medsWithImported1Name.count == 1 {
			XCTAssertEqual(medsWithImported1Name[0].recordScreenIndex, 4)
		}
		if medsWithImported2Name.count == 1 {
			XCTAssertEqual(medsWithImported2Name[0].recordScreenIndex, 5)
		}
	}

	func testGivenImportCancelled_importData_startsNewImport() throws {
		// given
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
		importer = try DependencyInjector.get(Database.self).pull(savedObject: importer)
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

	private final func createMedication1() {
		MedicationDataTestUtil.createMedication(name: Me.medInfo1.name)
	}

	private final func createMedication2() {
		MedicationDataTestUtil.createMedication(name: Me.medInfo2.name)
	}

	private final func isImported() -> Hamcrest.Matcher<MedInfo> {
		return Hamcrest.Matcher<MedInfo>("is imported") { (medInfo: MedInfo) -> MatchResult in
			do {
				let medications = try self.getMedicationsWith(name: medInfo.name)
				if medications.count == 0 {
					return .mismatch("not imported")
				} else if medications.count > 1 {
					return .mismatch("found \(medications.count) medication records with name '\(medInfo.name)'")
				} else {
					let medication = medications[0]
					if medication.startedOn != medInfo.startedOn { return .mismatch("had startedOn: \(String(describing: medication.startedOn))") }
					if medication.frequency != medInfo.frequency { return .mismatch("had frequency: \(String(describing: medication.frequency))") }
					if medication.dosage != medInfo.dosage { return .mismatch("had dosage: \(String(describing: medication.dosage))") }
					if medication.notes != medInfo.notes { return .mismatch("had notes: \(String(describing: medication.notes))") }
				}
			} catch {
				return .mismatch("error thrown in matcher: \(errorInfo(error))")
			}
			return .match
		}
	}

	private final func getMedicationsWith(name: String) throws -> [Medication] {
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		return try DependencyInjector.get(Database.self).query(medicationsWithCurrentNameFetchRequest)
	}

	// MARK: - structs

	private struct MedInfo {
		var name: String
		var notes: String?
		var dosage: Dosage?
		var frequency: Frequency?
		var startedOn: Date?
		var recordScreenIndex: Int16

		public init(name: String, notes: String? = nil, dosage: Dosage? = nil, frequency: Frequency? = nil, startedOn: Date? = nil, recordScreenIndex: Int16 = 0) {
			self.name = name
			self.notes = notes
			self.dosage = dosage
			self.frequency = frequency
			self.startedOn = startedOn
			self.recordScreenIndex = recordScreenIndex
		}
	}
}
