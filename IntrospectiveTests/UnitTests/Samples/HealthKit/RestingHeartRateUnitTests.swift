//
//  RestingHeartRateUnitTests.swift
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

final class RestingHeartRateUnitTests: UnitTest {

	private typealias Me = RestingHeartRateUnitTests
	private static let timestamp = Date()
	private static let bpm = 20.0

	private final var heartRate: RestingHeartRate!

	final override func setUp() {
		super.setUp()
		heartRate = RestingHeartRate(Me.bpm, Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try heartRate.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenHeartRateAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let bpm = try heartRate.value(of: RestingHeartRate.restingHeartRate) as? Double

		// then
		XCTAssertEqual(bpm, Me.bpm)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try heartRate.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try heartRate.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenHeartRateAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try heartRate.set(attribute: RestingHeartRate.restingHeartRate, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenHeartRateAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = heartRate.restingHeartRate + 1

		// when
		try heartRate.set(attribute: RestingHeartRate.restingHeartRate, to: expectedValue)

		// then
		XCTAssertEqual(heartRate.restingHeartRate, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try heartRate.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try heartRate.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(heartRate.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = heartRate.timestamp + 1.days
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, otherTimestamp)

		// when
		let areEqual = heartRate == otherHeartRate

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBpmMismatch_equalToOperator_returnsFalse() {
		// given
		let otherBpm = heartRate.restingHeartRate + 1
		let otherHeartRate = RestingHeartRate(otherBpm, heartRate.timestamp)

		// when
		let areEqual = heartRate == otherHeartRate

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = heartRate == heartRate

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoRestingHeartRatesWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, heartRate.timestamp)

		// when
		let areEqual = heartRate == otherHeartRate

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = heartRate.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = heartRate.timestamp + 1.days
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, otherTimestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBpmMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherBpm = heartRate.restingHeartRate + 1
		let otherHeartRate = RestingHeartRate(otherBpm, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = heartRate.equalTo(heartRate as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoHeartRatesWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = heartRate.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = heartRate.timestamp + 1.days
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, otherTimestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBpmMismatch_equalToSample_returnsFalse() {
		// given
		let otherBpm = heartRate.restingHeartRate + 1
		let otherHeartRate = RestingHeartRate(otherBpm, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = heartRate.equalTo(heartRate as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoHeartRatesWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(RestingHeartRate:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = heartRate.timestamp + 1.days
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, otherTimestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenBpmMismatch_equalTo_returnsFalse() {
		// given
		let otherBpm = heartRate.restingHeartRate + 1
		let otherHeartRate = RestingHeartRate(otherBpm, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = heartRate.equalTo(heartRate)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoHeartRatesWithSameValues_equalTo_returnsTrue() {
		// given
		let otherHeartRate = RestingHeartRate(heartRate.restingHeartRate, heartRate.timestamp)

		// when
		let areEqual = heartRate.equalTo(otherHeartRate)

		// then
		XCTAssert(areEqual)
	}
}
