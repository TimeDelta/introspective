//
//  DaysOfWeekAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class DaysOfWeekAttributeUnitTests: UnitTest {

	private final var attribute: DaysOfWeekAttribute!

	// MARK: - valueAsArray()

	func testGivenDayOfWeekSet_valueAsArray_returnsCorrespondingDayOfWeekArray() throws {
		// given
		useRequiredAttribute()
		let value = Set<DayOfWeek>(DayOfWeek.allDays)

		// when
		let valueAsArray = try attribute.valueAsArray(value) as! [DayOfWeek]

		// then
		assertThat(valueAsArray, containsInAnyOrder(
			DayOfWeek.Sunday,
			DayOfWeek.Monday,
			DayOfWeek.Tuesday,
			DayOfWeek.Wednesday,
			DayOfWeek.Thursday,
			DayOfWeek.Friday,
			DayOfWeek.Saturday))
	}

	func testGivenDayOfWeekArray_valueAsArray_returnsCorrespondingDayOfWeekArray() throws {
		// given
		useRequiredAttribute()
		let value = DayOfWeek.allDays

		// when
		let valueAsArray = try attribute.valueAsArray(value) as! [DayOfWeek]

		// then
		assertThat(valueAsArray, containsInAnyOrder(
			DayOfWeek.Sunday,
			DayOfWeek.Monday,
			DayOfWeek.Tuesday,
			DayOfWeek.Wednesday,
			DayOfWeek.Thursday,
			DayOfWeek.Friday,
			DayOfWeek.Saturday))
	}

	func testGivenValueIsNotDayOfWeekSetOrArray_valueAsArray_throwsUnsupportedValueError() throws {
		// given
		useRequiredAttribute()
		let value = "32"

		// when
		XCTAssertThrowsError(try attribute.valueAsArray(value)) { error in
			// then
			assertThat(error, instanceOf(UnsupportedValueError.self))
		}
	}

	// MARK: - valueFromArray()

	func testGivenValueIsNotADayOfWeekArray_valueFromArray_throwsTypeMismatchError() {
		// given
		useRequiredAttribute()
		let value = ["not a day of week"]

		// when
		XCTAssertThrowsError(try attribute.valueFromArray(value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenValueIsDayOfWeekArrayWithDuplicates_valueFromArray_returnsCorrespondingDayOfWeekSet() throws {
		// given
		useRequiredAttribute()
		var value = DayOfWeek.allDays
		value.append(DayOfWeek.Friday)
		let expectedSet = Set<DayOfWeek>(value)

		// when
		let actualSet = try attribute.valueFromArray(value) as! Set<DayOfWeek>

		// then
		XCTAssertEqual(actualSet, expectedSet)
	}

	// MARK: - indexOf()

	func testGivenSpecifiedValueNotInPossibleValues_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = ""

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertNil(index)
	}

	func testGivenSpecifiedValueInPossibleValues_indexOf_returnsCorrectIndex() {
		// given
		useRequiredAttribute()
		let expectedIndex = 3
		let value = DayOfWeek.allDays[expectedIndex]

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	func testGivenEmptyValuesArray_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = DayOfWeek.Monday

		// when
		let index = attribute.indexOf(possibleValue: value, in: [])

		// then
		XCTAssertNil(index)
	}

	func testGivenArrayOfWrongType_indexOf_returnsIndexOfValueInPossibleValues() {
		// given
		useRequiredAttribute()
		let expectedIndex = 2
		let searchValue = DayOfWeek.allDays[expectedIndex]
		let searchArray = ["1", "2"]

		// when
		let index = attribute.indexOf(possibleValue: searchValue, in: searchArray)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	// MARK: - convertPossibleValueToDisplayableString()

	func testGivenNonDayOfWeekValue_convertPossibleValueToDisplayableString_throwsTypeMismatchError() {
		// given
		let value = "abc"
		useOptionalAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertPossibleValueToDisplayableString(value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenEachPossibleDayOfWeek_convertPossibleValueToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()

		for dayOfWeek in DayOfWeek.allDays {
			// when
			let displayableString = try attribute.convertPossibleValueToDisplayableString(dayOfWeek)

			// then
			XCTAssertEqual(displayableString, dayOfWeek.abbreviation)
		}
	}

	// MARK: - convertToDisplayableString()

	func testGivenOptionalAttributeAndValueIsNil_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssertEqual(displayableString, "")
	}

	func testGivenRequiredAttributeAndValueIsNil_convertToDisplayableString_returnsEmptyString() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: nil)) { error in
			// then
			assertThat(error, instanceOf(UnsupportedValueError.self))
		}
	}

	func testGivenDayOfWeekSet_convertToDisplayableString_includesAllDaysOfWeekInSet() throws {
		// given
		let value = Set(DayOfWeek.allDays)
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		assertThat(displayableString, containsStringsInOrder(
			DayOfWeek.Sunday.abbreviation,
			DayOfWeek.Monday.abbreviation,
			DayOfWeek.Tuesday.abbreviation,
			DayOfWeek.Wednesday.abbreviation,
			DayOfWeek.Thursday.abbreviation,
			DayOfWeek.Friday.abbreviation,
			DayOfWeek.Saturday.abbreviation))
	}

	func testGivenDayOfWeekArray_convertToDisplayableString_includesAllDaysOfWeekInArray() throws {
		// given
		let value = DayOfWeek.allDays
		useRequiredAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		assertThat(displayableString, containsStringsInOrder(
			DayOfWeek.Sunday.abbreviation,
			DayOfWeek.Monday.abbreviation,
			DayOfWeek.Tuesday.abbreviation,
			DayOfWeek.Wednesday.abbreviation,
			DayOfWeek.Thursday.abbreviation,
			DayOfWeek.Friday.abbreviation,
			DayOfWeek.Saturday.abbreviation))
	}

	func testGivenEachPossibleDayOfWeek_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()

		for dayOfWeek in DayOfWeek.allDays {
			// when
			let displayableString = try attribute.convertToDisplayableString(from: dayOfWeek)

			// then
			XCTAssertEqual(displayableString, dayOfWeek.abbreviation)
		}
	}

	func testGivenWrongValueType_convertToDisplayableString_throwsTypeMismatchError() {
		// given
		let value = "string"
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	// MARK: - equalTo()

	func testGivenWrongClass_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DoubleAttribute(name: "name")

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// given
		useRequiredAttribute()

		// when
		let areEqual = attribute.equalTo(attribute)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNameMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DaysOfWeekAttribute(
			name: attribute.name + "other stuff",
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDescriptionMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DaysOfWeekAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: (attribute.extendedDescription ?? "") + "other stuff",
			variableName: attribute.variableName,
			optional: attribute.optional)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenVariableNameMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DaysOfWeekAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: (attribute.variableName ?? "") + "other stuff",
			optional: attribute.optional)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DaysOfWeekAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenAttributeWithSameProperties_equalTo_returnsTrue() {
		// given
		useRequiredAttribute()
		let other = DaysOfWeekAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	private final func useRequiredAttribute() {
		attribute = DaysOfWeekAttribute(name: "name", description: "description", variableName: "variableName", optional: false)
	}

	private final func useOptionalAttribute() {
		attribute = DaysOfWeekAttribute(name: "name", description: "description", variableName: "variableName", optional: true)
	}
}
