//
//  SexualActivityUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class SexualActivityUnitTests: UnitTest {

	private typealias Me = SexualActivityUnitTests
	private static let timestamp = Date()
	private static let protectionUsed: SexualActivity.Protection = .unspecified

	private final var sexualActivity: SexualActivity!

	final override func setUp() {
		super.setUp()
		sexualActivity = SexualActivity(Me.timestamp, Me.protectionUsed)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try sexualActivity.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenProtectionUsedAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let protectionUsed = try sexualActivity.value(of: SexualActivity.protectionUsed) as? SexualActivity.Protection

		// then
		XCTAssertEqual(protectionUsed, Me.protectionUsed)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let timestamp = try sexualActivity.value(of: CommonSampleAttributes.healthKitTimestamp) as? Date

		// then
		XCTAssertEqual(timestamp, Me.timestamp)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try sexualActivity.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenProtectionUsedAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try sexualActivity.set(attribute: SexualActivity.protectionUsed, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenProtectionUsedAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = SexualActivity.Protection.used

		// when
		try sexualActivity.set(attribute: SexualActivity.protectionUsed, to: expectedValue)

		// then
		XCTAssertEqual(sexualActivity.protectionUsed, expectedValue)
	}

	func testGivenTimestampAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try sexualActivity.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try sexualActivity.set(attribute: CommonSampleAttributes.healthKitTimestamp, to: expectedValue)

		// then
		XCTAssertEqual(sexualActivity.timestamp, expectedValue)
	}

	// MARK: - ==

	func testGivenTimestampMismatch_equalToOperator_returnsFalse() {
		// given
		let otherTimestamp = sexualActivity.timestamp + 1.days
		let otherSexualActivity = SexualActivity(otherTimestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity == otherSexualActivity

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenProtectionUsedMismatch_equalToOperator_returnsFalse() {
		// given
		let otherProtectionUsed = SexualActivity.Protection.used
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, otherProtectionUsed)

		// when
		let areEqual = sexualActivity == otherSexualActivity

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = sexualActivity == sexualActivity

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSexualActivitiesWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity == otherSexualActivity

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = sexualActivity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherTimestamp = sexualActivity.timestamp + 1.days
		let otherSexualActivity = SexualActivity(otherTimestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenProtectionUsedMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherProtectionUsed = SexualActivity.Protection.used
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, otherProtectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = sexualActivity.equalTo(sexualActivity as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSexualActivitiesWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = sexualActivity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToSample_returnsFalse() {
		// given
		let otherTimestamp = sexualActivity.timestamp + 1.days
		let otherSexualActivity = SexualActivity(otherTimestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenProtectionUsedMismatch_equalToSample_returnsFalse() {
		// given
		let otherProtectionUsed = SexualActivity.Protection.used
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, otherProtectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = sexualActivity.equalTo(sexualActivity as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSexualActivitiesWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sexualActivity:)

	func testGivenTimestampMismatch_equalTo_returnsFalse() {
		// given
		let otherTimestamp = sexualActivity.timestamp + 1.days
		let otherSexualActivity = SexualActivity(otherTimestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenProtectionUsedMismatch_equalTo_returnsFalse() {
		// given
		let otherProtectionUsed = SexualActivity.Protection.used
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, otherProtectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = sexualActivity.equalTo(sexualActivity)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSexualActivitiesWithSameValues_equalTo_returnsTrue() {
		// given
		let otherSexualActivity = SexualActivity(sexualActivity.timestamp, sexualActivity.protectionUsed)

		// when
		let areEqual = sexualActivity.equalTo(otherSexualActivity)

		// then
		XCTAssert(areEqual)
	}
}
