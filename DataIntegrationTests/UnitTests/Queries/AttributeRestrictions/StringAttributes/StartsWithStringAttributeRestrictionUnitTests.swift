//
//  StartsWithStringAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
@testable import DataIntegration

class StartsWithStringAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = StartsWithStringAttributeRestrictionUnitTests
	fileprivate static let attribute = TextAttribute(name: "text")
	fileprivate static let prefixAttribute = StartsWithStringAttributeRestriction.prefixAttribute

	fileprivate var restriction: StartsWithStringAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = StartsWithStringAttributeRestriction(attribute: Me.attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.attribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenPrefixAttribute_valueOf_returnsCorrectDate() {
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.attribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.prefixAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenPrefixAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedPrefix = "expected prefix"

		// when
		try! restriction.set(attribute: Me.prefixAttribute, to: expectedPrefix)

		// then
		XCTAssertEqual(restriction.prefix, expectedPrefix)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndEmptyPrefixForRestriction_samplePasses_returnsTrue() {
		// given
		let sample = createSample(withValue: "", for: Me.attribute)
		restriction.prefix = ""

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithEmptyStringForRestrictedAttributeAndNonEmptyPrefixForRestriction_samplePasses_returnsFalse() {
		// given
		let sample = createSample(withValue: "", for: Me.attribute)
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
		let sample = createSample(withValue: sampleValue, for: Me.attribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithExactMatchForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let prefix = "exact match"
		let sample = createSample(withValue: prefix, for: Me.attribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let prefix = "prefix"
		let sample = createSample(withValue: prefix + " some other stuff", for: Me.attribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleThatEndsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let suffix = "suffix"
		let sample = createSample(withValue: "some other stuff" + suffix, for: Me.attribute)
		restriction.prefix = suffix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func textGivenSampleThatStartsWithPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let prefix = "prefix"
		let sample = createSample(withValue: "some " + prefix + " other stuff", for: Me.attribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}

	func testGivenSampleWithValueAndEmptyPrefixForRestrictedAttribute_samplePasses_returnsTrue() {
		// given
		let sample = createSample(withValue: "some stuff", for: Me.attribute)
		restriction.prefix = ""

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssert(startsWith)
	}

	func testGivenSampleWithNonEmptyStringThatDoesNotContainPrefixForRestrictedAttribute_samplePasses_returnsFalse() {
		// given
		let prefix = "this is definitely not contained in the text the sample has"
		let sample = createSample(withValue: "i am not empty", for: Me.attribute)
		restriction.prefix = prefix

		// when
		let startsWith = try! restriction.samplePasses(sample)

		// then
		XCTAssertFalse(startsWith)
	}
}
