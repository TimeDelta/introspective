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
@testable import Common
@testable import DataExport
@testable import Notifications
@testable import Samples

final class ExportDataTableViewControllerUnitTests: UnitTest {

	private final var controller: ExportDataTableViewController!
	private final var tableView: UITableView { return controller.tableView }
	private final var exporter: ActivityExporterMock!

	private final let dataType = "this is the name of the data type for the exporter"

	final override func setUp() {
		super.setUp()
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in code() }))

		exporter = ActivityExporterMock()
		Given(exporter, .percentComplete(willReturn: 0.5))
		Given(exporter, .dataTypePluralName(getter: dataType))
		Given(exporter, .isCancelled(getter: false))
		Given(injectionProvider, .get(.value(ActivityExporter.self), willReturn: exporter))

		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "exportData") as! ExportDataTableViewController)
	}

	final override func tearDown() {
		if let controller = controller {
			NotificationCenter.default.removeObserver(controller)
			if let table = controller.viewIfLoaded as? UITableView {
				table.dataSource = nil
				table.delegate = nil
			}
		}
		ExportDataTableViewController.resetExports()
		mockAsyncUtil.resetMock()
		mockUiUtil.resetMock()
		controller = nil
		super.tearDown()
	}

	func testCompletedExportsKeepDistinctShareKeysWithoutRunningExecutions() {
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()
		let first = ExportDataTableViewController.backgroundExports { Set($0.keys) }
		XCTAssertEqual(first.count, 1)
		XCTAssertEqual(ExportDataTableViewController.runningExportCount, 0)
		setUpActiveExport()
		let all = ExportDataTableViewController.backgroundExports { Set($0.keys) }
		XCTAssertEqual(all.count, 2)
		XCTAssertTrue(first.isSubset(of: all))
		XCTAssertEqual(ExportDataTableViewController.runningExportCount, 0)
	}

	func testCancellingQueuedExportPreventsWorkFromStarting() {
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, _ in }))
		setUpActiveExport()
		let worker = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(worker)))
		setUpBackgroundTaskIdForNotification()
		NotificationCenter.default.post(name: NotificationName.cancelBackgroundTask.toName(), object: nil)
		guard let work = worker.value else { XCTFail("Missing queued export worker"); return }
		work()
		Verify(exporter, .never, .exportData())
		XCTAssertEqual(ExportDataTableViewController.backgroundExports { $0.count }, 0)
		XCTAssertEqual(ExportDataTableViewController.runningExportCount, 0)
	}

	func testBackgroundExecutionEndsExactlyOnceAfterCompletionOrExpiration() {
		var ended = [UIBackgroundTaskIdentifier]()
		let execution = ExportBackgroundExecution { ended.append($0) }
		let id = UIBackgroundTaskIdentifier(rawValue: 42)
		execution.register(id)
		XCTAssertTrue(execution.finish())
		XCTAssertFalse(execution.finish())
		XCTAssertEqual(ended, [id])
	}

	func testExpirationBeforeRegistrationStillEndsTheReturnedAssertion() {
		var ended = [UIBackgroundTaskIdentifier]()
		let execution = ExportBackgroundExecution { ended.append($0) }
		XCTAssertTrue(execution.finish())
		XCTAssertTrue(execution.isFinished)
		XCTAssertTrue(ended.isEmpty)
		let id = UIBackgroundTaskIdentifier(rawValue: 42)
		execution.register(id)
		XCTAssertFalse(execution.finish())
		XCTAssertEqual(ended, [id])
	}

	func testInvalidBackgroundAssertionIsNeverEnded() {
		let execution = ExportBackgroundExecution { _ in XCTFail("Invalid assertion must not be ended") }
		execution.register(.invalid)
		XCTAssertTrue(execution.finish())
	}

	func testLateFinishDoesNotEndAReusedUIKitIdentifier() {
		var ended = [UIBackgroundTaskIdentifier]()
		let id = UIBackgroundTaskIdentifier(rawValue: 42)
		let previous = ExportBackgroundExecution { ended.append($0) }
		previous.register(id)
		previous.finish()
		let next = ExportBackgroundExecution { ended.append($0) }
		next.register(id)
		XCTAssertFalse(previous.finish())
		XCTAssertEqual(ended, [id])
		next.finish()
		XCTAssertEqual(ended, [id, id])
	}

	func testConcurrentFinishConsumesOnlyOneAssertion() {
		var ended = [UIBackgroundTaskIdentifier]()
		let execution = ExportBackgroundExecution { ended.append($0) }
		let id = UIBackgroundTaskIdentifier(rawValue: 42)
		execution.register(id)
		DispatchQueue.concurrentPerform(iterations: 1000) { _ in _ = execution.finish() }
		XCTAssertEqual(ended, [id])
	}

	// MARK: - numberOfSections

	func testQueuedRefreshesDoNotRetainTheExportController() {
		Given(exporter, .isPaused(getter: false))
		weak var releasedController: ExportDataTableViewController?
		autoreleasepool {
			let subject = ExportDataTableViewController(style: .grouped)
			releasedController = subject
			subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
			// Mock invocation records own the worker and presentation arguments.
			mockAsyncUtil.resetMock()
			mockUiUtil.resetMock()
		}
		XCTAssertNil(releasedController, "Queued table refreshes must not keep a closed export screen alive")
	}

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

		// then
		Verify(exporter, .exportData())
	}

	func testGivenActiveExportCompletes_tableViewDidSelectRow_sendsSuccessfulExportNotificationToUser() throws {
		// when
		Given(exporter, .isPaused(getter: false))
		setUpActiveExport()

		// then
		let expectedId = "FinishedExport"
		let contentCaptor = ArgumentCaptor<UNMutableNotificationContent>()
		Verify(
			mockUiUtil,
			.sendUserNotification(
				withContent: .capturing(contentCaptor),
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
		setUpActiveExport()

		// then
		XCTAssertEqual(ExportDataTableViewController.backgroundExports { $0.count }, 0)
		XCTAssertEqual(ExportDataTableViewController.runningExportCount, 0)
		let expectedId = "ExportErrorOccurred"
		let contentCaptor = ArgumentCaptor<UNMutableNotificationContent>()
		Verify(
			mockUiUtil,
			.sendUserNotification(
				withContent: .capturing(contentCaptor),
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

	private final func setUpActiveExport(forRow row: Int = 0) {
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: row, section: 0))
	}

	private final func setUpBackgroundTaskIdForNotification() {
		guard let backgroundTaskId = ExportDataTableViewController.backgroundExports({ $0.first?.key }) else {
			XCTFail("Export must be registered before sending its notification")
			return
		}
		let taskIdString = String(backgroundTaskId.rawValue)
		Given(mockUiUtil, .value(for: .value(.backgroundTaskId), from: .any, keyIsOptional: .any, willReturn: taskIdString))
	}
}
