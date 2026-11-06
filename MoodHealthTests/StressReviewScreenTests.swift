import XCTest
import UIKit
import CoreData
import Common
@testable import Samples

final class StressReviewScreenTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: StressReviewScreenTests.self)])!
	private var calendar: Calendar {
		var value = Calendar(identifier: .gregorian)
		value.timeZone = TimeZone(secondsFromGMT: 0)!
		return value
	}
	private func date(_ value: String) -> Date { ISO8601DateFormatter().date(from: value)! }

	@MainActor func testRecentPeriodsRequestCalendarWindowsAndPreserveTheCapturedNow() throws {
		let now = date("2024-07-15T12:34:56Z").addingTimeInterval(0.875)
		let controller = makeController(now: now)
		var requests: [(interval: DateInterval, now: Date)] = []
		controller.loadCheckIns = { interval, asOf in requests.append((interval, asOf)); return [] }
		open(controller); waitUntilReady(controller)
		let period: UISegmentedControl = try control("stressReviewPeriod", in: controller.view)
		XCTAssertEqual(period.selectedSegmentIndex, 0)
		XCTAssertEqual(controller.tableView.accessibilityIdentifier, "stressReview")
		for (index, start) in [(0, "2024-07-09T00:00:00Z"), (1, "2024-06-16T00:00:00Z"), (2, "2024-04-17T00:00:00Z")] {
			period.selectedSegmentIndex = index
			period.sendActions(for: .valueChanged)
			waitUntilReady(controller)
			let request = try XCTUnwrap(requests.last)
			XCTAssertEqual(request.interval.start, date(start))
			XCTAssertEqual(request.interval.end, date("2024-07-16T00:00:00Z"))
			XCTAssertEqual(request.now, now)
			XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 0)
			XCTAssertTrue(cell(controller, section: 0, row: 0).detailTextLabel?.text?.contains("Daily mean: Unavailable") == true)
		}
	}

	@MainActor func testDisplayedSummariesUseHalfOpenStoredInstantsAndKeepPersonalMissingStatesSeparate() throws {
		let now = date("2024-07-15T12:00:00Z"), stressorID = UUID()
		let start = date("2024-07-09T00:00:00Z"), end = date("2024-07-16T00:00:00Z")
		let records = try [
			record(at: start, rating: 0, note: "First", responses: [(stressorID, "Work", "rated", 0)]),
			record(at: date("2024-07-10T12:00:00Z"), rating: 4, note: "Second", responses: [(stressorID, "Work", "notApplicable", nil)]),
			record(at: date("2024-07-11T12:00:00Z"), rating: 2, note: "Third", responses: [(stressorID, "Work", "skipped", nil)]),
			record(at: date("2024-07-12T12:00:00Z"), rating: 2, note: "Malformed", responses: [(stressorID, "Work", "unknown-status", nil)]),
			record(at: start.addingTimeInterval(-0.125), rating: 4, note: "Before start"),
			record(at: end, rating: 4, note: "Next midnight"),
			record(at: now.addingTimeInterval(1), rating: 4, note: "Future"),
			record(at: Date(timeIntervalSinceReferenceDate: .nan), rating: 4, note: "Invalid date"),
		]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		open(controller); waitUntilReady(controller)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 4)
		let summary = cell(controller, section: 0, row: 0).detailTextLabel?.text ?? ""
		XCTAssertTrue(summary.contains("4 offered · 4 rated · 0 skipped · 0 not applicable · 0 excluded"))
		let distribution = cell(controller, section: 0, row: 1).detailTextLabel?.text ?? ""
		XCTAssertTrue(distribution.contains("None: 1"))
		XCTAssertTrue(distribution.contains("Moderate: 2"))
		XCTAssertTrue(distribution.contains("Overwhelming: 1"))
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 1)
		let personal = cell(controller, section: 1, row: 0)
		XCTAssertEqual(personal.accessibilityIdentifier, "stressReviewStressor.\(stressorID.uuidString)")
		XCTAssertTrue(personal.detailTextLabel?.text?.contains("4 offered · 1 rated · 1 skipped · 1 not applicable · 1 excluded") == true)
		XCTAssertEqual((0..<4).compactMap { cell(controller, section: 2, row: $0).detailTextLabel?.text },
			["Malformed", "Third", "Second", "First"])
	}

	@MainActor func testComparisonNormalizesChosenDateAndUsesCalendarDaysAcrossDaylightSaving() throws {
		var local = calendar
		local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		let now = date("2024-03-20T19:00:00Z").addingTimeInterval(0.875)
		let controller = makeController(now: now, calendar: local)
		var requested: DateInterval?
		controller.loadCheckIns = { interval, _ in requested = interval; return [] }
		let chosen = date("2024-03-10T19:23:36Z").addingTimeInterval(0.125)
		controller.setComparisonDate(chosen)
		open(controller); waitUntilReady(controller)
		let expectedStart = date("2024-03-03T08:00:00Z")
		let expectedEnd = date("2024-03-17T07:00:00Z")
		XCTAssertEqual(requested, DateInterval(start: expectedStart, end: expectedEnd))
		XCTAssertEqual(requested?.duration, 335 * 60 * 60)
		let period: UISegmentedControl = try control("stressReviewPeriod", in: controller.view)
		XCTAssertEqual(period.selectedSegmentIndex, 3)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 3)
		let summary = cell(controller, section: 0, row: 0).detailTextLabel?.text ?? ""
		XCTAssertTrue(summary.contains("Before:")); XCTAssertTrue(summary.contains("After:"))
		XCTAssertTrue(summary.contains("0 recorded / 0 rated / 7 elapsed local days"))
		XCTAssertTrue(cell(controller, section: 0, row: 2).detailTextLabel?.text?.contains("Unavailable") == true)
		controller.setComparisonDate(date("2024-04-01T18:35:47Z"))
		waitUntilReady(controller)
		let today = local.startOfDay(for: now)
		XCTAssertEqual(requested?.start, local.date(byAdding: .day, value: -7, to: today))
		XCTAssertEqual(requested?.end, local.date(byAdding: .day, value: 7, to: today))
		XCTAssertTrue(cell(controller, section: 0, row: 0).detailTextLabel?.text?.contains("incomplete, through now") == true)
	}

	@MainActor func testHistoricalIdentityGroupsRenamedResponsesAndDrilldownRetainsOriginalNames() throws {
		let id = UUID(), now = date("2024-07-15T12:00:00Z")
		let records = try [
			record(at: date("2024-07-09T12:00:00Z"), rating: 1, note: "Earlier note", responses: [(id, "Old work name", "rated", 1)]),
			record(at: date("2024-07-14T12:00:00Z"), rating: 3, note: "Later note", responses: [(id, "Renamed work", "rated", 3)]),
		]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		let navigation = UINavigationController(rootViewController: controller)
		open(controller); waitUntilReady(controller)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 1)
		XCTAssertEqual(cell(controller, section: 1, row: 0).textLabel?.text, "Renamed work")
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		let detail = try XCTUnwrap(navigation.topViewController as? UITableViewController)
		XCTAssertFalse(detail === controller); detail.loadViewIfNeeded()
		XCTAssertEqual(detail.tableView(detail.tableView, numberOfRowsInSection: 1), 2)
		let recent = detail.tableView(detail.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
		let older = detail.tableView(detail.tableView, cellForRowAt: IndexPath(row: 1, section: 1))
		XCTAssertTrue(recent.detailTextLabel?.text?.contains("Renamed work: High") == true)
		XCTAssertTrue(older.detailTextLabel?.text?.contains("Old work name: Mild") == true)
		XCTAssertTrue(older.detailTextLabel?.text?.contains("Earlier note") == true)
	}

	@MainActor func testIndividualHistoryReadFailureShowsUnavailableWithoutClearingTheParentSummary() throws {
		let now = date("2024-07-15T12:00:00Z"), id = UUID()
		let records = try [record(at: now, rating: 3, note: "Recorded note", responses: [(id, "Work", "rated", 3)])]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		controller.loadStressorCheckIns = { _, _, _ in throw NSError(domain: "StressorHistoryRead", code: 1) }
		let navigation = UINavigationController(rootViewController: controller)
		open(controller); waitUntilReady(controller)
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		let detail = try XCTUnwrap(navigation.topViewController as? UITableViewController)
		XCTAssertFalse(detail === controller); detail.loadViewIfNeeded()
		XCTAssertEqual(detail.tableView(detail.tableView, numberOfRowsInSection: 1), 0)
		let unavailable = detail.tableView(detail.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		XCTAssertEqual(unavailable.textLabel?.text, "Stress review unavailable")
		XCTAssertTrue(unavailable.detailTextLabel?.text?.contains("Could not load") == true)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 1)
		XCTAssertTrue(cell(controller, section: 0, row: 0).detailTextLabel?.text?.contains("1 offered · 1 rated") == true)
	}

	@MainActor func testRareStressorDrilldownLoadsMatchingHistoryBeyondTheMainHistoryLimit() throws {
		let now = date("2024-07-15T12:00:00Z"), id = UUID()
		let unrelated = try (0..<201).map { index in
			try record(at: now.addingTimeInterval(-Double(index)), rating: 0, note: "Unrelated \(index)")
		}
		let rare = try record(at: now.addingTimeInterval(-202), rating: 3, note: "Rare recorded note",
			responses: [(id, "Occasional pressure", "rated", 3)])
		let records = unrelated + [rare]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		var requestedIDs: [UUID] = []
		controller.loadStressorCheckIns = { requestedID, interval, asOf in
			requestedIDs.append(requestedID)
			XCTAssertEqual(interval.start, self.date("2024-07-09T00:00:00Z"))
			XCTAssertEqual(interval.end, self.date("2024-07-16T00:00:00Z"))
			XCTAssertEqual(asOf, now)
			return [rare]
		}
		let navigation = UINavigationController(rootViewController: controller)
		open(controller); waitUntilReady(controller)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 200)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 1)
		XCTAssertTrue(cell(controller, section: 1, row: 0).detailTextLabel?.text?.contains("1 offered · 1 rated") == true)
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		let detail = try XCTUnwrap(navigation.topViewController as? UITableViewController)
		XCTAssertFalse(detail === controller); detail.loadViewIfNeeded()
		XCTAssertEqual(requestedIDs, [id])
		XCTAssertEqual(detail.tableView(detail.tableView, numberOfRowsInSection: 1), 1)
		let entry = detail.tableView(detail.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
		XCTAssertTrue(entry.detailTextLabel?.text?.contains("Occasional pressure: High") == true)
		XCTAssertTrue(entry.detailTextLabel?.text?.contains("Rare recorded note") == true)
	}

	@MainActor func testHistoryLimitDoesNotTruncateSummaryOrAppointmentCoverage() throws {
		let now = date("2024-07-15T12:00:00Z")
		let records = try (0..<205).map { index in
			try record(at: now.addingTimeInterval(-Double(index)), rating: index == 204 ? 4 : 0, note: "Entry \(index)")
		}
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		open(controller); waitUntilReady(controller)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 200)
		XCTAssertTrue(cell(controller, section: 0, row: 0).detailTextLabel?.text?.contains("205 offered · 205 rated") == true)
		let distribution = cell(controller, section: 0, row: 1).detailTextLabel?.text ?? ""
		XCTAssertTrue(distribution.contains("None: 204")); XCTAssertTrue(distribution.contains("Overwhelming: 1"))
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 2)?.contains("newest 200 of 205") == true)
		XCTAssertEqual(cell(controller, section: 2, row: 199).detailTextLabel?.text, "Entry 199")
	}

	@MainActor func testFailedLoadClearsPreviousRowsAndDisablesAppointmentUntilRecovery() throws {
		let now = date("2024-07-15T12:00:00Z")
		let records = try [record(at: now, rating: 3, note: "Old visible note")]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		open(controller); waitUntilReady(controller)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 1)
		controller.loadCheckIns = { _, _ in throw NSError(domain: "StressReviewRead", code: 1) }
		controller.reloadReview()
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 2), 0)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 0)
		XCTAssertEqual(cell(controller, section: 0, row: 0).textLabel?.text, "Stress review unavailable")
		XCTAssertFalse(controller.navigationItem.rightBarButtonItem?.isEnabled ?? true)
		XCTAssertFalse(controller.refreshControl?.isRefreshing ?? true)
		controller.loadCheckIns = { _, _ in records }
		controller.reloadReview(); waitUntilReady(controller)
		XCTAssertEqual(cell(controller, section: 2, row: 0).detailTextLabel?.text, "Old visible note")
	}

	@MainActor func testAppointmentPreparationUsesAnImmutableReadableSnapshotWithoutAutomaticSharing() throws {
		let now = date("2024-07-15T12:00:00Z"), id = UUID()
		let records = try [record(at: now, rating: 2, note: "Question for appointment", responses: [(id, "Caregiving", "notApplicable", nil)])]
		defer { release(records) }
		let controller = makeController(now: now, records: records)
		let navigation = UINavigationController(rootViewController: controller)
		open(controller); waitUntilReady(controller)
		let button = try XCTUnwrap(controller.navigationItem.rightBarButtonItem)
		XCTAssertEqual(button.accessibilityIdentifier, "stressReviewAppointmentPrep")
		let action = try XCTUnwrap(button.action)
		controller.perform(action)
		let preparation = try XCTUnwrap(navigation.topViewController as? UITableViewController)
		XCTAssertFalse(preparation === controller); preparation.loadViewIfNeeded()
		XCTAssertEqual(preparation.title, "Appointment Prep")
		XCTAssertEqual(preparation.tableView.accessibilityIdentifier, "stressAppointmentPreparation")
		XCTAssertEqual(preparation.navigationItem.rightBarButtonItem?.title, "Share")
		XCTAssertNil(preparation.presentedViewController)
		XCTAssertEqual(preparation.tableView(preparation.tableView, numberOfRowsInSection: 0), 2)
		records[0].note = "Changed after preparation opened"
		let entry = preparation.tableView(preparation.tableView, cellForRowAt: IndexPath(row: 0, section: 1))
		XCTAssertTrue(entry.detailTextLabel?.text?.contains("Caregiving: Not applicable") == true)
		XCTAssertTrue(entry.detailTextLabel?.text?.contains("Question for appointment") == true)
		XCTAssertFalse(entry.detailTextLabel?.text?.contains("Changed after preparation opened") == true)
		XCTAssertTrue(preparation.tableView(preparation.tableView, titleForFooterInSection: 1)?.contains("Nothing is sent automatically") == true)
	}

	@MainActor func testObserversAndPendingCalculationDoNotRetainTheReviewScreen() throws {
		let now = date("2024-07-15T12:00:00Z")
		let records = try [record(at: now, rating: 1)]
		defer { release(records) }
		weak var released: StressReviewViewController?
		autoreleasepool {
			let controller = makeController(now: now, records: records)
			controller.loadViewIfNeeded(); controller.viewWillAppear(false)
			controller.reloadReview(); controller.viewWillDisappear(false)
			released = controller
		}
		XCTAssertNil(released)
		NotificationCenter.default.post(name: .NSCalendarDayChanged, object: nil)
		NotificationCenter.default.post(name: .NSSystemTimeZoneDidChange, object: nil)
		XCTAssertNil(released)
	}

	@MainActor private func makeController(now: Date, calendar: Calendar? = nil,
		records: [StressCheckIn] = []) -> StressReviewViewController {
		let controller = StressReviewViewController(style: .grouped)
		let reviewCalendar = calendar ?? self.calendar
		controller.clock = { now }; controller.calendarProvider = { reviewCalendar }
		controller.loadCheckIns = { _, _ in records }
		controller.loadStressorCheckIns = { id, interval, asOf in
			Array(records.filter { record in
				record.timestamp >= interval.start && record.timestamp < interval.end && record.timestamp <= asOf
					&& record.responses.contains { $0.stressorID == id }
			}.sorted { $0.timestamp > $1.timestamp }.prefix(200))
		}
		return controller
	}
	@MainActor private func open(_ controller: StressReviewViewController) {
		controller.loadViewIfNeeded(); controller.viewWillAppear(false)
	}
	@MainActor private func waitUntilReady(_ controller: StressReviewViewController,
		file: StaticString = #file, line: UInt = #line) {
		let ready = NSPredicate { _, _ in controller.navigationItem.rightBarButtonItem?.isEnabled == true && controller.navigationItem.prompt == nil }
		let expectation = XCTNSPredicateExpectation(predicate: ready, object: nil)
		XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 3), .completed,
			"Stress review calculation did not finish", file: file, line: line)
	}
	@MainActor private func cell(_ controller: StressReviewViewController, section: Int, row: Int) -> UITableViewCell {
		controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: row, section: section))
	}
	@MainActor private func control<Control: UIView>(_ identifier: String, in view: UIView) throws -> Control {
		try XCTUnwrap(descendant(identifier, in: view) as? Control)
	}
	@MainActor private func descendant(_ identifier: String, in view: UIView) -> UIView? {
		if view.accessibilityIdentifier == identifier { return view }
		for child in view.subviews { if let match = descendant(identifier, in: child) { return match } }
		return nil
	}
	@MainActor private func record(at timestamp: Date, rating: Int, note: String? = nil,
		responses: [(UUID, String, String, Int?)] = []) throws -> StressCheckIn {
		let parentEntity = try XCTUnwrap(Self.model.entitiesByName[StressCheckIn.entityName])
		let responseEntity = try XCTUnwrap(Self.model.entitiesByName[StressorResponse.entityName])
		let parent = StressCheckIn(entity: parentEntity, insertInto: nil)
		parent.id = UUID(); parent.timestamp = timestamp; parent.overallRating = Int16(rating)
		parent.note = note; parent.measurementKind = "momentary"; parent.scaleVersion = 1
		let values = responses.enumerated().map { index, answer -> StressorResponse in
			let value = StressorResponse(entity: responseEntity, insertInto: nil)
			value.checkIn = parent; value.timestamp = timestamp; value.stressorID = answer.0
			value.stressorKey = answer.0.uuidString; value.nameSnapshot = answer.1
			value.displayOrder = Int64(index); value.statusKey = answer.2
			value.ratingValue = answer.3.map { NSNumber(value: $0) }
			return value
		}
		parent.responses = Set(values)
		return parent
	}
	@MainActor private func release(_ records: [StressCheckIn]) {
		for record in records {
			let answers = record.responses
			record.responses = []
			for answer in answers { answer.setValue(nil, forKey: "checkIn") }
		}
	}
}
