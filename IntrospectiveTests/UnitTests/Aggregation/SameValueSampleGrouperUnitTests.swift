//
//  SameValueSampleGrouperUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

final class SameValueSampleGrouperUnitTests: UnitTest {

	private typealias Me = SameValueSampleGrouperUnitTests
	private static let hashableAttribute = TextAttribute(name: "hashable attribute")
	private static let nonHashableAttribute = AttributeSelectAttribute(
		name: "non-hashable attribute",
		attributes: [hashableAttribute])

	private final var grouper: SameValueSampleGrouper!

	final override func setUp() {
		super.setUp()
		grouper = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
	}

	// MARK: - description

	func testGivenGroupByAttributeNotSet_description_doesNotThrowError() {
		// given
		grouper.groupByAttribute = nil

		// when
		let _ = grouper.description

		// then - no error thrown
	}

	func testGivenGroupByAttribtueSet_description_includesGroupByAttributeInReturn() throws {
		// given
		grouper.groupByAttribute = Me.hashableAttribute

		// when
		let description = grouper.description

		// then
		assertThat(description, containsString(Me.hashableAttribute.name))
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
		grouper.groupByAttribute = Me.hashableAttribute

		// when
		let groups = try grouper.group(samples: [])

		// then
		assertThat(groups, hasCount(0))
	}

	func testGivenNonHashableValues_group_correctlyGroupsSamples() throws {
		grouper.groupByAttribute = Me.nonHashableAttribute
		let group1Value = TextAttribute(name: "0")
		let group2Value = TextAttribute(name: "1")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				group1Value,
				group2Value,
				group1Value,
				group2Value,
			],
			for: Me.nonHashableAttribute)
		let group1Samples = try samples.filter{
			guard let value = try $0.value(of: Me.nonHashableAttribute) as? Attribute else {
				throw GenericError("Wrong value type")
			}
			return group1Value.equalTo(value)
		}
		let group2Samples = try samples.filter{
			guard let value = try $0.value(of: Me.nonHashableAttribute) as? Attribute else {
				throw GenericError("Wrong value type")
			}
			return group2Value.equalTo(value)
		}

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(
			groups,
			hasGroup(forValue: group1Value, withSamples: group1Samples, areEqual: { $0.equalTo($1) }))
		assertThat(
			groups,
			hasGroup(forValue: group2Value, withSamples: group2Samples, areEqual: { $0.equalTo($1) }))
	}

	func testGivenHashableValues_group_correctlyGroupsSamples() throws {
		// given
		grouper.groupByAttribute = Me.hashableAttribute
		let group1Value = "0"
		let group2Value = "1"
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				group1Value,
				group2Value,
				group1Value,
				group2Value,
			],
			for: Me.hashableAttribute)
		let group1Samples = try samples.filter{
			try $0.value(of: Me.hashableAttribute) as? String == group1Value
		}
		let group2Samples = try samples.filter{
			try $0.value(of: Me.hashableAttribute) as? String == group2Value
		}

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: group1Value, withSamples: group1Samples))
		assertThat(groups, hasGroup(forValue: group2Value, withSamples: group2Samples))
	}

	// MARK: - groupNameFor(value:)

	func testGivenGroupByAttributeNotSet_groupNameForValue_throwsError() throws {
		// given
		grouper.groupByAttribute = nil

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: ""))
	}

	func testGivenGroupByAttributeSet_groupNameForValue_returnsAttributeNameEqualsValue() throws {
		// given
		grouper.groupByAttribute = Me.hashableAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(Me.hashableAttribute.name) = \(value)"))
	}

	// MARK: - groupValuesAreEqual()

	func testGivenEqualValues_groupValuesAreEqual_returnsTrue() throws {
		// given
		let value = "value"
		grouper.groupByAttribute = Me.hashableAttribute

		// when
		let areEqual = try grouper.groupValuesAreEqual(value, value)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNotEqualValues_groupValuesAreEqual_returnsFalse() throws {
		// given
		let value1 = "value"
		let value2 = value1 + "other stuff"
		grouper.groupByAttribute = Me.hashableAttribute

		// when
		let areEqual = try grouper.groupValuesAreEqual(value1, value2)

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - copy()

	func test_copy_returnsExactCopy() {
		// given
		grouper.groupByAttribute = Me.nonHashableAttribute

		// when
		let copy = grouper.copy()

		// then
		guard let castedCopy = copy as? SameValueSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}
		assertThat(castedCopy.groupByAttribute, equals(grouper.groupByAttribute!))
		assertThat(castedCopy.attributeSelectAttribute, equals(grouper.attributeSelectAttribute))
		assertThat(castedCopy.attributes, arrayHasExactly(grouper.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_copy_returnsCopyThatModifyingDoesNotAffectOriginal() {
		// given
		grouper.groupByAttribute = Me.nonHashableAttribute
		guard let copy = grouper.copy() as? SameValueSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupByAttribute = Me.hashableAttribute

		// then
		assertThat(grouper.groupByAttribute, equals(Me.nonHashableAttribute))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try grouper.value(of: Me.hashableAttribute)) { error in
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
		XCTAssertThrowsError(try grouper.set(attribute: Me.hashableAttribute, to: "" as Any)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	func testGivenAttributeSelectAttributeWithValidValue_set_setsGroupByAttribute() throws {
		// given
		grouper.groupByAttribute = Me.hashableAttribute
		let expectedValue = Me.nonHashableAttribute

		// when
		try grouper.set(attribute: grouper.attributeSelectAttribute, to: expectedValue)

		// then
		assertThat(grouper.groupByAttribute, equals(expectedValue))
	}

	func testGivenAttributeSelectAttributeWithInvalidValue_set_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try grouper.set(attribute: grouper.attributeSelectAttribute, to: 0 as Any)) { error in
			assertThat(error, isA(TypeMismatchError.self))
		}
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
		let other = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOnlySelfGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = Me.hashableAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOnlyOtherGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
		grouper.groupByAttribute = Me.hashableAttribute
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentGroupByAttributes_equalTo_returnsFalse() {
		// given
		let other = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
		grouper.groupByAttribute = Me.hashableAttribute
		other.groupByAttribute = Me.nonHashableAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGroupByAttribute_equalTo_returnsTrue() {
		// given
		let other = SameValueSampleGrouper(attributes: [Me.hashableAttribute, Me.nonHashableAttribute])
		grouper.groupByAttribute = Me.hashableAttribute
		other.groupByAttribute = Me.hashableAttribute

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
