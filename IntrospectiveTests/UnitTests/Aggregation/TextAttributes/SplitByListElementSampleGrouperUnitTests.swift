//
//  SplitByListElementSampleGrouperUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest

@testable import Attributes
@testable import SampleGroupers

class SplitByListElementSampleGrouperUnitTests: UnitTest {

	// MARK: - Test Setup

	private typealias Me = SplitByListElementSampleGrouperUnitTests
	private static let textAttribute = TextAttribute(name: "text attribute")

	private var grouper: SplitByListElementSampleGrouper!

	override func setUp() {
		super.setUp()
		grouper = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
	}

	// MARK: - Initializers

	func testGivenTextAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let attributes = [
			Me.textAttribute,
			TextAttribute(name: Me.textAttribute.name + "other stuff"),
		]

		// when
		grouper = SplitByListElementSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenNonTextAttributes_init_doesNotIncludeThemAsPossibleValuesInAttributeSelectAttribute() {
		// given
		let attributes: [Attribute] = [
			BooleanAttribute(name: "fenwbhij"),
			DoubleAttribute(name: "huioyi"),
		]

		// when
		grouper = SplitByListElementSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			not(hasItem(equals(attributes[0]))))
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			not(hasItem(equals(attributes[1]))))
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
		grouper.groupByAttribute = Me.textAttribute

		// when
		let description = grouper.description

		// then
		assertThat(description, containsString(Me.textAttribute.name.localizedLowercase))
	}

	// MARK: - group(samples:)

	func testGivenNoSamples_group_returnsEmptyArray() throws {
		// when
		let groups = try grouper.group(samples: [])

		// then
		assertThat(groups, hasCount(0))
	}

	func testGivenTwoListElementsSeparatedByNewline_group_returnsCorrectGroups() throws {
		// given
		let listElement1 = "a"
		let listElement2 = "b"
		let sampleValue = "\(listElement1)\n\(listElement2)"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.textAttribute)

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, hasGroup(forValue: listElement1, withSamples: [sample]))
		assertThat(groups, hasGroup(forValue: listElement2, withSamples: [sample]))
	}

	func testGivenTwoListElementsSeparatedByComma_group_returnsCorrectGroups() throws {
		// given
		let listElement1 = "a"
		let listElement2 = "b"
		let sampleValue = "\(listElement1),\(listElement2)"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.textAttribute)

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, hasGroup(forValue: listElement1, withSamples: [sample]))
		assertThat(groups, hasGroup(forValue: listElement2, withSamples: [sample]))
	}

	func testGivenTwoListElementsSeparatedByAnd_group_returnsCorrectGroups() throws {
		// given
		let listElement1 = "a"
		let listElement2 = "b"
		let sampleValue = "\(listElement1) and \(listElement2)"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.textAttribute)

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, hasGroup(forValue: listElement1, withSamples: [sample]))
		assertThat(groups, hasGroup(forValue: listElement2, withSamples: [sample]))
	}

	func testGivenMultipleSamples_group_returnsCorrectGroups() throws {
		let listElement1 = "a"
		let listElement2 = "b"
		let sample1 = SampleCreatorTestUtil.createSample(withValue: listElement1, for: Me.textAttribute)
		let sample2 = SampleCreatorTestUtil.createSample(withValue: listElement2, for: Me.textAttribute)
		let sample3 = SampleCreatorTestUtil.createSample(withValue: listElement1, for: Me.textAttribute)

		// when
		let groups = try grouper.group(samples: [sample1, sample2, sample3])

		// then
		assertThat(groups, hasGroup(forValue: listElement1, withSamples: [sample1, sample3]))
		assertThat(groups, hasGroup(forValue: listElement2, withSamples: [sample2]))
	}

	func testGivenEmptyListElement_group_doesNotIncludeEmptyStringGroup() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: ",,", for: Me.textAttribute)

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, not(hasGroup(forValue: "")))
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
		grouper.groupByAttribute = Me.textAttribute

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: 1))
	}

	func testGivenValidSetup_groupNameForValue_returnsValueContainingGroupByAttributeName() throws {
		// given
		grouper.groupByAttribute = Me.textAttribute

		// when
		let groupName = try grouper.groupNameFor(value: "")

		// then
		assertThat(groupName, containsString(Me.textAttribute.name))
	}

	func testGivenValidSetup_groupNameForValue_returnsValueContainingGroupValue() throws {
		// given
		grouper.groupByAttribute = Me.textAttribute
		let expected = "hlgjkhfjdhzgsd"

		// when
		let groupName = try grouper.groupNameFor(value: expected)

		// then
		assertThat(groupName, containsString(expected))
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

	// MARK: - copy()

	func test_copy_returnsExactCopy() {
		// given
		grouper.groupByAttribute = Me.textAttribute

		// when
		let copy = grouper.copy()

		// then
		guard let castedCopy = copy as? SplitByListElementSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}
		assertThat(castedCopy.groupByAttribute, equals(grouper.groupByAttribute!))
		assertThat(castedCopy.attributeSelectAttribute, equals(grouper.attributeSelectAttribute))
		assertThat(castedCopy.attributes, arrayHasExactly(grouper.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_copy_returnsCopyThatModifyingDoesNotAffectOriginal() {
		// given
		grouper.groupByAttribute = Me.textAttribute
		guard let copy = grouper.copy() as? SplitByListElementSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupByAttribute = TextAttribute(name: "fjeoqugnjk")

		// then
		assertThat(grouper.groupByAttribute, equals(Me.textAttribute))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try grouper.value(of: Me.textAttribute)) { error in
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
		XCTAssertThrowsError(try grouper.set(attribute: Me.textAttribute, to: "" as Any)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	func testGivenAttributeSelectAttributeWithValidValue_set_setsGroupByAttribute() throws {
		// given
		grouper.groupByAttribute = TextAttribute(name: "ghjreiouq")
		let expectedValue = Me.textAttribute

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
		let value = DoubleAttribute(name: "fs")

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
		let other = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOnlySelfGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = Me.textAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOnlyOtherGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
		grouper.groupByAttribute = Me.textAttribute
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentGroupByAttributes_equalTo_returnsFalse() {
		// given
		let other = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
		grouper.groupByAttribute = Me.textAttribute
		other.groupByAttribute = TextAttribute(name: "grejnqio")

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGroupByAttribute_equalTo_returnsTrue() {
		// given
		let other = SplitByListElementSampleGrouper(attributes: [Me.textAttribute])
		grouper.groupByAttribute = Me.textAttribute
		other.groupByAttribute = Me.textAttribute

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
