//
//  CalendarUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class CalendarUtilUnitTests: UnitTest {

	fileprivate var util: CalendarUtilImpl!

	override func setUp() {
		super.setUp()
		util = CalendarUtilImpl()
	}

	func testGivenYear_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = 1
		let expectedDay = 1
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .year, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenMonth_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = 1
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .month, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenWeekOfYear_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()

		var expectedYear = calendar.component(.year, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let currentWeekday = calendar.component(.weekday, from: date)
		let currentDayOfMonth = calendar.component(.day, from: date)
		// if it's the first week of the year and the first week did not start on the first day of the week
		if expectedWeekOfYear == 1 && currentWeekday > currentDayOfMonth {
			// weekOfYear SHOULD still be 1. See https://github.com/malcommac/SwiftDate/issues/391 for more info.
			expectedYear -= 1
		}
		let expectedWeekday = 1
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .weekOfYear, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenDay_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .day, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenHour_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .hour, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenMinute_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .minute, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenSecond_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = calendar.component(.second, from: date)
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .second, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenNanosecond_startOf_changesNothing() {
		// given
		let date = Date()

		// when
		let zeroedDate = util.start(of: .nanosecond, in: date)

		// then
		XCTAssertEqual(zeroedDate, date)
	}

	func testGivenYear_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = 12
		let expectedDay = 31
		let expectedHour = 23
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .year, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenMonth_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date("2018-12-15")!
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = 31
		let expectedHour = 23
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .month, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenWeekOfYear_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = 7
		let expectedHour = 23
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .weekOfYear, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenDay_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = 23
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .day, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenHour_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .hour, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenMinute_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .minute, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenSecond_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = calendar.component(.weekday, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = calendar.component(.second, from: date)
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .second, in: date)

		// then
		XCTAssertEqual(calendar.component(.year, from: zeroedDate), expectedYear)
		XCTAssertEqual(calendar.component(.month, from: zeroedDate), expectedMonth)
		XCTAssertEqual(calendar.component(.weekOfYear, from: zeroedDate), expectedWeekOfYear)
		XCTAssertEqual(calendar.component(.weekday, from: zeroedDate), expectedWeekday)
		XCTAssertEqual(calendar.component(.day, from: zeroedDate), expectedDay)
		XCTAssertEqual(calendar.component(.hour, from: zeroedDate), expectedHour)
		XCTAssertEqual(calendar.component(.minute, from: zeroedDate), expectedMinute)
		XCTAssertEqual(calendar.component(.second, from: zeroedDate), expectedSecond)
		XCTAssertEqual(calendar.component(.nanosecond, from: zeroedDate), expectedNanosecond)
	}

	func testGivenNanosecond_endOf_changesNothing() {
		// given
		let date = Date()

		// when
		let zeroedDate = util.end(of: .nanosecond, in: date)

		// then
		XCTAssertEqual(zeroedDate, date)
	}

	func test_stringForDateInFormat_returnsCorrectlyFormattedDateString() {
		// given
		let date = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4, second: 5, nanosecond: 6, region: defaultRegion())
		let format = "d 'of' MMMM',' YYYY 'at' H:mm:ss"

		// when
		let dateString = util.string(for: date, inFormat: format)

		// then
		XCTAssertEqual(dateString, "2 of January, 2018 at 3:04:05")
	}

	func testGivenYearComponentAndTwoDatesInSameYear_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .year
		let date1 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4)
		let date2 = Date(year: 2018, month: 4, day: 3, hour: 2, minute: 1)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenYearComponentAndTwoDatesInDifferentYears_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .year
		let date1 = Date(year: 2017, month: 1, day: 2, hour: 3, minute: 4)
		let date2 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenMonthComponentAndTwoDatesInSameMonth_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .month
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3, second: 7, nanosecond: 8, region: defaultRegion())
		let date2 = Date(year: 2018, month: 1, day: 3, hour: 2, minute: 1, second: 7, nanosecond: 8, region: defaultRegion())

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenMonthComponentAndTwoDatesInDifferentMonths_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .month
		let date1 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4, second: 7, nanosecond: 8, region: defaultRegion())
		let date2 = Date(year: 2018, month: 2, day: 2, hour: 3, minute: 4, second: 7, nanosecond: 8, region: defaultRegion())

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenDayComponentAndTwoDatesInSameDay_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .day
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3)
		let date2 = Date(year: 2018, month: 1, day: 1, hour: 3, minute: 1)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenDayComponentAndTwoDatesInDifferentDays_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .day
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 3, minute: 4)
		let date2 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenHourComponentAndTwoDatesInSameHour_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .hour
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3)
		let date2 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 1)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenHourComponentAndTwoDatesInDifferentHours_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .hour
		let date1 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 5)
		let date2 = Date(year: 2018, month: 1, day: 2, hour: 4, minute: 5)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenMinuteComponentAndTwoDatesInSameMinute_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .minute
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3)
		let date2 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenMinuteComponentAndTwoDatesInDifferentMinutes_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .minute
		let date1 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4)
		let date2 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 5)

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenSecondComponentAndTwoDatesInSameSecond_dateOccursOnSameAs_returnsTrue() {
		// given
		let component: Calendar.Component = .second
		let date1 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3, second: 7, nanosecond: 8, region: defaultRegion())
		let date2 = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 3, second: 7, nanosecond: 9, region: defaultRegion())

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssert(result)
	}

	func testGivenSecondComponentAndTwoDatesInDifferentSeconds_dateOccursOnSameAs_returnsFalse() {
		// given
		let component: Calendar.Component = .second
		let date1 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 4, second: 7, nanosecond: 8, region: defaultRegion())
		let date2 = Date(year: 2018, month: 1, day: 2, hour: 3, minute: 5, second: 8, nanosecond: 8, region: defaultRegion())

		// when
		let result = util.date(date1, occursOnSame: component, as: date2)

		// then
		XCTAssertFalse(result)
	}

	func testGivenTwoNilDates_compare_returnsOrderedSame() {
		// given
		let firstDate: Date? = nil
		let secondDate: Date? = nil

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedSame)
	}

	func testGivenNilFirstDateAndRealSecondDate_compare_returnsOrderedDescending() {
		// given
		let firstDate: Date? = nil
		let secondDate: Date? = Date()

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedDescending)
	}

	func testGivenRealFirstDateAndNilSecondDate_compare_returnsOrderedAscending() {
		// given
		let firstDate: Date? = Date()
		let secondDate: Date? = nil

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedAscending)
	}

	func testGivenFirstDateEqualToSecondDate_compare_returnsOrderedSame() {
		// given
		let firstDate: Date? = Date()
		let secondDate: Date? = firstDate

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedSame)
	}

	func testGivenFirstDateLessThanSecondDate_compare_returnsOrderedAscending() {
		// given
		let firstDate: Date? = Date()
		let secondDate: Date? = firstDate! + 1.days

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedAscending)
	}

	func testGivenFirstDateGreaterThanSecondDate_compare_returnsOrderedDescending() {
		// given
		let firstDate: Date? = Date()
		let secondDate: Date? = firstDate! - 1.days

		// when
		let comparison = util.compare(firstDate, secondDate)

		// then
		XCTAssertEqual(comparison, .orderedDescending)
	}

	func testGivenEveryDayOfWeekExceptOneForDate_dateIsOnOneOf_returnsFalse() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday))
		let daysOfWeek = Set<DayOfWeek>([
			DayOfWeek.Sunday,
			DayOfWeek.Monday,
			DayOfWeek.Tuesday,
			DayOfWeek.Wednesday,
			DayOfWeek.Thursday,
			DayOfWeek.Friday,
		])

		// when
		let onOneOf = util.date(date.date, isOnOneOf: daysOfWeek)

		// then
		XCTAssertFalse(onOneOf)
	}

	func testGivenEveryDayOfWeek_dateIsOnOneOf_returnsTrue() {
		// given
		let date = Date()
		let daysOfWeek = Set<DayOfWeek>(DayOfWeek.allDays)

		// when
		let onOneOf = util.date(date, isOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenOnlyDayOfWeekOnWhichDateOccurs_dateIsOnOneOf_returnsTrue() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday))
		let daysOfWeek = Set<DayOfWeek>([DayOfWeek.Saturday])

		// when
		let onOneOf = util.date(date.date, isOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenDayOfWeekOnWhichDateOccurs_dateIsOnA_returnsTrue() {
		// given
		let dateDayOfWeek = DayOfWeek.Saturday
		let date = Date().next(dateDayOfWeek)

		// when
		let onA = util.date(date, isOnA: dateDayOfWeek)

		// then
		XCTAssert(onA)
	}

	func testGivenDayOfWeekOnWhichDateDoesNotOccur_dateIsOnA_returnsFalse() {
		// given
		let dateDayOfWeek = DayOfWeek.Saturday
		let date = Date().next(dateDayOfWeek)

		// when
		let onA = util.date(date, isOnA: DayOfWeek.Monday)

		// then
		XCTAssertFalse(onA)
	}

	func testGivenValidDateStringAndFormat_dateFromStringInFormat_returnsCorrectDate() {
		// given
		let year = 2018
		let month = 10
		let day = 12
		let hour = 13
		let minute = 32
		let second = 18
		let dateString = String(year) + " " + String(month) + " " + String(day) + " " + String(hour) + ":" + String(minute) + ":" + String(second)
		let dateFormatString = "YYYY MM dd HH:mm:ss"
		let expectedDate = Date(year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0, region: defaultRegion())

		// when
		let actualDate = util.date(from: dateString, format: dateFormatString)

		// then
		XCTAssertEqual(actualDate, expectedDate)
	}

	fileprivate func defaultRegion() -> Region {
		let calendar = Calendar.autoupdatingCurrent
		return Region(calendar: calendar, zone: calendar.timeZone)
	}
}
