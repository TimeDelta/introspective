//
//  BodyMassIndexUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Samples

final class BodyMassIndexUnitTests: UnitTest {

	private typealias Me = BodyMassIndexUnitTests
	private static let timestamp = Date()
	private static let ratio = 20.0

	private final var bmi: BodyMassIndex!

	final override func setUp() {
		super.setUp()
		bmi = BodyMassIndex(Me.ratio, Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try bmi.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenBmiAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let ratio = try bmi.value(of: BodyMassIndex.bmi) as? Double

		// then
		XCTAssertEqual(ratio, Me.ratio)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try bmi.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try bmi.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenBmiAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try bmi.set(attribute: BodyMassIndex.bmi, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenBmiAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = bmi.bmi + 1

		// when
		try bmi.set(attribute: BodyMassIndex.bmi, to: expectedValue)

		// then
		XCTAssertEqual(bmi.bmi, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try bmi.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try bmi.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(bmi.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = bmi.timestamp + 1.days
		let otherBmi = BodyMassIndex(bmi.bmi, otherTimestamp)

		// when
		let areEqual = bmi == otherBmi

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBmiMismatch_equalToOperator_returnsFalse() {
		// given
		let otherRatio = bmi.bmi + 1
		let otherBmi = BodyMassIndex(otherRatio, bmi.timestamp)

		// when
		let areEqual = bmi == otherBmi

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = bmi == bmi

		// then
		XCTAssert(areEqual)
	}

	func testGivenBodyMassIndexesWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherBmi = BodyMassIndex(bmi.bmi, bmi.timestamp)

		// when
		let areEqual = bmi == otherBmi

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = bmi.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = bmi.timestamp + 1.days
		let otherBmi = BodyMassIndex(bmi.bmi, otherTimestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBmiMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherRatio = bmi.bmi + 1
		let otherBmi = BodyMassIndex(otherRatio, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = bmi.equalTo(bmi as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBmisWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherBmi = BodyMassIndex(bmi.bmi, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = bmi.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = bmi.timestamp + 1.days
		let otherBmi = BodyMassIndex(bmi.bmi, otherTimestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBmiMismatch_equalToSample_returnsFalse() {
		// given
		let otherRatio = bmi.bmi + 1
		let otherBmi = BodyMassIndex(otherRatio, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = bmi.equalTo(bmi as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBmisWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherBmi = BodyMassIndex(bmi.bmi, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(bodyMassIndex:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = bmi.timestamp + 1.days
		let otherBmi = BodyMassIndex(bmi.bmi, otherTimestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBmiMismatch_equalTo_returnsFalse() {
		// given
		let otherRatio = bmi.bmi + 1
		let otherBmi = BodyMassIndex(otherRatio, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = bmi.equalTo(bmi)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBmisWithSameValues_equalTo_returnsTrue() {
		// given
		let otherBmi = BodyMassIndex(bmi.bmi, bmi.timestamp)

		// when
		let areEqual = bmi.equalTo(otherBmi)

		// then
		XCTAssert(areEqual)
	}
}
