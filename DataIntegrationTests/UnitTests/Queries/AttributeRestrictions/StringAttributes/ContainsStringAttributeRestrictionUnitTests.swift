//
//  ContainsStringAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class ContainsStringAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = ContainsStringAttributeRestrictionUnitTests
	fileprivate static let attribute = TextAttribute(name: "text")
	fileprivate static let substringAttribute = ContainsStringAttributeRestriction.substringAttribute

	fileprivate var restriction: ContainsStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = ContainsStringAttributeRestriction(attribute: Me.attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.attribute)) { error in
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.attribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.substringAttribute, to: 1)) { error in
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

	func testGivenSampleWithEmptyStringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = createSample(withValue: "", for: Me.attribute)

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithPartialSubstringMatchForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let partialSubstring = "partial"
		let substring = partialSubstring + "some other stuff"
		let sample = createSample(withValue: partialSubstring, for: Me.attribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "exact match"
		let sample = createSample(withValue: substring, for: Me.attribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatStartsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "prefix "
		let sample = createSample(withValue: substring + " some other stuff", for: Me.attribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleThatEndsWithSubstringForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let substring = "suffix"
		let sample = createSample(withValue: "some other stuff" + substring, for: Me.attribute)
		restriction.substring = substring

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssert(contains)
	}

	func testGivenSampleWithValueAndEmptySubstringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let sample = createSample(withValue: "some stuff", for: Me.attribute)
		restriction.substring = ""

		// when
		let contains = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(contains)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSubstringForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let substring = "this is definitely not contained in the text the sample has"
		let sample = createSample(withValue: "i am not empty", for: Me.attribute)
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
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(attribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanNumericAttributeRestriction(attribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(attribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute)

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
		let otherAttributed = ContainsStringAttributeRestriction(attribute: TextAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		let otherAttributed = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute, substring: restriction.substring + "other stuff")

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = ContainsStringAttributeRestriction(attribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}