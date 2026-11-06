import XCTest
import Foundation
import Common

final class StressDraftTests: XCTestCase {
	private let instant = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private func response(_ status: StressResponseStatus = .skipped, rating: Int? = nil,
		id: UUID = UUID(), name: String = "Work", order: Int = 0) -> StressResponseDraft {
		StressResponseDraft(stressorID: id, nameSnapshot: name, order: order, status: status, rating: rating)
	}
	func testRatingAnchorsKeepTheirStoredOrdinalValuesAndLabels() {
		XCTAssertEqual(StressRating.allCases.map { $0.rawValue }, [0, 1, 2, 3, 4])
		XCTAssertEqual(StressRating.allCases.map { $0.title }, ["None", "Mild", "Moderate", "High", "Overwhelming"])
		XCTAssertNil(StressRating(rawValue: -1)); XCTAssertNil(StressRating(rawValue: 5))
	}
	func testNewDraftDoesNotPrefillOverallStressOrIndividualAnswers() {
		let draft = StressCheckInDraft(date: instant, responses: [response()])
		XCTAssertNil(draft.overallRating); XCTAssertNil(draft.responses[0].rating)
		XCTAssertEqual(draft.responses[0].status, .skipped)
		XCTAssertThrowsError(try draft.validate())
	}
	func testOverallStressAloneIsACompleteCheckInAndRetainsTimestampPrecision() throws {
		for rating in StressRating.allCases {
			let draft = StressCheckInDraft(date: instant, overallRating: rating.rawValue)
			XCTAssertNoThrow(try draft.validate())
			XCTAssertEqual(draft.date, instant); XCTAssertTrue(draft.responses.isEmpty)
		}
	}
	func testUnansweredNotApplicableAndRecordedZeroRemainDifferent() throws {
		let draft = StressCheckInDraft(date: instant, overallRating: 0, responses: [
			response(.skipped), response(.notApplicable), response(.rated, rating: 0),
		])
		try draft.validate()
		let encoded = try JSONEncoder().encode(draft)
		let decoded = try JSONDecoder().decode(StressCheckInDraft.self, from: encoded)
		XCTAssertEqual(decoded, draft)
		XCTAssertNil(decoded.responses[0].rating); XCTAssertNil(decoded.responses[1].rating)
		XCTAssertEqual(decoded.responses[2].rating, 0)
		XCTAssertEqual(decoded.responses.map { $0.status }, [.skipped, .notApplicable, .rated])
	}
	func testFiftyPersonalStressorsAreAllowedWithoutAnArbitraryCountCap() throws {
		let answers = (0..<50).map { response(.rated, rating: $0 % 5, name: "Stressor \($0)", order: $0) }
		let draft = StressCheckInDraft(date: instant, overallRating: 2, responses: answers)
		try draft.validate()
		XCTAssertEqual(draft.responses.count, 50)
		XCTAssertEqual(draft.responses, answers)
	}
	func testDuplicateStressorsAreRejectedEvenWithDifferentNamesOrOrders() {
		let id = UUID()
		let draft = StressCheckInDraft(date: instant, overallRating: 1,
			responses: [response(id: id), response(id: id, name: "Renamed work", order: 1)])
		XCTAssertThrowsError(try draft.validate())
	}
	func testHistoricalNameAndIdentitySnapshotsDoNotChangeWhenDefinitionIsRenamed() {
		var definition = StressStressorSnapshot(name: "Work")
		let answer = response(.rated, rating: 2, id: definition.id, name: definition.name)
		definition.name = "New job"
		XCTAssertEqual(answer.nameSnapshot, "Work"); XCTAssertEqual(answer.stressorID, definition.id)
	}
	func testInvalidOverallRatingsCannotBeSaved() {
		let ratings: [Int?] = [nil, -1, 5, Int.min, Int.max]
		for rating in ratings {
			XCTAssertThrowsError(try StressCheckInDraft(date: instant, overallRating: rating).validate())
		}
	}
	func testInvalidResponseStateAndRatingCombinationsAreRejected() {
		let invalid = [response(.rated), response(.rated, rating: -1), response(.rated, rating: 5),
			response(.skipped, rating: 0), response(.notApplicable, rating: 0)]
		for answer in invalid {
			XCTAssertThrowsError(try answer.validate())
			XCTAssertThrowsError(try StressCheckInDraft(date: instant, overallRating: 1, responses: [answer]).validate())
		}
	}
	func testInvalidNamesAndNegativeOrdersAreRejectedWithoutAffectingValidLimits() {
		for name in ["", " \n\t", String(repeating: "a", count: 121)] {
			XCTAssertThrowsError(try response(name: name).validate())
		}
		XCTAssertThrowsError(try response(order: -1).validate())
		XCTAssertNoThrow(try response(name: String(repeating: "a", count: 120)).validate())
		XCTAssertNoThrow(try StressCheckInDraft(date: instant, overallRating: 1,
			responses: [response(order: 0), response(order: 0)]).validate(), "Order ties do not duplicate an identity")
	}
	func testNoteLengthLimitPreservesExactlyTheAcceptedNote() {
		let note = String(repeating: "a", count: 4000)
		let accepted = StressCheckInDraft(date: instant, overallRating: 1, note: note)
		XCTAssertNoThrow(try accepted.validate()); XCTAssertEqual(accepted.note, note)
		XCTAssertThrowsError(try StressCheckInDraft(date: instant, overallRating: 1, note: note + "a").validate())
	}
	func testNonfiniteDatesAndUnknownMeasurementVersionsAreRejected() {
		for value in [Double.nan, .infinity, -.infinity] {
			XCTAssertThrowsError(try StressCheckInDraft(date: Date(timeIntervalSinceReferenceDate: value), overallRating: 1).validate())
		}
		XCTAssertThrowsError(try StressCheckInDraft(date: instant, overallRating: 1, measurementKind: "daily").validate())
		XCTAssertThrowsError(try StressCheckInDraft(date: instant, overallRating: 1, scaleVersion: 2).validate())
	}
	func testUnknownSerializedStatusCannotSilentlyBecomeSkippedOrZero() throws {
		let answer = response(.rated, rating: 0)
		let data = try JSONEncoder().encode(answer)
		let source = try XCTUnwrap(String(data: data, encoding: .utf8))
		let altered = try XCTUnwrap(source.replacingOccurrences(of: "\"rated\"", with: "\"future-status\"").data(using: .utf8))
		XCTAssertThrowsError(try JSONDecoder().decode(StressResponseDraft.self, from: altered))
	}
}

final class StressAnalyticsTests: XCTestCase {
	private var calendar: Calendar {
		var value = Calendar(identifier: .gregorian); value.timeZone = TimeZone(secondsFromGMT: 0)!; return value
	}
	private let now = ISO8601DateFormatter().date(from: "2024-07-15T12:00:00Z")!
	private func date(_ text: String) -> Date { ISO8601DateFormatter().date(from: text)! }
	private func observation(_ rating: Int?, at instant: Date, status: StressResponseStatus = .rated) -> StressRatingObservation {
		StressRatingObservation(date: instant, rating: rating, status: status)
	}
	private func period(_ values: [StressRatingObservation], days: Int = 7) throws -> StressPeriodAnalytics {
		let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: days, asOf: now, calendar: calendar))
		return StressPeriodAnalytics(observations: values, interval: interval, asOf: now, calendar: calendar)
	}
	func testEmptyPeriodRetainsMissingDaysWithoutInventingNeutralRatings() throws {
		let value = try period([])
		XCTAssertEqual(value.calendarDayCount, 7); XCTAssertEqual(value.recordedDayCount, 0)
		XCTAssertEqual(value.distribution, [0, 0, 0, 0, 0]); XCTAssertEqual(value.offeredCount, 0)
		XCTAssertNil(value.averageRating); XCTAssertNil(value.dailyAverageRating)
		XCTAssertTrue(value.days.allSatisfy { $0.averageRating == nil && $0.offeredCount == 0 })
	}
	func testEachAnchorGetsItsOwnDistributionBinIncludingARecordedZero() throws {
		let day = date("2024-07-09T12:00:00Z")
		let value = try period((0...4).map { observation($0, at: day) })
		XCTAssertEqual(value.distribution, [1, 1, 1, 1, 1]); XCTAssertEqual(value.ratedCount, 5)
		XCTAssertEqual(value.averageRating, 2); XCTAssertEqual(value.dailyAverageRating, 2)
	}
	func testDailyAverageDoesNotOverweightDaysWithMoreCheckIns() throws {
		let first = date("2024-07-09T12:00:00Z"), second = date("2024-07-10T12:00:00Z")
		let value = try period([observation(0, at: first)] + (0..<3).map { _ in observation(4, at: second) })
		XCTAssertEqual(value.averageRating, 3); XCTAssertEqual(value.dailyAverageRating, 2)
		XCTAssertEqual(value.recordedDayCount, 2); XCTAssertEqual(value.ratedDayCount, 2)
	}
	func testSkippedAndNotApplicableStayInCoverageButNotTheRatingDenominator() throws {
		let day = date("2024-07-09T12:00:00Z")
		let value = try period([observation(4, at: day), observation(nil, at: day, status: .skipped),
			observation(nil, at: day, status: .notApplicable)])
		XCTAssertEqual(value.offeredCount, 3); XCTAssertEqual(value.ratedCount, 1)
		XCTAssertEqual(value.skippedCount, 1); XCTAssertEqual(value.notApplicableCount, 1)
		XCTAssertEqual(value.averageRating, 4); XCTAssertEqual(value.distribution, [0, 0, 0, 0, 1])
	}
	func testOnlySkippedOrNotApplicableResponsesDoNotBecomeZeroStressDays() throws {
		let value = try period([observation(nil, at: date("2024-07-09T12:00:00Z"), status: .skipped),
			observation(nil, at: date("2024-07-10T12:00:00Z"), status: .notApplicable)])
		XCTAssertEqual(value.recordedDayCount, 2); XCTAssertEqual(value.ratedDayCount, 0)
		XCTAssertNil(value.averageRating); XCTAssertNil(value.dailyAverageRating)
		XCTAssertEqual(value.days.filter { $0.offeredCount > 0 }.count, 2)
	}
	func testCorruptResponseStatesAndRatingsAreExcludedAndDisclosed() throws {
		let day = date("2024-07-09T12:00:00Z")
		let value = try period([observation(nil, at: day), observation(-1, at: day), observation(5, at: day),
			observation(0, at: day, status: .skipped), observation(0, at: day, status: .notApplicable)])
		XCTAssertEqual(value.offeredCount, 5); XCTAssertEqual(value.invalidRatingCount, 5)
		XCTAssertEqual(value.excludedCount, 5); XCTAssertEqual(value.skippedCount, 0); XCTAssertEqual(value.notApplicableCount, 0)
		XCTAssertEqual(value.ratedCount, 0); XCTAssertNil(value.averageRating)
	}
	func testDifferentQuestionsAndScaleVersionsAreNotMixedIntoMomentaryStatistics() throws {
		let day = date("2024-07-09T12:00:00Z")
		let value = try period([observation(1, at: day),
			StressRatingObservation(date: day, rating: 4, measurementKind: "daily"),
			StressRatingObservation(date: day, rating: 4, scaleVersion: 2)])
		XCTAssertEqual(value.offeredCount, 3); XCTAssertEqual(value.ratedCount, 1)
		XCTAssertEqual(value.unsupportedMeasurementCount, 2); XCTAssertEqual(value.excludedCount, 2)
		XCTAssertEqual(value.averageRating, 1); XCTAssertEqual(value.distribution, [0, 1, 0, 0, 0])
	}
	func testHalfOpenPeriodBoundariesIncludeStartButExcludeTheNextMidnight() throws {
		let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: now, calendar: calendar))
		let complete = interval.end.addingTimeInterval(3600)
		let inputs = [observation(4, at: interval.start.addingTimeInterval(-0.125)), observation(0, at: interval.start),
			observation(4, at: interval.end.addingTimeInterval(-0.125)), observation(1, at: interval.end)]
		let value = StressPeriodAnalytics(observations: inputs, interval: interval, asOf: complete, calendar: calendar)
		XCTAssertEqual(value.offeredCount, 2); XCTAssertEqual(value.distribution, [1, 0, 0, 0, 1])
	}
	func testFutureCheckInsAndInvalidTimestampsDoNotPolluteCoverage() throws {
		let inputs = [observation(1, at: now), observation(4, at: now.addingTimeInterval(1))]
			+ [Double.nan, .infinity, -.infinity].map { observation(4, at: Date(timeIntervalSinceReferenceDate: $0)) }
		let value = try period(inputs)
		XCTAssertEqual(value.offeredCount, 1); XCTAssertEqual(value.averageRating, 1)
		XCTAssertEqual(value.invalidTimestampCount, 3); XCTAssertEqual(value.futureObservationCount, 1)
		XCTAssertEqual(value.recordedDayCount, 1)
	}
	func testNewlyAddedStressorHasNoInventedResponsesBeforeItWasOffered() throws {
		let value = try period([observation(3, at: date("2024-07-14T12:00:00Z")),
			observation(nil, at: now, status: .skipped)])
		XCTAssertEqual(value.calendarDayCount, 7); XCTAssertEqual(value.offeredCount, 2)
		XCTAssertEqual(value.recordedDayCount, 2); XCTAssertEqual(value.ratedDayCount, 1)
		XCTAssertEqual(value.days.filter { $0.offeredCount == 0 }.count, 5)
		XCTAssertEqual(value.dailyAverageRating, 3)
	}
	func testRecentSevenAndThirtyDayWindowsUseCalendarDatesIncludingToday() throws {
		for (days, start) in [(7, "2024-07-09T00:00:00Z"), (30, "2024-06-16T00:00:00Z")] {
			let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: days, asOf: now, calendar: calendar))
			XCTAssertEqual(interval.start, date(start)); XCTAssertEqual(interval.end, date("2024-07-16T00:00:00Z"))
			XCTAssertEqual(try period([], days: days).days.count, days)
		}
	}
	func testRecentWindowsAndDailyRowsRespectSpringAndAutumnDaylightSavingChanges() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
		for (reference, hours) in [("2024-03-11T20:00:00Z", 167.0), ("2024-11-04T20:00:00Z", 169.0)] {
			let asOf = date(reference)
			let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: asOf, calendar: local))
			let value = StressPeriodAnalytics(observations: [], interval: interval, asOf: asOf, calendar: local)
			XCTAssertEqual(interval.duration / 3600, hours); XCTAssertEqual(value.days.count, 7)
			XCTAssertEqual(Set(value.days.map { local.component(.weekday, from: $0.date) }).count, 7)
		}
	}
	func testMidnightDaylightSavingGapDoesNotAddAnHourToTheFollowingDay() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Sao_Paulo"))
		let asOf = date("2018-11-05T12:00:00Z")
		let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 2, asOf: asOf, calendar: local))
		let value = StressPeriodAnalytics(observations: [observation(2, at: date("2018-11-05T02:30:00Z"))],
			interval: interval, asOf: asOf, calendar: local)
		XCTAssertEqual(value.days.count, 2)
		XCTAssertEqual(local.component(.hour, from: value.days[0].date), 1)
		XCTAssertEqual(local.component(.hour, from: value.days[1].date), 0)
		XCTAssertEqual(value.days[1].ratedCount, 1)
	}
	func testDailyGroupingUsesTheRequestedTimeZone() throws {
		let inputs = [observation(0, at: date("2024-07-01T00:30:00Z")), observation(4, at: date("2024-07-01T07:30:00Z"))]
		let asOf = date("2024-07-03T12:00:00Z")
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
		let utcInterval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: asOf, calendar: calendar))
		let localInterval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: asOf, calendar: local))
		XCTAssertEqual(StressPeriodAnalytics(observations: inputs, interval: utcInterval, asOf: asOf, calendar: calendar).recordedDayCount, 1)
		XCTAssertEqual(StressPeriodAnalytics(observations: inputs, interval: localInterval, asOf: asOf, calendar: local).recordedDayCount, 2)
	}
	func testNonGregorianCalendarAndFractionalTimeZoneRetainLocalMidnights() throws {
		var local = Calendar(identifier: .buddhist); local.timeZone = try XCTUnwrap(TimeZone(identifier: "Asia/Kathmandu"))
		let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: now, calendar: local))
		let value = StressPeriodAnalytics(observations: [], interval: interval, asOf: now, calendar: local)
		XCTAssertEqual(value.days.count, 7)
		XCTAssertTrue(value.days.allSatisfy { local.component(.hour, from: $0.date) == 0 && local.component(.minute, from: $0.date) == 0 })
		XCTAssertEqual(local.component(.year, from: interval.start), 2567)
	}
	func testBeforeAndAfterComparisonSplitsTheChosenDateWithoutDoubleCounting() throws {
		let change = date("2024-07-09T17:23:00Z")
		let value = try XCTUnwrap(StressPeriodComparison(observations: [
			observation(0, at: date("2024-07-08T23:59:59Z")), observation(4, at: date("2024-07-09T00:00:00Z")),
		], changeDate: change, asOf: now, calendar: calendar))
		XCTAssertEqual(value.before.interval.end, value.after.interval.start)
		XCTAssertEqual(value.changeDate, date("2024-07-09T00:00:00Z"))
		XCTAssertEqual(value.before.ratedCount, 1); XCTAssertEqual(value.after.ratedCount, 1)
		XCTAssertEqual(value.dailyAverageDifference, 4)
	}
	func testAfterComparisonDoesNotCountUnelapsedDaysAsMissingCoverage() throws {
		let asOf = date("2024-07-11T12:00:00Z")
		let value = try XCTUnwrap(StressPeriodComparison(observations: [], changeDate: date("2024-07-09T00:00:00Z"),
			asOf: asOf, calendar: calendar))
		XCTAssertEqual(value.before.calendarDayCount, 7); XCTAssertEqual(value.after.calendarDayCount, 3)
		XCTAssertNil(value.dailyAverageDifference)
	}
	func testDifferenceRequiresValidRatingsInBothPeriods() throws {
		let value = try XCTUnwrap(StressPeriodComparison(observations: [observation(4, at: date("2024-07-10T12:00:00Z"))],
			changeDate: date("2024-07-09T00:00:00Z"), asOf: now, calendar: calendar))
		XCTAssertNil(value.dailyAverageDifference)
		XCTAssertNil(value.before.dailyAverageRating); XCTAssertEqual(value.after.dailyAverageRating, 4)
	}
	func testComparisonWindowsUseCalendarDayLengthsAcrossDaylightSaving() throws {
		var local = calendar; local.timeZone = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
		let windows = try XCTUnwrap(StressReviewWindow.comparisonIntervals(changeDate: date("2024-11-04T17:00:00Z"),
			asOf: date("2024-11-15T17:00:00Z"), calendar: local))
		XCTAssertEqual(windows.before.duration / 3600, 169); XCTAssertEqual(windows.after.duration / 3600, 168)
		XCTAssertEqual(windows.before.end, windows.after.start)
	}
	func testInvalidWindowInputsReturnUnavailableWithoutCalendarArithmeticOnNaN() {
		for days in [0, -1, Int.min] {
			XCTAssertNil(StressReviewWindow.recentInterval(days: days, asOf: now, calendar: calendar))
			XCTAssertNil(StressReviewWindow.comparisonIntervals(changeDate: now, days: days, asOf: now, calendar: calendar))
		}
		for invalid in [Double.nan, .infinity, -.infinity] {
			let instant = Date(timeIntervalSinceReferenceDate: invalid)
			XCTAssertNil(StressReviewWindow.recentInterval(days: 7, asOf: instant, calendar: calendar))
			XCTAssertNil(StressReviewWindow.comparisonIntervals(changeDate: instant, asOf: now, calendar: calendar))
		}
		XCTAssertNil(StressReviewWindow.comparisonIntervals(changeDate: now.addingTimeInterval(86400), asOf: now, calendar: calendar))
	}
	func testInvalidAsOfDoesNotCreateDailyRowsOrCountInputs() throws {
		let interval = try XCTUnwrap(StressReviewWindow.recentInterval(days: 7, asOf: now, calendar: calendar))
		let value = StressPeriodAnalytics(observations: [observation(4, at: now)], interval: interval,
			asOf: Date(timeIntervalSinceReferenceDate: .nan), calendar: calendar)
		XCTAssertEqual(value.offeredCount, 0); XCTAssertTrue(value.days.isEmpty)
		XCTAssertNil(value.averageRating); XCTAssertNil(value.dailyAverageRating)
	}
	func testLargeUnequalFrequencyInputsHaveOrderIndependentDailyMeansAndCounts() throws {
		let start = date("2024-07-09T12:00:00Z")
		var observations: [StressRatingObservation] = []
		for day in 0..<5 {
			let at = try XCTUnwrap(calendar.date(byAdding: .day, value: day, to: start))
			observations += (0..<(100 * (day + 1))).map { _ in observation(day, at: at) }
		}
		let first = try period(observations), reversed = try period(Array(observations.reversed()))
		XCTAssertEqual(first.offeredCount, 1500); XCTAssertEqual(first.ratedDayCount, 5)
		XCTAssertEqual(first.distribution, [100, 200, 300, 400, 500])
		XCTAssertEqual(first.dailyAverageRating, 2)
		XCTAssertEqual(try XCTUnwrap(first.averageRating), 4000.0 / 1500, accuracy: 1e-12)
		XCTAssertEqual(first.distribution, reversed.distribution); XCTAssertEqual(first.dailyAverageRating, reversed.dailyAverageRating)
	}
}
