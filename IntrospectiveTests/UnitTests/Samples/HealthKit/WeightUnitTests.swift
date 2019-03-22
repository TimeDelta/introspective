//
//  WeightUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class WeightUnitTests: UnitTest {

	private typealias Me = WeightUnitTests
	private static let timestamp = Date()
	private static let weight = 20.0

	private final var weight: Weight!

	final override func setUp() {
		super.setUp()
		weight = Weight(Me.weight, Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try weight.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWeightAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let mass = try weight.value(of: Weight.weight) as? Double

		// then
		XCTAssertEqual(mass, Me.weight)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try weight.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try weight.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWeightAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try weight.set(attribute: Weight.weight, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenWeightAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = weight.weight + 1

		// when
		try weight.set(attribute: Weight.weight, to: expectedValue)

		// then
		XCTAssertEqual(weight.weight, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try weight.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try weight.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(weight.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = weight.timestamp + 1.days
		let otherWeight = Weight(weight.weight, otherTimestamp)

		// when
		let areEqual = weight == otherWeight

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToOperator_returnsFalse() {
		// given
		let otherMass = weight.weight + 1
		let otherWeight = Weight(otherMass, weight.timestamp)

		// when
		let areEqual = weight == otherWeight

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = weight == weight

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoWeightsWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherWeight = Weight(weight.weight, weight.timestamp)

		// when
		let areEqual = weight == otherWeight

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = weight.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = weight.timestamp + 1.days
		let otherWeight = Weight(weight.weight, otherTimestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherMass = weight.weight + 1
		let otherWeight = Weight(otherMass, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = weight.equalTo(weight as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoWeightsWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherWeight = Weight(weight.weight, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = weight.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = weight.timestamp + 1.days
		let otherWeight = Weight(weight.weight, otherTimestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalToSample_returnsFalse() {
		// given
		let otherMass = weight.weight + 1
		let otherWeight = Weight(otherMass, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = weight.equalTo(weight as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoWeightsWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherWeight = Weight(weight.weight, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(weight:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = weight.timestamp + 1.days
		let otherWeight = Weight(weight.weight, otherTimestamp)

		// when
		let areEqual = weight.equalTo(otherWeight)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenMassMismatch_equalTo_returnsFalse() {
		// given
		let otherMass = weight.weight + 1
		let otherWeight = Weight(otherMass, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = weight.equalTo(weight)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoWeightsWithSameValues_equalTo_returnsTrue() {
		// given
		let otherWeight = Weight(weight.weight, weight.timestamp)

		// when
		let areEqual = weight.equalTo(otherWeight)

		// then
		XCTAssert(areEqual)
	}
}
