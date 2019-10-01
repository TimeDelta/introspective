//
//  DayOfWeekSampleGrouperUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/29/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import Common
@testable import DependencyInjection
@testable import SampleGroupers
@testable import Samples

class DayOfWeekSampleGrouperUnitTests: UnitTest {

	private final let dayOfWeekAttribute = DayOfWeekAttribute(name: "fds")

	private final var grouper: DayOfWeekSampleGrouper!

	override func setUp() {
		super.setUp()
		grouper = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
	}

	// MARK: - initializers

	func testGivenDayOfWeekAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let attributes = [
			dayOfWeekAttribute,
			DayOfWeekAttribute(name: dayOfWeekAttribute.name + "other stuff"),
		]

		// when
		grouper = DayOfWeekSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenDaysOfWeekAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let daysOfWeekAttribute = DaysOfWeekAttribute(name: "fjdskl")
		let attributes = [
			daysOfWeekAttribute,
			DaysOfWeekAttribute(name: daysOfWeekAttribute.name + "other stuff"),
		]

		// when
		grouper = DayOfWeekSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenDateAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let dateAttribute = CommonSampleAttributes.endDate
		let attributes = [
			dateAttribute,
			DateTimeAttribute(name: dateAttribute.name + "other stuff"),
		]

		// when
		grouper = DayOfWeekSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1])))
	}

	func testGivenDayOfWeekAndDaysOfWeekAndDateAttributes_init_includesThemAsPossibleValuesForAttributeSelectAttribute() {
		// given
		let attributes: [Attribute] = [
			dayOfWeekAttribute,
			CommonSampleAttributes.endDate,
			DaysOfWeekAttribute(name: dayOfWeekAttribute.name + "other stuff"),
		]

		// when
		grouper = DayOfWeekSampleGrouper(attributes: attributes)

		// then
		assertThat(
			grouper.attributeSelectAttribute.typedPossibleValues,
			hasItems(equals(attributes[0]), equals(attributes[1]), equals(attributes[2])))
	}

	func testGivenNonDayOfWeekAndNonDateBasedAttributes_init_doesNotIncludeThemAsPossibleVZaluesForAttributeSelectAttribute() {
		// given
		let attributes: [Attribute] = [
			TextAttribute(name: "f"),
			DoubleAttribute(name: "a"),
		]

		// when
		grouper = DayOfWeekSampleGrouper(attributes: attributes)

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
		grouper.groupByAttribute = dayOfWeekAttribute

		// when
		let description = grouper.description

		// then
		assertThat(description, containsString(dayOfWeekAttribute.name.localizedLowercase))
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
		grouper.groupByAttribute = dayOfWeekAttribute

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

	func testGivenDateAttribute_group_correctlyGroupsSamplesByDayOfWeek() throws {
		// given
		let dayOfWeek1 = DayOfWeek.Friday
		let dayOfWeek2 = DayOfWeek.Monday
		let dateAttribute = DateTimeAttribute(name: "fds")
		grouper.groupByAttribute = dateAttribute
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				dateForDayOfWeek(dayOfWeek1),
				dateForDayOfWeek(dayOfWeek2),
				dateForDayOfWeek(dayOfWeek1),
			],
			for: dateAttribute)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: dayOfWeek1, withSamples: [samples[0], samples[2]]))
		assertThat(groups, hasGroup(forValue: dayOfWeek2, withSamples: [samples[1]]))
	}

	func testGivenDayOfWeekAttribute_group_correctlyGroupsSamplesByDayOfWeek() throws {
		// given
		let dayOfWeek1 = DayOfWeek.Friday
		let dayOfWeek2 = DayOfWeek.Monday
		grouper.groupByAttribute = dayOfWeekAttribute
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				dayOfWeek1,
				dayOfWeek2,
				dayOfWeek1,
			],
			for: dayOfWeekAttribute)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: dayOfWeek1, withSamples: [samples[0], samples[2]]))
		assertThat(groups, hasGroup(forValue: dayOfWeek2, withSamples: [samples[1]]))
	}

	func testGivenDaysOfWeekAttribute_group_correctlyGroupsSamplesByDayOfWeek() throws {
		// given
		let dayOfWeek1 = DayOfWeek.Friday
		let dayOfWeek2 = DayOfWeek.Monday
		let dayOfWeek3 = DayOfWeek.Saturday
		let daysOfWeekAttribute = DaysOfWeekAttribute(name: "fd")
		grouper.groupByAttribute = daysOfWeekAttribute
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				[dayOfWeek1, dayOfWeek3],
				[dayOfWeek2, dayOfWeek3],
				[dayOfWeek1, dayOfWeek2],
			],
			for: daysOfWeekAttribute)

		// when
		let groups = try grouper.group(samples: samples)

		// then
		assertThat(groups, hasGroup(forValue: dayOfWeek1, withSamples: [samples[0], samples[2]]))
		assertThat(groups, hasGroup(forValue: dayOfWeek2, withSamples: [samples[1], samples[2]]))
		assertThat(groups, hasGroup(forValue: dayOfWeek3, withSamples: [samples[0], samples[1]]))
	}

	func testGivenDateAttributeWithNonDateValueForSample_group_throwsTypeMismatchError() throws {
		// given
		grouper.groupByAttribute = CommonSampleAttributes.endDate
		let samples = SampleCreatorTestUtil.createSamples(withValues: [0], for: CommonSampleAttributes.endDate)

		// when
		XCTAssertThrowsError(try grouper.group(samples: samples)) { error in
			// then
			assertThat(error, isA(TypeMismatchError.self))
		}
	}

	func testGivenDayOfWeekAttributeWithNonDayOfWeekValueForSample_group_throwsTypeMismatchError() throws {
		// given
		grouper.groupByAttribute = dayOfWeekAttribute
		let samples = SampleCreatorTestUtil.createSamples(withValues: [0], for: dayOfWeekAttribute)

		// when
		XCTAssertThrowsError(try grouper.group(samples: samples)) { error in
			// then
			assertThat(error, isA(TypeMismatchError.self))
		}
	}

	func testGivenDaysOfWeekAttributeWithNonDaysOfWeekValueForSample_group_throwsTypeMismatchError() throws {
		// given
		let daysOfWeekAttribute = DaysOfWeekAttribute(name: "fg")
		grouper.groupByAttribute = daysOfWeekAttribute
		let samples = SampleCreatorTestUtil.createSamples(withValues: [0], for: daysOfWeekAttribute)

		// when
		XCTAssertThrowsError(try grouper.group(samples: samples)) { error in
			// then
			assertThat(error, isA(TypeMismatchError.self))
		}
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
		grouper.groupByAttribute = dayOfWeekAttribute

		// when / then
		XCTAssertThrowsError(try grouper.groupNameFor(value: 1))
	}

	func testGivenGroupByDateAttributeWithStringValue_groupNameForValue_returnsAttributeNameIsOnAValue() throws {
		// given
		let dateAttribute = DateTimeAttribute(name: "hteq")
		grouper.groupByAttribute = dateAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(dateAttribute.name) is on a \(value)"))
	}

	func testGivenGroupByDayOfWeekAttributeWithStringValue_groupNameForValue_returnsAttributeNameIsValue() throws {
		// given
		grouper.groupByAttribute = dayOfWeekAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(dayOfWeekAttribute.name) is \(value)"))
	}

	func testGivenGroupByDaysOfWeekAttributeWithStringValue_groupNameForValue_returnsAttributeNameContainsValue() throws {
		// given
		let daysOfWeekAttribute = DaysOfWeekAttribute(name: "fdjkjwiofjeiow")
		grouper.groupByAttribute = daysOfWeekAttribute
		let value = "value string"

		// when
		let groupName = try grouper.groupNameFor(value: value)

		// then
		assertThat(groupName, equalTo("\(daysOfWeekAttribute.name) contains \(value)"))
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

	func testGivenEqualDayOfWeekValues_groupValuesAreEqual_returnsTrue() throws {
		// given
		let dayOfWeek = DayOfWeek.Friday

		// when
		let areEqual = try grouper.groupValuesAreEqual(dayOfWeek, dayOfWeek)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNotEqualDayOfWeekValues_groupValuesAreEqual_returnsFalse() throws {
		// given
		let dayOfWeek1 = DayOfWeek.Saturday
		let dayOfWeek2 = DayOfWeek.Sunday

		// when
		let areEqual = try grouper.groupValuesAreEqual(dayOfWeek1, dayOfWeek2)

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
		grouper.groupByAttribute = dayOfWeekAttribute

		// when
		let copy = grouper.copy()

		// then
		guard let castedCopy = copy as? DayOfWeekSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}
		assertThat(castedCopy.groupByAttribute, equals(grouper.groupByAttribute!))
		assertThat(castedCopy.attributeSelectAttribute, equals(grouper.attributeSelectAttribute))
		assertThat(castedCopy.attributes, arrayHasExactly(grouper.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_copy_returnsCopyThatModifyingDoesNotAffectOriginal() {
		// given
		grouper.groupByAttribute = dayOfWeekAttribute
		guard let copy = grouper.copy() as? DayOfWeekSampleGrouper else {
			XCTFail("Wrong SampleGrouper type")
			return
		}

		// when
		copy.groupByAttribute = DaysOfWeekAttribute(name: "fjeoqugnjk")

		// then
		assertThat(grouper.groupByAttribute, equals(dayOfWeekAttribute))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try grouper.value(of: dayOfWeekAttribute)) { error in
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
		XCTAssertThrowsError(try grouper.set(attribute: dayOfWeekAttribute, to: "" as Any)) { error in
			// then
			assertThat(error, isA(UnknownAttributeError.self))
		}
	}

	func testGivenAttributeSelectAttributeWithValidValue_set_setsGroupByAttribute() throws {
		// given
		grouper.groupByAttribute = DaysOfWeekAttribute(name: "ghjreiouq")
		let expectedValue = dayOfWeekAttribute

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
		let other = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenOnlySelfGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
		grouper.groupByAttribute = nil
		other.groupByAttribute = dayOfWeekAttribute

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenOnlyOtherGroupByAttributeNil_equalTo_returnsFalse() {
		// given
		let other = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
		grouper.groupByAttribute = dayOfWeekAttribute
		other.groupByAttribute = nil

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentGroupByAttributes_equalTo_returnsFalse() {
		// given
		let other = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
		grouper.groupByAttribute = dayOfWeekAttribute
		other.groupByAttribute = DaysOfWeekAttribute(name: "grejnqio")

		// when
		let areEqual = grouper.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameGroupByAttribute_equalTo_returnsTrue() {
		// given
		let other = DayOfWeekSampleGrouper(attributes: [dayOfWeekAttribute])
		grouper.groupByAttribute = dayOfWeekAttribute
		other.groupByAttribute = dayOfWeekAttribute

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

	// MARK: - Helper Functions

	private final func dateForDayOfWeek(_ dayOfWeek: DayOfWeek) -> Date {
		let date = Date().dateBySet([.weekday: dayOfWeek.intValue + 1])!
		Given(mockCalendarUtil, .dayOfWeek(forDate: .value(date), willReturn: dayOfWeek))
		return date
	}
}
