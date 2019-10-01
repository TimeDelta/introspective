//
//  DosageUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import Introspective
@testable import Common

final class DosageUnitTests: UnitTest {

	func testGivenEmptyString_initFromString_returnsNil() {
		// given
		let dosageText = ""

		// when
		let dosage = Dosage(dosageText)

		// then
		XCTAssertNil(dosage)
	}

	func testGivenStringThatDoesNotStartWithNumber_initFromString_returnsNil() {
		// given
		let dosageText = "this is not a valid dosage"

		// when
		let dosage = Dosage(dosageText)

		// then
		XCTAssertNil(dosage)
	}

	func testGivenPointOneMilligrams_initFromString_correctlyParsesDosage() {
		// given
		let dosageText = ".1milligrams"

		// when
		let dosage = Dosage(dosageText)

		// then
		XCTAssertEqual(dosage?.amount, 0.1)
		XCTAssertEqual(dosage?.unit, "milligrams")
	}

	func testGivenValidString_initFromString_returnsDosageWithCorrectlyParsedAmountAndUnit() {
		// given
		let amount = 12.3
		let unit = "mg"
		let dosageText = String(amount) + unit

		// when
		let dosage = Dosage(dosageText)

		// then
		XCTAssertEqual(dosage?.amount, amount)
		XCTAssertEqual(dosage?.unit, unit)
	}

	func testGivenWhitespaceBetweenAmountAndUnit_initFromString_returnsDosageWithCorrectlyParsedAmountAndUnit() {
		// given
		let amount = 12.3
		let unit = "mg"
		let dosageText = String(amount) + " \t\n" + unit

		// when
		let dosage = Dosage(dosageText)

		// then
		XCTAssertEqual(dosage?.amount, amount)
		XCTAssertEqual(dosage?.unit, unit)
	}

	func testGivenMilliToDeciAmount_inUnits_returnsCorrectlyConvertedAmount() {
		// given
		let milliAmount = 23.4
		let dosage = Dosage(milliAmount, "millivolts")

		// when
		let deciAmount = dosage.inUnits("decivolts")

		// then
		XCTAssertEqual(milliAmount, deciAmount * 100)
	}

	func testGivenDeciToMilliAmount_inUnits_returnsCorrectlyConvertedAmount() {
		// given
		let deciAmount = 23.4
		let dosage = Dosage(deciAmount, "decivolts")

		// when
		let milliAmount = dosage.inUnits("millivolts")

		// then
		XCTAssertEqual(milliAmount, deciAmount * 100)
	}

	func testGivenBaseUnitToMicroAmount_inUnits_returnsCorrectlyConvertedAmount() {
		// given
		let baseAmount = 23.4
		let dosage = Dosage(baseAmount, "volts")

		// when
		let microAmount = dosage.inUnits("microvolts")

		// then
		XCTAssertEqual(microAmount, baseAmount * 1000000)
	}

	func testGivenMicroAmountToCentiAmount_inUnits_returnsCorrectlyConvertedAmount() {
		// given
		let microAmount = 23.4
		let dosage = Dosage(microAmount, "microvolts")

		// when
		let centiAmount = dosage.inUnits("centivolts")

		// then
		XCTAssertEqual(microAmount / 10000, centiAmount)
	}

	func testGivenCentiAmountToBaseAmount_inUnits_returnsCorrectlyConvertedAmount() {
		// given
		let centiAmount = 23.4
		let dosage = Dosage(centiAmount, "centivolts")

		// when
		let baseAmount = dosage.inUnits("volts")

		// then
		XCTAssertEqual(baseAmount, centiAmount / 100)
	}

	func testGivenTwoMilligramsComparedToTwoDecigrams_lessThan_returnsTrue() {
		// given
		let smaller = Dosage(2, "mg")
		let bigger = Dosage(2, "dg")

		// when
		let lessThan = smaller < bigger

		// then
		XCTAssert(lessThan)
	}

	func testGivenTwoGramsComparedToTwoMicroGrams_lessThan_returnsFalse() {
		// given
		let smaller = Dosage(2, "µg")
		let bigger = Dosage(2, "g")

		// when
		let lessThan = bigger < smaller

		// then
		XCTAssertFalse(lessThan)
	}

	func testGivenTwentyDecigramsComparedToTwoGrams_equalTo_returnsTrue() {
		// given
		let decigrams = Dosage(20, "decigrams")
		let grams = Dosage(2, "grams")

		// when
		let equalTo = decigrams == grams

		// then
		XCTAssert(equalTo)
	}

	func testGivenSameNumberAndTimeUnit_equalTo_returnsTrue() {
		// given
		let first = Dosage(2, "g")
		let second = Dosage(2, "g")

		// when
		let equalTo = first == second

		// then
		XCTAssert(equalTo)
	}

	func testGivenSameNumberAndTimeUnit_XCTAssertEqual_returnsTrue() {
		// given
		let first = Dosage(2, "g")
		let second = Dosage(2, "g")

		// when / then
		XCTAssertEqual(first, second)
	}
}
