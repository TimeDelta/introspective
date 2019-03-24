//
//  DayOfWeekAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class DayOfWeekAttributeUnitTests: UnitTest {

	private final var attribute: DayOfWeekAttribute!

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

	// MARK: - convertToDisplayableString()

	func testGivenNonDayOfWeekValue_convertToDisplayableString_throwsTypeMismatchError() {
		// given
		let value = "abc"
		useOptionalAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenNilValueAndAttributeIsRequired_convertToDisplayableString_throwsTypeMismatchError() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: nil)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenNilValueAndAttributeIsOptional_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssertEqual(displayableString, "")
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

	// MARK: - valuesAreEqual()

	func testGivenFirstValueNotDayOfWeek_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = DayOfWeek.Friday

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSecondValueNotCalendarComponent_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = DayOfWeek.Monday
		let secondValue = "abc"

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothValuesAreNotCalendarComponents_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = "abc"

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoEqualDaysOfWeek_valuesAreEqual_returnsTrue() {
		// given
		useRequiredAttribute()
		let firstValue = DayOfWeek.Wednesday
		let secondValue = firstValue

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoDifferentDaysOfWeek_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = DayOfWeek.Thursday
		let secondValue = DayOfWeek.Sunday

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndBothValuesNil_valuesAreEqual_returnsTrue() {
		// given
		useRequiredAttribute()
		let firstValue: Any? = nil
		let secondValue: Any? = nil

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRequiredAttributeAndOnlyFirstValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue: Any? = nil
		let secondValue = DayOfWeek.Saturday

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = DayOfWeek.Tuesday
		let secondValue: Any? = nil

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndBothValuesNil_valuesAreEqual_returnsTrue() {
		// given
		useOptionalAttribute()
		let firstValue: Any? = nil
		let secondValue: Any? = nil

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOptionalAttributeAndOnlyFirstValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useOptionalAttribute()
		let firstValue: Any? = nil
		let secondValue = DayOfWeek.Monday

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useOptionalAttribute()
		let firstValue = DayOfWeek.Thursday
		let secondValue: Any? = nil

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo()

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
		let other = DayOfWeekAttribute(
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
		let other = DayOfWeekAttribute(
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
		let other = DayOfWeekAttribute(
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
		let other = DayOfWeekAttribute(
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
		let other = DayOfWeekAttribute(
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

	private final func useOptionalAttribute() {
		attribute = DayOfWeekAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: true)
	}

	private final func useRequiredAttribute() {
		attribute = DayOfWeekAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: false)
	}
}
