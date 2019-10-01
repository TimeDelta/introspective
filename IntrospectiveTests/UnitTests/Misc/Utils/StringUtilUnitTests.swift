//
//  StringUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
@testable import Common

class StringUtilUnitTests: UnitTest {

	fileprivate var util: StringUtilImpl!

	override func setUp() {
		super.setUp()
		util = StringUtilImpl()
	}

	// MARK: - isNumber()

	func testGivenEmptyString_isNumber_returnsFalse() {
		// given
		let str = ""

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssertFalse(isNumber)
	}

	func testGivenOnlyLetters_isNumber_returnsFalse() {
		// given
		let str = "ahjkfd"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssertFalse(isNumber)
	}

	func testGivenNumberWithDecimalPoint_isNumber_returnsTrue() {
		// given
		let str = "41.23"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenNumberWithNothingBeforeDecimalPoint_isNumber_returnsTrue() {
		// given
		let str = ".23"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenOnlyDecimalPoint_isNumber_returnsFalse() {
		// given
		let str = "."

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssertFalse(isNumber)
	}

	func testGivenNumberWithNoDecimalPoint_isNumber_returnsTrue() {
		// given
		let str = "45321"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenNumberWithLeadingZero_isNumber_returnsTrue() {
		// given
		let str = "041.23"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenNumberLessThanOneWithZeroBeforeDecimalPoint_isNumber_returnsTrue() {
		// given
		let str = "0.32678"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenNumberWithTrailingZerosAfterDecimnalPortion_isNumber_returnsTrue() {
		// given
		let str = "41.23000"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenNumberWithOnlyTrailingZerosAfterDecimnalPoint_isNumber_returnsTrue() {
		// given
		let str = "34.00"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenZeroPointZero_isNumber_returnsTrue() {
		// given
		let str = "0.0"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	func testGivenPointZero_isNumber_returnsTrue() {
		// given
		let str = ".0"

		// when
		let isNumber = util.isNumber(str)

		// then
		XCTAssert(isNumber)
	}

	// MARK: - isInteger()

	func testGivenEmptyString_isInteger_returnsFalse() {
		// given
		let str = ""

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssertFalse(isInteger)
	}

	func testGivenOnlyLetters_isInteger_returnsFalse() {
		// given
		let str = "ahjkfd"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssertFalse(isInteger)
	}

	func testGivenNonIntegerNumber_isInteger_returnsFalse() {
		// given
		let str = "2.5"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssertFalse(isInteger)
	}

	func testGivenIntegerNumberWithNoTrailingOrLeadingZeros_isInteger_returnsTrue() {
		// given
		let str = "234"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssert(isInteger)
	}

	func testGivenIntegerNumberWithLeadingZeros_isInteger_returnsTrue() {
		// given
		let str = "000234"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssert(isInteger)
	}

	func testGivenIntegerNumberWithTrailingZeros_isInteger_returnsTrue() {
		// given
		let str = "23400"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssert(isInteger)
	}

	func testGivenTwoIntegersSeparatedBySpace_isInteger_returnsFalse() {
		// given
		let str = "234 542"

		// when
		let isInteger = util.isInteger(str)

		// then
		XCTAssertFalse(isInteger)
	}

	// MARK: - isDayOfWeek()

	func testGivenSunday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Sunday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenMonday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Monday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenTuesday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Tuesday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenWednesday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Wednesday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenThursday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Thursday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenFriday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Friday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenSaturday_isDayOfWeek_returnsTrue() {
		// given
		let value = "Saturday"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssert(isDayOfWeek)
	}

	func testGivenNonDay_isDayOfWeek_returnsTrue() {
		// given
		let value = "NonDay"

		// when
		let isDayOfWeek = util.isDayOfWeek(value)

		// then
		XCTAssertFalse(isDayOfWeek)
	}
}
