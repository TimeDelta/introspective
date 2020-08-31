//
//  AdvancedSampleGrouperUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/24/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import DependencyInjection
@testable import SampleGroupers
@testable import Samples

class AdvancedSampleGrouperUnitTests: UnitTest {

	private var grouper: AdvancedSampleGrouper!

	override func setUp() {
		super.setUp()
		grouper = AdvancedSampleGrouper()
	}

	// MARK: - description

	func testGivenNoGroupDefinitions_description_returnsEmptyString() {
		// when
		let description = grouper.description

		// then
		assertThat(description, equalTo(""))
	}

	func testGivenGroupDefinitions_description_includesDescriptionOfEachGroupDefinition() {
		// given
		let definitionName1 = "abc"
		let groupDefinition1 = GroupDefinitionMock()
		Given(groupDefinition1, .name(getter: definitionName1))
		let definitionName2 = "fdshauijk"
		let groupDefinition2 = GroupDefinitionMock()
		Given(groupDefinition2, .name(getter: definitionName2))
		grouper.groupDefinitions = [groupDefinition1, groupDefinition2]

		// when
		let description = grouper.description

		// then
		assertThat(description, containsStringsInOrder(definitionName1, definitionName2))
	}

	// MARK: - group(samples:)

	func testGivenEmptySamplesArray_group_returnsEmptyGroupsArray() throws {
		// given
		let samples: [Sample] = []

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasCount(0))
	}

	func testGivenSampleBelongsToMultipleGroups_group_addsSampleToAllOfThem() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample()
		let groupDefinition1Name = "fdsjk"
		let groupDefinition1 = mockGroupDefinition(withName: groupDefinition1Name)
		Given(groupDefinition1, .sampleBelongsInGroup(.value(sample), willReturn: true))
		let groupDefinition2Name = "gtq"
		let groupDefinition2 = mockGroupDefinition(withName: groupDefinition2Name)
		Given(groupDefinition2, .sampleBelongsInGroup(.value(sample), willReturn: true))
		grouper.groupDefinitions = [groupDefinition1, groupDefinition2]

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, hasGroup(forValue: groupDefinition1Name, withSamples: [sample]))
		assertThat(groups, hasGroup(forValue: groupDefinition2Name, withSamples: [sample]))
	}

	func testGivenSampleDoesNotBelongToGroup_group_doesNotAddItToThatGroup() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample()
		let groupDefinitionName = "fdsjk"
		let groupDefinition = mockGroupDefinition(withName: groupDefinitionName)
		Given(groupDefinition, .sampleBelongsInGroup(.value(sample), willReturn: false))

		// when
		let groups = try grouper.group(samples: [sample])

		// then
		assertThat(groups, not(hasGroup(forValue: groupDefinitionName, withSamples: [sample])))
	}

	func testGivenMultipleSamplesBelongToGroup_group_addsAllOfThemToThatGroup() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2)
		let groupDefinitionName = "fdsjk"
		let groupDefinition = mockGroupDefinition(withName: groupDefinitionName)
		for sample in samples {
			Given(groupDefinition, .sampleBelongsInGroup(.value(sample), willReturn: true))
		}
		grouper.groupDefinitions = [groupDefinition]

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: groupDefinitionName, withSamples: samples))
	}

	// MARK: - groupNameFor(value:)

	func testGivenNonString_groupNameFor_throwsError() throws {
		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: 1.0))
	}

	func testGivenString_groupNameFor_returnsInputString() throws {
		// given
		let value = "fhjdsokl"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo(value))
	}

	// MARK: - groupValuesAreEqual()

	func testGivenValue1IsNotString_groupValuesAreEqual_throwsError() throws {
		// given
		let value1 = 1.0
		let value2 = "a"

		// when / then
		XCTAssertThrowsError(try grouper.groupValuesAreEqual(value1, value2))
	}

	func testGivenValue2IsNotString_groupValuesAreEqual_throwsError() throws {
		// given
		let value1 = "a"
		let value2 = 1.0

		// when / then
		XCTAssertThrowsError(try grouper.groupValuesAreEqual(value1, value2))
	}

	func testGivenNeitherValueIsString_groupValuesAreEqual_throwsError() throws {
		// given
		let value1 = 1.0
		let value2 = 2.0

		// when / then
		XCTAssertThrowsError(try grouper.groupValuesAreEqual(value1, value2))
	}

	func testGivenBothValuesAreStringsButAreNotEqual_groupValuesAreEqual_returnsFalse() throws {
		// given
		let value1 = "a"
		let value2 = value1 + "other stuff"

		// when
		let areEqual = try grouper.groupValuesAreEqual(value1, value2)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBothValuesAreStringsAndAreEqual_groupValuesAreEqual_returnsTrue() throws {
		// given
		let value1 = "a"
		let value2 = value1

		// when
		let areEqual = try grouper.groupValuesAreEqual(value1, value2)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - attributeValuesAreValid()

	func test_attributeValuesAreValid_returnsTrue() {
		// when
		let valid = grouper.attributeValuesAreValid()

		// then
		XCTAssert(valid)
	}

	// MARK: - isValid()

	func testGivenNoGroupDefinitions_isValid_returnsFalse() {
		// given
		grouper.groupDefinitions = []

		// when
		let isValid = grouper.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenOnlyAGroupDefinitionThatIsNotValid_isValid_returnsFalse() {
		// given
		grouper.groupDefinitions = [
			mockGroupDefinition(isValid: false),
		]

		// when
		let isValid = grouper.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenOneValidGroupDefinitionAndOneInvalid_isValid_returnsFalse() {
		// given
		grouper.groupDefinitions = [
			mockGroupDefinition(isValid: true),
			mockGroupDefinition(isValid: false),
		]

		// when
		let isValid = grouper.isValid()

		// then
		XCTAssertFalse(isValid)
	}

	func testGivenOnlyAGroupDefinitionThatIsValid_isValid_returnsTrue() {
		// given
		grouper.groupDefinitions = [
			mockGroupDefinition(isValid: true),
		]

		// when
		let isValid = grouper.isValid()

		// then
		XCTAssert(isValid)
	}

	func testGivenMultipleValidGroupDefinitions_isValid_returnsTrue() {
		// given
		grouper.groupDefinitions = [
			mockGroupDefinition(isValid: true),
			mockGroupDefinition(isValid: true),
		]

		// when
		let isValid = grouper.isValid()

		// then
		XCTAssert(isValid)
	}

	// MARK: - copy()

	func test_copy_returnsExactCopy() {
		// given
		let definition1Copy = mockGroupDefinition()
		let groupDefinition1 = mockGroupDefinition(withCopy: definition1Copy)
		let definition2Copy = mockGroupDefinition()
		let groupDefinition2 = mockGroupDefinition(withCopy: definition2Copy)
		grouper.groupDefinitions = [
			groupDefinition1,
			groupDefinition2,
		]

		// when
		let copy = grouper.copy()

		// then
		guard let castedCopy = copy as? AdvancedSampleGrouper else {
			XCTFail("Returned wrong type of SampleGrouper")
			return
		}
		assertThat(castedCopy.groupDefinitions, hasItems(
			sameObject(definition1Copy),
			sameObject(definition2Copy)))
	}

	func test_copy_returnsCopyThatModifyingGroupDefinitionsArrayDoesNotAffectOriginal() {
		// given
		let groupDefinition1 = GroupDefinitionImpl(HeartRate.self)
		groupDefinition1.name = "1"
		let groupDefinition2 = GroupDefinitionImpl(BloodPressure.self)
		groupDefinition2.name = "2"
		grouper.groupDefinitions = [
			groupDefinition1,
			groupDefinition2,
		]
		guard let copy = grouper.copy() as? AdvancedSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupDefinitions.append(mockGroupDefinition())

		// then
		XCTAssertNotEqual(copy.groupDefinitions.count, grouper.groupDefinitions.count)
	}

	func test_copy_returnsCopyThatModifyingAGroupDefinitionDoesNotAffectOriginal() {
		// given
		let groupDefinition = GroupDefinitionImpl(HeartRate.self)
		groupDefinition.name = "1"
		grouper.groupDefinitions = [
			groupDefinition,
		]
		guard let copy = grouper.copy() as? AdvancedSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupDefinitions[0].name = "fjskl"

		// then
		XCTAssertNotEqual(copy.groupDefinitions[0].name, grouper.groupDefinitions[0].name)
	}

	// MARK: - value(of:)

	func test_valueOf_throwsUnknownAttributeError() {
		// given - to fail if there is ever an attribute added to it that shouldn't throw an error
		let attribute: Attribute
		if grouper.attributes.count > 0 {
			attribute = grouper.attributes[0]
		} else {
			attribute = TextAttribute(name: "f")
		}

		// when
		XCTAssertThrowsError(try grouper.value(of: attribute)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	// MARK: - set(attribute:, to:)

	func test_set_throwsUnknownAttributeError() {
		// given - to fail if there is ever an attribute added to it that shouldn't throw an error
		let attribute: Attribute
		if grouper.attributes.count > 0 {
			attribute = grouper.attributes[0]
		} else {
			attribute = TextAttribute(name: "f")
		}

		// when
		XCTAssertThrowsError(try grouper.set(attribute: attribute, to: 1 as Any)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	// MARK: - equalTo()

	func testGivenDifferentSampleGrouperClass_equalTo_returnsFalse() {
		// given
		let other = SameValueSampleGrouper(sampleType: HeartRate.self)

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGroupDefinitions_equalTo_returnsTrue() {
		// given
		let groupDefinition = mockGroupDefinition()
		Given(groupDefinition, .equalTo(.value(groupDefinition), willReturn: true))
		grouper.groupDefinitions = [groupDefinition]
		let other = AdvancedSampleGrouper()
		other.groupDefinitions = grouper.groupDefinitions

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenDifferentGroupDefinitions_equalTo_returnsFalse() {
		// given
		let groupDefinition = mockGroupDefinition()
		Given(groupDefinition, .equalTo(.any, willReturn: false))
		grouper.groupDefinitions = [groupDefinition]
		let other = AdvancedSampleGrouper()
		other.groupDefinitions = [groupDefinition]

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGrouperTwice_equalTo_returnsTrue() {
		// when
		let areEqual = grouper.equalTo(grouper)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - Helper Functions

	func mockGroupDefinition(
		withName name: String = "",
		isValid: Bool = true,
		withCopy copy: GroupDefinition? = nil)
	-> GroupDefinitionMock {
		let definition = GroupDefinitionMock()
		Given(definition, .name(getter: name))
		Given(definition, .isValid(willReturn: isValid))
		Given(definition, .description(getter: ""))
		if let copy = copy {
			Given(definition, .copy(willReturn: copy))
		}
		return definition
	}
}
