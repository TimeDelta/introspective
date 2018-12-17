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

	func testGivenSeconds_inUnit_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(start: date, end: date + 10.seconds)

		// when
		let valueInHours = duration.inUnit(.second)

		// then
		XCTAssertEqual(valueInHours, 10.0)
	}

	func testGivenMinutes_inUnit_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(start: date, end: date + 326.minutes + 30.seconds)

		// when
		let valueInHours = duration.inUnit(.minute)

		// then
		XCTAssertEqual(valueInHours, 326.5)
	}

	func testGivenHours_inUnit_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(start: date, end: date + 2.days + 15.minutes)

		// when
		let valueInHours = duration.inUnit(.hour)

		// then
		XCTAssertEqual(valueInHours, 48.25)
	}

	func testGivenDays_inUnit_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(start: date, end: date + 2.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.day)

		// then
		XCTAssertEqual(valueInHours, 2.5)
	}

	func testGivenWeeks_inUnit_returnsCorrectValue() {
		// given
		let date = Date()
		let duration = Duration(start: date, end: date + 3.weeks + 3.days + 12.hours)

		// when
		let valueInHours = duration.inUnit(.weekOfYear)

		// then
		XCTAssertEqual(valueInHours, 3.5)
	}
}
