//
//  EndsWithStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
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

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenSuffixAttribute_valueOf_returnsCorrectString() {
		// given
		let expectedSuffix = "expected suffix"
		restriction.suffix = expectedSuffix

		// when
		let actualSuffix = try! restriction.value(of: Me.suffixAttribute) as! String

		// then
		XCTAssertEqual(actualSuffix, expectedSuffix)
	}

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.suffixAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSuffixAttributeAndValidValue_setAttributeTo_setsCorrectValue() {
		// given
		let expectedSuffix = "expected suffix"

		// when
		try! restriction.set(attribute: Me.suffixAttribute, to: expectedSuffix)

		// then
		XCTAssertEqual(restriction.suffix, expectedSuffix)
	}

	func testGivenSampleWithNonStringValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1 as Any))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptySuffixForRestriction_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.suffix = ""

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptySuffixForRestriction_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.suffix = "not empty"

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithPartialSuffixMatchForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sampleValue = String(suffix.prefix(suffix.count - 2))
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let suffix = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: suffix, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + suffix, for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatStartsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: suffix + "some other stuff", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func textGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some " + suffix + " other stuff", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithValueAndEmptySuffixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.suffix = ""

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "this is definitely not contained in the text the sample has"
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.suffix = restrictionValue

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.suffix = "not empty"

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.suffix = ""

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
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = EndsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed = EndsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		let otherAttributed = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, suffix: restriction.suffix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = EndsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
