import XCTest
import Foundation
import Common

final class MoodAnalyticsTests: XCTestCase {
	private var calendar: Calendar { var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value }
	private let now = ISO8601DateFormatter().date(from: "2024-07-15T12:00:00Z")!
	private func date(_ text: String) -> Date { ISO8601DateFormatter().date(from: text)! }
	private func observation(_ rating: Double, at date: Date, minimum: Double = 0, maximum: Double = 1) -> MoodReviewObservation {
		MoodReviewObservation(date: date, rating: rating, minimum: minimum, maximum: maximum)
	}
	private func review(_ values: [MoodReviewObservation], includeToday: Bool = false) -> MoodWeekComparison {
		MoodWeekComparison(observations: values, endingOn: now, includingToday: includeToday, calendar: calendar)
	}
	func testEmptyPeriodsRetainSevenMissingDaysAndUnavailableStatistics() {
		let value = review([])
		XCTAssertEqual(value.current.days.count, 7); XCTAssertEqual(value.previous.days.count, 7)
		XCTAssertEqual(value.current.recordedDayCount, 0); XCTAssertEqual(value.current.distribution, [0, 0, 0, 0, 0])
		XCTAssertTrue(value.current.days.allSatisfy { $0.averagePosition == nil && $0.checkInCount == 0 })
		XCTAssertNil(value.current.averagePosition); XCTAssertNil(value.current.dailyAveragePosition)
		XCTAssertNil(value.current.medianPosition); XCTAssertNil(value.current.standardDeviation); XCTAssertNil(value.difference)
	}
	func testDayBalancedAverageDoesNotOverweightFrequentlyRecordedDays() throws {
		let first = date("2024-07-09T12:00:00Z"), second = date("2024-07-10T12:00:00Z")
		let value = review([observation(0, at: first)] + (0..<3).map { _ in observation(1, at: second) }).current
		XCTAssertEqual(try XCTUnwrap(value.averagePosition), 0.75, accuracy: 1e-12)
		XCTAssertEqual(try XCTUnwrap(value.dailyAveragePosition), 0.5, accuracy: 1e-12)
		XCTAssertEqual(value.recordedDayCount, 2); XCTAssertEqual(value.ratedDayCount, 2)
		XCTAssertEqual(try XCTUnwrap(value.standardDeviation), 0.5, accuracy: 1e-12)
	}
	func testHistoricalScalesNormalizeWithoutChangingInputs() throws {
		let day = date("2024-07-09T12:00:00Z")
		let input = [observation(1, at: day, maximum: 4), observation(25, at: day, maximum: 100), observation(-0.5, at: day, minimum: -1)]
		let result = review(input).current
		XCTAssertEqual(try XCTUnwrap(result.averagePosition), 0.25, accuracy: 1e-12)
		XCTAssertEqual(result.distribution, [0, 3, 0, 0, 0]); XCTAssertEqual(input[2].rating, -0.5)
	}
	func testInvalidRecordsHaveDistinctExclusionsAndNeverBecomeZeroRatings() {
		let day = date("2024-07-09T12:00:00Z")
		let input = [observation(0, at: day, maximum: 0), observation(0, at: day, minimum: 1, maximum: 0),
			observation(0, at: day, minimum: -.infinity), observation(0, at: day, minimum: -Double.greatestFiniteMagnitude, maximum: Double.greatestFiniteMagnitude),
			observation(.nan, at: day), observation(.infinity, at: day), observation(-0.01, at: day), observation(1.01, at: day)]
		let value = review(input).current
		XCTAssertEqual(value.checkInCount, 8); XCTAssertEqual(value.ratedCheckInCount, 0)
		XCTAssertEqual(value.invalidScaleCount, 4); XCTAssertEqual(value.invalidRatingCount, 2); XCTAssertEqual(value.outOfRangeCount, 2)
		XCTAssertEqual(value.recordedDayCount, 1); XCTAssertEqual(value.ratedDayCount, 0)
		XCTAssertNil(value.dailyAveragePosition); XCTAssertNil(value.medianPosition)
	}
	func testDistributionHasHalfOpenBinsAndIncludesTheMaximumOnce() {
		let day = date("2024-07-09T12:00:00Z")
		let result = review([0, 20, 40, 60, 80, 100].map { observation(Double($0), at: day, maximum: 100) }).current
		XCTAssertEqual(result.distribution, [1, 1, 1, 1, 2])
		XCTAssertEqual(result.distribution.reduce(0, +), result.ratedCheckInCount)
	}
	func testMedianQuartilesAndSampleDeviationUseDocumentedDefinitions() throws {
		let day = date("2024-07-09T12:00:00Z")
		let value = review([0.0, 0.25, 0.75, 1].map { observation($0, at: day) }).current
		XCTAssertEqual(try XCTUnwrap(value.medianPosition), 0.5, accuracy: 1e-12)
		XCTAssertEqual(try XCTUnwrap(value.lowerQuartile), 0.1875, accuracy: 1e-12)
		XCTAssertEqual(try XCTUnwrap(value.upperQuartile), 0.8125, accuracy: 1e-12)
		XCTAssertEqual(try XCTUnwrap(value.standardDeviation), sqrt(0.625 / 3), accuracy: 1e-12)
	}
	func testOneRatingHasMedianAndQuartilesButNoSampleDeviation() {
		let value = review([observation(0.6, at: date("2024-07-09T12:00:00Z"))]).current
		XCTAssertEqual(value.medianPosition, 0.6); XCTAssertEqual(value.lowerQuartile, 0.6); XCTAssertEqual(value.upperQuartile, 0.6)
		XCTAssertNil(value.standardDeviation)
	}
	func testAdjacentHalfOpenWindowsNeverDoubleCountBoundaryRecords() {
		let windows = MoodWeekComparison.intervals(endingOn: now, calendar: calendar)
		let values = [observation(0.1, at: windows.previous.start.addingTimeInterval(-0.001)), observation(0.2, at: windows.previous.start),
			observation(0.3, at: windows.current.start.addingTimeInterval(-0.001)), observation(0.4, at: windows.current.start),
			observation(0.5, at: windows.current.end.addingTimeInterval(-0.001)), observation(0.6, at: windows.current.end)]
		let result = review(values)
		XCTAssertEqual(result.previous.checkInCount, 2); XCTAssertEqual(result.current.checkInCount, 2)
		XCTAssertEqual(result.previous.interval.end, result.current.interval.start)
	}
	func testIncludingTodayIsExplicitAndNeverIncludesFutureRecords() {
		let values = [observation(0.2, at: now), observation(0.9, at: now.addingTimeInterval(1)),
			observation(0.5, at: Date(timeIntervalSinceReferenceDate: .nan))]
		let result = review(values, includeToday: true)
		XCTAssertEqual(result.current.checkInCount, 1); XCTAssertEqual(result.current.averagePosition, 0.2)
		XCTAssertEqual(result.futureCheckInCount, 1); XCTAssertEqual(result.invalidTimestampCount, 1)
		XCTAssertEqual(review(values).current.checkInCount, 0)
	}
	func testSpringAndFallWindowsContainSevenCalendarDaysAcrossDST() {
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		for (text, hours) in [("2024-03-11T20:00:00Z", 167.0), ("2024-11-04T20:00:00Z", 169.0)] {
			let result = MoodWeekComparison(observations: [], endingOn: date(text), calendar: local)
			XCTAssertEqual(result.current.interval.duration / 3600, hours)
			XCTAssertEqual(result.current.days.count, 7)
			XCTAssertEqual(Set(result.current.days.map { local.component(.weekday, from: $0.date) }).count, 7)
		}
	}
	func testDailyGroupingUsesSelectedLocalCalendarRatherThanUTC() {
		let values = [observation(0, at: date("2024-07-01T00:30:00Z")), observation(1, at: date("2024-07-01T07:30:00Z"))]
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		let end = date("2024-07-03T12:00:00Z")
		XCTAssertEqual(MoodWeekComparison(observations: values, endingOn: end, calendar: calendar).current.recordedDayCount, 1)
		XCTAssertEqual(MoodWeekComparison(observations: values, endingOn: end, calendar: local).current.recordedDayCount, 2)
	}
	func testNonGregorianCalendarAndFractionalHourZoneStillProduceAdjacentWeeks() {
		var local = Calendar(identifier: .buddhist); local.timeZone = TimeZone(identifier: "Asia/Kathmandu")!
		let result = MoodWeekComparison(observations: [], endingOn: now, calendar: local)
		XCTAssertEqual(result.current.days.count, 7); XCTAssertEqual(result.previous.days.count, 7)
		XCTAssertEqual(result.previous.interval.end, result.current.interval.start)
		XCTAssertEqual(local.component(.minute, from: result.current.interval.start), 0)
		XCTAssertEqual(local.component(.hour, from: result.current.interval.start), 0)
	}
	func testComparisonUsesDailyMeansAndRequiresValidRatingsInBothPeriods() throws {
		let old = date("2024-07-02T12:00:00Z"), latest = date("2024-07-09T12:00:00Z")
		XCTAssertNil(review([observation(1, at: latest)]).difference)
		let result = review([observation(0.25, at: old), observation(0.75, at: latest)])
		XCTAssertEqual(try XCTUnwrap(result.difference), 0.5, accuracy: 1e-12)
	}
	func testManyUnevenDailySamplesMatchIndependentWeightedExpectations() throws {
		let start = MoodWeekComparison.intervals(endingOn: now, calendar: calendar).current.start
		var values: [MoodReviewObservation] = []
		for day in 1...7 {
			let date = calendar.date(byAdding: .day, value: day - 1, to: start)!.addingTimeInterval(3600)
			values += (0..<(100 * day * day)).map { _ in observation(Double(day), at: date, maximum: 7) }
		}
		let result = review(values).current, reversed = review(Array(values.reversed())).current
		XCTAssertEqual(result.checkInCount, 14000); XCTAssertEqual(result.ratedDayCount, 7)
		XCTAssertEqual(try XCTUnwrap(result.dailyAveragePosition), 4.0 / 7, accuracy: 1e-10)
		XCTAssertEqual(try XCTUnwrap(result.averagePosition), 0.8, accuracy: 1e-10)
		XCTAssertEqual(result.distribution, reversed.distribution)
		XCTAssertEqual(try XCTUnwrap(result.dailyAveragePosition), try XCTUnwrap(reversed.dailyAveragePosition), accuracy: 1e-10)
	}
	func testMatchedWeekdaysCompareOnlyPairsWithValidRatingsInBothPeriods() throws {
		let values = [observation(0.8, at: date("2024-07-09T12:00:00Z")), observation(0.6, at: date("2024-07-10T12:00:00Z")),
			observation(0.2, at: date("2024-07-02T12:00:00Z")), observation(0.4, at: date("2024-07-04T12:00:00Z"))]
		let result = review(values)
		XCTAssertEqual(try XCTUnwrap(result.difference), 0.4, accuracy: 1e-12)
		XCTAssertEqual(result.matchedDayCount, 1)
		XCTAssertEqual(try XCTUnwrap(result.matchedDayDifference), 0.6, accuracy: 1e-12)
	}
	func testDisjointRecordedWeekdaysDoNotInventAMatchedComparison() {
		let result = review([observation(0.8, at: date("2024-07-09T12:00:00Z")), observation(0.2, at: date("2024-07-03T12:00:00Z"))])
		XCTAssertNotNil(result.difference); XCTAssertNil(result.matchedDayDifference); XCTAssertEqual(result.matchedDayCount, 0)
	}
	func testInvalidEntriesDoNotDiluteValidAveragesOrDistributionDenominators() {
		let day = date("2024-07-09T12:00:00Z")
		let value = review([observation(0.8, at: day), observation(.nan, at: day), observation(2, at: day)]).current
		XCTAssertEqual(value.checkInCount, 3); XCTAssertEqual(value.ratedCheckInCount, 1)
		XCTAssertEqual(value.averagePosition, 0.8); XCTAssertEqual(value.dailyAveragePosition, 0.8)
		XCTAssertEqual(value.distribution, [0, 0, 0, 0, 1])
	}
	func testNegativeComparisonIsNotClampedToAValidRatingRange() {
		let result = review([observation(0, at: date("2024-07-09T12:00:00Z")), observation(1, at: date("2024-07-02T12:00:00Z"))])
		XCTAssertEqual(result.difference, -1); XCTAssertEqual(result.matchedDayDifference, -1)
	}
	func testSourceCountsIncludeExcludedRecordsWithoutChangingRatingWeights() {
		let day = date("2024-07-09T12:00:00Z")
		let result = review([MoodReviewObservation(date: day, rating: 0.8, minimum: 0, maximum: 1, source: "App"),
			MoodReviewObservation(date: day, rating: .nan, minimum: 0, maximum: 1, source: "Health")]).current
		XCTAssertEqual(result.sourceCounts, ["App": 1, "Health": 1]); XCTAssertEqual(result.averagePosition, 0.8)
	}
}

final class MoodHistoryWindowTests: XCTestCase {
	private var calendar: Calendar { var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value }
	private let now = ISO8601DateFormatter().date(from: "2024-07-15T12:34:56Z")!.addingTimeInterval(0.75)
	private func date(_ text: String) -> Date { ISO8601DateFormatter().date(from: text)! }
	private func window(_ selection: MoodHistoryWindow.Selection, asOf: Date? = nil, calendar: Calendar? = nil) throws -> MoodHistoryWindow {
		try XCTUnwrap(MoodHistoryWindow(selection: selection, asOf: asOf ?? now, calendar: calendar ?? self.calendar))
	}

	func testRecentWindowsRetainOneSevenAndThirtyCalendarDaysIncludingToday() throws {
		for (days, start) in [(1, "2024-07-15T00:00:00Z"), (7, "2024-07-09T00:00:00Z"), (30, "2024-06-16T00:00:00Z")] {
			let value = try window(.recentDays(days))
			XCTAssertEqual(value.selection, .recentDays(days))
			XCTAssertEqual(value.interval.start, date(start))
			XCTAssertEqual(value.interval.end, date("2024-07-16T00:00:00Z"))
			XCTAssertTrue(value.contains(now))
		}
	}

	func testRecentWindowsHaveNoDayCursorOrBackfillDefault() throws {
		for days in [1, 7, 30] {
			let value = try window(.recentDays(days))
			XCTAssertNil(value.selectedDay); XCTAssertNil(value.newCheckInDate)
			XCTAssertFalse(value.canMoveForward); XCTAssertNil(value.movingDay(by: -1))
		}
	}

	func testSelectedDayNormalizesItsSelectionAndInterval() throws {
		let value = try window(.day(date("2024-07-02T17:45:23Z").addingTimeInterval(0.125)))
		let start = date("2024-07-02T00:00:00Z")
		XCTAssertEqual(value.selection, .day(start)); XCTAssertEqual(value.selectedDay, start)
		XCTAssertEqual(value.interval, DateInterval(start: start, end: date("2024-07-03T00:00:00Z")))
		XCTAssertEqual(value.newCheckInDate, start); XCTAssertTrue(value.canMoveForward)
	}

	func testContainmentUsesFiniteInstantsAndHalfOpenBoundaries() throws {
		let value = try window(.day(date("2024-07-02T12:00:00Z")))
		XCTAssertFalse(value.contains(value.interval.start.addingTimeInterval(-0.001)))
		XCTAssertTrue(value.contains(value.interval.start))
		XCTAssertTrue(value.contains(value.interval.end.addingTimeInterval(-0.001)))
		XCTAssertFalse(value.contains(value.interval.end))
		for invalid in [Double.nan, .infinity, -.infinity] {
			XCTAssertFalse(value.contains(Date(timeIntervalSinceReferenceDate: invalid)))
		}
	}

	func testAdjacentDayNavigationHasNoGapOrDoubleCountedBoundary() throws {
		let value = try window(.day(date("2024-07-02T12:00:00Z")))
		let previous = try XCTUnwrap(value.movingDay(by: -1)), next = try XCTUnwrap(value.movingDay(by: 1))
		XCTAssertEqual(previous.interval.end, value.interval.start)
		XCTAssertEqual(value.interval.end, next.interval.start)
		XCTAssertFalse(value.contains(next.interval.start)); XCTAssertTrue(next.contains(next.interval.start))
		XCTAssertEqual(try XCTUnwrap(next.movingDay(by: -1)).selection, value.selection)
		XCTAssertEqual(try XCTUnwrap(value.movingDay(by: 0)).selection, value.selection)
	}

	func testFutureSelectionsAndForwardNavigationClampToTheCapturedToday() throws {
		let today = date("2024-07-15T00:00:00Z")
		for future in [date("2024-07-15T23:59:00Z"), date("2024-07-20T12:00:00Z")] {
			let value = try window(.day(future))
			XCTAssertEqual(value.selection, .day(today)); XCTAssertFalse(value.canMoveForward)
			XCTAssertNil(value.newCheckInDate)
			XCTAssertEqual(try XCTUnwrap(value.movingDay(by: 1)).selectedDay, today)
		}
		let past = try window(.day(date("2024-07-14T18:00:00Z")))
		let moved = try XCTUnwrap(past.movingDay(by: 10))
		XCTAssertEqual(moved.selectedDay, today); XCTAssertNil(moved.newCheckInDate)
		XCTAssertTrue(try XCTUnwrap(moved.movingDay(by: -1)).canMoveForward)
	}

	func testTodayIncludesFutureClockTimesWithoutInventingAnAddTimestamp() throws {
		for selection in [MoodHistoryWindow.Selection.day(now), .recentDays(1)] {
			let value = try window(selection)
			XCTAssertTrue(value.contains(now.addingTimeInterval(1)))
			XCTAssertTrue(value.contains(date("2024-07-15T23:59:59Z")))
			XCTAssertNil(value.newCheckInDate, "The editor retains its automatic full-precision Date() default")
		}
		XCTAssertEqual(calendar.component(.second, from: now), 56)
		XCTAssertEqual(now.timeIntervalSince1970.truncatingRemainder(dividingBy: 1), 0.75)
	}

	func testPastDayBackfillDefaultClearsTimeSecondsAndFractions() throws {
		let value = try window(.day(date("2024-07-14T18:22:43Z").addingTimeInterval(0.875)))
		let initial = try XCTUnwrap(value.newCheckInDate)
		let components = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: initial)
		XCTAssertEqual(components.hour, 0); XCTAssertEqual(components.minute, 0)
		XCTAssertEqual(components.second, 0); XCTAssertEqual(components.nanosecond, 0)
		XCTAssertEqual(initial, value.interval.start)
	}

	func testInvalidDatesAndNonpositiveRecentCountsFailWithoutNormalization() {
		for invalid in [Double.nan, .infinity, -.infinity] {
			let invalidDate = Date(timeIntervalSinceReferenceDate: invalid)
			XCTAssertNil(MoodHistoryWindow(selection: .day(invalidDate), asOf: now, calendar: calendar))
			XCTAssertNil(MoodHistoryWindow(selection: .day(now), asOf: invalidDate, calendar: calendar))
			XCTAssertNil(MoodHistoryWindow(selection: .recentDays(7), asOf: invalidDate, calendar: calendar))
		}
		for count in [0, -1, Int.min] {
			XCTAssertNil(MoodHistoryWindow(selection: .recentDays(count), asOf: now, calendar: calendar))
		}
	}

	func testSelectedDaysRespectSpringAndAutumnDaylightSavingLengths() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
		for (day, hours) in [("2024-03-10T19:00:00Z", 23.0), ("2024-11-03T20:00:00Z", 25.0)] {
			let value = try window(.day(date(day)), asOf: date("2024-12-01T12:00:00Z"), calendar: local)
			XCTAssertEqual(value.interval.duration / 3600, hours)
			XCTAssertEqual(local.component(.hour, from: value.interval.start), 0)
			XCTAssertEqual(local.component(.hour, from: value.interval.end), 0)
		}
	}

	func testDaylightSavingNavigationAndRecentWindowsUseCalendarDays() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
		for (day, expectedHours) in [("2024-03-11T19:00:00Z", 167.0), ("2024-11-04T20:00:00Z", 169.0)] {
			let reference = date(day)
			let value = try window(.day(reference), asOf: reference, calendar: local)
			let previous = try XCTUnwrap(value.movingDay(by: -1))
			XCTAssertEqual(previous.interval.end, value.interval.start)
			XCTAssertEqual(try XCTUnwrap(previous.movingDay(by: 1)).interval, value.interval)
			let recent = try window(.recentDays(7), asOf: reference, calendar: local)
			XCTAssertEqual(recent.interval.duration / 3600, expectedHours)
			XCTAssertEqual(local.dateComponents([.day], from: recent.interval.start, to: recent.interval.end).day, 7)
		}
	}

	func testNavigationHandlesLeapDayAndYearBoundaries() throws {
		for (initial, offset, expected) in [("2024-02-28T12:00:00Z", 1, "2024-02-29T00:00:00Z"),
			("2024-02-28T12:00:00Z", 2, "2024-03-01T00:00:00Z"),
			("2023-12-31T12:00:00Z", 1, "2024-01-01T00:00:00Z"),
			("2024-01-01T12:00:00Z", -1, "2023-12-31T00:00:00Z")] {
			let value = try window(.day(date(initial)))
			XCTAssertEqual(try XCTUnwrap(value.movingDay(by: offset)).selectedDay, date(expected))
		}
	}

	func testNonGregorianCalendarPreservesLocalDaySelectionAndNavigation() throws {
		var local = Calendar(identifier: .buddhist); local.timeZone = try XCTUnwrap(TimeZone(identifier: "Asia/Bangkok"))
		let value = try window(.day(date("2024-07-02T18:00:00Z")), calendar: local)
		XCTAssertEqual(value.interval.start, date("2024-07-02T17:00:00Z"))
		XCTAssertEqual(local.component(.year, from: value.interval.start), 2567)
		XCTAssertEqual(try XCTUnwrap(value.movingDay(by: -1)).interval.end, value.interval.start)
		XCTAssertEqual(try window(.recentDays(30), calendar: local).interval.end, date("2024-07-15T17:00:00Z"))
	}

	func testFractionalHourTimeZoneUsesItsOwnMidnight() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "Asia/Kathmandu"))
		let value = try window(.day(date("2024-07-02T12:00:00Z")), calendar: local)
		XCTAssertEqual(value.interval.start, date("2024-07-01T18:15:00Z"))
		XCTAssertEqual(value.interval.end, date("2024-07-02T18:15:00Z"))
		XCTAssertEqual(local.component(.minute, from: value.interval.start), 0)
		XCTAssertEqual(value.newCheckInDate, value.interval.start)
	}

	func testMidnightGapUsesTheFirstValidInstantAndTheFollowingDayBoundary() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Sao_Paulo"))
		let value = try window(.day(date("2018-11-04T12:00:00Z")), calendar: local)
		XCTAssertEqual(value.interval.start, date("2018-11-04T03:00:00Z"))
		XCTAssertEqual(local.component(.hour, from: value.interval.start), 1)
		XCTAssertEqual(value.interval.end, date("2018-11-05T02:00:00Z"))
		XCTAssertEqual(value.interval.duration / 3600, 23)
		XCTAssertEqual(value.newCheckInDate, value.interval.start)
		XCTAssertEqual(local.component(.second, from: try XCTUnwrap(value.newCheckInDate)), 0)
		XCTAssertEqual(try XCTUnwrap(value.movingDay(by: 1)).interval.start, value.interval.end)
		XCTAssertEqual(try XCTUnwrap(value.movingDay(by: -1)).interval.end, value.interval.start)
		let recent = try window(.recentDays(7), asOf: date("2018-11-04T12:00:00Z"), calendar: local)
		XCTAssertEqual(recent.interval.start, date("2018-10-29T03:00:00Z"))
		XCTAssertEqual(recent.interval.end, value.interval.end)
		XCTAssertEqual(recent.interval.duration / 3600, 167)
	}

	func testContainmentInterpretsStoredInstantsInTheSelectedCalendarTimeZone() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
		let instant = date("2024-07-01T00:30:00Z")
		let utcDay = try window(.day(instant)), localDay = try window(.day(instant), calendar: local)
		XCTAssertEqual(utcDay.interval.start, date("2024-07-01T00:00:00Z"))
		XCTAssertEqual(localDay.interval.start, date("2024-06-30T07:00:00Z"))
		XCTAssertTrue(utcDay.contains(instant)); XCTAssertTrue(localDay.contains(instant))
		XCTAssertFalse(try XCTUnwrap(localDay.movingDay(by: 1)).contains(instant))
	}
}

final class MoodReminderPlanTests: XCTestCase {
	private var calendar: Calendar { var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value }
	private func date(_ value: String) -> Date { ISO8601DateFormatter().date(from: value)! }
	func testDefaultsAreOptInAndCreateNoNotifications() throws {
		XCTAssertTrue(try MoodReminderPlan.dates(settings: MoodReminderSettings(), now: Date(), recordedDates: [], calendar: calendar).isEmpty)
	}
	func testPastTimesAndExactNowAreExcludedAndRequestCountIsBounded() throws {
		var settings = MoodReminderSettings(); settings.enabled = true; settings.times = [9 * 60, 12 * 60, 18 * 60]
		let dates = try MoodReminderPlan.dates(settings: settings, now: date("2024-07-15T12:00:00Z"), recordedDates: [], calendar: calendar)
		XCTAssertEqual(dates.count, 40); XCTAssertEqual(dates.first, date("2024-07-15T18:00:00Z"))
		XCTAssertEqual(Set(dates).count, dates.count); XCTAssertLessThan(dates.count, 64)
		XCTAssertTrue(dates.allSatisfy { calendar.component(.second, from: $0) == 0 && $0.timeIntervalSince1970.rounded() == $0.timeIntervalSince1970 })
	}
	func testCheckInSuppressesOnlyItsLocalDayAndBackdatingDoesNotSuppressToday() throws {
		var settings = MoodReminderSettings(); settings.enabled = true
		let now = date("2024-07-15T12:00:00Z")
		XCTAssertEqual(try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [now], calendar: calendar).count, 13)
		XCTAssertEqual(try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [now.addingTimeInterval(-86400)], calendar: calendar).count, 14)
		XCTAssertEqual(try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [now.addingTimeInterval(1)], calendar: calendar).count, 14)
		settings.skipRecordedDays = false
		XCTAssertEqual(try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [now], calendar: calendar).count, 14)
	}
	func testQuietHoursHandleMidnightAndBothBoundaries() throws {
		var settings = MoodReminderSettings(); settings.enabled = true
		XCTAssertTrue(settings.isQuiet(22 * 60)); XCTAssertTrue(settings.isQuiet(0)); XCTAssertTrue(settings.isQuiet(8 * 60 - 1))
		XCTAssertFalse(settings.isQuiet(8 * 60)); XCTAssertFalse(settings.isQuiet(22 * 60 - 1))
		settings.times = [22 * 60]; XCTAssertThrowsError(try settings.validate())
		settings.quietStart = 12 * 60; settings.quietEnd = 13 * 60
		XCTAssertFalse(settings.isQuiet(0)); XCTAssertTrue(settings.isQuiet(12 * 60)); XCTAssertFalse(settings.isQuiet(13 * 60))
		settings.quietHoursEnabled = false; XCTAssertNoThrow(try settings.validate())
	}
	func testInvalidSchedulesAreRejectedRatherThanPartiallyApplied() {
		for times in [[], [0, 0], [-1], [1440], [0, 60, 120, 180]] {
			var settings = MoodReminderSettings(); settings.times = times
			XCTAssertThrowsError(try settings.validate())
		}
		var settings = MoodReminderSettings(); settings.quietEnd = settings.quietStart
		XCTAssertThrowsError(try settings.validate())
	}
	func testSpringGapDoesNotMoveAReminderIntoQuietHours() throws {
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		var settings = MoodReminderSettings(); settings.enabled = true; settings.times = [150]; settings.quietStart = 180; settings.quietEnd = 240
		let dates = try MoodReminderPlan.dates(settings: settings, now: date("2024-03-10T08:00:00Z"), recordedDates: [], calendar: local)
		XCTAssertEqual(dates.count, 13)
		XCTAssertFalse(dates.contains { local.isDate($0, inSameDayAs: date("2024-03-10T08:00:00Z")) })
	}
	func testAutumnRepeatedTimeIsScheduledOnceUsingItsFirstOccurrence() throws {
		var local = calendar; local.timeZone = TimeZone(identifier: "America/Los_Angeles")!
		var settings = MoodReminderSettings(); settings.enabled = true; settings.times = [90]; settings.quietHoursEnabled = false
		let dates = try MoodReminderPlan.dates(settings: settings, now: date("2024-11-03T07:00:00Z"), recordedDates: [], calendar: local)
		XCTAssertEqual(dates.count, 14); XCTAssertEqual(dates.first, date("2024-11-03T08:30:00Z"))
		XCTAssertEqual(Set(dates.map { local.startOfDay(for: $0) }).count, 14)
	}
	func testRefreshAfterTravelKeepsChosenLocalTime() throws {
		var settings = MoodReminderSettings(); settings.enabled = true
		var tokyo = calendar; tokyo.timeZone = TimeZone(identifier: "Asia/Tokyo")!
		let now = date("2024-07-15T01:00:00Z")
		let first = try XCTUnwrap(MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [], calendar: tokyo).first)
		XCTAssertEqual(tokyo.component(.hour, from: first), 18)
		XCTAssertNotEqual(first, try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: [], calendar: calendar).first)
	}
}

final class MoodTrackingPreferencesTests: XCTestCase {
	private var suite: String!
	private var defaults: UserDefaults!
	private var preferences: MoodTrackingPreferences!
	override func setUp() { super.setUp(); suite = UUID().uuidString; defaults = UserDefaults(suiteName: suite)!; preferences = MoodTrackingPreferences(defaults: defaults) }
	override func tearDown() { defaults.removePersistentDomain(forName: suite); preferences = nil; defaults = nil; super.tearDown() }
	func testPresetsSurviveReopenWithIdentityScaleNotesAndContext() throws {
		let preset = MoodCheckInPreset(name: "Après work", rating: -0.25, minimum: -1, maximum: 1, note: "quoted \"note\"\nnext line", contexts: ["Travel"])
		try preferences.save(presets: [preset])
		XCTAssertEqual(try MoodTrackingPreferences(defaults: defaults).presets(), [preset])
	}
	func testInvalidPresetSaveLeavesPreviousPresetsIntact() throws {
		let valid = MoodCheckInPreset(name: "Saved", rating: 1, minimum: 0, maximum: 2)
		try preferences.save(presets: [valid])
		for rating in [Double.nan, .infinity, -1, 3] {
			var invalid = valid; invalid.rating = rating
			XCTAssertThrowsError(try preferences.save(presets: [invalid])); XCTAssertEqual(try preferences.presets(), [valid])
		}
		XCTAssertThrowsError(try preferences.save(presets: [valid, valid]))
		XCTAssertEqual(try preferences.presets(), [valid])
	}
	func testReorderingAndDeletingPresetsPersistsWithoutChangingIdentity() throws {
		let a = MoodCheckInPreset(name: "A", rating: 1, minimum: 0, maximum: 2), b = MoodCheckInPreset(name: "B", rating: 2, minimum: 0, maximum: 2)
		try preferences.save(presets: [a, b]); try preferences.save(presets: [b, a])
		XCTAssertEqual(try preferences.presets().map { $0.id }, [b.id, a.id])
		try preferences.save(presets: [a]); XCTAssertEqual(try preferences.presets(), [a])
	}
	func testInvalidNamesScalesAndOversizedPresetsAreRejected() {
		for preset in [MoodCheckInPreset(name: "  ", rating: 1, minimum: 0, maximum: 2), MoodCheckInPreset(name: "Bad", rating: 0, minimum: 0, maximum: 0),
			MoodCheckInPreset(name: "Bad", rating: 1, minimum: 0, maximum: 2, contexts: ["Travel", "Travel"]),
			MoodCheckInPreset(name: "Bad", rating: 1, minimum: 0, maximum: 2, note: String(repeating: "a", count: 4001))] {
			XCTAssertThrowsError(try preset.validate())
		}
		XCTAssertThrowsError(try preferences.save(presets: (0..<21).map { MoodCheckInPreset(name: String($0), rating: 1, minimum: 0, maximum: 2) }))
	}
	func testReminderPreferencesRoundTripAndRemainIndependentOfPresets() throws {
		var settings = MoodReminderSettings(); settings.enabled = true; settings.times = [600, 1080]; settings.skipRecordedDays = false
		try preferences.save(reminders: settings); try preferences.save(presets: [])
		XCTAssertEqual(try MoodTrackingPreferences(defaults: defaults).reminders(), settings)
	}
}
