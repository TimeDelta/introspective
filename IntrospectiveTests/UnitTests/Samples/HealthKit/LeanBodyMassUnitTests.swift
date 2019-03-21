//
//  LeanBodyMassUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class LeanBodyMassUnitTests: UnitTest {

	private typealias Me = LeanBodyMassUnitTests
	private static let timestamp = Date()
	private static let mass = 20.0

	private final var leanBodyMass: LeanBodyMass!

	final override func setUp() {
		super.setUp()
		leanBodyMass = LeanBodyMass(Me.mass, Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try leanBodyMass.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenLeanBodyMassAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let mass = try leanBodyMass.value(of: LeanBodyMass.leanBodyMass) as? Double

		// then
		XCTAssertEqual(mass, Me.mass)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try leanBodyMass.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try leanBodyMass.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenLeanBodyMassAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try leanBodyMass.set(attribute: LeanBodyMass.leanBodyMass, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenLeanBodyMassAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = leanBodyMass.leanBodyMass + 1

		// when
		try leanBodyMass.set(attribute: LeanBodyMass.leanBodyMass, to: expectedValue)

		// then
		XCTAssertEqual(leanBodyMass.leanBodyMass, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try leanBodyMass.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try leanBodyMass.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(leanBodyMass.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = leanBodyMass.timestamp + 1.days
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, otherTimestamp)

		// when
		let areEqual = leanBodyMass == otherLeanBodyMass

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToOperator_returnsFalse() {
		// given
		let otherMass = leanBodyMass.leanBodyMass + 1
		let otherLeanBodyMass = LeanBodyMass(otherMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass == otherLeanBodyMass

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = leanBodyMass == leanBodyMass

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBloodPressuresWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass == otherLeanBodyMass

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = leanBodyMass.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = leanBodyMass.timestamp + 1.days
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, otherTimestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherMass = leanBodyMass.leanBodyMass + 1
		let otherLeanBodyMass = LeanBodyMass(otherMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = leanBodyMass.equalTo(leanBodyMass as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoLeanBodyMasssWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = LeanBodyMass(12, Date())

		// when
		let areEqual = leanBodyMass.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = leanBodyMass.timestamp + 1.days
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, otherTimestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToSample_returnsFalse() {
		// given
		let otherMass = leanBodyMass.leanBodyMass + 1
		let otherLeanBodyMass = LeanBodyMass(otherMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = leanBodyMass.equalTo(leanBodyMass as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoLeanBodyMasssWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(LeanBodyMass:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = leanBodyMass.timestamp + 1.days
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, otherTimestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalTo_returnsFalse() {
		// given
		let otherMass = leanBodyMass.leanBodyMass + 1
		let otherLeanBodyMass = LeanBodyMass(otherMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = leanBodyMass.equalTo(leanBodyMass)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoLeanBodyMasssWithSameValues_equalTo_returnsTrue() {
		// given
		let otherLeanBodyMass = LeanBodyMass(leanBodyMass.leanBodyMass, leanBodyMass.timestamp)

		// when
		let areEqual = leanBodyMass.equalTo(otherLeanBodyMass)

		// then
		XCTAssert(areEqual)
	}
}
