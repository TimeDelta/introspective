//
//  ExportDataTableViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/23/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import CSV
import UserNotifications
@testable import Introspective

final class ExportDataTableViewControllerUnitTests: UnitTest {

	private final var controller: ExportDataTableViewController!
	private final var tableView: UITableView { return controller.tableView }
	private final var exporter: ActivityExporterMock!

	private final let exportSleepTime: UInt32 = 2
	private final let dataType = "this is the name of the data type for the exporter"

	final override func setUp() {
		super.setUp()

		exporter = ActivityExporterMock()
		Given(exporter, .percentComplete(willReturn: 0.5))
		Given(exporter, .dataTypePluralName(getter: dataType))
		Given(exporter, .isCancelled(getter: false))
		Given(mockExporterFactory, .activityExporter(willReturn: exporter))

		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "exportData") as! ExportDataTableViewController)
	}

	final override func tearDown() {
		ExportDataTableViewController.resetExports()
		super.tearDown()
	}

	// MARK: - numberOfSections

	func testGivenNoActiveExports_numberOfSections_returns1() {
		// when
		let numberOfSections = controller.numberOfSections(in: tableView)

		// then
		XCTAssertEqual(numberOfSections, 1)
	}

	func testGivenActiveExports_numberOfSections_returns2() throws {
		// given
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		sleep(1)

		// when
		let numberOfSections = controller.numberOfSections(in: tableView)

		// then
		XCTAssertEqual(numberOfSections, 2)
	}

	// MARK: - tableViewNumberOfRowsInSection

	func testGivenNormalSection_tableViewNumberOfRowsInSection_returns3() {
		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		XCTAssertEqual(rows, 3)
	}

	func testGivenActiveExportsSectionAndNoActiveExports_tableViewNumberOfRowsInSection_returns0() {
		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		XCTAssertEqual(rows, 0)
	}

	func testGivenActiveExportsSectionWithOneActiveExport_tableViewNumberOfRowsInSection_returns1() throws {
		// given
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		sleep(1)

		// when
		let rows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		XCTAssertEqual(rows, 1)
	}

	// MARK: - tableViewCellForRowAt

	func testGivenActiveExportSection_tableViewCellForRowAt_stopsObservingPresentViewNotificationsForAssociatedExporter() throws {
		// given
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		sleep(1)

		// when
		let _ = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))

		// then
		Verify(mockUiUtil, .stopObserving(.value(controller), name: .value(.presentView), object: .value(exporter)))
	}

	// MARK: - sectionTitle

	func testGivenActiveExportsSection_sectionTitle_returnsActiveExports() {
		// when
		let sectionTitle = controller.tableView(tableView, titleForHeaderInSection: 1)

		// then
		XCTAssertEqual(sectionTitle, "Active Exports")
	}

	// MARK: - tableViewHeightForRow

	func testGivenNormalSectionRow_tableViewHeightForRow_returnsValueLessThanHeightForActiveExportRow() {
		// given
		let activeExportCellHeight = controller.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 1))

		// when
		let normalCellHeight = controller.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))

		// then
		XCTAssertLessThan(normalCellHeight, activeExportCellHeight)
	}

	// MARK: - tableViewDidSelectRow

	func testGivenExportNotStarted_tableViewDidSelectRow_startsExport() throws {
		// when
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		sleep(1)

		// then
		Verify(exporter, .exportData())
	}

	func testGivenActiveExportCompletes_tableViewDidSelectRow_sendsSuccessfulExportNotificationToUser() throws {
		// when
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()

		// when
		sleep(exportSleepTime + 1)

		// then
		let expectedId = "FinishedExport"
		let contentCaptor = ArgumentCaptor<UNMutableNotificationContent>()
		Verify(
			mockUiUtil,
			.sendUserNotification(
				withContent: contentCaptor.capture(),
				id: .value(expectedId),
				repeats: .value(false),
				interval: .value(1)))
		if let content = contentCaptor.value {
			assertThat(content.title, containsString("Finished exporting"))
			assertThat(content.body, containsString(dataType))
			XCTAssertEqual(content.categoryIdentifier, UserNotificationDelegate.finishedExportingActivities.identifier)
		} else {
			XCTFail("No captured content (Found \(contentCaptor.allValues.count) other notifications)")
		}
	}

	func testGivenActiveExportThrowsError_tableViewDidSelectRow_sendsErrorNotificationToUser() throws {
		// given
		let errorTitle = "displayable error title"
		let errorDescription = "displayable error description"
		let error = GenericDisplayableError(title: errorTitle, description: errorDescription)
		Given(exporter, .exportData(willThrow: error))
		Given(exporter, .isPaused(getter: false))

		// when
		setUpActiveExport(sleepOnExport: false)
		sleep(1)

		// then
		let expectedId = "ExportErrorOccurred"
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
			assertThat(content.title, containsString("Failed to export"))
			assertThat(content.title, containsString(dataType))
			assertThat(content.body, containsString(errorTitle))
			assertThat(content.body, containsString(errorDescription))
			XCTAssertEqual(content.categoryIdentifier, UserNotificationDelegate.generalError.identifier)
		} else {
			XCTFail("No captured content (Found \(contentCaptor.allValues.count) other notifications)")
		}
	}

	// MARK: - extendTime

	func testGivenMatchingActiveExportExists_extendTime_resumesThatExport() throws {
		// given
		Given(exporter, .isPaused(getter: false, true))
		setUpActiveExport()
		setUpBackgroundTaskIdForNotification()

		// when
		let extendTime = NotificationName.extendBackgroundTaskTime.toName()
		NotificationCenter.default.post(name: extendTime, object: nil, userInfo: nil)

		// then
		sleep(1)
		Verify(exporter, .once, .resume())
	}

	// MARK: - cancelBackgroundExport

	func testGivenValidNotificationMetadata_cancelBackgroundExport_cancelsExport() throws {
		// given
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		setUpBackgroundTaskIdForNotification()

		// when
		let cancelBackgroundTask = NotificationName.cancelBackgroundTask.toName()
		NotificationCenter.default.post(name: cancelBackgroundTask, object: nil, userInfo: nil)

		// then
		Verify(exporter, .cancel())
	}

	// MARK: - Helper Functions

	private final func setUpActiveExport(forRow row: Int = 0, sleepOnExport: Bool = true) {
		if sleepOnExport {
			Perform(exporter, .exportData{ sleep(self.exportSleepTime) })
		}
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: row, section: 0))
	}

	private final func setUpBackgroundTaskIdForNotification() {
		while ExportDataTableViewController.backgroundExports({ $0.count }) == 0 {}
		let backgroundTaskId = ExportDataTableViewController.backgroundExports({ $0.first!.key })
		let taskIdString = String(backgroundTaskId.rawValue)
		Given(mockUiUtil, .value(for: .value(.backgroundTaskId), from: .any, keyIsOptional: .any, willReturn: taskIdString))
	}
}
