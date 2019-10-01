//
//  NotEqualToSelectOneAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/28/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Common
@testable import Queries

final class NotEqualToSelectOneAttributeRestrictionUnitTests: UnitTest {

	private final var restriction: NotEqualToSelectOneAttributeRestriction!
	private final var attribute: SelectOneAttribute!
	private final var value: DayOfWeek!

	final override func setUp() {
		super.setUp()
		value = DayOfWeek.Sunday
		attribute = DayOfWeekAttribute(name: "name of restricted attribute")
		restriction = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: attribute,
			value: value,
			valueAttribute: attribute)
	}

	// MARK: - description

	func test_description_containsValue() {
		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(value.abbreviation))
	}

	func test_description_containsNameOfRestrictedAttribute() {
		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(attribute.name))
	}

	// MARK: - init

	func testGivenSelectOneAttribute_init_setsRestrictionValueToFirstPossibleValue() {
		// when
		restriction = NotEqualToSelectOneAttributeRestriction(restrictedAttribute: attribute)

		// then
		XCTAssertEqual(restriction.value as? DayOfWeek, attribute.possibleValues[0] as? DayOfWeek)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try restriction.value(of: unknownAttribute)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	func testGivenValueAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let returnedValue = try restriction.value(of: attribute) as? DayOfWeek

		// then
		XCTAssertEqual(returnedValue, value)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try restriction.set(attribute: unknownAttribute, to: value)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	func testGivenValueAttributeWithCorrectValueType_set_correctlySetsValue() throws {
		// given
		let expectedValue = DayOfWeek.Thursday

		// when
		try restriction.set(attribute: attribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value as? DayOfWeek, expectedValue)
	}

	func testGivenValueAttributeWithWrongValueType_set_throwsTypeMismatchError() throws {
		// given
		let value = ""

		// when
		XCTAssertThrowsError(try restriction.set(attribute: attribute, to: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	// MARK: - samplePasses()

	func testGivenSampleValueEqualToRestrictionValue_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: value, for: attribute)

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleValueNotEqualToRestrictionValue_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: DayOfWeek.Friday, for: attribute)

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenNilSampleValueAndValueIsNotNil_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilSampleValueAndValueIsNil_samplePasses_returnsFalse() throws {
		// given
		restriction.value = nil as Any?
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: attribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? NotEqualToSelectOneAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - restrictedAttributeWasSet()

	func testGivenValueIsNoLongerPossible_setRestrictedAttribute_setsValueToFirstPossibleValueOfNewAttribute() {
		// given
		let expectedNewRestrictionValue = 2.0
		let newAttribute = TypedEquatableSelectOneAttribute<Double>(
			name: "new attribute",
			typeName: "type",
			possibleValues: [
				expectedNewRestrictionValue,
				expectedNewRestrictionValue + 1,
			],
			possibleValueToString: { String($0) })

		// when
		restriction.restrictedAttribute = newAttribute

		// then
		XCTAssertEqual(restriction.value as? Double, expectedNewRestrictionValue)
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenValueMismatch_equalToOperator_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: DayOfWeek.Thursday as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenAllAttributesSame_equalToOperator_returnsTrue() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenDifferentClass_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenRestrictedAttributesMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as Attributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenValueMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: DayOfWeek.Thursday as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as Attributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenAllAttributesSame_equalToAttributed_returnsTrue() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as Attributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenDifferentClass_equalToRestriction_returnsFalse() {
		// given
		let other = AfterDateAttributeRestriction(restrictedAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	func testGivenRestrictedAttributesMismatch_equalToRestriction_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenValueMismatch_equalToRestriction_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: DayOfWeek.Thursday as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenAllAttributesSame_equalToRestriction_returnsTrue() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction.equalTo(other as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"),
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenValueMismatch_equalTo_returnsFalse() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: DayOfWeek.Thursday as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenAllAttributesSame_equalTo_returnsTrue() {
		// given
		let other = NotEqualToSelectOneAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as Any,
			valueAttribute: attribute)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}
}
