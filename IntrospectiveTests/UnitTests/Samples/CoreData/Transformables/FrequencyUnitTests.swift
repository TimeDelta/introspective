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

	// MARK: - init

	func testGivenUnsupportedTimeUnit_init_returnsNil() {
		// given
		let unsupportedTimeUnit = Calendar.Component.calendar

		// when
		let frequency = Frequency(12, unsupportedTimeUnit)

		// then
		XCTAssertNil(frequency)
	}

	func testGivenSupportedTimeUnit_init_doesNotReturnNil() {
		// given
		let supportedTimeUnit = Calendar.Component.hour

		// when
		let frequency = Frequency(12, supportedTimeUnit)

		// then
		XCTAssertNotNil(frequency)
	}

	// MARK: - per

	func testGivenOncePerSecondToTimesPerNanoSecond_per_returnsOneHundredMillionth() throws {
		// given
		let oncePerSecond = Frequency(1, .second)!

		// when
		let converted = try oncePerSecond.per(.nanosecond)

		// then
		XCTAssertEqual(converted, 1.0/100000000.0)
	}

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

	func testGivenFourTimesPerYearToTimesPerQuarter_per_returns1() throws {
		// given
		let fourTimesPerYear = Frequency(4, .year)!

		// when
		let converted = try fourTimesPerYear.per(.quarter)

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

	func testGivenUnsupportedTimeUnit_per_throwsCannotConvertToTimesPerSecondError() {
		// given
		let frequency = Frequency(1, .hour)!
		let unsupportedTimeUnit = Calendar.Component.calendar

		// when
		XCTAssertThrowsError(try frequency.per(unsupportedTimeUnit)) { error in
			// then
			XCTAssertEqual(error as? Frequency.Errors, Frequency.Errors.cannotConvertToTimesPerSecond)
		}
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

	func testGivenOncePerDayDividedByOneAsInt_divide_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwoAsInt_divide_returnsHalfPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 2

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	func testGivenOncePerDayDividedByOneAsDouble_divide_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 1.0

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwoAsDouble_divide_returnsHalfPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay / 2.0

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	// MARK: - /=

	func testGivenOncePerDayDividedByOneAsInt_divideAssign_assignsOnePerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwoAsInt_divideAssign_assignsHalfPerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 2.0

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	func testGivenOncePerDayDividedByOneAsDouble_divideAssign_assignsOnePerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 1.0

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayDividedByTwoAsDouble_divideAssign_assignsHalfPerDay() {
		// given
		var frequency = Frequency(1, .day)!

		// when
		frequency /= 2

		// then
		XCTAssertEqual(frequency, Frequency(0.5, .day)!)
	}

	// MARK: - *

	func testGivenOncePerDayMultipliedByOneAsInt_multiply_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 1

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayMultipliedByTwoAsInt_multiply_returnsTwoPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 2

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	func testCommutativeProperty_multiplyByInt() {
		// given
		let twicePerWeek = Frequency(2, .weekOfYear)!

		// when
		let order1 = twicePerWeek * 2
		let order2 = 2 * twicePerWeek

		// then
		XCTAssertEqual(order1, order2)
	}

	func testGivenOncePerDayMultipliedByOneAsDouble_multiply_returnsOnePerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 1.0

		// then
		XCTAssertEqual(frequency, Frequency(1, .day)!)
	}

	func testGivenOncePerDayMultipliedByTwoAsDouble_multiply_returnsTwoPerDay() {
		// given
		let oncePerDay = Frequency(1, .day)!

		// when
		let frequency = oncePerDay * 2.0

		// then
		XCTAssertEqual(frequency, Frequency(2, .day)!)
	}

	func testCommutativeProperty_multiplyByDouble() {
		// given
		let twicePerWeek = Frequency(2, .weekOfYear)!

		// when
		let order1 = twicePerWeek * 2.0
		let order2 = 2.0 * twicePerWeek

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

	func testGivenOtherIsNotAFrequency_isEqual_returnsFalse() {
		// given
		let frequency = Frequency(12, .hour)!

		// when
		let equal = frequency.isEqual("string" as Any)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenOtherIsNil_isEqual_returnsFalse() {
		// given
		let other: Any? = nil
		let frequency = Frequency(12, .hour)!

		// when
		let equal = frequency.isEqual(other)

		// then
		XCTAssertFalse(equal)
	}
}
