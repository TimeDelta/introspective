//
//  EndsWithStringAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class EndsWithStringAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = EndsWithStringAttributeRestrictionUnitTests
	fileprivate static let attribute = TextAttribute(name: "text")
	fileprivate static let suffixAttribute = EndsWithStringAttributeRestriction.suffixAttribute

	fileprivate var restriction: EndsWithStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = EndsWithStringAttributeRestriction(attribute: Me.attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.attribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenSuffixAttribute_valueOf_returnsCorrectDate() {
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.attribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.suffixAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenSuffixAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedSuffix = "expected suffix"

		// when
		try! restriction.set(attribute: Me.suffixAttribute, to: expectedSuffix)

		// then
		XCTAssertEqual(restriction.suffix, expectedSuffix)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptySuffixForRestriction_samplePasses_returnsTrue() {
		// given
		let sample = createSample(withValue: "", for: Me.attribute)
		restriction.suffix = ""

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptySuffixForRestriction_samplePasses_returnsFalse() {
		// given
		let sample = createSample(withValue: "", for: Me.attribute)
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
		let sample = createSample(withValue: sampleValue, for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let suffix = "exact match"
		let sample = createSample(withValue: suffix, for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let suffix = "suffix"
		let sample = createSample(withValue: "some other stuff" + suffix, for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleThatStartsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = createSample(withValue: suffix + "some other stuff", for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func textGivenSampleThatEndsWithSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = createSample(withValue: "some " + suffix + " other stuff", for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}

	func testGivenSampleWithValueAndEmptySuffixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sample = createSample(withValue: "some stuff", for: Me.attribute)
		restriction.suffix = ""

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(endsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainSuffixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "this is definitely not contained in the text the sample has"
		let sample = createSample(withValue: "i am not empty", for: Me.attribute)
		restriction.suffix = suffix

		// when
		let endsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(endsWith)
	}
}
