//
//  XYGraphDataGeneratorUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/2/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate
@testable import Introspective

final class XYGraphDataGeneratorUnitTests: UnitTest {

	public final var generator: XYGraphDataGenerator!

	override func setUp() {
		super.setUp()
		generator = XYGraphDataGenerator(log: Log())
	}

	// MARK: - areAllNumbers()

	func testGivenEmptyArray_areAllNumbers_returnsTrue() {
		// when
		let areAllNumbers = generator.areAllNumbers([])

		// then
		XCTAssert(areAllNumbers)
	}

	func testGivenAllNumbers_areAllNumbers_returnsTrue() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true))

		// when
		let areAllNumbers = generator.areAllNumbers(["1"])

		// then
		XCTAssert(areAllNumbers)
	}

	func testGivenOnlySomeNumbers_areAllNumbers_returnsFalse() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true, false, true))

		// when
		let areAllNumbers = generator.areAllNumbers(["1", "a", "3"])

		// then
		XCTAssertFalse(areAllNumbers)
	}

	// MARK: - areAllDates

	func testGivenEmptyArray_areAllDates_returnsTrue() {
		// when
		let areAllDates = generator.areAllDates([])

		// then
		XCTAssert(areAllDates)
	}

	func testsGivenAllDates_areAllDates_returnsTrue() {
		// given
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: Date()))

		// when
		let areAllDates = generator.areAllDates([""])

		// then
		XCTAssert(areAllDates)
	}

	func testsGivenOnlySomeDates_areAllDates_returnsFalse() {
		// given
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: Date(), nil, Date()))

		// when
		let areAllDates = generator.areAllDates(["date", "not a date", "date"])

		// then
		XCTAssertFalse(areAllDates)
	}

	// MARK: - areAllDaysOfWeek

	func testGivenEmptyArray_areAllDaysOfWeek_returnsTrue() {
		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek([])

		// then
		XCTAssert(areAllDaysOfWeek)
	}

	func testsGivenAllDates_areAllDaysOfWeek_returnsTrue() {
		// given
		let values = [DayOfWeek.Sunday.fullDayName]

		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek(values)

		// then
		XCTAssert(areAllDaysOfWeek)
	}

	func testsGivenOnlySomeDates_areAllDaysOfWeek_returnsFalse() {
		// given
		let values = [DayOfWeek.Sunday.fullDayName, "not a day of week", DayOfWeek.Saturday.fullDayName]

		// when
		let areAllDaysOfWeek = generator.areAllDaysOfWeek(values)

		// then
		XCTAssertFalse(areAllDaysOfWeek)
	}

	// MARK: - getSortedXValues()

	func testGivenEmptyArray_getSortedXVales_returnsEmptyArray() {
		// when
		let sortedValues = generator.getSortedXValues([])

		// then
		assertThat(sortedValues, hasCount(0))
	}

	func testGivenAllNumbers_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		Given(mockStringUtil, .isNumber(.any, willReturn: true))
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "2g", sampleValue: "2"),
			(groupValue: "1g", sampleValue: "1"),
			(groupValue: "3g", sampleValue: "3"),
		]

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(sortedValues, contains(hasSampleValue(1.0), hasSampleValue(2.0), hasSampleValue(3.0)))
	}

	func testGivenAllDates_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		let date1 = Date() - 2.days
		let date2 = Date() - 1.days
		let date3 = Date()
		let date1String = "date1"
		let date2String = "date2"
		let date3String = "date3"
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "3", sampleValue: date3String),
			(groupValue: "1", sampleValue: date1String),
			(groupValue: "2", sampleValue: date2String),
		]
		Given(mockCalendarUtil, .date(from: .value(date1String), format: .any, willReturn: date1))
		Given(mockCalendarUtil, .date(from: .value(date2String), format: .any, willReturn: date2))
		Given(mockCalendarUtil, .date(from: .value(date3String), format: .any, willReturn: date3))
		Given(mockStringUtil, .isNumber(.any, willReturn: false))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(date1String),
				hasSampleValue(date2String),
				hasSampleValue(date3String)))
	}

	func testGivenAllDaysOfWeek_getSortedXValues_returnsCorrectlySortedValues() {
		// given
		let day1 = DayOfWeek.Sunday
		let day2 = DayOfWeek.Monday
		let day3 = DayOfWeek.Tuesday
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "3", sampleValue: day3.fullDayName),
			(groupValue: "1", sampleValue: day1.fullDayName),
			(groupValue: "2", sampleValue: day2.fullDayName),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: false))
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: nil))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(day1.fullDayName),
				hasSampleValue(day2.fullDayName),
				hasSampleValue(day3.fullDayName)))
	}

	func testGivenNonSortableType_getSortedXValues_returnsSameAsInput() {
		// given
		let values: [(groupValue: Any, sampleValue: String)] = [
			(groupValue: "1", sampleValue: "a"),
			(groupValue: "2", sampleValue: "b"),
			(groupValue: "3", sampleValue: "c"),
		]
		Given(mockStringUtil, .isNumber(.any, willReturn: false))
		Given(mockCalendarUtil, .date(from: .any, format: .any, willReturn: nil))

		// when
		let sortedValues = generator.getSortedXValues(values)

		// then
		assertThat(
			sortedValues,
			contains(
				hasSampleValue(values[0].sampleValue),
				hasSampleValue(values[1].sampleValue),
				hasSampleValue(values[2].sampleValue)))
	}

	// MARK: - getSeriesDataForYInformation()

	func test_getSeriesDataForYInformation_() {
		// given

		// when

		// then
		XCTFail()
	}

	// MARK: - Helper Functions

	private final func hasSampleValue<Type: Equatable>(_ expectedValue: Type)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return hasSampleValue(expectedValue, areEqual: { $0 == $1 })
	}

	private final func hasSampleValue<Type>(_ expectedValue: Type, areEqual: @escaping (Type, Type) -> Bool)
	-> Hamcrest.Matcher<(groupValue: Any, sampleValue: Any)> {
		return Hamcrest.Matcher("Sample value of \(String(describing: expectedValue))") { (group) -> MatchResult in
			guard let sampleValue = group.sampleValue as? Type else {
				return .mismatch("Wrong type")
			}
			if areEqual(sampleValue, expectedValue) {
				return .match
			}
			return .mismatch("Was \(String(describing: sampleValue))")
		}
	}
}
