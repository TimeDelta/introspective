//
//  DurationUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/17/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class DurationUnitTests: UnitTest {

	// MARK: - +

	func testGiven10SecondsPlus50Seconds_plus_returnsOneMinute() {
		// given
		let tenSeconds = Duration(10.seconds)

		// when
		let sum = tenSeconds + 50.seconds

		// then
		XCTAssertEqual(sum, Duration(1.minutes))
	}

	// MARK: - +=

	func testGiven10SecondsPlus50Seconds_plusEquals_assignsOneMinute() {
		// given
		var duration = Duration(10.seconds)

		// when
		duration += 50.seconds

		// then
		XCTAssertEqual(duration, Duration(1.minutes))
	}

	// MARK: - -

	func testGiven5DaysMinus24Hours_minus_returns4Days() {
		// given
		let fiveDays = Duration(5.days)

		// when
		let result = fiveDays - 24.hours

		// then
		XCTAssertEqual(result, Duration(4.days))
	}

	// MARK: - -=

	func testGiven5DaysMinus24Hours_minusEquals_assigns4Days() {
		// given
		var duration = Duration(5.days)

		// when
		duration -= 24.hours

		// then
		XCTAssertEqual(duration, Duration(4.days))
	}

	// MARK: - *

	func testGiven6MinutesTimes4_multiply_returns24Minutes() {
		// given
		let sixMinutes = Duration(6.minutes)

		// when
		let result = sixMinutes * 4

		// then
		XCTAssertEqual(result, Duration(24.minutes))
	}

	// MARK: - *=

	func testGiven6MinutesTimes4_multiplyEquals_assigns24Minutes() {
		// given
		var duration = Duration(6.minutes)

		// when
		duration *= 4

		// then
		XCTAssertEqual(duration, Duration(24.minutes))
	}

	// MARK: - /

	func testGiven10DaysDividedBy2_divided_returns5Days() {
		// given
		let tenDays = Duration(10.days)

		// when
		let result = tenDays / 2

		// then
		XCTAssertEqual(result, Duration(5.days))
	}

	// MARK: - /=

	func testGiven10DaysDividedBy2_dividedEquals_assigns5Days() {
		// given
		var duration = Duration(10.days)

		// when
		duration /= 2

		// then
		XCTAssertEqual(duration, Duration(5.days))
	}

	// MARK: - inUnit()

	func testGivenSeconds_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(10.seconds)

		// when
		let valueInHours = duration.inUnit(.second)

		// then
		XCTAssertEqual(valueInHours, 10.0)
	}

	func testGivenMinutes_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(326.minutes + 30.seconds)

		// when
		let valueInHours = duration.inUnit(.minute)

		// then
		XCTAssertEqual(valueInHours, 326.5)
	}

	func testGivenHours_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(2.days + 15.minutes)

		// when
		let valueInHours = duration.inUnit(.hour)

		// then
		XCTAssertEqual(valueInHours, 48.25)
	}

	func testGivenDays_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(2.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.day)

		// then
		XCTAssertEqual(valueInHours, 2.5)
	}

	func testGivenWeeks_inUnit_returnsCorrectValue() {
		// given
		let duration = Duration(3.weeks + 3.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.weekOfYear)

		// then
		XCTAssertEqual(valueInHours, 3.5)
	}
}
