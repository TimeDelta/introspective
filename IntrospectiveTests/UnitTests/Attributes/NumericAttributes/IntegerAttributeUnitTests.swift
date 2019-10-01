//
//  IntegerAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import Common

final class IntegerAttributeUnitTests: UnitTest {

	private final var attribute: IntegerAttribute!

	// MARK: - isValid(value: Any?)

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
		let value = 4
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssert(valid)
	}

	// MARK: - isValid(value: String)

	func testGivenAttributeIsOptionalAndValueIsEmpty_isValid_returnsTrue() {
		// given
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssert(valid)
	}

	func testGivenAttributeIsNotOptionalAndValueIsEmpty_isValid_returnsFalse() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssertFalse(valid)
	}

	func testGivenValueContainsLetter_isValid_returnsFalse() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: "12A3")

		// then
		XCTAssertFalse(valid)
	}

	func testGivenValueContainsDecimalPoint_isValid_returnsFalse() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: "1.23")

		// then
		XCTAssertFalse(valid)
	}

	func testGivenValueIsInteger_isValid_returnsTrue() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: "123")

		// then
		XCTAssert(valid)
	}

	// MARK: - errorMessageFor(invalidValue:)

	func testGivenNonEmptyString_errorMessageForInvalidValue_includesInvalidValue() {
		// given
		useOptionalAttribute()
		let invalidValue = "fr32"

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: invalidValue)

		// then
		assertThat(errorMessage, containsString(invalidValue))
	}

	func testGivenNonEmptyString_errorMessageForInvalidValue_includesTheWordInteger() {
		// given
		useOptionalAttribute()
		let invalidValue = "fr32"

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: invalidValue)

		// then
		assertThat(errorMessage, containsString("integer"))
	}

	func testGivenRequiredAttributeAndEmptyString_errorMessageForInvalidValue_includesAttributeName() {
		// given
		useRequiredAttribute()
		let invalidValue = ""

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: invalidValue)

		// then
		assertThat(errorMessage, containsString(attribute.name))
	}

	func testGivenRequiredAttributeAndEmptyString_errorMessageForInvalidValue_includesTheWordRequired() {
		// given
		useRequiredAttribute()
		let invalidValue = ""

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: invalidValue)

		// then
		assertThat(errorMessage, containsString("required"))
	}

	// MARK: - convertToValue()

	func testGivenInvalidString_convertToValue_throwsUnsupportedValueError() {
		// given
		useOptionalAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToValue(from: "_")) { error in
			// then
			XCTAssert(error is UnsupportedValueError)
		}
	}

	func testGivenAttributeIsOptionalAndStringIsEmpty_convertToValue_returnsNil() throws {
		// given
		useOptionalAttribute()

		// when
		let convertedValue = try attribute.convertToValue(from: "")

		XCTAssertNil(convertedValue)
	}

	func testGivenValidIntegerString_convertToValue_returnsCorrespondingInt() throws {
		// given
		useRequiredAttribute()
		let expectedValue = 1234
		let intString = String(expectedValue)

		// when
		let convertedValue = try attribute.convertToValue(from: intString) as? Int

		// then
		XCTAssertEqual(convertedValue, expectedValue)
	}

	// MARK: - convertToDisplayableString()

	func testGivenAttributeIsOptionalAndValueIsNil_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let convertedValue = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssert(convertedValue.isEmpty)
	}

	func testGivenAttributeIsNotOptionalAndValueIsNil_convertToDisplayableString_throwsUnsupportedValueError() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: nil)) { error in
			// then
			XCTAssert(error is UnsupportedValueError)
		}
	}

	func testGivenNonIntValue_convertToDisplayableString_throwsTypeMismatchError() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: "" as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenIntValue_convertToDisplayableString_returnsCorrespondingString() throws {
		// given
		useRequiredAttribute()
		let value = 1345
		let expectedValue = String(value)

		// when
		let convertedValue = try attribute.convertToDisplayableString(from: value)

		// then
		XCTAssertEqual(convertedValue, expectedValue)
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
		let other = IntegerAttribute(
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
		let other = IntegerAttribute(
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
		let other = IntegerAttribute(
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
		let other = IntegerAttribute(
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
		let other = IntegerAttribute(
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
		attribute = IntegerAttribute(
			name: "integer",
			pluralName: "pluralName",
			description: "description",
			variableName: "variableName",
			optional: true)
	}

	private final func useRequiredAttribute() {
		attribute = IntegerAttribute(
			name: "integer",
			pluralName: "pluralName",
			description: "description",
			variableName: "variableName",
			optional: false)
	}
}
