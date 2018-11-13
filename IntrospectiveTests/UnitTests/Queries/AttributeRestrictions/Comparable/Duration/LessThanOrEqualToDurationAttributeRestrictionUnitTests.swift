//
//  LessThanOrEqualToDurationAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class LessThanOrEqualToDurationAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = LessThanOrEqualToDurationAttributeRestrictionUnitTests
	private static let valueAttribute = LessThanOrEqualToDurationAttributeRestriction.valueAttribute
	private static let restrictedAttribute = DurationAttribute(name: "restricted")

	private var restriction: LessThanOrEqualToDurationAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenValueAttribute_valueOf_returnsCorrectDuration() {
		// given
		let expectedValue = Duration(15)
		restriction.value = expectedValue

		// when
		let actualValue = try! restriction.value(of: Me.valueAttribute) as! Duration

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	// MARK: - set(attribute:to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: Duration(15))) { error in
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
		let expectedValue = Duration(15)

		// when
		try! restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value, expectedValue)
	}

	// MARK: - samplePasses()

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
		let restrictionValue = Duration(15)
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue - 1))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertTrue(samplePasses)
	}

	func testGivenSampleWithValueEqualToRestrictionValue_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionValue = Duration(15)
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
		let restrictionValue = Duration(15)
		restriction.value = restrictionValue
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: restrictionValue + 1))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
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
		let otherAttributed: Attributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: DurationAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValue_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value + 1)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

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
		let otherAttributed: AttributeRestriction = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: DurationAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value + 1)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

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
		let otherAttributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: DurationAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameRestrictedAttributeButDifferentValues_equalTo_returnsFalse() {
		// given
		let otherAttributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value + 1)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = LessThanOrEqualToDurationAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}}
