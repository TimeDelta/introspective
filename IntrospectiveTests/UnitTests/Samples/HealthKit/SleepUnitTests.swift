//
//  SleepUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Samples

final class SleepUnitTests: UnitTest {

	private typealias Me = SleepUnitTests
	private static let startDate = Date()
	private static let endDate = Date() + 8.hours
	private static let sleepState: Sleep.State = .asleep

	private final var sleep: Sleep!

	final override func setUp() {
		super.setUp()
		sleep = Sleep(Me.sleepState, startDate: Me.startDate, endDate: Me.endDate)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try sleep.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenSleepStateAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let sleepState = try sleep.value(of: Sleep.stateAttribute) as? Sleep.State

		// then
		XCTAssertEqual(sleepState, Me.sleepState)
	}

	func testGivenStartDateAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let startDate = try sleep.value(of: CommonSampleAttributes.healthKitStartDate) as? Date

		// then
		XCTAssertEqual(startDate, Me.startDate)
	}

	func testGivenEndDateAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let endDate = try sleep.value(of: CommonSampleAttributes.healthKitEndDate) as? Date

		// then
		XCTAssertEqual(endDate, Me.endDate)
	}

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttribute_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")
		let value = ""

		// when
		XCTAssertThrowsError(try sleep.set(attribute: unknownAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenSleepStateAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try sleep.set(attribute: Sleep.stateAttribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSleepStateAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Sleep.State.awake

		// when
		try sleep.set(attribute: Sleep.stateAttribute, to: expectedValue)

		// then
		XCTAssertEqual(sleep.state, expectedValue)
	}

	func testGivenStartDateAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try sleep.set(attribute: CommonSampleAttributes.healthKitStartDate, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenStartDateAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try sleep.set(attribute: CommonSampleAttributes.healthKitStartDate, to: expectedValue)

		// then
		XCTAssertEqual(sleep.startDate, expectedValue)
	}

	func testGivenEndDateAttributeWithWrongValueType_setAttribute_throwsTypeMismatchError() {
		// given
		let value = "abc"

		// when
		XCTAssertThrowsError(try sleep.set(attribute: CommonSampleAttributes.healthKitEndDate, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenEndDateAttributeWithCorrectValueType_setAttribute_correctlySetsValue() throws {
		// given
		let expectedValue = Date() - 1.days

		// when
		try sleep.set(attribute: CommonSampleAttributes.healthKitEndDate, to: expectedValue)

		// then
		XCTAssertEqual(sleep.endDate, expectedValue)
	}

	// MARK: - ==

	func testGivenStartDateMismatch_equalToOperator_returnsFalse() {
		// given
		let otherStartDate = sleep.startDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: otherStartDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep == otherSleep

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalToOperator_returnsFalse() {
		// given
		let otherEndDate = sleep.endDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: otherEndDate)

		// when
		let areEqual = sleep == otherSleep

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSleepStateMismatch_equalToOperator_returnsFalse() {
		// given
		let otherSleepState = Sleep.State.awake
		let otherSleep = Sleep(otherSleepState, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep == otherSleep

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = sleep == sleep

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSleepsWithSameValues_equalToOperator_returnsTrue() {
		// given
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep == otherSleep

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = EqualToStringAttributeRestriction(restrictedAttribute: TextAttribute(name: ""), value: "")

		// when
		let areEqual = sleep.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenStartDateMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherStartDate = sleep.startDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: otherStartDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherEndDate = sleep.endDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: otherEndDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSleepStateMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherSleepState = Sleep.State.awake
		let otherSleep = Sleep(otherSleepState, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = sleep.equalTo(sleep as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSleepsWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = sleep.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenStartDateMismatch_equalToSample_returnsFalse() {
		// given
		let otherStartDate = sleep.startDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: otherStartDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalToSample_returnsFalse() {
		// given
		let otherEndDate = sleep.endDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: otherEndDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSleepStateMismatch_equalToSample_returnsFalse() {
		// given
		let otherSleepState = Sleep.State.awake
		let otherSleep = Sleep(otherSleepState, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let areEqual = sleep.equalTo(sleep as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSleepsWithSameValues_equalToSample_returnsTrue() {
		// given
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sleep:)

	func testGivenStartDateMismatch_equalTo_returnsFalse() {
		// given
		let otherStartDate = sleep.startDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: otherStartDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalTo_returnsFalse() {
		// given
		let otherEndDate = sleep.endDate + 1.days
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: otherEndDate)

		// when
		let areEqual = sleep.equalTo(otherSleep)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSleepStateMismatch_equalTo_returnsFalse() {
		// given
		let otherSleepState = Sleep.State.awake
		let otherSleep = Sleep(otherSleepState, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let areEqual = sleep.equalTo(sleep)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoSleepsWithSameValues_equalTo_returnsTrue() {
		// given
		let otherSleep = Sleep(sleep.state, startDate: sleep.startDate, endDate: sleep.endDate)

		// when
		let areEqual = sleep.equalTo(otherSleep)

		// then
		XCTAssert(areEqual)
	}
}
