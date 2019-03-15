//
//  StartsWithStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class StartsWithStringAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = StartsWithStringAttributeRestrictionUnitTests
	private static let restrictedAttribute = TextAttribute(name: "text")
	private static let prefixAttribute = StartsWithStringAttributeRestriction.prefixAttribute

	private var restriction: StartsWithStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = StartsWithStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenPrefixAttribute_valueOf_returnsCorrectString() {
		// given
		let expectedPrefix = "expected prefix"
		restriction.prefix = expectedPrefix

		// when
		let actualPrefix = try! restriction.value(of: Me.prefixAttribute) as! String

		// then
		XCTAssertEqual(actualPrefix, expectedPrefix)
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.prefixAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenPrefixAttributeAndValidValue_setAttributeTo_setsCorrectValue() {
		// given
		let expectedPrefix = "expected prefix"

		// when
		try! restriction.set(attribute: Me.prefixAttribute, to: expectedPrefix)

		// then
		XCTAssertEqual(restriction.prefix, expectedPrefix)
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

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptyPrefixForRestriction_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.prefix = ""

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptyPrefixForRestriction_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.prefix = "not empty"

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithPartialPrefixMatchForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let prefix = "prefix"
		let sampleValue = String(prefix.prefix(prefix.count - 2))
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let prefix = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: prefix, for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let prefix = "prefix"
		let sample = SampleCreatorTestUtil.createSample(withValue: prefix + " some other stuff", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatEndsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + suffix, for: Me.restrictedAttribute)
		restriction.prefix = suffix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func textGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let prefix = "prefix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some " + prefix + " other stuff", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithValueAndEmptyPrefixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.prefix = ""

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let prefix = "this is definitely not contained in the text the sample has"
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.prefix = restrictionValue

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.prefix = "not empty"

		// when
		let passes = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.prefix = ""

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
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed = StartsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		let otherAttributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}