//
//  ImportDataTableViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import CSV
import UserNotifications
@testable import Introspective

final class ImportDataTableViewControllerUnitTests: UnitTest {

	private final var controller: ImportDataTableViewController!
	private final var tableView: UITableView { return controller.tableView }
	private final let url = URL(fileURLWithPath: "/")
	private final var mockImporterFactory: ImporterFactoryMock!
	private final var importer: ATrackerActivityImporterMock!

	private final let importSleepTime: UInt32 = 2
	private final let importerDataType = "this is the name of the data type for the importer"
	private final let importerSourceName = "this is the name of the source for the importer"

	private final let sectionRows = ImportDataTableViewController.sectionRows
	private final let activeImportsSection = ImportDataTableViewController.sectionRows.count

	final override func setUp() {
		super.setUp()
		mockImporterFactory = ImporterFactoryMock()
		Given(injectionProvider, .importerFactory(willReturn: mockImporterFactory))

		importer = ATrackerActivityImporterMock()
		Given(importer, .percentComplete(willReturn: 0.5))
		Given(importer, .customImportMessage(getter: nil))
		Given(importer, .dataTypePluralName(getter: importerDataType))
		Given(importer, .sourceName(getter: importerSourceName))
		Given(importer, .isPaused(getter: false))
		Given(importer, .isCancelled(getter: false))
		Given(mockImporterFactory, .aTrackerActivityImporter(willReturn: importer))

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "importData") as! ImportDataTableViewController)
	}

	// MARK: - numberOfSections

	func testGivenNoActiveImports_numberOfSections_returnsNormalSectionsCount() {
		// when
		let numberOfSections = controller.numberOfSections(in: tableView)

		// then
		XCTAssertEqual(numberOfSections, sectionRows.count)
	}

	func testGivenActiveImports_numberOfSections_returnsNormalSectionsCountPlusOne() throws {
		// given
		try setUpActiveImport()
		sleep(1)

		// when
		let numberOfSections = controller.numberOfSections(in: tableView)

		// then
		XCTAssertEqual(numberOfSections, sectionRows.count + 1)
	}

	// MARK: - tableViewNumberOfRowsInSection

	func testGivenActiveImportsSectionAndNoActiveImports_tableViewNumberOfRowsInSection_returns0() {
		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: activeImportsSection)

		// then
		XCTAssertEqual(rows, 0)
	}

	func testGivenActiveImportsSectionWithOneActiveImport_tableViewNumberOfRowsInSection_returns1() throws {
		// given
		try setUpActiveImport()
		sleep(1)

		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: activeImportsSection)

		// then
		XCTAssertEqual(rows, 1)
	}

	func testGivenEachNonActiveImportsSection_tableViewNumberOfRowsInSection_returnsCorrectValue() {
		for i in 0 ..< sectionRows.count {
			// when
			let rows = controller.tableView(tableView, numberOfRowsInSection: i)

			// then
			XCTAssertEqual(rows, sectionRows[i].rows.count)
		}
	}

	// MARK: - tableViewCellForRowAt

	func testGivenActiveImportSection_tableViewCellForRowAt_stopsObservingPresentViewNotificationsForAssociatedImporter() throws {
		// given
		try setUpActiveImport()
		sleep(1)

		// when
		let _ = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: activeImportsSection))

		// then
		Verify(mockUiUtil, .stopObserving(.value(controller), name: .value(.presentView), object: .value(importer)))
	}

	// MARK: - sectionTitle

	func testGivenActiveImportsSection_sectionTitle_returnsActiveImports() {
		// when
		let sectionTitle = controller.tableView(tableView, titleForHeaderInSection: activeImportsSection)

		// then
		XCTAssertEqual(sectionTitle, "Active Imports")
	}

	// MARK: - tableViewHeightForRow

	func testGivenNormalSectionRow_tableViewHeightForRow_returnsValueLessThanHeightForActiveImportRow() {
		// given
		let activeImportCellHeight = controller.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: activeImportsSection))
		let normalSection = activeImportsSection - 1

		// when
		let normalCellHeight = controller.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: normalSection))

		// then
		XCTAssertLessThan(normalCellHeight, activeImportCellHeight)
	}

	// MARK: - tableViewDidSelectRow

	func testGivenDataTypeNeverImportedFromSpecifiedSource_tableViewDidSelectRow_showsAlertWithTitleNeverImported() {
		// given
		let dateString = "this shouldn't be in alert title"
		Given(importer, .lastImport(getter: nil))
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: dateString))

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

		// then
		let alertCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.any, alertCaptor.capture(), animated: .any, completion: .any))
		guard let alert = alertCaptor.value as? UIAlertController else {
			XCTFail("Unable to get alert controller")
			return
		}
		XCTAssertEqual(alert.title, "Never imported")
	}

	func testGivenPreviouslyImportedAndResetLastImportDateChosen_tableViewDidSelectRow_resetsLastImportDate() throws {
		// given
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: ""))
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		let alertCaptor = ArgumentCaptor<UIViewController>()
		Verify(mockUiUtil, .present(.any, alertCaptor.capture(), animated: .any, completion: .any))
		guard let alert = alertCaptor.value as? UIAlertController else {
			XCTFail("Unable to get alert controller")
			return
		}

		// when
		try alert.tapButton(withTitle: "Reset Last Import Date")

		// then
		Verify(importer, .resetLastImportDate())
	}

	// MARK: - runImportInBackground

	func testGivenImportNotStarted_runImportInBackground_startsImport() throws {
		// when
		try setUpActiveImport()
		sleep(1)

		// then
		Verify(importer, .importData(from: .value(url)))
	}

	func testGivenActiveImportCompletes_runImportInBackground_sendsSuccessfulImportNotificationToUser() throws {
		// given
		try setUpActiveImport()

		// when
		sleep(importSleepTime)

		// then
		let expectedId = "FinishedImport"
		let contentCaptor = ArgumentCaptor<UNMutableNotificationContent>()
		Verify(
			mockUiUtil,
			.sendUserNotification(
				withContent: contentCaptor.capture(),
				id: .value(expectedId),
				repeats: .value(false),
				interval: .value(1)))
		if let content = contentCaptor.value {
			assertThat(content.title, containsString("Finished importing"))
			assertThat(content.body, containsString(importerSourceName))
			assertThat(content.body, containsString(importerDataType))
			XCTAssertEqual(content.categoryIdentifier, UserNotificationDelegate.finishedImportingActivities.identifier)
		} else {
			XCTFail("No captured content (Found \(contentCaptor.allValues.count) other notifications)")
		}
	}

	func testGivenActiveImportThrowsError_runImportInBackground_sendsErrorNotificationToUser() throws {
		// given
		let errorTitle = "displayable error title"
		let errorDescription = "displayable error description"
		let error = GenericDisplayableError(title: errorTitle, description: errorDescription)
		Given(importer, .importData(from: .any, willThrow: error))

		// when
		try setUpActiveImport(sleepOnImport: false)
		sleep(1)

		// then
		let expectedId = "ImportErrorOccurred"
		let contentCaptor = ArgumentCaptor<UNMutableNotificationContent>()
		Verify(
			mockUiUtil,
			.sendUserNotification(
				withContent: contentCaptor.capture(),
				id: .value(expectedId),
				repeats: .value(false),
				interval: .value(1)))
		// if not done this way, test can be flaky
		let expectedCategoryId = UserNotificationDelegate.generalError.identifier
		if let content = contentCaptor.allValues.first(where: { $0.categoryIdentifier == expectedCategoryId }) {
			assertThat(content.title, containsString("Failed to import"))
			assertThat(content.title, containsString(importerSourceName))
			assertThat(content.title, containsString(importerDataType))
			assertThat(content.body, containsString(errorTitle))
			assertThat(content.body, containsString(errorDescription))
			XCTAssertEqual(content.categoryIdentifier, UserNotificationDelegate.generalError.identifier)
		} else {
			XCTFail("No captured content (Found \(contentCaptor.allValues.count) other notifications)")
		}
	}

	// MARK: - extendTime

	func testGivenMatchingActiveImportExists_extendTime_resumesThatImport() throws {
		// given
		try setUpActiveImport()
		setUpBackgroundTaskIdForNotification()

		// when
		let extendTime = NotificationName.extendBackgroundTaskTime.toName()
		NotificationCenter.default.post(name: extendTime, object: nil, userInfo: nil)

		// then
		sleep(1)
		Verify(importer, .once, .resume())
	}

	// MARK: - cancelBackgroundImport

	func testGivenValidNotificationMetadata_cancelBackgroundImport_cancelsImport() throws {
		// given
		try setUpActiveImport()
		setUpBackgroundTaskIdForNotification()

		// when
		let cancelBackgroundTask = NotificationName.cancelBackgroundTask.toName()
		NotificationCenter.default.post(name: cancelBackgroundTask, object: nil, userInfo: nil)

		// then
		Verify(importer, .cancel())
	}

	// MARK: - Helper Functions

	private final func setUpActiveImport(forSection section: Int = 0, row: Int = 0, sleepOnImport: Bool = true) throws {
		if sleepOnImport {
			Perform(importer, .importData(from: .value(url), perform: { _ in sleep(self.importSleepTime) }))
		}
		Given(importer, .lastImport(getter: Date()))
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: ""))
		Given(mockUiUtil, .documentPicker(docTypes: .any, in: .any, willReturn: UIDocumentPickerViewController(documentTypes: [], in: .import)))
		let argumentCaptor = ArgumentCaptor<UIViewController>()

		controller.tableView(tableView, didSelectRowAt: IndexPath(row: row, section: section))

		Verify(mockUiUtil, .present(.any, argumentCaptor.capture(), animated: .any, completion: .any))
		guard let actionSheet = argumentCaptor.value as? UIAlertController else {
			XCTFail("Unable to get alert controller")
			return
		}
		try actionSheet.tapButton(withTitle: "Import")

		// wait for the next alert controller to be presented
		Verify(mockUiUtil, .present(.any, argumentCaptor.capture(), animated: .any, completion: .any))
		while argumentCaptor.value == actionSheet {}
		guard let alert = argumentCaptor.value as? UIAlertController else {
			XCTFail("Unable to get alert controller")
			return
		}
		try alert.tapButton(withTitle: "Yes")

		// wait for the document picker to be presented
		Verify(mockUiUtil, .present(.any, argumentCaptor.capture(), animated: .any, completion: .any))
		while argumentCaptor.value == alert {}
		guard let documentPicker = argumentCaptor.value as? UIDocumentPickerViewController else {
			XCTFail("Unable to get document picker")
			return
		}
		documentPicker.delegate?.documentPicker?(documentPicker, didPickDocumentsAt: [url])
	}

	private final func setUpBackgroundTaskIdForNotification() {
		while controller.backgroundImports({ $0.count }) == 0 {}
		let backgroundTaskId = controller.backgroundImports({ $0.first!.key })
		let taskIdString = String(backgroundTaskId.rawValue)
		Given(mockUiUtil, .value(for: .value(.backgroundTaskId), from: .any, keyIsOptional: .any, willReturn: taskIdString))
	}
}
