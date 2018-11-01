//
//  EqualToStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class EqualToStringAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = EqualToStringAttributeRestrictionUnitTests
	private static let restrictedAttribute = TextAttribute(name: "text", optional: true)
	private static let valueAttribute = EqualToStringAttributeRestriction.valueAttribute

	private var restriction: EqualToStringAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = EqualToStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenvalueAttribute_valueOf_returnsCorrectString() {
		// given
		let expectedValue = "expected value"
		restriction.value = expectedValue

		// when
		let actualValue = try! restriction.value(of: Me.valueAttribute) as! String

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.valueAttribute, to: 1 as Any)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenvalueAttributeAndValidValue_setAttributeTo_setsCorrectValue() {
		// given
		let expectedValue = "expected value"

		// when
		try! restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value as! String, expectedValue)
	}

	func testGivenSampleWithNonStringValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1 as Any))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndRestrictionWithNonEmptyString_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.value = "fd" as Any

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithValueMatchForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let equalToValue = "partial"
		let value = equalToValue + "some other stuff"
		let sample = SampleCreatorTestUtil.createSample(withValue: equalToValue, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let value = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: value, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleThatStartsWithValueForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let value = "prefix "
		let sample = SampleCreatorTestUtil.createSample(withValue: value + " some other stuff", for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleThatEndsWithValueForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let value = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + value, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithValueAndEmptyValueForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.value = "" as Any

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.value = restrictionValue

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.value = "not empty" as Any

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.value = "" as Any

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

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
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalTo_returnsFalse() {
		// given
		let otherAttributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}