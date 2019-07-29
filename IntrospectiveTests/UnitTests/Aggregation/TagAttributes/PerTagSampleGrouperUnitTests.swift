//
//  PerTagSampleGrouperUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class PerTagSampleGrouperUnitTests: UnitTest {

	private final let tagAttribute = TagAttribute(name: "fdjkl")

	private final var grouper: PerTagSampleGrouper!

	override func setUp() {
		super.setUp()
		grouper = PerTagSampleGrouper(attributes: [tagAttribute])
	}

	// MARK: - initializers

	func testGivenTagAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let attributes = [
			tagAttribute,
			TagAttribute(name: tagAttribute.name + "other stuff"),
		]

		// when
		grouper = PerTagSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenTagsAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let tagsAttribute = TagsAttribute(name: "fjdskl")
		let attributes = [
			tagsAttribute,
			TagsAttribute(name: tagsAttribute.name + "other stuff"),
		]

		// when
		grouper = PerTagSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenTagAndTagsAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let attributes = [
			tagAttribute,
			TagsAttribute(name: tagAttribute.name + "other stuff"),
		]

		// when
		grouper = PerTagSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenNonTagBasedAttributes_init_doesNotIncludeThemAsPossibleVZaluesForAttributeSelectAttribute() {
		// given
		let attributes: [Attribute] = [
			TextAttribute(name: "f"),
			DoubleAttribute(name: "a"),
		]

		// when
		grouper = PerTagSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			not(hasItems(equals(attributes[0]), equals(attributes[1]))))
	}

	// MARK: - description

	func testGivenGroupByAttributeIsNil_description_returnsAttributedName() {
		// given
		grouper.groupByAttribute = nil

		// when
		let description = grouper.description

		// then
		assertThat(description, equalTo(grouper.attributedName))
	}

	func testGivenGroupByAttributeNotNil_description_includesAttributeNameInReturnValue() {
		// given
		grouper.groupByAttribute = tagAttribute

		// when
		let description = grouper.description

		// then
		assertThat(description, containsString(tagAttribute.name))
	}

	// MARK: - group(samples:)

	func testGivenGroupByAttributeNotSet_group_throwsError() throws {
		// given
		grouper.groupByAttribute = nil
		let samples = [SampleCreatorTestUtil.createSample()]

		// when / then
		XCTAssertThrowsError(try grouper.group(samples: samples))
	}

	func testGivenEmptySamplesArray_group_returnsEmptyArray() throws {
		// given
		grouper.groupByAttribute = tagAttribute

		// when
		let groups = try grouper.group(samples: [])

		// then
		assertThat(groups, hasCount(0))
	}

	func testGivenInvalidGroupByAttribute_group_throwsError() throws {
		// given
		grouper.groupByAttribute = TextAttribute(name: "fs")
		let samples = [SampleCreatorTestUtil.createSample()]

		// when / then
		XCTAssertThrowsError(try grouper.group(samples: samples))
	}

	// MARK: - groupNameFor(value:)

	func testGivenGroupByAttributeNotSet_groupNameForValue_throwsError() throws {
		// given
		grouper.groupByAttribute = nil

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: ""))
	}

	func testGivenUnknownValueType_groupNameForValue_throwsError() throws {
		// given
		grouper.groupByAttribute = tagAttribute

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: 1))
	}

	func testGivenGroupByTagAttributeWithStringValue_groupNameForValue_returnsAttributeNameEqualsValue() throws {
		// given
		grouper.groupByAttribute = tagAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(tagAttribute.name) = \(value)"))
	}

	func testGivenGroupByTagsAttributeWithStringValue_groupNameForValue_returnsAttributeNameHasValue() throws {
		// given
		let tagsAttribute = TagsAttribute(name: "fdjkjwiofjeiow")
		grouper.groupByAttribute = tagsAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(tagsAttribute.name) has \(value)"))
	}

	func testGivenGroupByUnknownAttributeTypeWithStringValue_groupNameForValue_throwsError() throws {
		// given
		let invalidAttribute = TextAttribute(name: "fes")
		grouper.groupByAttribute = invalidAttribute

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: "fd"))
	}

	// MARK: - groupValuesAreEqual()

	func testGivenEqualStringValues_groupValuesAreEqual_returnsTrue() throws {
		// given
		let value = "value"

		// when
		let areEqual = try grouper.groupValuesAreEqual(value, value)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNotEqualStringValues_groupValuesAreEqual_returnsFalse() throws {
		// given
		let value1 = "value"
		let value2 = value1 + "other stuff"

		// when
		let areEqual = try grouper.groupValuesAreEqual(value1, value2)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenInvalidValueType_groupValuesAreEqual_throwsError() throws {
		// given
		let value1 = 1
		let value2 = 2

		// when / then
		XCTAssertThrowsError(try grouper.groupValuesAreEqual(value1, value2))
	}

	// MARK: - copy()

	func test_copy_returnsExactCopy() {
		// given
		grouper.groupByAttribute = tagAttribute

		// when
		let copy = grouper.copy()

		// then
		guard let castedCopy = copy as? PerTagSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}
		assertThat(castedCopy.groupByAttribute, equals(grouper.groupByAttribute!))
		assertThat(castedCopy.attributeSelectAttribute, equals(grouper.attributeSelectAttribute))
		assertThat(castedCopy.attributes, arrayHasExactly(grouper.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_copy_returnsCopyThatModifyingDoesNotAffectOriginal() {
		// given
		grouper.groupByAttribute = tagAttribute
		guard let copy = grouper.copy() as? PerTagSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupByAttribute = TagsAttribute(name: "fjeoqugnjk")

		// then
		assertThat(grouper.groupByAttribute, equals(tagAttribute))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try grouper.value(of: tagAttribute)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	func testGivenAttributeSelectAttribute_valueOf_returnsGroupByAttribute() throws {
		// when
		let value = try grouper.value(of: grouper.attributeSelectAttribute)

		// then
		guard let castedValue = value as? Attribute else {
			XCTFail("Wrong value type")
			return
		}
		assertThat(castedValue, equals(grouper.groupByAttribute!))
	}

	// MARK: - set(attribute:, to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try grouper.set(attribute: tagAttribute, to: "" as Any)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	func testGivenAttributeSelectAttributeWithValidValue_set_setsGroupByAttribute() throws {
		// given
		grouper.groupByAttribute = TagsAttribute(name: "ghjreiouq")
		let expectedValue = tagAttribute

		// when
		try grouper.set(attribute: grouper.attributeSelectAttribute, to: expectedValue)

		// then
		assertThat(grouper.groupByAttribute, equals(expectedValue))
	}

	func testGivenAttributeSelectAttributeWithInvalidValue_set_throwsTypeMismatchError() throws {
		// when
		XCTAssertThrowsError(try grouper.set(attribute: grouper.attributeSelectAttribute, to: 0 as Any)) { error in
			assertThat(error, isA(TypeMismatchError.self))
		}
	}

	func testGivenAttributeThatIsNotAPossibleValue_set_throwsError() throws {
		// given
		let value = TextAttribute(name: "fs")

		// when / then
		XCTAssertThrowsError(try grouper.set(attribute: grouper.attributeSelectAttribute, to: value))
	}

	// MARK: - equalTo()

	func testGivenDifferentSampleGrouperClass_equalTo_returnsFalse() {
		// given
		let other = AdvancedSampleGrouper()

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothGroupByAttributesNil_equalTo_returnsTrue() {
		// given
		let other = PerTagSampleGrouper(attributes: [tagAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOnlySelfGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = PerTagSampleGrouper(attributes: [tagAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = tagAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOnlyOtherGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = PerTagSampleGrouper(attributes: [tagAttribute])
		grouper.groupByAttribute = tagAttribute
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentGroupByAttributes_equalTo_returnsFalse() {
		// given
		let other = PerTagSampleGrouper(attributes: [tagAttribute])
		grouper.groupByAttribute = tagAttribute
		other.groupByAttribute = TagsAttribute(name: "grejnqio")

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGroupByAttribute_equalTo_returnsTrue() {
		// given
		let other = PerTagSampleGrouper(attributes: [tagAttribute])
		grouper.groupByAttribute = tagAttribute
		other.groupByAttribute = tagAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenSameGrouperTwice_equalTo_returnsTrue() {
		// when
		let areEqual = grouper.equalTo(grouper)

		// then
		XCTAssert(areEqual)
	}
}
