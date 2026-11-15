import XCTest
import Foundation
import Common

final class ActivityReminderPlanTests: XCTestCase {
	private var suite: String!
	private var defaults: UserDefaults!
	private var preferences: ActivityReminderPreferences!
	private let now = Date(timeIntervalSince1970: 1_720_440_000)

	override func setUpWithError() throws {
		suite = "activity-reminder-plan-tests." + UUID().uuidString
		defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
		defaults.removePersistentDomain(forName: suite)
		preferences = ActivityReminderPreferences(defaults: defaults)
	}

	override func tearDown() {
		defaults.removePersistentDomain(forName: suite)
		preferences = nil
		defaults = nil
		suite = nil
		super.tearDown()
	}

	private func enable(minutes: Int = 120) throws {
		var settings = ActivityReminderSettings()
		settings.enabled = true
		settings.intervalMinutes = minutes
		try preferences.save(settings: settings)
	}

	private func running(_ id: String = "saved-instance", start: Date? = nil) -> ActivityReminderRunningActivity {
		ActivityReminderRunningActivity(id: id, start: start ?? now)
	}

	private func dates(_ values: [ActivityReminderPrompt]) -> [String: Date] {
		Dictionary(uniqueKeysWithValues: values.map { ($0.activityID, $0.date) })
	}

	private func date(_ text: String) throws -> Date {
		try XCTUnwrap(ISO8601DateFormatter().date(from: text))
	}

	func testDefaultsAreOffAndDoNotScheduleRunningActivities() throws {
		let settings = try preferences.settings()
		XCTAssertFalse(settings.enabled)
		XCTAssertEqual(settings.intervalMinutes, 120)
		XCTAssertEqual(ActivityReminderSettings.allowedIntervals, [30, 60, 120, 240])
		XCTAssertTrue(try preferences.plan(running: [running()], now: now).isEmpty)
	}

	func testReminderUsesElapsedDurationFromTheOriginalStart() throws {
		try enable()
		let started = now.addingTimeInterval(-20 * 60)
		let result = try preferences.plan(running: [running(start: started)], now: now)
		XCTAssertEqual(dates(result), ["saved-instance": now.addingTimeInterval(100 * 60)])
	}

	func testRefreshDoesNotMoveAnExistingFuturePromptLater() throws {
		try enable()
		let current = running()
		let first = try preferences.plan(running: [current], now: now)
		let later = try preferences.plan(running: [current], now: now.addingTimeInterval(30 * 60))
		XCTAssertEqual(dates(first), [current.id: now.addingTimeInterval(120 * 60)])
		XCTAssertEqual(dates(later), dates(first))
	}

	func testDiscoveringAnOverdueActivitySchedulesAfterAFullIntervalInsteadOfImmediately() throws {
		try enable(minutes: 60)
		let overdue = running(start: now.addingTimeInterval(-8 * 60 * 60))
		XCTAssertEqual(dates(try preferences.plan(running: [overdue], now: now)),
			[overdue.id: now.addingTimeInterval(60 * 60)])
	}

	func testAnExpiredPromptDoesNotRepeatAfterRefreshOrPreferencesReopen() throws {
		try enable(minutes: 30)
		let current = running()
		let initial = try preferences.plan(running: [current], now: now)
		let due = try XCTUnwrap(initial.first?.date)
		XCTAssertEqual(due, now.addingTimeInterval(30 * 60))
		XCTAssertTrue(try preferences.plan(running: [current], now: due).isEmpty)
		XCTAssertTrue(try preferences.plan(running: [current], now: due.addingTimeInterval(1)).isEmpty)
		let reopened = ActivityReminderPreferences(defaults: defaults)
		XCTAssertTrue(try reopened.plan(running: [current], now: due.addingTimeInterval(3 * 60 * 60)).isEmpty)
	}

	func testContinueSchedulesOneFurtherPromptForTheSameInstance() throws {
		try enable(minutes: 60)
		let current = running()
		_ = try preferences.plan(running: [current], now: now)
		let continuedAt = now.addingTimeInterval(65 * 60)
		try preferences.snooze(activityID: current.id, startedAt: current.start, now: continuedAt)
		let expected = continuedAt.addingTimeInterval(60 * 60)
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: continuedAt)), [current.id: expected])
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: continuedAt.addingTimeInterval(15 * 60))),
			[current.id: expected])
		XCTAssertTrue(try preferences.plan(running: [current], now: expected).isEmpty)
	}

	func testConcurrentActivitiesKeepIndependentDueDatesAndSnoozes() throws {
		try enable(minutes: 60)
		let work = running("work-instance", start: now.addingTimeInterval(-10 * 60))
		let music = running("music-instance", start: now.addingTimeInterval(-20 * 60))
		_ = try preferences.plan(running: [work, music], now: now)
		try preferences.snooze(activityID: work.id, startedAt: work.start, now: now.addingTimeInterval(5 * 60))
		XCTAssertEqual(dates(try preferences.plan(running: [music, work], now: now.addingTimeInterval(5 * 60))), [
			work.id: now.addingTimeInterval(65 * 60), music.id: now.addingTimeInterval(40 * 60)
		])
	}

	func testClosingAnActivityPrunesItsPromptWithoutAffectingAnotherActivity() throws {
		try enable(minutes: 60)
		let work = running("work-instance"), music = running("music-instance")
		_ = try preferences.plan(running: [work, music], now: now)
		let later = now.addingTimeInterval(5 * 60)
		XCTAssertEqual(dates(try preferences.plan(running: [music], now: later)),
			[music.id: now.addingTimeInterval(60 * 60)])
		XCTAssertTrue(try preferences.plan(running: [], now: later).isEmpty)
		// Reopening a formerly finished timer starts a new reminder opportunity.
		let reopenedAt = now.addingTimeInterval(2 * 60 * 60)
		XCTAssertEqual(dates(try preferences.plan(running: [work], now: reopenedAt)),
			[work.id: reopenedAt.addingTimeInterval(60 * 60)])
	}

	func testAReusedIdentifierWithAnotherStartDoesNotInheritAnOldSnooze() throws {
		try enable(minutes: 60)
		let original = running()
		_ = try preferences.plan(running: [original], now: now)
		try preferences.snooze(activityID: original.id, startedAt: original.start, now: now.addingTimeInterval(20 * 60))
		let restartedAt = now.addingTimeInterval(30 * 60)
		let restarted = running(original.id, start: restartedAt)
		XCTAssertEqual(dates(try preferences.plan(running: [restarted], now: restartedAt)),
			[restarted.id: restartedAt.addingTimeInterval(60 * 60)])
	}

	func testDisablingThenEnablingRemindersCancelsTheOldSchedule() throws {
		try enable(minutes: 60)
		let current = running()
		_ = try preferences.plan(running: [current], now: now)
		var settings = try preferences.settings()
		settings.enabled = false
		try preferences.save(settings: settings)
		XCTAssertTrue(try preferences.plan(running: [current], now: now.addingTimeInterval(10 * 60)).isEmpty)
		settings.enabled = true
		try preferences.save(settings: settings)
		let later = now.addingTimeInterval(2 * 60 * 60)
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: later)),
			[current.id: later.addingTimeInterval(60 * 60)])
	}

	func testChangingTheIntervalReplacesRatherThanPreservesAnOldSnooze() throws {
		try enable(minutes: 120)
		let current = running()
		_ = try preferences.plan(running: [current], now: now)
		try preferences.snooze(activityID: current.id, startedAt: current.start, now: now.addingTimeInterval(10 * 60))
		try enable(minutes: 30)
		let later = now.addingTimeInterval(35 * 60)
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: later)),
			[current.id: later.addingTimeInterval(30 * 60)])
	}

	func testInvalidSettingsCannotReplaceSavedSettingsOrPrompts() throws {
		try enable(minutes: 60)
		let current = running()
		let before = try preferences.plan(running: [current], now: now)
		for minutes in [0, -1, 1, 59, 61, Int.max] {
			var invalid = ActivityReminderSettings()
			invalid.enabled = true; invalid.intervalMinutes = minutes
			XCTAssertThrowsError(try invalid.validate())
			XCTAssertThrowsError(try preferences.save(settings: invalid))
			XCTAssertEqual(try preferences.settings().intervalMinutes, 60)
			XCTAssertEqual(dates(try preferences.plan(running: [current], now: now)), dates(before))
		}
	}

	func testInvalidCurrentDatesAreRejectedWithoutChangingTheSchedule() throws {
		try enable()
		let current = running()
		let before = try preferences.plan(running: [current], now: now)
		for invalid in [Double.nan, Double.infinity, -Double.infinity] {
			XCTAssertThrowsError(try preferences.plan(running: [current], now: Date(timeIntervalSinceReferenceDate: invalid)))
		}
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: now)), dates(before))
	}

	func testInvalidAndFutureStartsCannotCreatePrompts() throws {
		try enable()
		let invalid = [running("future", start: now.addingTimeInterval(1)),
			running("nan", start: Date(timeIntervalSinceReferenceDate: .nan)),
			running("infinite", start: Date(timeIntervalSinceReferenceDate: .infinity))]
		XCTAssertTrue(try preferences.plan(running: invalid, now: now).isEmpty)
	}

	func testDuplicateInputsCreateOnePromptAndManyActivitiesRemainBounded() throws {
		try enable(minutes: 60)
		let current = running()
		let duplicates = try preferences.plan(running: [current, current, current], now: now)
		XCTAssertEqual(duplicates.count, 1)
		let many = (0..<40).map { running("activity-\($0)") }
		let planned = try preferences.plan(running: many, now: now)
		XCTAssertEqual(planned.count, 8)
		XCTAssertEqual(Set(planned.map { $0.activityID }).count, planned.count)
		XCTAssertTrue(Set(planned.map { $0.activityID }).isSubset(of: Set(many.map { $0.id })))
		XCTAssertTrue(planned.allSatisfy { $0.date == now.addingTimeInterval(60 * 60) })
	}

	func testExternalNotificationBudgetCanReduceButCannotIncreaseTheActivityCap() throws {
		try enable(minutes: 60)
		let many = (0..<20).map { running("activity-\($0)") }
		XCTAssertTrue(try preferences.plan(running: many, now: now, maximumPending: 0).isEmpty)
		XCTAssertEqual(try preferences.plan(running: many, now: now, maximumPending: 2).count, 2)
		XCTAssertEqual(try preferences.plan(running: many, now: now, maximumPending: 100).count, 8)
	}

	func testSavingUnchangedSettingsKeepsTheExistingContinueDeadline() throws {
		try enable(minutes: 60)
		let current = running()
		_ = try preferences.plan(running: [current], now: now)
		let continuedAt = now.addingTimeInterval(20 * 60)
		try preferences.snooze(activityID: current.id, startedAt: current.start, now: continuedAt)
		let unchanged = try preferences.settings()
		try preferences.save(settings: unchanged)
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: continuedAt)),
			[current.id: now.addingTimeInterval(80 * 60)])
	}

	func testElapsedIntervalsRemainTwoHoursAcrossBothDaylightSavingTransitions() throws {
		try enable(minutes: 120)
		let spring = try date("2024-03-10T06:30:00Z")
		let autumn = try date("2024-11-03T05:30:00Z")
		let springPrompt = try preferences.plan(running: [running("spring", start: spring)], now: spring)
		XCTAssertEqual(springPrompt.first?.date, try date("2024-03-10T08:30:00Z"))
		let autumnPrompt = try preferences.plan(running: [running("autumn", start: autumn)], now: autumn)
		XCTAssertEqual(autumnPrompt.first?.date, try date("2024-11-03T07:30:00Z"))
	}

	func testCorruptPreferencesFailWithoutSilentlyEnablingOrReplacingThem() throws {
		try enable()
		let domain = defaults.persistentDomain(forName: suite) ?? [:]
		let storedKeys = domain.compactMap { key, value in value is Data ? key : nil }
		let key = try XCTUnwrap(storedKeys.first)
		XCTAssertEqual(storedKeys.count, 1)
		let corruption = Data("not valid reminder settings".utf8)
		defaults.set(corruption, forKey: key)
		XCTAssertThrowsError(try preferences.settings())
		XCTAssertThrowsError(try preferences.plan(running: [running()], now: now))
		XCTAssertEqual(defaults.data(forKey: key), corruption)
	}

	func testAnExplicitValidSaveRepairsCorruptPreferences() throws {
		try enable()
		let domain = defaults.persistentDomain(forName: suite) ?? [:]
		let key = try XCTUnwrap(domain.first { $0.value is Data }?.key)
		defaults.set(Data("broken".utf8), forKey: key)
		var replacement = ActivityReminderSettings()
		replacement.intervalMinutes = 240
		try preferences.save(settings: replacement)
		XCTAssertEqual(try preferences.settings(), replacement)
		XCTAssertTrue(try preferences.plan(running: [running()], now: now).isEmpty)
	}

	func testInvalidContinueInputsCannotMoveAnExistingDeadline() throws {
		try enable(minutes: 60)
		let current = running()
		let before = try preferences.plan(running: [current], now: now)
		let invalid: [(String, Date, Date)] = [
			("", now, now), (current.id, now.addingTimeInterval(1), now),
			(current.id, Date(timeIntervalSinceReferenceDate: .nan), now),
			(current.id, now, Date(timeIntervalSinceReferenceDate: .infinity))
		]
		for (id, start, at) in invalid {
			XCTAssertThrowsError(try preferences.snooze(activityID: id, startedAt: start, now: at))
		}
		XCTAssertEqual(dates(try preferences.plan(running: [current], now: now)), dates(before))
	}

	func testUnavailablePreferenceLockCannotPartiallyEnableReminders() throws {
		let missingDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		let unavailable = ActivityReminderPreferences(defaults: defaults,
			lockURL: missingDirectory.appendingPathComponent("preferences.lock"))
		var settings = ActivityReminderSettings()
		settings.enabled = true
		XCTAssertThrowsError(try unavailable.save(settings: settings))
		XCTAssertFalse(try preferences.settings().enabled)
	}
}
