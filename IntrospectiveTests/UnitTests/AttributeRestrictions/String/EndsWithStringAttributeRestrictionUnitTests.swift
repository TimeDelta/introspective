//
//  EndsWithStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective

final class EndsWithStringAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = EndsWithStringAttributeRestrictionUnitTests
	private static let restrictedAttribute = TextAttribute(name: "text")
	private static let suffixAttribute = EndsWithStringAttributeRestriction.suffixAttribute

	private var restriction: EndsWithStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = EndsWithStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsSuffix() throws {
		// given
		let suffix = "i should be in the description"
		restriction.suffix = suffix

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(suffix))
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

	func testGivenSuffixAttribute_valueOf_returnsCorrectString() throws {
		// given
		let expectedSuffix = "expected suffix"
		restriction.suffix = expectedSuffix

		// when
		let actualSuffix = try restriction.value(of: Me.suffixAttribute) as! String

		// then
		XCTAssertEqual(actualSuffix, expectedSuffix)
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.suffixAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSuffixAttributeAndValidValue_setAttributeTo_setsCorrectValue() throws {
		// given
		let expectedSuffix = "expected suffix"

		// when
		try restriction.set(attribute: Me.suffixAttribute, to: expectedSuffix)

		// then
		XCTAssertEqual(restriction.suffix, expectedSuffix)
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

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptySuffixForRestriction_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.suffix = ""

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptySuffixForRestriction_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.suffix = "not empty"

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithPartialSuffixMatchForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let suffix = "suffix"
		let sampleValue = String(suffix.prefix(suffix.count - 2))
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let suffix = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: suffix, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + suffix, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatStartsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: suffix + "some other stuff", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func textGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some " + suffix + " other stuff", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithValueAndEmptySuffixForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.suffix = ""

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSuffixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let suffix = "this is definitely not contained in the text the sample has"
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.suffix = restrictionValue

		// when
		let endsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.suffix = "not empty"

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.suffix = ""

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
		guard let castedCopy = copy as? EndsWithStringAttributeRestriction else {
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
		let other = EndsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSuffixes_equalToOperator_returnsFalse() throws {
		// given
		let other = EndsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let other = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(
			restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSuffixes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() throws {
		// given
		let otherRestriction: AttributeRestriction = LessThanDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute)

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
		let otherRestriction: AttributeRestriction = EndsWithStringAttributeRestriction(
			restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSuffixes_equalToRestriction_returnsFalse() throws {
		// given
		let otherRestriction: AttributeRestriction = EndsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() throws {
		// given
		let otherRestriction: AttributeRestriction = EndsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute)

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
		let other = EndsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSuffixes_equalTo_returnsFalse() throws {
		// given
		let other = EndsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() throws {
		// given
		let other = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
