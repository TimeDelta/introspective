//
//  StartsWithStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Queries

final class StartsWithStringAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = StartsWithStringAttributeRestrictionUnitTests
	private static let restrictedAttribute = TextAttribute(name: "text")
	private static let prefixAttribute = StartsWithStringAttributeRestriction.prefixAttribute

	private var restriction: StartsWithStringAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = StartsWithStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsPrefix() throws {
		// given
		let prefix = "i should be in the description"
		restriction.prefix = prefix

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(prefix))
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

	func testGivenPrefixAttribute_valueOf_returnsCorrectString() throws {
		// given
		let expectedPrefix = "expected prefix"
		restriction.prefix = expectedPrefix

		// when
		let actualPrefix = try restriction.value(of: Me.prefixAttribute) as! String

		// then
		XCTAssertEqual(actualPrefix, expectedPrefix)
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.prefixAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenPrefixAttributeAndValidValue_setAttributeTo_setsCorrectValue() throws {
		// given
		let expectedPrefix = "expected prefix"

		// when
		try restriction.set(attribute: Me.prefixAttribute, to: expectedPrefix)

		// then
		XCTAssertEqual(restriction.prefix, expectedPrefix)
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

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptyPrefixForRestriction_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.prefix = ""

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptyPrefixForRestriction_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)
		restriction.prefix = "not empty"

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithPartialPrefixMatchForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let prefix = "prefix"
		let sampleValue = String(prefix.prefix(prefix.count - 2))
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let prefix = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: prefix, for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let prefix = "prefix"
		let sample = SampleCreatorTestUtil.createSample(withValue: prefix + " some other stuff", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatEndsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let suffix = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + suffix, for: Me.restrictedAttribute)
		restriction.prefix = suffix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func textGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let prefix = "prefix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some " + prefix + " other stuff", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithValueAndEmptyPrefixForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.prefix = ""

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainPrefixForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let prefix = "this is definitely not contained in the text the sample has"
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.prefix = prefix

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithDifferentCaseVersionOfValueForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let sampleValue = "JkflJdkKfejkl"
		let restrictionValue = "jKFLjDKkFEJKL"
		let sample = SampleCreatorTestUtil.createSample(withValue: sampleValue, for: Me.restrictedAttribute)
		restriction.prefix = restrictionValue

		// when
		let startsWith = try restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithNilValueAndNonEmptyRestrictionValue_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.prefix = "not empty"

		// when
		let passes = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(passes)
	}

	func testGivenSampleWithNilValueAndEmptyRestrictionValue_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as String?, for: Me.restrictedAttribute)
		restriction.prefix = ""

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
		guard let castedCopy = copy as? StartsWithStringAttributeRestriction else {
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
		let other = StartsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentPrefixs_equalToOperator_returnsFalse() throws {
		// given
		let other = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let other = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			prefix: restriction.prefix)

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
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(
			restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentPrefixes_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

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
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(
			restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentPrefixs_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() throws {
		// given
		let otherAttributed: AttributeRestriction = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

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
		let otherAttributed = StartsWithStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentPrefixs_equalTo_returnsFalse() throws {
		// given
		let otherAttributed = StartsWithStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			prefix: restriction.prefix + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() throws {
		// given
		let otherAttributed = StartsWithStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
