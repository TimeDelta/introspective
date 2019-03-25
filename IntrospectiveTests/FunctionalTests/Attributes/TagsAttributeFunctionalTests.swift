//
//  TagsAttributeFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/25/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class TagsAttributeFunctionalTests: FunctionalTest {

	private final var attribute: TagsAttribute!

	// MARK: - valueAsArray()

	func testGivenTagsSet_valueAsArray_returnsCorrespondingTagArray() throws {
		// given
		useRequiredAttribute()
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let tag3 = TagDataTestUtil.createTag(name: "tag3")
		let value = Set<Tag>([tag1, tag2, tag3])

		// when
		let valueAsArray = try attribute.valueAsArray(value) as! [Tag]

		// then
		assertThat(valueAsArray, containsInAnyOrder(tag1, tag2, tag3))
	}

	func testGivenTagArray_valueAsArray_returnsCorrespondingTagArray() throws {
		// given
		useRequiredAttribute()
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let tag3 = TagDataTestUtil.createTag(name: "tag3")
		let value = [tag1, tag2, tag3]

		// when
		let valueAsArray = try attribute.valueAsArray(value) as! [Tag]

		// then
		assertThat(valueAsArray, containsInAnyOrder(tag1, tag2, tag3))
	}

	func testGivenValueIsNotTagSetOrArray_valueAsArray_throwsUnsupportedValueError() throws {
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

	func testGivenValueIsNotATagArray_valueFromArray_throwsTypeMismatchError() {
		// given
		useRequiredAttribute()
		let value = ["not a tag"]

		// when
		XCTAssertThrowsError(try attribute.valueFromArray(value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenValueIsTagArrayWithDuplicates_valueFromArray_returnsCorrespondingTagSet() throws {
		// given
		useRequiredAttribute()
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let value = [tag1, tag2, tag1]
		let expectedSet = Set<Tag>(value)

		// when
		let actualSet = try attribute.valueFromArray(value) as! Set<Tag>

		// then
		XCTAssertEqual(actualSet, expectedSet)
	}

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

	// MARK: - convertPossibleValueToDisplayableString()

	func testGivenNonTagValue_convertPossibleValueToDisplayableString_throwsTypeMismatchError() {
		// given
		let value = "abc"
		useOptionalAttribute()

		// when
		XCTAssertThrowsError(try attribute.convertPossibleValueToDisplayableString(value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenTag_convertPossibleValueToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let tagName = "tag name"
		let tag = TagDataTestUtil.createTag(name: tagName)

		// when
		let displayableString = try attribute.convertPossibleValueToDisplayableString(tag)

		// then
		XCTAssertEqual(displayableString, tagName)
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

	func testGivenTagSet_convertToDisplayableString_includesAllTagsInSet() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let value = Set<Tag>([tag1, tag2])
		useOptionalAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		assertThat(displayableString, containsStringsInOrder(tag1.name, tag2.name))
	}

	func testGivenTagArray_convertToDisplayableString_includesAllTagsInArray() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "tag1")
		let tag2 = TagDataTestUtil.createTag(name: "tag2")
		let value = [tag1, tag2]
		useRequiredAttribute()

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		assertThat(displayableString, containsStringsInOrder(tag1.name, tag2.name))
	}

	func testGivenTag_convertToDisplayableString_returnsCorrectValue() throws {
		// given
		useRequiredAttribute()
		let value = TagDataTestUtil.createTag(name: "tag name")

		// when
		let displayableString = try attribute.convertToDisplayableString(from: value)

		// then
		XCTAssertEqual(displayableString, value.name)
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
		let other = TagsAttribute(
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
		let other = TagsAttribute(
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
		let other = TagsAttribute(
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
		let other = TagsAttribute(
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
		let other = TagsAttribute(
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
		attribute = TagsAttribute(name: "name", description: "description", variableName: "variableName", optional: false)
	}

	private final func useOptionalAttribute() {
		attribute = TagsAttribute(name: "name", description: "description", variableName: "variableName", optional: true)
	}
}
