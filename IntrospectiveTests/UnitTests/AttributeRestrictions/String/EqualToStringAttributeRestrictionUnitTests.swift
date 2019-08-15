//
//  EqualToStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
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

	// MARK: - description

	func test_description_containsValueString() throws {
		// given
		let value = "i should be in the description"
		restriction.value = value

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(value))
	}

	func test_description_containsRestrictedAttributeName() throws {
		// when
		let description = restriction.description

		// then
		let attributeName = restriction.restrictedAttribute.name.localizedLowercase
		assertThat(description.localizedLowercase, containsString(attributeName))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() throws {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenvalueAttribute_valueOf_returnsCorrectString() throws {
		// given
		let expectedValue = "expected value"
		restriction.value = expectedValue

		// when
		let actualValue = try restriction.value(of: Me.valueAttribute) as! String

		// then
		XCTAssertEqual(actualValue, expectedValue)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.valueAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenvalueAttributeAndValidValue_setAttributeTo_setsCorrectValue() throws {
		// given
		let expectedValue = "expected value"

		// when
		try restriction.set(attribute: Me.valueAttribute, to: expectedValue)

		// then
		XCTAssertEqual(restriction.value as! String, expectedValue)
	}

	// MARK: - samplePasses()

	func testGivenSampleWithNonStringValueForGivenAttribute_samplePasses_throwsTypeMismatchError() throws {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1 as Any))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndRestrictionWithNonEmptyString_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.value = "fd" as Any

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithValueMatchForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let equalToValue = "partial"
		let value = equalToValue + "some other stuff"
		let sample = SampleCreatorTestUtil.createSample(withValue: equalToValue, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let value = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: value, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleThatStartsWithValueForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let value = "prefix "
		let sample = SampleCreatorTestUtil.createSample(withValue: value + " some other stuff", for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleThatEndsWithValueForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let value = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + value, for: Me.restrictedAttribute)
		restriction.value = value

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithValueAndEmptyValueForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.value = "" as Any

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.value = restrictionValue

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.value = "not empty" as Any

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.value = "" as Any

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenExpectedValueIsNilAndSampleValueIsNil_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.value = nil as Any?

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	func testGivenExpectedValueIsNilAndSampleValueIsEmpty_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.value = nil as Any?

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssert(passes)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() throws {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? EqualToStringAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() throws {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToOperator_returnsFalse() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

	func testGivenOtherOfDifferentTypes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = SameDatesSubQueryMatcher()

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction as Attributed)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() throws {
		// given
		let otherRestriction: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameObjectTwice_equalToRestriction_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction as AttributeRestriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToRestriction_returnsFalse() throws {
		// given
		let otherRestriction: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalToRestriction_returnsFalse() throws {
		// given
		let otherRestriction: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() throws {
		// given
		let otherRestriction: AttributeRestriction = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() throws {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentValues_equalTo_returnsFalse() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, value: restriction.value as! String + "other stuff")

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() throws {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
