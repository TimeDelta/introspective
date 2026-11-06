import XCTest
import UIKit
import CoreData
import SwiftyMocky
import Presentr
@testable import Introspective
@testable import Common
@testable import Samples

final class MoodHistoryDayTests: UnitTest {

	private var controller: MoodHistoryViewController!
	private var calendar: Calendar!
	private var now: Date!
	private var queries: [(from: Date?, to: Date?)] = []

	override func setUp() {
		super.setUp()
		var fixedCalendar = Calendar(identifier: .gregorian)
		fixedCalendar.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		fixedCalendar.locale = Locale(identifier: "en_US_POSIX")
		calendar = fixedCalendar
		now = date(2024, 5, 15, 12)
		let fixedNow = now!
		controller = MoodHistoryViewController(style: .grouped)
		controller.clock = { fixedNow }
		controller.calendarProvider = { fixedCalendar }
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: []))
		Perform(mockMoodDAO, .getMoods(from: .any, to: .any, perform: { [weak self] from, to in
			self?.queries.append((from, to))
		}))
	}

	override func tearDown() {
		if let controller = controller, controller.isViewLoaded {
			NotificationCenter.default.removeObserver(controller)
			controller.tableView.dataSource = nil
			controller.tableView.delegate = nil
		}
		controller = nil
		queries = []
		super.tearDown()
	}

	func testDefaultSevenDaysAndTodayAndThirtyDayPresetsUseCalendarBounds() throws {
		open()
		let period: UISegmentedControl = try control("moodHistoryPeriod")
		XCTAssertEqual(period.selectedSegmentIndex, 1)
		XCTAssertEqual(controller.tableView.accessibilityIdentifier, "moodHistory")
		assertLastQuery(from: date(2024, 5, 9), to: date(2024, 5, 16))

		period.selectedSegmentIndex = 0
		period.sendActions(for: .valueChanged)
		assertLastQuery(from: date(2024, 5, 15), to: date(2024, 5, 16))

		period.selectedSegmentIndex = 2
		period.sendActions(for: .valueChanged)
		assertLastQuery(from: date(2024, 4, 16), to: date(2024, 5, 16))
	}

	func testHistoricalDayOlderThanThirtyDaysFetchesItsDSTBoundsAndExcludesAdjacentDays() throws {
		let start = date(2024, 3, 10)
		let end = date(2024, 3, 11)
		let earliest = mood(start, rating: 0, note: "At start")
		let latest = mood(end.addingTimeInterval(-1), rating: 10, note: "Before end")
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [
			mood(start.addingTimeInterval(-1), note: "Previous day"), earliest,
			mood(end, note: "Next day"), latest,
		]))
		controller.selectDay(date(2024, 3, 10, 15))

		open()

		let period: UISegmentedControl = try control("moodHistoryPeriod")
		XCTAssertEqual(period.selectedSegmentIndex, 3)
		assertLastQuery(from: start, to: end)
		XCTAssertEqual(end.timeIntervalSince(start), 23 * 60 * 60)
		XCTAssertEqual(notes(), ["Before end", "At start"])
		XCTAssertEqual(summary().textLabel?.text, "2 check-ins on 1 days")
		XCTAssertEqual(summaryAverage(), "Average position: 50% of mood scale")

		var changedCalendar = calendar!
		changedCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
		controller.calendarProvider = { changedCalendar }
		controller.refreshControl?.sendActions(for: .valueChanged)
		let changedStart = changedCalendar.date(from: DateComponents(year: 2024, month: 3, day: 10))!
		let changedEnd = changedCalendar.date(from: DateComponents(year: 2024, month: 3, day: 11))!
		assertLastQuery(from: changedStart, to: changedEnd)
	}

	func testPreviousAndNextMoveOneCalendarDayAndNextStopsAtToday() throws {
		open()
		controller.selectDay(date(2024, 5, 14, 18))
		let previous: UIButton = try control("moodHistoryPreviousDay")
		let next: UIButton = try control("moodHistoryNextDay")
		XCTAssertTrue(next.isEnabled)

		previous.sendActions(for: .touchUpInside)
		assertLastQuery(from: date(2024, 5, 13), to: date(2024, 5, 14))
		next.sendActions(for: .touchUpInside)
		assertLastQuery(from: date(2024, 5, 14), to: date(2024, 5, 15))
		next.sendActions(for: .touchUpInside)
		assertLastQuery(from: date(2024, 5, 15), to: date(2024, 5, 16))
		XCTAssertFalse(next.isEnabled)
		XCTAssertTrue(previous.isEnabled)
	}

	func testSelectingFutureDayClampsToTodayAndDisablesNextDay() throws {
		open()

		controller.selectDay(date(2024, 5, 20))

		assertLastQuery(from: date(2024, 5, 15), to: date(2024, 5, 16))
		let next: UIButton = try control("moodHistoryNextDay")
		XCTAssertFalse(next.isEnabled)
	}

	func testNoteSearchTrimsWhitespaceIgnoresCaseAndDiacriticsAndSummarizesMatchingRows() throws {
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [
			mood(date(2024, 3, 10, 8), rating: 8, note: "Morning café"),
			mood(date(2024, 3, 10, 20), rating: 1, minimum: -3, maximum: 17, note: "Evening CAFÉ"),
			mood(date(2024, 3, 10, 12), rating: 5, minimum: 10, maximum: 0, note: nil),
		]))
		open()
		controller.selectDay(date(2024, 3, 10))
		let search = try XCTUnwrap(controller.navigationItem.searchController)

		search.searchBar.text = "  CAFE  "
		controller.updateSearchResults(for: search)

		XCTAssertEqual(notes(), ["Evening CAFÉ", "Morning café"])
		XCTAssertEqual(summary().textLabel?.text, "2 check-ins on 1 days")
		XCTAssertEqual(summaryAverage(), "Average position: 50% of mood scale")

		search.searchBar.text = "missing"
		controller.updateSearchResults(for: search)
		XCTAssertEqual(notes(), [])
		XCTAssertEqual(summaryAverage(), "Average unavailable")

		search.searchBar.text = ""
		controller.updateSearchResults(for: search)
		XCTAssertEqual(notes(), ["Evening CAFÉ", "No note", "Morning café"])
		XCTAssertEqual(summaryAverage(), "Average position: 50% of mood scale")
		XCTAssertTrue(summary().detailTextLabel?.text?.contains("2 valid ratings · 1 excluded") == true)
	}

	func testSelectingExistingCheckInPassesTheSameModelWithoutBackfillTimestamp() throws {
		let existing = mood(date(2024, 3, 10, 13), rating: 7, note: "Keep identity")
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [existing]))
		let editor = editorMock()
		open()
		controller.selectDay(date(2024, 3, 10))

		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))

		XCTAssertTrue((editor.mood as? MoodMock) === existing)
		XCTAssertNil(editor.initialTimestamp)
		Verify(mockUiUtil, .once, .push(controller: .value(editor), toNavigationController: .any, animated: .value(false)))
	}

	func testAddingOnHistoricalDayStartsANewCheckInAtTheSelectedLocalDay() throws {
		let editor = editorMock()
		open()
		controller.selectDay(date(2024, 3, 10, 20))

		try tapAdd()

		XCTAssertNil(editor.mood)
		XCTAssertEqual(editor.initialTimestamp, date(2024, 3, 10))
		XCTAssertTrue(editor.navigationItem.prompt?.contains("approximate time") == true)
		Verify(mockUiUtil, .once, .push(controller: .value(editor), toNavigationController: .any, animated: .value(false)))
	}

	func testAddingOnTodayOrRecentPeriodsLeavesTheEditorUsingItsCurrentTimeDefault() throws {
		open()
		let period: UISegmentedControl = try control("moodHistoryPeriod")
		for index in [0, 1, 2] {
			let editor = editorMock()
			period.selectedSegmentIndex = index
			period.sendActions(for: .valueChanged)

			try tapAdd()

			XCTAssertNil(editor.mood)
			XCTAssertNil(editor.initialTimestamp)
		}
		controller.selectDay(now)
		let editor = editorMock()
		try tapAdd()
		XCTAssertNil(editor.initialTimestamp)
	}

	func testFetchFailureClearsOldRowsAndSummaryAndRefreshCanRecover() throws {
		let existing = mood(date(2024, 3, 10, 12), note: "Previously visible")
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [existing]))
		open()
		controller.selectDay(date(2024, 3, 10))
		XCTAssertEqual(notes(), ["Previously visible"])
		Given(mockMoodDAO, .getMoods(from: .any, to: .any,
			willThrow: NSError(domain: "MoodHistoryDayTests", code: 1)))

		controller.refreshControl?.sendActions(for: .valueChanged)

		XCTAssertEqual(notes(), [])
		XCTAssertEqual(summary().textLabel?.text, "Mood history unavailable")
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 0)?
			.lowercased().contains("refresh") == true)
		XCTAssertFalse(controller.refreshControl?.isRefreshing ?? true)

		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [existing]))
		controller.refreshControl?.sendActions(for: .valueChanged)
		XCTAssertEqual(notes(), ["Previously visible"])
		XCTAssertEqual(summary().textLabel?.text, "1 check-ins on 1 days")
	}

	func testReturningFromEditRefetchesAndReappliesDayAndNoteFilters() throws {
		let moved = mood(date(2024, 3, 10, 18), rating: 10, note: "stay moved")
		let renamed = mood(date(2024, 3, 10, 8), rating: 0, note: "stay original")
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [moved, renamed]))
		let editor = editorMock()
		open()
		controller.selectDay(date(2024, 3, 10))
		let search = try XCTUnwrap(controller.navigationItem.searchController)
		search.searchBar.text = "stay"
		controller.updateSearchResults(for: search)
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		XCTAssertTrue((editor.mood as? MoodMock) === moved)
		moved.date = date(2024, 3, 11)
		renamed.note = "No longer matches"
		let arriving = mood(date(2024, 3, 10, 12), rating: 5, note: "stay new")
		Given(mockMoodDAO, .getMoods(from: .any, to: .any, willReturn: [moved, renamed, arriving]))

		controller.viewWillAppear(false)

		assertLastQuery(from: date(2024, 3, 10), to: date(2024, 3, 11))
		XCTAssertEqual(notes(), ["stay new"])
		XCTAssertEqual(summary().textLabel?.text, "1 check-ins on 1 days")
		XCTAssertEqual(summaryAverage(), "Average position: 50% of mood scale")
		XCTAssertEqual(search.searchBar.text, "stay")
	}

	func testDayPickerUsesDateOnlyModeAndAcceptsOnlyItsOwnFirstSelection() throws {
		let picker = SelectDateViewControllerMock()
		Given(mockUiUtil, .controller(named: .value("datePicker"), from: .value("Util"),
			as: .value(UIViewController.self), willReturn: picker))
		Given(mockUiUtil, .customPresenter(width: .any, height: .any, center: .any,
			willReturn: Presentr(presentationType: .alert)))
		let chosenDate = date(2024, 3, 8, 17)
		Given(mockUiUtil, .value(for: .value(.date), from: .any, keyIsOptional: .value(false),
			willReturn: chosenDate))
		open()
		controller.selectDay(date(2024, 3, 10, 15))
		let chooseDay: UIButton = try control("moodHistorySelectedDay")

		chooseDay.sendActions(for: .touchUpInside)

		XCTAssertEqual(picker.initialDate, date(2024, 3, 10))
		XCTAssertEqual(picker.latestPossibleDate, now)
		XCTAssertEqual(picker.datePickerMode, .date)
		let notification = try XCTUnwrap(picker.notificationToSendOnAccept)
		let beforeSelection = queries.count
		NotificationCenter.default.post(name: notification, object: UIViewController())
		XCTAssertEqual(queries.count, beforeSelection)

		NotificationCenter.default.post(name: notification, object: picker)
		XCTAssertEqual(queries.count, beforeSelection + 1)
		assertLastQuery(from: date(2024, 3, 8), to: date(2024, 3, 9))

		NotificationCenter.default.post(name: notification, object: picker)
		XCTAssertEqual(queries.count, beforeSelection + 1)
		Verify(mockUiUtil, .once, .value(for: .value(.date), from: .any, keyIsOptional: .value(false)))
	}

	func testEditorInitialTimestampPreservesPrecisionWithoutLoadingAndExistingMoodTakesPriority() throws {
		Given(mockSettings, .minMood(getter: 0))
		Given(mockSettings, .maxMood(getter: 10))
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: "Timestamp"))
		let initial = date(2024, 3, 10, 13).addingTimeInterval(0.125)
		let stored = date(2024, 3, 10, 15).addingTimeInterval(0.875)
		Given(injectionProvider, .get(.value(CoreDataSampleUtil.self),
			willReturn: MoodHistoryDisplayTimeShift()))
		let existing = try storedMood(stored)
		XCTAssertEqual(existing.originalTimestamp, stored)
		XCTAssertNotEqual(existing.date, stored)
		let editor = EditMoodTableViewControllerImpl(style: .grouped)
		editor.initialTimestamp = initial
		XCTAssertFalse(editor.isViewLoaded)
		renderTimestamp(editor)
		Verify(mockCalendarUtil, .once, .string(for: .value(initial), dateStyle: .any, timeStyle: .any))
		for invalid in [Date(timeIntervalSinceReferenceDate: .nan), Date(timeIntervalSinceReferenceDate: .infinity)] {
			editor.initialTimestamp = invalid
			renderTimestamp(editor)
		}
		Verify(mockCalendarUtil, .exactly(3), .string(for: .value(initial), dateStyle: .any, timeStyle: .any))

		editor.mood = existing
		editor.initialTimestamp = date(2020, 1, 1)
		renderTimestamp(editor)
		Verify(mockCalendarUtil, .once, .string(for: .value(stored), dateStyle: .any, timeStyle: .any))
		XCTAssertFalse(editor.isViewLoaded)

		let otherEditor = EditMoodTableViewControllerImpl(style: .grouped)
		otherEditor.mood = existing
		otherEditor.initialTimestamp = initial
		renderTimestamp(otherEditor)
		Verify(mockCalendarUtil, .exactly(2), .string(for: .value(stored), dateStyle: .any, timeStyle: .any))
		XCTAssertFalse(otherEditor.isViewLoaded)

		let transaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: transaction))
		Given(transaction, .pull(savedObject: .any, willReturn: existing))
		Given(mockDatabase, .pull(savedObject: .any, willReturn: existing))
		otherEditor.perform(NSSelectorFromString("saveButtonPressed:"), with: self)
		XCTAssertEqual(existing.originalTimestamp, stored)
		Verify(transaction, .once, .commit())
	}

	func testSavingBackfilledEditorPersistsItsInitialTimestampWithFullPrecision() throws {
		Given(mockSettings, .minMood(getter: 0))
		Given(mockSettings, .maxMood(getter: 10))
		let initial = date(2024, 3, 10, 13).addingTimeInterval(0.125)
		let created = try storedMood(date(2020, 1, 1))
		let transaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: transaction))
		Given(transaction, .new(.any, willReturn: created))
		Given(mockDatabase, .pull(savedObject: .any, willReturn: created))
		let editor = EditMoodTableViewControllerImpl(style: .grouped)
		editor.initialTimestamp = initial

		editor.perform(NSSelectorFromString("saveButtonPressed:"), with: self)

		XCTAssertEqual(created.originalTimestamp, initial)
		XCTAssertEqual(created.minRating, 0)
		XCTAssertEqual(created.maxRating, 10)
		XCTAssertEqual(created.getSource(), .introspective)
		Verify(transaction, .once, .commit())
		Verify(mockUiUtil, .once, .popFrom(.any, animated: .value(false)))
		XCTAssertFalse(editor.isViewLoaded)
	}

	private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0) -> Date {
		calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
	}

	private func mood(_ date: Date, rating: Double = 5, minimum: Double = 0, maximum: Double = 10,
		note: String? = nil) -> MoodMock {
		let result = MoodMock()
		Given(result, .date(getter: date))
		Given(result, .rating(getter: rating))
		Given(result, .minRating(getter: minimum))
		Given(result, .maxRating(getter: maximum))
		Given(result, .note(getter: note))
		Given(result, .timeZone(getter: nil))
		return result
	}

	private func storedMood(_ timestamp: Date) throws -> MoodImpl {
		let entity = try XCTUnwrap(ObjectModelContainer.objectModel.entitiesByName[MoodImpl.entityName])
		let result = MoodImpl(entity: entity, insertInto: nil)
		result.setSource(.introspective)
		result.date = timestamp
		result.rating = 7
		result.minRating = 0
		result.maxRating = 10
		result.note = "Stored timestamp"
		return result
	}

	private func open() {
		controller.loadViewIfNeeded()
		controller.viewWillAppear(false)
	}

	private func control<Control: UIView>(_ identifier: String) throws -> Control {
		try XCTUnwrap(descendant(identifier, in: controller.view) as? Control)
	}

	private func descendant(_ identifier: String, in view: UIView) -> UIView? {
		if view.accessibilityIdentifier == identifier { return view }
		for child in view.subviews {
			if let found = descendant(identifier, in: child) { return found }
		}
		return nil
	}

	private func summary() -> UITableViewCell {
		controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
	}

	private func summaryAverage() -> String? {
		summary().detailTextLabel?.text?.components(separatedBy: "\n").first
	}

	private func notes() -> [String] {
		let count = controller.tableView(controller.tableView, numberOfRowsInSection: 1)
		return (0..<count).map {
			controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: $0, section: 1))
				.detailTextLabel?.text ?? ""
		}
	}

	private func assertLastQuery(from: Date, to: Date, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(queries.last?.from, from, file: file, line: line)
		XCTAssertEqual(queries.last?.to, to, file: file, line: line)
	}

	private func editorMock() -> EditMoodTableViewControllerMock {
		let result = EditMoodTableViewControllerMock()
		Given(mockUiUtil, .controller(named: .value("editMood"), from: .value("Util"),
			as: .value(UIViewController.self), willReturn: result))
		return result
	}

	private func tapAdd() throws {
		let button = try XCTUnwrap(controller.navigationItem.rightBarButtonItem)
		let action = try XCTUnwrap(button.action)
		XCTAssertTrue(UIApplication.shared.sendAction(action, to: button.target, from: button, for: nil))
	}

	private func renderTimestamp(_ editor: EditMoodTableViewControllerImpl) {
		let table = UITableView(frame: .zero, style: .grouped)
		table.register(MoodHistoryTimestampCell.self, forCellReuseIdentifier: "timestamp")
		let cell = editor.tableView(table, cellForRowAt: IndexPath(row: 0, section: 0))
		XCTAssertEqual(cell.detailTextLabel?.text, "Timestamp")
	}
}

private final class MoodHistoryTimestampCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder: NSCoder) { super.init(coder: coder) }
}

private struct MoodHistoryDisplayTimeShift: CoreDataSampleUtil {
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date {
		date.addingTimeInterval(12 * 60 * 60)
	}
}
