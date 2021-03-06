//
//  NotEqualToFrequencyAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Common
@testable import Queries

class NotEqualToFrequencyAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = NotEqualToFrequencyAttributeRestrictionUnitTests
	private static let valueAttribute = NotEqualToFrequencyAttributeRestriction.valueAttribute
	private static let restrictedAttribute = FrequencyAttribute(name: "restricted")

	private var restriction: NotEqualToFrequencyAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = NotEqualToFrequencyAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsValue() {
		// given
		let value = Frequency(2, .hour)!
		restriction.value = value

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(value.description))
	}

	func test_description_containsNotEqualTo() {
		// when
		let description = restriction.description

		// then
		assertThat(description, containsString("≠"))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenValueAttribute_valueOf_returnsCorrectFrequency() {
		// given
		let expectedValue = Frequency(15, .day)!
		restriction.value = expectedValue

		// when
		let actualValue = try! restriction.value(of: Me.valueAttribute) as! Frequency

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: Frequency(15, .day)!)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.valueAttribute, to: Date())) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenValueAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedValue = Frequency(15, .day)!

		// when
		try! restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value as? Frequency, expectedValue)
	}

	// MARK: - samplePasses

	func testGivenSampleWithIncorrectValueTypeForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: Date()))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithValueLessThanRestrictionValue_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)!
		restriction.value = restrictionValue
		Given(
			mockSample,
			.value(of: .value(Me.restrictedAttribute),
			willReturn: Frequency(restrictionValue.timesPerTimeUnit - 1, restrictionValue.timeUnit)!))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenSampleWithValueEqualToRestrictionValue_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)!
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithValueGreaterThanRestrictionValue_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)!
		restriction.value = restrictionValue
		Given(
			mockSample,
			.value(of: .value(Me.restrictedAttribute),
			willReturn: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)!))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilSampleValueAndValueIsNotNil_samplePasses_returnsTrue() throws {
		// given
		restriction.value = Frequency(2, .hour)! as Any
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilSampleValueAndValueIsNil_samplePasses_returnsFalse() throws {
		// given
		restriction.value = nil as Any?
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

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
		guard let castedCopy = copy as? NotEqualToFrequencyAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
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
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalToOperator_returnsFalse() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)!)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restrictionValue)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenOtherOfDifferentType_equalToAttributed_returnsFalse() {
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

	func testGivenSameClassWithDifferentRestrictedAttribute_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValue_equalToAttributed_returnsFalse() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let otherAttributed: Attributed = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)!)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let otherAttributed: Attributed = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restrictionValue)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentType_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalToRestriction_returnsFalse() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let otherRestriction: AttributeRestriction = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)!)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let otherRestriction: AttributeRestriction = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restrictionValue)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() {
		// given
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalTo_returnsFalse() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)!)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let restrictionValue = restriction.value as! Frequency
		let other = NotEqualToFrequencyAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restrictionValue)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
