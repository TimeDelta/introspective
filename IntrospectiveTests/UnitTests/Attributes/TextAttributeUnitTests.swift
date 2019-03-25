//
//  TextAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class TextAttributeUnitTests: UnitTest, TextAttributeDelegate {

	private final var attribute: TextAttribute!
	private final var isValidReturnValue = true
	private final var errorMessageValue = "error message"

	private final var isValidDelegateCalled = false
	private final var errorMessageDelegateCalled = false

	// MARK: - isValid()

	func testGivenOptionalAttributeWithNoDelegateAndNonNilValue_isValid_returnsTrue() {
		// given
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssert(valid)
	}

	func testGivenOptionalAttributeWithDelegateAndNonNilValue_isValid_callsDelegate() {
		// given
		useOptionalAttribute(withDelegate: self)
		isValidReturnValue = false

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssert(isValidDelegateCalled)
		XCTAssertEqual(valid, isValidReturnValue)
	}

	func testGivenOptionalAttributeWithNoDelegateAndNilValue_isValid_returnsTrue() {
		// given
		useOptionalAttribute()

		// when
		let valid = attribute.isValid(value: nil)

		// then
		XCTAssert(valid)
	}

	func testGivenOptionalAttributeWithDelegateAndNilValue_isValid_returnsTrue() {
		// given
		useOptionalAttribute(withDelegate: self)
		isValidReturnValue = false

		// when
		let valid = attribute.isValid(value: nil)

		// then
		XCTAssert(valid)
	}

	func testGivenRequiredAttributeWithNoDelegateAndNonNilValue_isValid_returnsTrue() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssert(valid)
	}

	func testGivenRequiredAttributeWithDelegateAndNonNilValue_isValid_callsDelegate() {
		// given
		useRequiredAttribute(withDelegate: self)
		isValidReturnValue = false

		// when
		let valid = attribute.isValid(value: "")

		// then
		XCTAssert(isValidDelegateCalled)
		XCTAssertEqual(valid, isValidReturnValue)
	}

	func testGivenRequiredAttributeWithNoDelegateAndNilValue_isValid_returnsFalse() {
		// given
		useRequiredAttribute()

		// when
		let valid = attribute.isValid(value: nil)

		// then
		XCTAssertFalse(valid)
	}

	func testGivenRequiredAttributeWithDelegateAndNilValue_isValid_returnsFalse() {
		// given
		useRequiredAttribute(withDelegate: self)
		isValidReturnValue = true

		// when
		let valid = attribute.isValid(value: nil)

		// then
		XCTAssertFalse(valid)
	}

	// MARK: - errorMessageFor()

	func testGivenRequiredAttributeWithNilValue_errorMessageFor_returnsValueIsRequired() {
		// given
		useRequiredAttribute()

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: nil)

		// then
		XCTAssertEqual(errorMessage, "Value is required")
	}

	func testGivenRequiredAttributeWithEmptyString_errorMessageFor_returnsValueIsRequired() {
		// given
		useRequiredAttribute()

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: "")

		// then
		XCTAssertEqual(errorMessage, "Value is required")
	}

	func testGivenRequiredAttributeWithDelegateAndNonEmptyString_errorMessageFor_returnsValueFromDelegate() {
		// given
		let expectedMessage = "expected error message"
		errorMessageValue = expectedMessage
		useRequiredAttribute(withDelegate: self)

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: "not empty")

		// then
		XCTAssert(errorMessageDelegateCalled)
		XCTAssertEqual(errorMessage, expectedMessage)
	}

	func testGivenOptionalAttributeWithNilValueAndDelegate_errorMessageFor_returnsValueFromDelegate() {
		// given
		let expectedMessage = "expected error message"
		errorMessageValue = expectedMessage
		useOptionalAttribute(withDelegate: self)

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: nil)

		// then
		XCTAssert(errorMessageDelegateCalled)
		XCTAssertEqual(errorMessage, expectedMessage)
	}

	func testGivenOptionalAttributeWithNilValueAndNoDelegate_errorMessageFor_returnsEmptyString() {
		// given
		useOptionalAttribute()

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: nil)

		// then
		XCTAssertEqual(errorMessage, "")
	}

	func testGivenOptionalAttributeWithDelegateAndNonEmptyString_errorMessageFor_returnsValueFromDelegate() {
		// given
		let expectedMessage = "expected error message"
		errorMessageValue = expectedMessage
		useOptionalAttribute(withDelegate: self)

		// when
		let errorMessage = attribute.errorMessageFor(invalidValue: "not empty")

		// then
		XCTAssert(errorMessageDelegateCalled)
		XCTAssertEqual(errorMessage, expectedMessage)
	}

	// MARK: - convertToDisplayableString()

	func testGivenOptionalAttributeWithNilValue_convertToDisplayableString_returnsEmptyString() throws {
		// given
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: nil)

		// then
		XCTAssertEqual(displayableString, "")
	}

	func testGivenRequiredAttributeWithNilValue_convertToDisplayableString_throwsUnsupportedValueError() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: nil)) { error in
			// then
			assertThat(error, instanceOf(UnsupportedValueError.self))
		}
	}

	func testGivenNonEmptyStringValue_convertToDisplayableString_returnsSameString() throws {
		// given
		let value = "not empty"
		useRequiredAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		XCTAssertEqual(displayableString, value)
	}

	func testGivenWrongValueType_convertToDisplayableString_throwsTypeMismatchError() {
		// given
		useRequiredAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertToDisplayableString(from: [""] as Any)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
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
		let other = TextAttribute(
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
		let other = TextAttribute(
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
		let other = TextAttribute(
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
		let other = TextAttribute(
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
		let other = TextAttribute(
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

	private final func useOptionalAttribute(withDelegate delegate: TextAttributeDelegate? = nil) {
		attribute = TextAttribute(
			name: "name",
			description: "description",
			variableName: "variableName",
			optional: true,
			delegate: delegate)
	}

	private final func useRequiredAttribute(withDelegate delegate: TextAttributeDelegate? = nil) {
		attribute = TextAttribute(
			name: "name",
			description: "description",
			variableName: "variableName",
			optional: false,
			delegate: delegate)
	}

	func isValid(value: String?) -> Bool {
		isValidDelegateCalled = true
		return isValidReturnValue
	}

	func errorMessageFor(invalidValue: String?) -> String {
		errorMessageDelegateCalled = true
		return errorMessageValue
	}
}
