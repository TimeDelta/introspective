import XCTest
import Foundation
import Common

final class StressReminderPlanTests: XCTestCase {
	private var calendar: Calendar { var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value }
	private func date(_ text: String) -> Date { ISO8601DateFormatter().date(from: text)! }
	private var enabled: StressReminderSettings { var value = StressReminderSettings(); value.enabled = true; return value }

	func testDefaultsAreOptionalAndDoNotScheduleAnyPrompts() throws {
		let value = StressReminderSettings()
		XCTAssertFalse(value.enabled); XCTAssertEqual(value.minute, 18 * 60)
		XCTAssertTrue(try StressReminderPlan.dates(settings: value, now: date("2024-07-15T12:00:00Z"), recordedDates: [], calendar: calendar).isEmpty)
	}
	func testOneDailyPromptUsesFourteenDistinctLocalDaysAndNoPastDates() throws {
		let now = date("2024-07-15T12:00:00Z")
		let values = try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [], calendar: calendar)
		XCTAssertEqual(values.count, 14); XCTAssertEqual(values.first, date("2024-07-15T18:00:00Z"))
		XCTAssertTrue(values.allSatisfy { $0 > now && calendar.component(.hour, from: $0) == 18 })
		XCTAssertEqual(Set(values.map { calendar.startOfDay(for: $0) }).count, 14)
	}
	func testRecordedDaySuppressionDoesNotTreatBackdatedOrFutureInstantsAsToday() throws {
		let now = date("2024-07-15T12:00:00Z")
		XCTAssertEqual(try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [now], calendar: calendar).count, 13)
		XCTAssertEqual(try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [date("2024-07-14T12:00:00Z"), now.addingTimeInterval(1)], calendar: calendar).count, 14)
		var value = enabled; value.skipRecordedDays = false
		XCTAssertEqual(try StressReminderPlan.dates(settings: value, now: now, recordedDates: [now], calendar: calendar).count, 14)
	}
	func testQuietHoursRejectReminderAndEqualBoundsWithoutPersistingInvalidSchedule() {
		for minute in [-1, 1440, 22 * 60, 7 * 60] {
			var value = enabled; value.minute = minute
			XCTAssertThrowsError(try value.validate())
		}
		var value = enabled; value.quietEnd = value.quietStart
		XCTAssertThrowsError(try value.validate())
		value.quietHoursEnabled = false; XCTAssertNoThrow(try value.validate())
	}
	func testSpringGapDoesNotMoveReminderIntoQuietHours() throws {
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		var value = enabled; value.minute = 150; value.quietStart = 180; value.quietEnd = 240
		let values = try StressReminderPlan.dates(settings: value, now: date("2024-03-10T08:00:00Z"), recordedDates: [], calendar: local)
		XCTAssertEqual(values.count, 13)
		XCTAssertFalse(values.contains { local.isDate($0, inSameDayAs: date("2024-03-10T08:00:00Z")) })
	}
	func testAutumnRepeatedTimeSchedulesOneOccurrenceAtChosenWallTime() throws {
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		var value = enabled; value.minute = 90; value.quietHoursEnabled = false
		let values = try StressReminderPlan.dates(settings: value, now: date("2024-11-03T07:00:00Z"), recordedDates: [], calendar: local)
		XCTAssertEqual(values.count, 14); XCTAssertEqual(values.first, date("2024-11-03T08:30:00Z"))
		XCTAssertEqual(Set(values.map { local.startOfDay(for: $0) }).count, 14)
	}
	func testRefreshAfterTravelUsesNewLocalTimeZone() throws {
		var tokyo = calendar; tokyo.timeZone = TimeZone(identifier: "Asia/Tokyo")!
		let now = date("2024-07-15T01:00:00Z")
		let values = try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [], calendar: tokyo)
		XCTAssertEqual(tokyo.component(.hour, from: try XCTUnwrap(values.first)), 18)
		XCTAssertNotEqual(values.first, try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [], calendar: calendar).first)
	}
	func testInvalidNowFailsAndNonfiniteRecordedDatesCannotCompleteADay() throws {
		let now = date("2024-07-15T12:00:00Z")
		for invalid in [Double.nan, .infinity, -.infinity] {
			let date = Date(timeIntervalSinceReferenceDate: invalid)
			XCTAssertThrowsError(try StressReminderPlan.dates(settings: enabled, now: date, recordedDates: [], calendar: calendar))
			XCTAssertEqual(try StressReminderPlan.dates(settings: enabled, now: now, recordedDates: [date], calendar: calendar).count, 14)
		}
	}
	func testPreferencesRoundTripStaySeparateFromMoodAndRejectInvalidReplacement() throws {
		let suite = UUID().uuidString
		let defaults = UserDefaults(suiteName: suite)!
		defer { defaults.removePersistentDomain(forName: suite) }
		let stress = StressReminderPreferences(defaults: defaults), mood = MoodTrackingPreferences(defaults: defaults)
		var value = enabled; value.minute = 17 * 60; value.skipRecordedDays = false
		try stress.save(reminders: value)
		XCTAssertEqual(try StressReminderPreferences(defaults: defaults).reminders(), value)
		XCTAssertFalse(try mood.reminders().enabled)
		var invalid = value; invalid.minute = 1500
		XCTAssertThrowsError(try stress.save(reminders: invalid))
		XCTAssertEqual(try stress.reminders(), value)
	}
}
