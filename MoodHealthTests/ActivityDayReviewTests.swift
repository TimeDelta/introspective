import XCTest
import Foundation
import Common

final class ActivityDayReviewTests: XCTestCase {
	private func calendar(_ zone: String = "UTC") throws -> Calendar {
		var value = Calendar(identifier: .gregorian)
		value.timeZone = try XCTUnwrap(TimeZone(identifier: zone))
		return value
	}

	private func date(_ text: String) throws -> Date {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		if let value = formatter.date(from: text) { return value }
		formatter.formatOptions = [.withInternetDateTime]
		return try XCTUnwrap(formatter.date(from: text))
	}

	private func record(_ id: String, _ start: String, _ end: String? = nil) throws -> ActivityReviewRecord {
		ActivityReviewRecord(id: id, definitionID: "definition-" + id, name: id,
			start: try date(start), end: try end.map(date))
	}

	private func review(_ records: [ActivityReviewRecord], day: String = "2024-07-15T12:00:00Z",
		asOf: String = "2024-07-16T12:00:00Z", zone: String = "UTC") throws -> ActivityDayReview {
		try ActivityDayReview(records: records, day: date(day), asOf: date(asOf), calendar: calendar(zone))
	}

	func testEmptyHistoricalDayIsOneUnrecordedIntervalRatherThanRecordedInactivity() throws {
		let result = try review([])
		let expected = DateInterval(start: try date("2024-07-15T00:00:00Z"), end: try date("2024-07-16T00:00:00Z"))
		XCTAssertEqual(result.dayInterval, expected); XCTAssertEqual(result.reviewInterval, expected)
		XCTAssertEqual(result.gaps, [expected]); XCTAssertTrue(result.records.isEmpty)
		XCTAssertTrue(result.coveredIntervals.isEmpty); XCTAssertEqual(result.recordedDuration, 0)
		XCTAssertEqual(result.unrecordedDuration, 86400)
	}

	func testNestedOverlappingAndAdjacentRecordsMergeCoverageWithoutCollapsingTheRows() throws {
		let records = try [record("outer", "2024-07-15T01:00:00Z", "2024-07-15T04:00:00Z"),
			record("nested", "2024-07-15T02:00:00Z", "2024-07-15T03:00:00Z"),
			record("overlap", "2024-07-15T03:30:00Z", "2024-07-15T05:00:00Z"),
			record("adjacent", "2024-07-15T05:00:00Z", "2024-07-15T06:00:00Z")]
		let result = try review([records[3], records[1], records[0], records[2]])
		XCTAssertEqual(result.records.map(\.id), ["outer", "nested", "overlap", "adjacent"])
		XCTAssertEqual(result.coveredIntervals, [DateInterval(start: try date("2024-07-15T01:00:00Z"), end: try date("2024-07-15T06:00:00Z"))])
		XCTAssertEqual(result.gaps, [
			DateInterval(start: try date("2024-07-15T00:00:00Z"), end: try date("2024-07-15T01:00:00Z")),
			DateInterval(start: try date("2024-07-15T06:00:00Z"), end: try date("2024-07-16T00:00:00Z"))])
		XCTAssertEqual(result.recordedDuration, 5 * 3600)
		XCTAssertEqual(result.recordedDuration + result.unrecordedDuration, result.reviewInterval.duration)
	}

	func testGapDefaultsRetainTheExactNeighboringFractionalTimestamps() throws {
		let before = try record("Before", "2024-07-14T23:00:00Z", "2024-07-15T09:13:26.125Z")
		let after = try record("After", "2024-07-15T09:47:18.875Z", "2024-07-16T01:00:00Z")
		let result = try review([before, after])
		XCTAssertEqual(result.gaps, [DateInterval(start: try XCTUnwrap(before.end), end: after.start)])
		XCTAssertEqual(result.records, [before, after], "Clipping coverage must not rewrite the source records")
	}

	func testCrossDayRecordsAreClippedForCoverageWhileTheirStoredInstantsRemainUntouched() throws {
		let record = try record("Travel", "2024-07-14T23:12:36.125Z", "2024-07-16T01:42:09.875Z")
		let result = try review([record])
		XCTAssertEqual(result.records, [record]); XCTAssertEqual(result.coveredIntervals, [result.dayInterval])
		XCTAssertTrue(result.gaps.isEmpty); XCTAssertEqual(result.recordedDuration, 86400)
	}

	func testRunningActivityFromPreviousDayCoversOnlyThroughTheCurrentInstant() throws {
		let running = try record("Forgotten timer", "2024-07-14T22:00:00.125Z")
		let result = try review([running], asOf: "2024-07-15T12:34:56.875Z")
		XCTAssertEqual(result.reviewInterval.end, try date("2024-07-15T12:34:56.875Z"))
		XCTAssertEqual(result.records, [running]); XCTAssertEqual(result.runningRecords, [running])
		XCTAssertEqual(result.coveredIntervals, [result.reviewInterval]); XCTAssertTrue(result.gaps.isEmpty)
		XCTAssertNil(result.records.first?.end, "An unfinished record must not acquire an inferred end")
	}

	func testTodayStopsAtAsOfAndNeverCreatesFutureGapsOrFutureRows() throws {
		let before = try record("Morning", "2024-07-15T08:00:00Z", "2024-07-15T10:00:00Z")
		let future = try record("Future", "2024-07-15T13:00:00Z", "2024-07-15T14:00:00Z")
		let result = try review([before, future], asOf: "2024-07-15T12:00:00Z")
		XCTAssertEqual(result.records, [before]); XCTAssertEqual(result.reviewInterval.duration, 12 * 3600)
		XCTAssertEqual(result.gaps, [
			DateInterval(start: try date("2024-07-15T00:00:00Z"), end: before.start),
			DateInterval(start: try XCTUnwrap(before.end), end: try date("2024-07-15T12:00:00Z"))])
	}

	func testFutureDayHasNoReviewableRowsCoverageOrGaps() throws {
		let future = try record("Future", "2024-07-17T10:00:00Z")
		let result = try review([future], day: "2024-07-17T12:00:00Z", asOf: "2024-07-16T12:00:00Z")
		XCTAssertEqual(result.reviewInterval.duration, 0)
		XCTAssertTrue(result.records.isEmpty); XCTAssertTrue(result.runningRecords.isEmpty)
		XCTAssertTrue(result.coveredIntervals.isEmpty); XCTAssertTrue(result.gaps.isEmpty)
		XCTAssertEqual(result.recordedDuration, 0); XCTAssertEqual(result.unrecordedDuration, 0)
	}

	func testMidnightBoundariesAreExclusiveAndDoNotBorrowRowsFromAdjacentDays() throws {
		let ended = try record("Yesterday", "2024-07-14T22:00:00Z", "2024-07-15T00:00:00Z")
		let next = try record("Tomorrow", "2024-07-16T00:00:00Z", "2024-07-16T01:00:00Z")
		let result = try review([ended, next])
		XCTAssertTrue(result.records.isEmpty); XCTAssertEqual(result.gaps, [result.dayInterval])
	}

	func testSpringAndFallDaysKeepTheirCalendarLengths() throws {
		for (day, asOf, hours) in [("2024-03-10T16:00:00Z", "2024-03-12T16:00:00Z", 23.0),
			("2024-11-03T17:00:00Z", "2024-11-05T17:00:00Z", 25.0)] {
			let result = try review([], day: day, asOf: asOf, zone: "America/New_York")
			XCTAssertEqual(result.dayInterval.duration, hours * 3600)
			XCTAssertEqual(result.gaps, [result.dayInterval])
		}
	}

	func testLocalDayInFractionalHourZoneUsesLocalMidnight() throws {
		let result = try review([], day: "2024-07-15T12:00:00Z", zone: "Asia/Kathmandu")
		XCTAssertEqual(result.dayInterval.start, try date("2024-07-14T18:15:00Z"))
		XCTAssertEqual(result.dayInterval.end, try date("2024-07-15T18:15:00Z"))
	}

	func testInvalidReferenceDatesThrowAndInvalidRecordDatesDoNotBecomeCoverage() throws {
		let validDay = try date("2024-07-15T12:00:00Z"), validNow = try date("2024-07-16T12:00:00Z")
		for invalid in [Double.nan, Double.infinity, -Double.infinity, Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude] {
			let date = Date(timeIntervalSinceReferenceDate: invalid)
			XCTAssertThrowsError(try ActivityDayReview(records: [], day: date, asOf: validNow, calendar: calendar()))
			XCTAssertThrowsError(try ActivityDayReview(records: [], day: validDay, asOf: date, calendar: calendar()))
		}
		let invalidStart = ActivityReviewRecord(id: "bad start", definitionID: "x", name: "Bad", start: Date(timeIntervalSinceReferenceDate: .nan))
		let invalidEnd = ActivityReviewRecord(id: "bad end", definitionID: "x", name: "Bad", start: validDay, end: Date(timeIntervalSinceReferenceDate: .infinity))
		let result = try ActivityDayReview(records: [invalidStart, invalidEnd], day: validDay, asOf: validNow, calendar: calendar())
		XCTAssertTrue(result.records.isEmpty); XCTAssertEqual(result.gaps, [result.dayInterval])
	}

	func testBackwardsRecordStaysAvailableForCorrectionWithoutInventingCoverage() throws {
		let invalid = try record("Needs correction", "2024-07-15T11:00:00Z", "2024-07-15T10:00:00Z")
		let result = try review([invalid])
		XCTAssertEqual(result.records, [invalid]); XCTAssertTrue(result.coveredIntervals.isEmpty)
		XCTAssertEqual(result.gaps, [result.dayInterval])
	}

	func testStableOrderingAndSnapshotValuesDoNotChangeWhenCallerReplacesItsInputs() throws {
		let earlier = try record("earlier", "2024-07-15T08:00:00Z", "2024-07-15T09:00:00Z")
		let a = try record("a", "2024-07-15T09:00:00Z", "2024-07-15T10:00:00Z")
		let b = try record("b", "2024-07-15T09:00:00Z", "2024-07-15T11:00:00Z")
		var inputs = [b, earlier, a]
		let result = try review(inputs)
		inputs[0] = earlier
		XCTAssertEqual(result.records.map(\.id), ["earlier", "a", "b"])
		XCTAssertEqual(result.records.last, b)
	}

	func testManyOverlappingRecordsUseUnionDurationRatherThanSummedDuration() throws {
		let start = try date("2024-07-15T00:00:00Z")
		let records = (0..<240).map { index in
			ActivityReviewRecord(id: String(index), definitionID: "Work", name: "Work",
				start: start.addingTimeInterval(Double(index) * 60), end: start.addingTimeInterval(Double(index + 2) * 60))
		}
		let result = try review(Array(records.reversed()))
		XCTAssertEqual(result.records.count, 240); XCTAssertEqual(result.coveredIntervals.count, 1)
		XCTAssertEqual(result.recordedDuration, 241 * 60)
		XCTAssertEqual(result.unrecordedDuration, 86400 - 241 * 60)
	}
}
