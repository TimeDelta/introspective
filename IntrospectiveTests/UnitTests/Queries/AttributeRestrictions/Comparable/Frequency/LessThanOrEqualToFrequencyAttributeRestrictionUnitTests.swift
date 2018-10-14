//
//  LessThanOrEqualToFrequencyAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class LessThanOrEqualToFrequencyAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = LessThanOrEqualToFrequencyAttributeRestrictionUnitTests
	private static let valueAttribute = LessThanOrEqualToFrequencyAttributeRestriction.valueAttribute
	private static let restrictedAttribute = FrequencyAttribute(name: "restricted")

	private var restriction: LessThanOrEqualToFrequencyAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenValueAttribute_valueOf_returnsCorrectFrequency() {
		// given
		let expectedValue = Frequency(15, .day)
		restriction.value = expectedValue

		// when
		let actualValue = try! restriction.value(of: Me.valueAttribute) as! Frequency

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: Frequency(15, .day))) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.valueAttribute, to: Date())) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenValueAttributeAndValidValue_setAttributeTo_setsCorrectValue() {
		// given
		let expectedValue = Frequency(15, .day)

		// when
		try! restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value, expectedValue)
	}

	func testGivenSampleWithIncorrectValueTypeForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: Date()))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenSampleWithValueLessThanRestrictionValue_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: Frequency(restrictionValue.timesPerTimeUnit - 1, restrictionValue.timeUnit)))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenSampleWithValueEqualToRestrictionValue_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenSampleWithValueGreaterThanRestrictionValue_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Frequency(15, .day)
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: Frequency(restrictionValue.timesPerTimeUnit + 1, restrictionValue.timeUnit)))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}

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
		let otherAttributed: Attributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValue_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: Frequency(restriction.value.timesPerTimeUnit + 1, .day))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenOtherOfDifferentType_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

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
		let otherAttributed: AttributeRestriction = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: Frequency(restriction.value.timesPerTimeUnit + 1, .day))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() {
		// given
		let otherAttributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: FrequencyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalTo_returnsFalse() {
		// given
		let otherAttributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: Frequency(restriction.value.timesPerTimeUnit + 1, .day))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = LessThanOrEqualToFrequencyAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
