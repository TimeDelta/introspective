import XCTest
import Foundation
import Samples

final class ActivityBackdateTests: XCTestCase {
	private func calendar(_ zone: String = "UTC") throws -> Calendar {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = try XCTUnwrap(TimeZone(identifier: zone))
		calendar.firstWeekday = 2
		calendar.minimumDaysInFirstWeek = 4
		return calendar
	}

	private func date(_ text: String) throws -> Date {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		if let value = formatter.date(from: text) { return value }
		formatter.formatOptions = [.withInternetDateTime]
		return try XCTUnwrap(formatter.date(from: text))
	}

	func testEachBackdateUnitZerosEveryLowerUnit() throws {
		let now = try date("2024-07-17T14:25:36.875Z")
		let cases: [(Int, Calendar.Component, String)] = [
			(5, .second, "2024-07-17T14:25:31Z"),
			(5, .minute, "2024-07-17T14:20:00Z"),
			(2, .hour, "2024-07-17T12:00:00Z"),
			(2, .day, "2024-07-15T00:00:00Z"),
			(1, .weekOfYear, "2024-07-08T00:00:00Z"),
			(2, .month, "2024-05-01T00:00:00Z"),
			(2, .year, "2022-01-01T00:00:00Z"),
		]
		for (value, unit, expected) in cases {
			let result = try ActivityBackdate.date(value: value, unit: unit, now: now, calendar: calendar())
			XCTAssertEqual(result, try date(expected), "Backdating in \(unit) must zero every lower unit")
			XCTAssertEqual(result.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1), 0)
		}
	}

	func testZeroOffsetStillMarksTheExplicitlyChosenPrecision() throws {
		let now = try date("2024-07-17T14:25:36.875Z")
		XCTAssertEqual(try ActivityBackdate.date(value: 0, unit: .minute, now: now, calendar: calendar()),
			try date("2024-07-17T14:25:00Z"))
		XCTAssertEqual(try ActivityBackdate.date(value: 0, unit: .hour, now: now, calendar: calendar()),
			try date("2024-07-17T14:00:00Z"))
		XCTAssertEqual(now, try date("2024-07-17T14:25:36.875Z"), "Normalizing a backdate must not modify its reference instant")
	}

	func testDayBackdatingUsesTheLocalCalendarAcrossSpringDST() throws {
		let now = try date("2024-03-11T16:25:36.875Z")
		let result = try ActivityBackdate.date(value: 1, unit: .day, now: now, calendar: calendar("America/New_York"))
		XCTAssertEqual(result, try date("2024-03-10T05:00:00Z"), "The requested day starts in EST before the spring transition")
	}

	func testDayBackdatingUsesTheLocalCalendarAcrossFallDST() throws {
		let now = try date("2024-11-04T17:25:36.875Z")
		let result = try ActivityBackdate.date(value: 1, unit: .day, now: now, calendar: calendar("America/New_York"))
		XCTAssertEqual(result, try date("2024-11-03T04:00:00Z"), "The requested day starts in EDT before the repeated hour")
	}

	func testDayWithoutMidnightUsesItsFirstValidLocalInstant() throws {
		let now = try date("2018-11-05T14:25:36.875Z")
		let result = try ActivityBackdate.date(value: 1, unit: .day, now: now, calendar: calendar("America/Sao_Paulo"))
		XCTAssertEqual(result, try date("2018-11-04T03:00:00Z"))
		XCTAssertEqual(try calendar("America/Sao_Paulo").component(.hour, from: result), 1)
	}

	func testMinuteBackdatingRetainsTheCorrectOccurrenceOfRepeatedHour() throws {
		let now = try date("2024-11-03T06:45:36.875Z")
		let result = try ActivityBackdate.date(value: 15, unit: .minute, now: now, calendar: calendar("America/New_York"))
		XCTAssertEqual(result, try date("2024-11-03T06:30:00Z"), "The second 01:30 must not move into the first occurrence")
	}

	func testWholeSecondsAreRetainedAndOnlyFractionsAreRemovedForSeconds() throws {
		let now = try date("2024-07-17T14:25:03.875Z")
		XCTAssertEqual(try ActivityBackdate.date(value: 5, unit: .second, now: now, calendar: calendar()),
			try date("2024-07-17T14:24:58Z"))
	}

	func testMonthAndYearBackdatesNormalizeInTheSelectedTimeZone() throws {
		let now = try date("2024-03-31T20:25:36.875Z")
		let local = try calendar("America/New_York")
		XCTAssertEqual(try ActivityBackdate.date(value: 1, unit: .month, now: now, calendar: local),
			try date("2024-02-01T05:00:00Z"))
		XCTAssertEqual(try ActivityBackdate.date(value: 1, unit: .year, now: now, calendar: local),
			try date("2023-01-01T05:00:00Z"))
	}

	func testNegativeAndOverflowingOffsetsAreRejected() throws {
		let now = try date("2024-07-17T14:25:36.875Z")
		for value in [-1, Int.min, Int.max] {
			XCTAssertThrowsError(try ActivityBackdate.date(value: value, unit: .minute, now: now, calendar: calendar()))
		}
	}

	func testUnsupportedUnitsAndNonFiniteDatesAreRejected() throws {
		let now = try date("2024-07-17T14:25:36.875Z")
		for unit: Calendar.Component in [.nanosecond, .weekday, .era] {
			XCTAssertThrowsError(try ActivityBackdate.date(value: 1, unit: unit, now: now, calendar: calendar()))
		}
		for value in [Double.nan, Double.infinity, -Double.infinity] {
			XCTAssertThrowsError(try ActivityBackdate.date(value: 1, unit: .minute,
				now: Date(timeIntervalSinceReferenceDate: value), calendar: calendar()))
		}
	}

	func testSiriUnitNamesAcceptSingularPluralWhitespaceAndCase() throws {
		let cases: [(String, Calendar.Component)] = [
			("second", .second), ("SECONDS", .second), ("minute", .minute), (" minutes ", .minute),
			("hour", .hour), ("Hours", .hour), ("day", .day), ("DAYS", .day),
			("week", .weekOfYear), ("weeks", .weekOfYear), ("Week of Year", .weekOfYear),
			("month", .month), ("months", .month), ("year", .year), ("\nYears\t", .year),
		]
		for (name, expected) in cases { XCTAssertEqual(try ActivityBackdate.unit(named: name), expected) }
	}

	func testUnsupportedSiriUnitNamesCannotSilentlyBecomeNowOrAnotherUnit() {
		for name in ["", " ", "millisecond", "nanoseconds", "fortnight", "weekday", "minutes ago", "garbage"] {
			XCTAssertThrowsError(try ActivityBackdate.unit(named: name))
		}
	}
}
