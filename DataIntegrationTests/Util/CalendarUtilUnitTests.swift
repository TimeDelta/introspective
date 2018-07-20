//
//  CalendarUtilUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class CalendarUtilUnitTests: UnitTest {

	fileprivate var util: CalendarUtil!

    override func setUp() {
        super.setUp()
        util = CalendarUtil()
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
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
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
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenWeekOfYear_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedWeekOfYear = calendar.component(.weekOfYear, from: date)
		let expectedWeekday = 1
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .weekOfYear, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.weekOfYear, from: zeroedDate) == expectedWeekOfYear)
		XCTAssert(calendar.component(.weekday, from: zeroedDate) == expectedWeekday)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenDay_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = 0
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .day, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenHour_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = 0
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .hour, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenMinute_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = 0
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .minute, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenSecond_startOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = calendar.component(.second, from: date)
		let expectedNanosecond = 0

		// when
		let zeroedDate = util.start(of: .second, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenNanosecond_startOf_changesNothing() {
		// given
		let date = Date()

		// when
		let zeroedDate = util.start(of: .nanosecond, in: date)

		// then
		XCTAssert(zeroedDate == date)
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
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
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
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
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
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.weekOfYear, from: zeroedDate) == expectedWeekOfYear)
		XCTAssert(calendar.component(.weekday, from: zeroedDate) == expectedWeekday)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenDay_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = 23
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .day, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenHour_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = 59
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .hour, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenMinute_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = 59
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .minute, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenSecond_endOf_setsAllLesserComponentsToMinimumValueButDoesNotTouchGreaterComponents() {
		// given
		let calendar = Calendar.autoupdatingCurrent
		let date = Date()
		let expectedYear = calendar.component(.year, from: date)
		let expectedMonth = calendar.component(.month, from: date)
		let expectedDay = calendar.component(.day, from: date)
		let expectedHour = calendar.component(.hour, from: date)
		let expectedMinute = calendar.component(.minute, from: date)
		let expectedSecond = calendar.component(.second, from: date)
		let expectedNanosecond = 998999953

		// when
		let zeroedDate = util.end(of: .second, in: date)

		// then
		XCTAssert(calendar.component(.year, from: zeroedDate) == expectedYear)
		XCTAssert(calendar.component(.month, from: zeroedDate) == expectedMonth)
		XCTAssert(calendar.component(.day, from: zeroedDate) == expectedDay)
		XCTAssert(calendar.component(.hour, from: zeroedDate) == expectedHour)
		XCTAssert(calendar.component(.minute, from: zeroedDate) == expectedMinute)
		XCTAssert(calendar.component(.second, from: zeroedDate) == expectedSecond)
		XCTAssert(calendar.component(.nanosecond, from: zeroedDate) == expectedNanosecond)
	}

	func testGivenNanosecond_endOf_changesNothing() {
		// given
		let date = Date()

		// when
		let zeroedDate = util.end(of: .nanosecond, in: date)

		// then
		XCTAssert(zeroedDate == date)
	}
}
