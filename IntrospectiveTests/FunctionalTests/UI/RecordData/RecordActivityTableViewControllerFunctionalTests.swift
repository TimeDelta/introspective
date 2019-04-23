//
//  RecordActivityTableViewControllerFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/11/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
import CSV
@testable import Introspective

final class RecordActivityTableViewControllerFunctionalTests: FunctionalTest {

	private final var controller: RecordActivityTableViewController!

	final override func setUp() {
		super.setUp()
		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "activitiesTable") as! RecordActivityTableViewController)
	}

	// MARK: - Reordering

	func testGivenMoveToLowerSpotWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		let definition3 = ActivityDataTestUtil.createActivityDefinition(name: "definition 3", recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, definition2.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, definition1.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, definition3.name)
	}

	func testGivenMoveToHigherSpotWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() {
		// given
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		let definition3 = ActivityDataTestUtil.createActivityDefinition(name: "definition 3", recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, definition1.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, definition3.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, definition2.name)
	}

	func testGivenMoveToLowerSpotWhileFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() {
		// given
		let filterString = "filter string"
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: filterString, recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		let definition3 = ActivityDataTestUtil.createActivityDefinition(name: "\(filterString) definition 3", recordScreenIndex: 2)
		let definition4 = ActivityDataTestUtil.createActivityDefinition(name: "definition 4 \(filterString)", recordScreenIndex: 3)
		controller.viewDidLoad()
		filterDefinitions(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(1))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterDefinitions(by: "") // reset filter string in order to check that all definitions are in correct spot
		XCTAssertEqual(getDefinition(atIndex: 0).name, definition2.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, definition3.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, definition1.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, definition4.name)
	}

	func testGivenMoveToHigherSpotWhileFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() {
		// given
		let filterString = "filter string"
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: filterString, recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		let definition3 = ActivityDataTestUtil.createActivityDefinition(name: "\(filterString) definition 3", recordScreenIndex: 2)
		let definition4 = ActivityDataTestUtil.createActivityDefinition(name: "definition 4 \(filterString)", recordScreenIndex: 3)
		controller.viewDidLoad()
		filterDefinitions(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(1), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterDefinitions(by: "") // reset filter string in order to check that all definitions are in correct spot
		XCTAssertEqual(getDefinition(atIndex: 0).name, definition3.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, definition1.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, definition2.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, definition4.name)
	}

	// MARK: Imported definitions

	func testGivenMoveToLowerSpotWithImportedDefinitionsWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		let importedName1 = "imported definition 1"
		let importedName2 = "imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, importedName1)
		XCTAssertEqual(getDefinition(atIndex: 2).name, existingDefinition1.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, importedName2)
	}

	func testGivenMoveToHigherSpotImportedDefinitionsWhileNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		let importedName1 = "imported definition 1"
		let importedName2 = "imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, importedName1)
		XCTAssertEqual(getDefinition(atIndex: 1).name, existingDefinition1.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, importedName2)
	}

	func testGivenMoveToLowerSpotWithImportedDefinitionsWhileFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let filterString = "filter string"

		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: filterString, recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		let importedName1 = "imported definition 1 \(filterString)"
		let importedName2 = "\(filterString) imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()
		filterDefinitions(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(0), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterDefinitions(by: "") // reset filter string in order to check that all definitions are in correct spot
		XCTAssertEqual(getDefinition(atIndex: 0).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, importedName1)
		XCTAssertEqual(getDefinition(atIndex: 2).name, importedName2)
		XCTAssertEqual(getDefinition(atIndex: 3).name, existingDefinition1.name)
	}

	func testGivenMoveToHigherSpotWithImportedDefinitionsWhileFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let filterString = "filter string"

		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: filterString, recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		let importedName1 = "imported definition 1 \(filterString)"
		let importedName2 = "\(filterString) imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		controller.viewDidLoad()
		filterDefinitions(by: filterString)

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(0))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		filterDefinitions(by: "") // reset filter string in order to check that all definitions are in correct spot
		XCTAssertEqual(getDefinition(atIndex: 0).name, importedName2)
		XCTAssertEqual(getDefinition(atIndex: 1).name, existingDefinition1.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, importedName1)
	}

	func testGivenMoveToLowerSpotWithNonImportedDefinitionCreatedWhileImportingAndNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		importer.pauseOnRecord = 2

		let importedName1 = "imported definition 1"
		let importedName2 = "imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		let definitionCreatedDuringImport1 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 1 created during import",
			recordScreenIndex: 2)
		let definitionCreatedDuringImport2 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(2), to: cellIndex(4))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until after the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, existingDefinition1.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, definitionCreatedDuringImport2.name)
		XCTAssertEqual(getDefinition(atIndex: 3).name, importedName1)
		XCTAssertEqual(getDefinition(atIndex: 4).name, definitionCreatedDuringImport1.name)
		XCTAssertEqual(getDefinition(atIndex: 5).name, importedName2)
	}

	func testGivenMoveToHigherSpotWithNonImportedDefinitionCreatedWhileImportingAndNotFiltering_tableViewMoveRowAtTo_correctlyReordersDefinitions() throws {
		// given
		let existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		let existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)

		let importer = try DependencyInjector.importer.aTrackerActivityImporter() as! ATrackerActivityImporterImpl
		importer.pauseOnRecord = 2

		let importedName1 = "imported definition 1"
		let importedName2 = "imported definition 2"
		setUpActivityImportFileContents([importedName1, importedName2])
		try importer.importData(from: URL(fileURLWithPath: "/"))

		let definitionCreatedDuringImport1 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 1 created during import",
			recordScreenIndex: 2)
		let definitionCreatedDuringImport2 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		controller.viewDidLoad()

		// when
		controller.tableView(controller.tableView, moveRowAt: cellIndex(4), to: cellIndex(2))

		// then
		// note: recordScreenIndex appears to not be updated in the CoreData stack until Fafter the calling thread is done
		//       and cannot use asynchronous asserts
		XCTAssertEqual(getDefinition(atIndex: 0).name, existingDefinition1.name)
		XCTAssertEqual(getDefinition(atIndex: 1).name, existingDefinition2.name)
		XCTAssertEqual(getDefinition(atIndex: 2).name, importedName1)
		XCTAssertEqual(getDefinition(atIndex: 3).name, definitionCreatedDuringImport1.name)
		XCTAssertEqual(getDefinition(atIndex: 4).name, definitionCreatedDuringImport2.name)
		XCTAssertEqual(getDefinition(atIndex: 5).name, importedName2)
	}

	// MARK: - Helper Functions

	private final func getDefinition(atIndex index: Int) -> ActivityDefinition {
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: index, section: 0)) as! RecordActivityDefinitionTableViewCell
		return cell.activityDefinition
	}

	private final func filterDefinitions(by filterString: String) {
		controller.setSearchText(filterString)
	}

	private final func cellIndex(_ i: Int) -> IndexPath {
		return IndexPath(row: i, section: 0)
	}

	private final func setUpActivityImportFileContents(_ activityNames: [String]) {
		var input = "Task name, Task description, Start time, End time, Duration,Duration in hours, Note, Category"
		for name in activityNames {
			input += "\n\"\(name)\",\"\",\"2018-02-07 21:17\",\"\",\"00:41:50\",0.6973508,\"\",\"\""
		}
		Given(ioUtil, .csvReader(
			url: .any,
			hasHeaderRow: .value(true),
			willReturn: try! CSVReader(string: input, hasHeaderRow: true)))
		Given(ioUtil, .contentsOf(.any, willReturn: input))
	}
}