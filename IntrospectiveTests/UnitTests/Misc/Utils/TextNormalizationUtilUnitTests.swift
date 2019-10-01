//
//  TextNormalizationUtilUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
@testable import Common

class TextNormalizationUtilUnitTests: UnitTest {

	fileprivate var util: TextNormalizationUtilImpl!

	override func setUp() {
		super.setUp()
		util = TextNormalizationUtilImpl()
	}

	func testGivenTheOneHundredTwentiethGame_normalizeNumbers_replacesOneHundredTwentiethWith120th() {
		// given
		let text = "the one hundred twentieth game"
		let expectedResult = "the 120th game"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenOnTheTwlefth_normalizeNumbers_replacesTwelfthWith12th() {
		// given
		let text = "on the twelfth"
		let expectedResult = "on the 12th"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenThereAreNoNumbersInThisTextToNormalize_normalizeNumbers_replacesNothing() {
		// given
		let text = "there are no numbers in this text to normalize"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == text)
	}

	func testGivenOnTheThirteenthOfLastMonth_normalizeNumber_replacesThirteenthWith13th() {
		// given
		let text = "on the thirteenth of last month"
		let expectedResult = "on the 13th of last month"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenThereWereNinetyNineOfThem_normalizeNumbers_replacesNinetyNineWith99() {
		// given
		let text = "there were ninety nine of them"
		let expectedResult = "there were 99 of them"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenGreaterThanEightySeven_normalizeNumbers_replacesEightySevenWith87() {
		// given
		let text = "greater than eighty seven"
		let expectedResult = "greater than 87"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenItWasTheNinthInnningWithTwoOutsAndOneStrike_normalizeNumbers_replacesNinthWith9thTwoWith2OneWith1() {
		// given
		let text = "it was the ninth innning with two outs and one strike"
		let expectedResult = "it was the 9th innning with 2 outs and 1 strike"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenOnTheNinetyHyphenNinthDayAtTwoThirty_normalizeNumbers_replacesNinetyHyphenNinthWith99thTwoThirtyWith230() {
		// given
		let text = "on the ninety-ninth day at two thirty"
		let expectedResult = "on the 99th day at 230"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}

	func testGivenAtFirstThereWereOnly2OfThemButSoonThereWereFourteen_normalizeNumbers_replacesFirstWith1stFourteenWith14() {
		// given
		let text = "at first there were only 2 of them but soon there were fourteen"
		let expectedResult = "at 1st there were only 2 of them but soon there were 14"

		// when
		let result = util.normalizeNumbers(text)

		// then
		XCTAssert(result == expectedResult)
	}
}
