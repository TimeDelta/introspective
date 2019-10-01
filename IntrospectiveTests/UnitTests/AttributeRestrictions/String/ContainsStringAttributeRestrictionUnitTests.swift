//
//  ContainsStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Queries

final class ContainsStringAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = ContainsStringAttributeRestrictionUnitTests
	private static let restrictedAttribute = TextAttribute(name: "text")
	private static let substringAttribute = ContainsStringAttributeRestriction.substringAttribute

	private var restriction: ContainsStringAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = ContainsStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsSubstring() throws {
		// given
		let substring = "i should be in the description"
		restriction.substring = substring

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(substring))
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

	func testGivenSubstringAttribute_valueOf_returnsCorrectString() throws {
		// given
		let expectedSubstring = "expected substring"
		restriction.substring = expectedSubstring

		// when
		let actualSubstring = try restriction.value(of: Me.substringAttribute) as! String

		// then
		XCTAssertEqual(actualSubstring, expectedSubstring)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_set_throwsUnknownAttributeError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_set_throwsTypeMismatchError() throws {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.substringAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSubstringAttributeAndValidValue_set_setsCorrectValue() throws {
		// given
		let expectedSubstring = "expected substring"

		// when
		try restriction.set(attribute: Me.substringAttribute, to: expectedSubstring)

		// then
		XCTAssertEqual(restriction.substring, expectedSubstring)
	}

	// MARK: - samplePasses

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

	func testGivenSampleWithEmptyStringForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithPartialSubstringMatchForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let partialSubstring = "partial"
		let substring = partialSubstring + "some other stuff"
		let sample = SampleCreatorTestUtil.createSample(withValue: partialSubstring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let substring = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: substring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleWithDifferentCaseMatchForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let substring = "different case"
		let sample = SampleCreatorTestUtil.createSample(withValue: substring.uppercased(), for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatStartsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let substring = "prefix "
		let sample = SampleCreatorTestUtil.createSample(withValue: substring + " some other stuff", for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatEndsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() throws {
		// given
		let substring = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + substring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleWithValueAndEmptySubstringForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.substring = ""

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSubstringForRestrictedAttribute_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.substring = "this is definitely not contained in the text the sample has"

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleValueIsNilAndSubstringNotEmpty_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)
		restriction.substring = "not empty"

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleValueIsNilAndSubstringIsEmpty_samplePasses_returnsTrue() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)
		restriction.substring = ""

		// when
		let contains = try restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() throws {
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? ContainsStringAttributeRestriction else {
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
		let other = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToOperator_returnsFalse() throws {
		// given
		let other = ContainsStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			substring: restriction.substring + "other stuff")

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() throws {
		// given
		let other = ContainsStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			substring: restriction.substring)

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
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() throws {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() throws {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() throws {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() throws {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let other = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() throws {
		// given
		let other = ContainsStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() throws {
		// given
		let other = ContainsStringAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			substring: restriction.substring)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
