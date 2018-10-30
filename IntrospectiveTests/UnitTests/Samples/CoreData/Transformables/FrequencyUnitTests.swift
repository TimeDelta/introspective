//
//  FrequencyUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective

final class FrequencyUnitTests: UnitTest {

	func testGivenOncePerDayComparedToOncePerWeek_lessThan_returnsFalse() {
		// given
		let oncePerDay = Frequency(1, .day)
		let oncePerWeek = Frequency(1, .weekOfYear)

		// when
		let lessThan = oncePerDay < oncePerWeek

		// then
		XCTAssertFalse(lessThan)
	}

	func testGivenOncePerMonthComparedToTwicePerMonth_lessThan_returnsTrue() {
		// given
		let oncePerMonth = Frequency(1, .month)
		let twicePerMonth = Frequency(2, .month)

		// when
		let lessThan = oncePerMonth < twicePerMonth

		// then
		XCTAssert(lessThan)
	}

	func testGivenOncePerDayComparedToSevenTimesPerWeek_equalTo_returnsTrue() {
		// given
		let oncePerDay = Frequency(1, .day)
		let sevenTimesPerWeek = Frequency(7, .weekOfYear)

		// when
		let equalTo = oncePerDay == sevenTimesPerWeek

		// then
		XCTAssert(equalTo)
	}

	func testGivenFiveTimesPerSecondComparedToEightTimesPerHour_equalTo_returnsFalse() {
		// given
		let fiveTimesPerSecond = Frequency(5, .second)
		let eightTimesPerHour = Frequency(8, .hour)

		// when
		let equalTo = fiveTimesPerSecond == eightTimesPerHour

		// then
		XCTAssertFalse(equalTo)
	}

	func testGivenSixtyTimesPerHourComparedToOncePerMinute_equalTo_returnsTrue() {
		// given
		let sixtyTimesPerHour = Frequency(60, .hour)
		let oncePerMinute = Frequency(1, .minute)

		// when
		let equalTo = sixtyTimesPerHour == oncePerMinute

		// then
		XCTAssert(equalTo)
	}

	func testGivenSameNumberAndTimeUnit_equalTo_returnsTrue() {
		// given
		let number = 5.0
		let timeUnit = Calendar.Component.day
		let first = Frequency(number, timeUnit)
		let second = Frequency(number, timeUnit)

		// when
		let equalTo = first == second

		// then
		XCTAssert(equalTo)
	}

	func testGivenSameNumberAndTimeUnit_XCTAssertEqual_returnsTrue() {
		// given
		let number = 5.0
		let timeUnit = Calendar.Component.day
		let first = Frequency(number, timeUnit)
		let second = Frequency(number, timeUnit)

		// when / then
		XCTAssertEqual(first, second)
	}
}
