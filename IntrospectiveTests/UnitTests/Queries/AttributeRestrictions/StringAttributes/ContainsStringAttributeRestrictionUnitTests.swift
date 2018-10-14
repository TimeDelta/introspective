//
//  ContainsStringAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

class ContainsStringAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = ContainsStringAttributeRestrictionUnitTests
	fileprivate static let restrictedAttribute = TextAttribute(name: "text")
	fileprivate static let substringAttribute = ContainsStringAttributeRestriction.substringAttribute

	fileprivate var restriction: ContainsStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = ContainsStringAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenSubstringAttribute_valueOf_returnsCorrectDate() {
		// given
		let expectedSubstring = "expected substring"
		restriction.substring = expectedSubstring

		// when
		let actualSubstring = try! restriction.value(of: Me.substringAttribute) as! String

		// then
		XCTAssertEqual(actualSubstring, expectedSubstring)
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.substringAttribute, to: 1 as Any)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenSubstringAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedSubstring = "expected substring"

		// when
		try! restriction.set(attribute: Me.substringAttribute, to: expectedSubstring)

		// then
		XCTAssertEqual(restriction.substring, expectedSubstring)
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

	func testGivenSampleWithEmptyStringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "", for: Me.restrictedAttribute)

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithPartialSubstringMatchForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let partialSubstring = "partial"
		let substring = partialSubstring + "some other stuff"
		let sample = SampleCreatorTestUtil.createSample(withValue: partialSubstring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "exact match"
		let sample = SampleCreatorTestUtil.createSample(withValue: substring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatStartsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "prefix "
		let sample = SampleCreatorTestUtil.createSample(withValue: substring + " some other stuff", for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatEndsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "suffix"
		let sample = SampleCreatorTestUtil.createSample(withValue: "some other stuff" + substring, for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleWithValueAndEmptySubstringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: "some stuff", for: Me.restrictedAttribute)
		restriction.substring = ""

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSubstringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let substring = "this is definitely not contained in the text the sample has"
		let sample = SampleCreatorTestUtil.createSample(withValue: "i am not empty", for: Me.restrictedAttribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
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
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed = ContainsStringAttributeRestriction(restrictedAttribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		let otherAttributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = ContainsStringAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
