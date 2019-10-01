//
//  CalendarComponentAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import Common

final class CalendarComponentAttributeUnitTests: UnitTest {

	private final var attribute: CalendarComponentAttribute!

	// MARK: - isValid(value:)

	func testGivenNilValueAndOptionalAttribute_isValid_returnsTrue() {
		// given
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: nil as Any?)

		// then
		XCTAssert(valid)
	}

	func testGivenNilValueAndRequiredAttribute_isValid_returnsFalse() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: nil as Any?)

		// then
		XCTAssertFalse(valid)
	}

	func testGivenWrongValueType_isValid_returnsFalse() {
		// given
		let value = GenericError("")
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssertFalse(valid)
	}

	func testGivenCorrectValueTypeAndValueIsPossibleValue_isValid_returnsTrue() {
		// given
		useOptionalAttribute()
		let value = attribute.possibleValues[0]

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssert(valid)
	}

	func testGivenCorrectValueTypeAndValueIsNotPossibleValue_isValid_returnsFalse() {
		// given
		useOptionalAttribute()
		let value = getImpossibleValue()

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssertFalse(valid)
	}

	// MARK: - indexOf()

	func testGivenSpecifiedValueNotInPossibleValues_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = getImpossibleValue()

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertNil(index)
	}

	func testGivenSpecifiedValueInPossibleValues_indexOf_returnsCorrectIndex() {
		// given
		useRequiredAttribute()
		let value = Calendar.Component.hour

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertEqual(index, 1)
	}

	// MARK: - convertToDisplayableString()

	func testGivenNonCalendarComponentValue_convertToDisplayableString_throwsTypeMismatchError() {
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
			assertThat(error, instanceOf(UnsupportedValueError.self))
		}
	}

	func testGivenNilValueAndOptionalAttribute_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssertEqual(displayableString, "")
	}

	func testGivenEachPossibleCalendarComponent_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let values: [Calendar.Component: String] = [
			.calendar: "calendar",
			.era: "era",
			.year: "year",
			.yearForWeekOfYear: "year for week of year",
			.quarter: "quarter",
			.month: "month",
			.weekOfMonth: "week of month",
			.weekOfYear: "week",
			.weekday: "day of week",
			.weekdayOrdinal: "weekday ordinal",
			.timeZone: "time zone",
			.day: "day",
			.hour: "hour",
			.minute: "minute",
			.second: "second",
			.nanosecond: "nanosecond"]

		for (component, name) in values {
			// when
			let displayableString = try attribute.convertToDisplayableString(from: component)

			// then
			XCTAssertEqual(displayableString.localizedLowercase, name.localizedLowercase)
		}
	}

	// MARK: - valuesAreEqual()

	func testGivenFirstValueNotCalendarComponent_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = Calendar.Component.day

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSecondValueNotCalendarComponent_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = Calendar.Component.day
		let secondValue = "abc"

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothValuesAreNotCalendarComponents_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = "abc"

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoEqualCalendarComponents_valuesAreEqual_returnsTrue() throws {
		// given
		useRequiredAttribute()
		let firstValue = Calendar.Component.day
		let secondValue = firstValue

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoDifferentCalendarComponents_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = Calendar.Component.day
		let secondValue = Calendar.Component.weekday

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndBothValuesNil_valuesAreEqual_returnsTrue() throws {
		// given
		useRequiredAttribute()
		let firstValue: Any? = nil
		let secondValue: Any? = nil

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRequiredAttributeAndOnlyFirstValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue: Any? = nil
		let secondValue: Calendar.Component = .day

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue: Calendar.Component = .day
		let secondValue: Any? = nil

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndBothValuesNil_valuesAreEqual_returnsTrue() throws {
		// given
		useOptionalAttribute()
		let firstValue: Any? = nil
		let secondValue: Any? = nil

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOptionalAttributeAndOnlyFirstValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useOptionalAttribute()
		let firstValue: Any? = nil
		let secondValue: Calendar.Component = .day

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useOptionalAttribute()
		let firstValue: Calendar.Component = .day
		let secondValue: Any? = nil

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

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
		let other = CalendarComponentAttribute(
			name: attribute.name + "other stuff",
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			possibleValues: attribute.possibleValues as! [Calendar.Component])

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDescriptionMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = CalendarComponentAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: (attribute.extendedDescription ?? "") + "other stuff",
			variableName: attribute.variableName,
			optional: attribute.optional,
			possibleValues: attribute.possibleValues as! [Calendar.Component])

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenVariableNameMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = CalendarComponentAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: (attribute.variableName ?? "") + "other stuff",
			optional: attribute.optional,
			possibleValues: attribute.possibleValues as! [Calendar.Component])

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = CalendarComponentAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			possibleValues: attribute.possibleValues as! [Calendar.Component])

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenPossibleValuesMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		var otherPossibleValues: [Calendar.Component] = [.calendar]
		otherPossibleValues.append(contentsOf: attribute.possibleValues as! [Calendar.Component])
		let other = CalendarComponentAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			possibleValues: otherPossibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenAttributeWithSameProperties_equalTo_returnsTrue() {
		// given
		useRequiredAttribute()
		let other = CalendarComponentAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			possibleValues: attribute.possibleValues as! [Calendar.Component])

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	private final func useOptionalAttribute() {
		attribute = CalendarComponentAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: true,
			possibleValues: [.weekOfYear, .hour, .era])
	}

	private final func useRequiredAttribute() {
		attribute = CalendarComponentAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: false,
			possibleValues: [.weekOfYear, .hour, .era])
	}

	private final func getImpossibleValue() -> Calendar.Component {
		let possibleValues = attribute.possibleValues as! [Calendar.Component]
		return Calendar.Component.allValues.filter{ value in !possibleValues.contains(where: { $0 == value }) }[0]
	}
}
