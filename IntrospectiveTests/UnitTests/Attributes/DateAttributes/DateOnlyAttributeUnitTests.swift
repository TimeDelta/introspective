//
//  DateOnlyAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
import SwiftyMocky
@testable import Introspective

final class DateOnlyAttributeUnitTests: UnitTest {

	private final var attribute: DateOnlyAttribute!

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

	func testGivenCorrectValueType_isValid_returnsTrue() {
		// given
		let value = Date()
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssert(valid)
	}

	// MARK: - convertToDisplayableString()

	func testGivenNonBooleanValue_convertToDisplayableString_throwsTypeMismatchError() {
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

	func testGivenNilValueAndAttributeIsOptional_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssertEqual(displayableString, "")
	}

	func testGivenDate_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let date = Date()
		let expectedValue = "expected value"
		Given(mockCalendarUtil, .string(for: .value(date), inFormat: .any(String.self), willReturn: expectedValue))

		// when
		let displayableString = try attribute.convertToDisplayableString(from: date)

		// then
		XCTAssertEqual(displayableString, expectedValue)
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
		let other = DateOnlyAttribute(
			name: attribute.name + "other stuff",
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDescriptionMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: (attribute.extendedDescription ?? "") + "other stuff",
			variableName: attribute.variableName,
			optional: attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenVariableNameMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: (attribute.variableName ?? "") + "other stuff",
			optional: attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEarliestDateMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			earliestDate: (attribute.earliestDate ?? Date()) + 1.weeks,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenLatestDateMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: (attribute.latestDate ?? Date()) + 1.weeks)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenAttributeWithSameProperties_equalTo_returnsTrue() {
		// given
		useRequiredAttribute()
		let other = DateOnlyAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			earliestDate: attribute.earliestDate,
			latestDate: attribute.latestDate)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	private final func useOptionalAttribute() {
		attribute = DateOnlyAttribute(
			name: "name",
			description: "description",
			variableName: "variableName",
			optional: true,
			earliestDate: Date() - 1.days,
			latestDate: Date() + 1.days)
	}

	private final func useRequiredAttribute() {
		attribute = DateOnlyAttribute(
			name: "name",
			description: "description",
			variableName: "variableName",
			optional: false,
			earliestDate: Date() - 1.days,
			latestDate: Date() + 1.days)
	}
}
