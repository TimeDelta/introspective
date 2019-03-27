//
//  NotEqualToDoubleAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective

final class NotEqualToDoubleAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = NotEqualToDoubleAttributeRestrictionUnitTests
	private static let valueAttribute = NotEqualToDoubleAttributeRestriction.valueAttribute
	private static let restrictedAttribute = DoubleAttribute(name: "restricted")

	private var restriction: NotEqualToDoubleAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = NotEqualToDoubleAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsValue() {
		// given
		let value = 2.3
		restriction.value = value

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(String(value)))
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

	func testGivenDateAttribute_valueOf_returnsCorrectDate() {
		// given
		let expectedValue = 432.0
		restriction.value = expectedValue

		// when
		let actualValue = try! restriction.value(of: Me.valueAttribute) as! Double

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
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

	func testGivenDateAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedValue = 2345.0

		// when
		try! restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value as? Double, expectedValue)
	}

	// MARK: - samplePasses()

	func testGivenSampleWithNonDateValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
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
		let restrictionValue = 235.0
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue - 1))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenSampleWithValueEqualToRestrictionValue_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = 235.0
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
		let restrictionValue = 235.0
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue + 1))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenNilSampleValueAndValueIsNotNil_samplePasses_returnsTrue() throws {
		// given
		restriction.value = 2.3 as Any
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

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() {
		// given
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: IntegerAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToOperator_returnsFalse() {
		// given
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double + 1)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenOtherOfDifferentTypes_equalToAttributed_returnsFalse() {
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

	func testGivenSameClassWithDifferentAttributes_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: IntegerAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double + 1)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = ContainsStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute)

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
		let otherRestriction: AttributeRestriction = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: IntegerAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double + 1)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherRestriction: AttributeRestriction = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double)

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
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: IntegerAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalTo_returnsFalse() {
		// given
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double + 1)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = NotEqualToDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			value: restriction.value as! Double)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
