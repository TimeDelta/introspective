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
@testable import Introspective

final class EasyPillMedicationDoseImporterFunctionalTests: FunctionalTest {

	private typealias Me = EasyPillMedicationDoseImporterFunctionalTests
	private static let url = URL(fileURLWithPath: "/")

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

	private static let validImportFileText = """
Pill name,Taken on,Time
\(medicationName1),\(date1Text),\(time1)
\(medicationName2),\(date2Text),\(time2)
\(medicationName3),\(date3Text),\(time3)
"""

	private final var importer: EasyPillMedicationDoseImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.db.new(EasyPillMedicationDoseImporterImpl.self)
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date3
		importer.importOnlyNewData = false
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: Me.url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssert(try doseWasImported(for: Me.medicationName3, at: Me.date3))
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date3
		importer.importOnlyNewData = true
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: Me.url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssertFalse(try doseWasImported(for: Me.medicationName3, at: Me.date3))
	}

	func testGivenNeverImportedBefore_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		createAllMedications()
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: Me.url)

		// then
		XCTAssert(try doseWasImported(for: Me.medicationName1, at: Me.date1))
		XCTAssert(try doseWasImported(for: Me.medicationName2, at: Me.date2))
		XCTAssert(try doseWasImported(for: Me.medicationName3, at: Me.date3))
	}

	func testGivenMedicationNameDoesNotExist_importData_throwsDisplayableError() throws {
		// given
		useInput(Me.validImportFileText)

		// when
		XCTAssertThrowsError(try importer.importData(from: Me.url)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenInvalidTimeFormat_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidInput = "\n\(Me.medicationName1),\(Me.date1Text),jrw"
		useInput(invalidInput)

		// when
		XCTAssertThrowsError(try importer.importData(from: Me.url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	// MARK: - Helper Functions

	private final func useInput(_ input: String) {
		Given(ioUtil, .contentsOf(.value(Me.url), willReturn: input))
	}

	private final func createAllMedications() {
		let _ = MedicationDataTestUtil.createMedication(name: Me.medicationName1)
		let _ = MedicationDataTestUtil.createMedication(name: Me.medicationName2)
	}

	private final func doseWasImported(for medicationName: String, at date: Date) throws -> Bool {
		let doses = try getDosesForMedicationNamed(medicationName)
		for dose in doses {
			if dose.timestamp == date {
				return true
			}
		}
		return false
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
		return try DependencyInjector.db.query(medicationsWithCurrentNameFetchRequest)
	}
}
