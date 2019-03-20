//
//  BloodPressureUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class BloodPressureUnitTests: UnitTest {

	private typealias Me = BloodPressureUnitTests
	private static let timestamp = Date()
	private static let systolic = 120.0
	private static let diastolic = 80.0

	private final var bloodPressure: BloodPressure!

	final override func setUp() {
		super.setUp()
		bloodPressure = BloodPressure(systolic: Me.systolic, diastolic: Me.diastolic, Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try bloodPressure.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenSystolicAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let systolic = try bloodPressure.value(of: BloodPressure.systolic) as? Double

		// then
		XCTAssertEqual(systolic, Me.systolic)
	}

	func testGivenDiastolicAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let diastolic = try bloodPressure.value(of: BloodPressure.diastolic) as? Double

		// then
		XCTAssertEqual(diastolic, Me.diastolic)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try bloodPressure.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try bloodPressure.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenSystolicAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try bloodPressure.set(attribute: BloodPressure.systolic, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSystolicAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = 12.3

		// when
		try bloodPressure.set(attribute: BloodPressure.systolic, to: expectedValue)

		// then
		XCTAssertEqual(bloodPressure.systolic, expectedValue)
	}

	func testGivenDiastolicAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try bloodPressure.set(attribute: BloodPressure.diastolic, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenDiastolicAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = 12.3

		// when
		try bloodPressure.set(attribute: BloodPressure.diastolic, to: expectedValue)

		// then
		XCTAssertEqual(bloodPressure.diastolic, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try bloodPressure.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try bloodPressure.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(bloodPressure.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = bloodPressure.timestamp + 1.days
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: bloodPressure.diastolic, otherTimestamp)

		// when
		let areEqual = bloodPressure == otherBloodPressure

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDiastolicMismatch_equalToOperator_returnsFalse() {
		// given
		let otherDiastolic = bloodPressure.diastolic + 1
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: otherDiastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure == otherBloodPressure

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSystolicMismatch_equalToOperator_returnsFalse() {
		// given
		let otherSystolic = bloodPressure.systolic + 1
		let otherBloodPressure = BloodPressure(systolic: otherSystolic, diastolic: bloodPressure.diastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure == otherBloodPressure

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = bloodPressure == bloodPressure

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBloodPressuresWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherBloodPressure = BloodPressure(
			systolic: bloodPressure.systolic,
			diastolic: bloodPressure.diastolic,
			bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure == otherBloodPressure

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = bloodPressure.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = bloodPressure.timestamp + 1.days
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: bloodPressure.diastolic, otherTimestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDiastolicMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherDiastolic = bloodPressure.diastolic + 1
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: otherDiastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSystolicMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherSystolic = bloodPressure.systolic + 1
		let otherBloodPressure = BloodPressure(systolic: otherSystolic, diastolic: bloodPressure.diastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = bloodPressure.equalTo(bloodPressure as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBloodPressuresWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherBloodPressure = BloodPressure(
			systolic: bloodPressure.systolic,
			diastolic: bloodPressure.diastolic,
			bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12.3, Date())

		// when
		let areEqual = bloodPressure.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = bloodPressure.timestamp + 1.days
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: bloodPressure.diastolic, otherTimestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDiastolicMismatch_equalToSample_returnsFalse() {
		// given
		let otherDiastolic = bloodPressure.diastolic + 1
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: otherDiastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSystolicMismatch_equalToSample_returnsFalse() {
		// given
		let otherSystolic = bloodPressure.systolic + 1
		let otherBloodPressure = BloodPressure(systolic: otherSystolic, diastolic: bloodPressure.diastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = bloodPressure.equalTo(bloodPressure as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBloodPressuresWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherBloodPressure = BloodPressure(
			systolic: bloodPressure.systolic,
			diastolic: bloodPressure.diastolic,
			bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(bloodPressure:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = bloodPressure.timestamp + 1.days
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: bloodPressure.diastolic, otherTimestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDiastolicMismatch_equalTo_returnsFalse() {
		// given
		let otherDiastolic = bloodPressure.diastolic + 1
		let otherBloodPressure = BloodPressure(systolic: bloodPressure.systolic, diastolic: otherDiastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSystolicMismatch_equalTo_returnsFalse() {
		// given
		let otherSystolic = bloodPressure.systolic + 1
		let otherBloodPressure = BloodPressure(systolic: otherSystolic, diastolic: bloodPressure.diastolic, bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = bloodPressure.equalTo(bloodPressure)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoBloodPressuresWithSameValues_equalTo_returnsTrue() {
		// given
		let otherBloodPressure = BloodPressure(
			systolic: bloodPressure.systolic,
			diastolic: bloodPressure.diastolic,
			bloodPressure.timestamp)

		// when
		let areEqual = bloodPressure.equalTo(otherBloodPressure)

		// then
		XCTAssert(areEqual)
	}
}
