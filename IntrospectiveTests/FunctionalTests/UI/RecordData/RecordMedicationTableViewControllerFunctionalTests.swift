//
//  RecordMedicationTableViewControllerFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/4/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import CoreData
@testable import Introspective

final class RecordMedicationTableViewControllerFunctionalTests: FunctionalTest {

	private final var controller: RecordMedicationTableViewController!

	final override func setUp() {
		super.setUp()
		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "medicationsTable") as! RecordMedicationTableViewController)
	}

	// MARK: - Reordering

	func testGivenMoveToLowerSpotWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)
		let medication3 = MedicationDataTestUtil.createMedication(name: "med 3", recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, medication2.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, medication1.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, medication3.name)
	}

	func testGivenMoveToHigherSpotWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)
		let medication3 = MedicationDataTestUtil.createMedication(name: "med 3", recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, medication1.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, medication3.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, medication2.name)
	}

	func testGivenMoveToLowerSpotWhileFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() {
		// given
		let filterString = "filter string"
		let medication1 = MedicationDataTestUtil.createMedication(name: filterString, recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)
		let medication3 = MedicationDataTestUtil.createMedication(name: "\(filterString) med 3", recordScreenIndex: 2)
		let medication4 = MedicationDataTestUtil.createMedication(name: "med 4 \(filterString)", recordScreenIndex: 3)
		controller.viewDidLoad()
		filterMedications(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterMedications(by: "") // reset filter string in order to check that all medications are in correct spot
		XCTAssertEqual(getMedication(atIndex: 0).name, medication2.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, medication3.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, medication1.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, medication4.name)
	}

	func testGivenMoveToHigherSpotWhileFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() {
		// given
		let filterString = "filter string"
		let medication1 = MedicationDataTestUtil.createMedication(name: filterString, recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)
		let medication3 = MedicationDataTestUtil.createMedication(name: "\(filterString) med 3", recordScreenIndex: 2)
		let medication4 = MedicationDataTestUtil.createMedication(name: "med 4 \(filterString)", recordScreenIndex: 3)
		controller.viewDidLoad()
		filterMedications(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(1), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterMedications(by: "") // reset filter string in order to check that all medications are in correct spot
		XCTAssertEqual(getMedication(atIndex: 0).name, medication3.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, medication1.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, medication2.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, medication4.name)
	}

	// MARK: Imported Medications

	func testGivenMoveToLowerSpotWithImportedMedicationsWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let existingMedication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		let importedName1 = "imported med 1"
		let importedName2 = "imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, importedName1)
		XCTAssertEqual(getMedication(atIndex: 2).name, existingMedication1.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, importedName2)
	}

	func testGivenMoveToHigherSpotImportedMedicationsWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let existingMedication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		let importedName1 = "imported med 1"
		let importedName2 = "imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, importedName1)
		XCTAssertEqual(getMedication(atIndex: 1).name, existingMedication1.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, importedName2)
	}

	func testGivenMoveToLowerSpotWithImportedMedicationsWhileFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let filterString = "filter string"

		let existingMedication1 = MedicationDataTestUtil.createMedication(name: filterString, recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		let importedName1 = "imported med 1 \(filterString)"
		let importedName2 = "\(filterString) imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()
		filterMedications(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterMedications(by: "") // reset filter string in order to check that all medications are in correct spot
		XCTAssertEqual(getMedication(atIndex: 0).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, importedName1)
		XCTAssertEqual(getMedication(atIndex: 2).name, importedName2)
		XCTAssertEqual(getMedication(atIndex: 3).name, existingMedication1.name)
	}

	func testGivenMoveToHigherSpotWithImportedMedicationsWhileFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let filterString = "filter string"

		let existingMedication1 = MedicationDataTestUtil.createMedication(name: filterString, recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		let importedName1 = "imported med 1 \(filterString)"
		let importedName2 = "\(filterString) imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()
		filterMedications(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterMedications(by: "") // reset filter string in order to check that all medications are in correct spot
		XCTAssertEqual(getMedication(atIndex: 0).name, importedName2)
		XCTAssertEqual(getMedication(atIndex: 1).name, existingMedication1.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, importedName1)
	}

	func testGivenMoveToLowerSpotWithNonImportedMedicationCreatedWhileImportingAndNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let existingMedication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		importer.pauseOnRecord = 2

		let importedName1 = "imported med 1"
		let importedName2 = "imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		let medicationCreatedDuringImport1 = MedicationDataTestUtil.createMedication(
			name: "med 1 created during import",
			recordScreenIndex: 2)
		let medicationCreatedDuringImport2 = MedicationDataTestUtil.createMedication(
			name: "med 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(4))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, existingMedication1.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, medicationCreatedDuringImport2.name)
		XCTAssertEqual(getMedication(atIndex: 3).name, importedName1)
		XCTAssertEqual(getMedication(atIndex: 4).name, medicationCreatedDuringImport1.name)
		XCTAssertEqual(getMedication(atIndex: 5).name, importedName2)
	}

	func testGivenMoveToHigherSpotWithNonImportedMedicationCreatedWhileImportingAndNotFiltering_tableViewMoveRowAtTo_correctlyReordersMedications() throws {
		// given
		let existingMedication1 = MedicationDataTestUtil.createMedication(name: "med 1", recordScreenIndex: 0)
		let existingMedication2 = MedicationDataTestUtil.createMedication(name: "med 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.easyPillMedicationImporter() as! EasyPillMedicationImporterImpl
		importer.pauseOnRecord = 2

		let importedName1 = "imported med 1"
		let importedName2 = "imported med 2"
		setUpMedicationImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		let medicationCreatedDuringImport1 = MedicationDataTestUtil.createMedication(
			name: "med 1 created during import",
			recordScreenIndex: 2)
		let medicationCreatedDuringImport2 = MedicationDataTestUtil.createMedication(
			name: "med 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(4), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until Fafter the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getMedication(atIndex: 0).name, existingMedication1.name)
		XCTAssertEqual(getMedication(atIndex: 1).name, existingMedication2.name)
		XCTAssertEqual(getMedication(atIndex: 2).name, importedName1)
		XCTAssertEqual(getMedication(atIndex: 3).name, medicationCreatedDuringImport1.name)
		XCTAssertEqual(getMedication(atIndex: 4).name, medicationCreatedDuringImport2.name)
		XCTAssertEqual(getMedication(atIndex: 5).name, importedName2)
	}

	// MARK: - Helper Functions

	private final func getMedication(atIndex index: Int) -> Medication {
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: index, section: 0)) as! RecordMedicationTableViewCell
		return cell.medication
	}

	private final func filterMedications(by filterString: String) {
		controller.setSearchText(filterString)
	}

	private final func cellIndex(_ i: Int) -> IndexPath {
		return IndexPath(row: i, section: 0)
	}

	private final func setUpMedicationImportFileContents(_ medicationNames: [String]) {
		var input = "Pill name,Notes,Dosage,Frequency,How many times per day,How many days,Starting,Ending,Completed,Doses taken,Taking consistency,Quantity per"
		for name in medicationNames {
			input += "\n\(name),notes,1mg,as needed,1,ongoing,1/10/12,-,-,206,98%,,,,"
		}
		Given(ioUtil, .contentsOf(.any, willReturn: input))
	}
}
