//
//  TagAttributeFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class TagAttributeFunctionalTests: FunctionalTest {

	private final var attribute: TagAttribute!

	// MARK: - indexOf()

	func testGivenWrongTypeOfPossibleValue_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = "not a tag"

		// when
		let index = attribute.indexOf(possibleValue: value)

		// then
		XCTAssertNil(index)
	}

	func testGivenSpecifiedValueNotInPossibleValues_indexOf_returnsNil() throws {
		// given
		useRequiredAttribute()
		TagDataTestUtil.createTag(name: "possible value")
		let transaction = DependencyInjector.db.transaction()
		let tag = try transaction.new(Tag.self)
		tag.name = "not a possible value"

		// when
		let index = attribute.indexOf(possibleValue: tag)

		// then
		XCTAssertNil(index)
	}

	func testGivenSpecifiedValueInPossibleValues_indexOf_returnsCorrectIndex() {
		// given
		useRequiredAttribute()
		TagDataTestUtil.createTag(name: "0")
		let targetTag = TagDataTestUtil.createTag(name: "1")
		TagDataTestUtil.createTag(name: "2")
		let expectedIndex = 1

		// when
		let index = attribute.indexOf(possibleValue: targetTag)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	func testGivenEmptyValuesArray_indexOf_returnsNil() {
		// given
		useRequiredAttribute()
		let value = TagDataTestUtil.createTag(name: "tag")

		// when
		let index = attribute.indexOf(possibleValue: value, in: [])

		// then
		XCTAssertNil(index)
	}

	func testGivenArrayOfWrongType_indexOf_returnsIndexOfValueInPossibleValues() {
		// given
		useRequiredAttribute()
		TagDataTestUtil.createTag(name: "0")
		TagDataTestUtil.createTag(name: "1")
		let searchValue = TagDataTestUtil.createTag(name: "2")
		let searchArray = ["1", "2"]
		let expectedIndex = 2

		// when
		let index = attribute.indexOf(possibleValue: searchValue, in: searchArray)

		// then
		XCTAssertEqual(index, expectedIndex)
	}

	// MARK: - convertToDisplayableString()

	func testGivenNonTagValue_convertToDisplayableString_throwsTypeMismatchError() {
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

	func testGivenTag_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let tagName = "tag name"
		let tag = TagDataTestUtil.createTag(name: tagName)

		// when
		let displayableString = try attribute.convertToDisplayableString(from: tag)

		// then
		XCTAssertEqual(displayableString, tagName)
	}

	// MARK: - valuesAreEqual()

	func testGivenFirstValueNotTag_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = TagDataTestUtil.createTag()

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSecondValueNotTag_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = TagDataTestUtil.createTag()
		let secondValue = "abc"

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothValuesAreNotTags_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = "abc"
		let secondValue = "abc"

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoTagsWithSameName_valuesAreEqual_returnsTrue() {
		// given
		useRequiredAttribute()
		let tagName = "tag name"
		let firstValue = TagDataTestUtil.createTag(name: tagName)
		let secondValue = TagDataTestUtil.createTag(name: tagName)

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoDifferentTags_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = TagDataTestUtil.createTag(name: "tag 1")
		let secondValue = TagDataTestUtil.createTag(name: "tag 2")

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
		let secondValue = TagDataTestUtil.createTag(name: "tag 1")

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenRequiredAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useRequiredAttribute()
		let firstValue = TagDataTestUtil.createTag(name: "tag 1")
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
		let secondValue = TagDataTestUtil.createTag(name: "tag 1")

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOptionalAttributeAndOnlySecondValueIsNil_valuesAreEqual_returnsFalse() {
		// given
		useOptionalAttribute()
		let firstValue = TagDataTestUtil.createTag(name: "tag 1")
		let secondValue: Any? = nil

		// when
		let areEqual = attribute.valuesAreEqual(firstValue, secondValue)

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
		let other = TagAttribute(
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
		let other = TagAttribute(
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
		let other = TagAttribute(
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
		let other = TagAttribute(
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
		let other = TagAttribute(
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
		attribute = TagAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: true)
	}

	private final func useRequiredAttribute() {
		attribute = TagAttribute(
			name: "name",
			description: "description",
			variableName: "variable name",
			optional: false)
	}
}