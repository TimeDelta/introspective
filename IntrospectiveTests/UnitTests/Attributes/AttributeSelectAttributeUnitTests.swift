//
//  AttributeSelectAttributeUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class AttributeSelectAttributeUnitTests: UnitTest {

	private typealias Me = AttributeSelectAttributeUnitTests
	private static let possibleValues: [Attribute] = [
		TextAttribute(name: "text"),
		DoubleAttribute(name: "double"),
		IntegerAttribute(name: "integer")
	]

	private final var attribute: AttributeSelectAttribute!

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
		let value = TextAttribute(name: "This attribute is not a possible value")

		// when
		let valid = attribute.isValid(value: value)

		// then
		XCTAssertFalse(valid)
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
		let expectedIndex = Me.possibleValues.count - 1
		let value = Me.possibleValues[expectedIndex]

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	func testGivenEmptyValuesArray_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = TextAttribute(name: "not found")

		// when
		let index = attribute.indexOf(possibleValue: value, in: [])

		// then
		XCTAssertNil(index)
	}

	func testGivenArrayOfWrongType_indexOf_returnsIndexOfValueInPossibleValues() {
		// given
		useRequiredAttribute()
		let expectedIndex = 2
		let searchValue = Me.possibleValues[expectedIndex]
		let searchArray = ["1", "2"]

		// when
		let index = attribute.indexOf(possibleValue: searchValue, in: searchArray)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	// MARK: - convertToDisplayableString()

	func testGivenNonAttributeValue_convertToDisplayableString_throwsTypeMismatchError() {
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

	func testGivenAttribute_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let value = Me.possibleValues[0]

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		XCTAssertEqual(displayableString, value.name)
	}

	// MARK: - valuesAreEqual()

	func testGivenFirstValueNotAttribute_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = Me.possibleValues[0]

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSecondValueNotAttribute_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = Me.possibleValues[0]
		let secondValue = "abc"

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothValuesAreNotAttributes_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = "abc"

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoEqualAttributes_valuesAreEqual_returnsTrue() throws {
		// given
		useRequiredAttribute()
		let firstValue = Me.possibleValues[0]
		let secondValue = firstValue

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoDifferentAttributes_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = Me.possibleValues[0]
		let secondValue = Me.possibleValues[1]

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
		let secondValue = Me.possibleValues[0]

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useRequiredAttribute()
		let firstValue = Me.possibleValues[0]
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
		let secondValue = Me.possibleValues[0]

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() throws {
		// given
		useOptionalAttribute()
		let firstValue = Me.possibleValues[0]
		let secondValue: Any? = nil

		// when
		let areEqual = try attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
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
		let other = AttributeSelectAttribute(
			name: attribute.name + "other stuff",
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			attributes: Me.possibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDescriptionMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = AttributeSelectAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: (attribute.extendedDescription ?? "") + "other stuff",
			variableName: attribute.variableName,
			optional: attribute.optional,
			attributes: Me.possibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenVariableNameMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = AttributeSelectAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: (attribute.variableName ?? "") + "other stuff",
			optional: attribute.optional,
			attributes: Me.possibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		let other = AttributeSelectAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			attributes: Me.possibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenPossibleValuesMismatch_equalTo_returnsFalse() {
		// given
		useRequiredAttribute()
		var otherPossibleValues = Me.possibleValues
		otherPossibleValues.append(TextAttribute(name: "not in main attribute"))
		let other = AttributeSelectAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: !attribute.optional,
			attributes: otherPossibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenAttributeWithSameProperties_equalTo_returnsTrue() {
		// given
		useRequiredAttribute()
		let other = AttributeSelectAttribute(
			name: attribute.name,
			pluralName: attribute.pluralName,
			description: attribute.extendedDescription,
			variableName: attribute.variableName,
			optional: attribute.optional,
			attributes: Me.possibleValues)

		// when
		let areEqual = attribute.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	private final func useOptionalAttribute() {
		attribute = AttributeSelectAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: true,
			attributes: Me.possibleValues)
	}

	private final func useRequiredAttribute() {
		attribute = AttributeSelectAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: false,
			attributes: Me.possibleValues)
	}
}
