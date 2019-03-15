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

	// MARK: - per

	func testGiven15PerMinuteToTimesPerSecond_per_returnsOneQuarter() throws {
		// given
		let fifteenPerMinute = Frequency(15, .minute)!

		// when
		let converted = try fifteenPerMinute.per(.second)

		// then
		XCTAssertEqual(converted, 0.25)
	}

	func testGiven120PerHourToTimesPerMinute_per_returns2() throws {
		// given
		let oneTwentyPerHour = Frequency(120, .hour)!

		// when
		let converted = try oneTwentyPerHour.per(.minute)

		// then
		XCTAssertEqual(converted, 2)
	}

	func testGivenTwentyFourPerDayToTimesPerHour_per_returnsOneTwelfth() throws {
		// given
		let twentyFourPerDay = Frequency(24, .day)!

		// when
		let converted = try twentyFourPerDay.per(.hour)

		// then
		XCTAssertEqual(converted, 1)
	}

	func testGivenSevenTimesPerWeekToTimesPerDay_per_returns1() throws {
		// given
		let sevenPerWeek = Frequency(7, .weekOfYear)!

		// when
		let converted = try sevenPerWeek.per(.day)

		// then
		XCTAssertEqual(converted, 1)
	}

	func testGivenTwicePerDayToTimesPerWeek_per_returns14() throws {
		// given
		let twicePerDay = Frequency(2, .day)!

		// when
		let converted = try twicePerDay.per(.weekOfYear)

		// then
		XCTAssertEqual(converted, 14)
	}

	func testGivenTwelveTimesPerYearToTimesPerMonth_per_returns1() throws {
		// given
		let twelvePerYear = Frequency(12, .year)!

		// when
		let converted = try twelvePerYear.per(.month)

		// then
		XCTAssertEqual(converted, 1)
	}

	func testGivenThreeTimesPerMonthToTimesPerYear_per_returns36() throws {
		// given
		let threePerMonth = Frequency(3, .month)!

		// when
		let converted = try threePerMonth.per(.year)

		// then
		XCTAssertEqual(converted, 36)
	}

	// MARK: - +

	func testGivenOncePerDayPlusSevenPerWeek_add_returnsTwoPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!
		let sevenPerWeek = Frequency(7, .weekOfYear)!

		// when
		let frequency = oncePerDay + sevenPerWeek

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	// MARK: - +=

	func testGivenOncePerDayPlusSevenPerWeek_addAssign_assingsTwoPerDay() {
		// given
		var frequency = Frequency(1, .day)!
		let sevenPerWeek = Frequency(7, .weekOfYear)!

		// when
		frequency += sevenPerWeek

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	// MARK: - -

	func testGivenOncePerDayMinusSevenPerWeek_subtract_returnsZeroPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!
		let sevenPerWeek = Frequency(7, .weekOfYear)!

		// when
		let frequency = oncePerDay - sevenPerWeek

		// then
		XCTAssertEqual(frequency, Frequency(0, .day)!)
	}

	// MARK: - -=

	func testGivenOncePerDayMinusSevenPerWeek_subtractAssign_assignsZeroPerDay() {
		// given
		var frequency = Frequency(1, .day)!
		let sevenPerWeek = Frequency(7, .weekOfYear)!

		// when
		frequency -= sevenPerWeek

		// then
		XCTAssertEqual(frequency, Frequency(0, .day)!)
	}

	// MARK: - /

	func testGivenOncePerDayDividedByOne_divide_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwo_divide_returnsHalfPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 2

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	// MARK: - /=

	func testGivenOncePerDayDividedByOne_divideAssign_assignsOnePerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwo_divideAssign_assignsHalfPerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 2

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	// MARK: - *

	func testGivenOncePerDayMultipliedByOne_multiply_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayMultipliedByTwo_multiply_returnsTwoPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 2

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	func testCommutativeProperty_multiply() {
		// given
		let twicePerWeek = Frequency(2, .weekOfYear)!

		// when
		let order1 = twicePerWeek * 2
		let order2 = 2 * twicePerWeek

		// then
		XCTAssertEqual(order1, order2)
	}

	// MARK: - *=

	func testGivenOncePerDayMultipliedByOne_multiplyAssign_assignsOnePerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency *= 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayMultipliedByTwo_multiplyAssign_assignsTwoPerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency *= 2

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	// MARK: - <

	func testGivenOncePerDayComparedToOncePerWeek_lessThan_returnsFalse() {
		// given
		let oncePerDay = Frequency(1, .day)!
		let oncePerWeek = Frequency(1, .weekOfYear)!

		// when
		let lessThan = oncePerDay < oncePerWeek

		// then
		XCTAssertFalse(lessThan)
	}

	func testGivenOncePerMonthComparedToTwicePerMonth_lessThan_returnsTrue() {
		// given
		let oncePerMonth = Frequency(1, .month)!
		let twicePerMonth = Frequency(2, .month)!

		// when
		let lessThan = oncePerMonth < twicePerMonth

		// then
		XCTAssert(lessThan)
	}

	// MARK: - ==

	func testGivenOncePerDayComparedToSevenTimesPerWeek_equalTo_returnsTrue() {
		// given
		let oncePerDay = Frequency(1, .day)!
		let sevenTimesPerWeek = Frequency(7, .weekOfYear)!

		// when
		let equalTo = oncePerDay == sevenTimesPerWeek

		// then
		XCTAssert(equalTo)
	}

	func testGivenFiveTimesPerSecondComparedToEightTimesPerHour_equalTo_returnsFalse() {
		// given
		let fiveTimesPerSecond = Frequency(5, .second)!
		let eightTimesPerHour = Frequency(8, .hour)!

		// when
		let equalTo = fiveTimesPerSecond == eightTimesPerHour

		// then
		XCTAssertFalse(equalTo)
	}

	func testGivenSixtyTimesPerHourComparedToOncePerMinute_equalTo_returnsTrue() {
		// given
		let sixtyTimesPerHour = Frequency(60, .hour)!
		let oncePerMinute = Frequency(1, .minute)!

		// when
		let equalTo = sixtyTimesPerHour == oncePerMinute

		// then
		XCTAssert(equalTo)
	}

	func testGivenSameNumberAndTimeUnit_equalTo_returnsTrue() {
		// given
		let number = 5.0
		let timeUnit = Calendar.Component.day
		let first = Frequency(number, timeUnit)!
		let second = Frequency(number, timeUnit)!

		// when
		let equalTo = first == second

		// then
		XCTAssert(equalTo)
	}

	// MARK: - isEqual()

	func testGivenSameNumberAndTimeUnit_XCTAssertEqual_returnsTrue() {
		// given
		let number = 5.0
		let timeUnit = Calendar.Component.day
		let first = Frequency(number, timeUnit)!
		let second = Frequency(number, timeUnit)!

		// when / then
		XCTAssertEqual(first, second)
	}
}
