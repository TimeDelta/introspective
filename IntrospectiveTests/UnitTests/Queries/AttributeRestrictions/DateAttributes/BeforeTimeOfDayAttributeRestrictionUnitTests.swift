//
//  BeforeTimeOfDayAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

class BeforeTimeOfDayAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = BeforeTimeOfDayAttributeRestrictionUnitTests
	fileprivate static let timeAttribute = BeforeTimeOfDayAttributeRestriction.timeAttribute
	fileprivate static let restrictedAttribute = DateTimeAttribute(name: "date")

	fileprivate var restriction: BeforeTimeOfDayAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenTimeAttribute_valueOf_returnsCorrectTimeOfDay() {
		// given
		var expectedTimeOfDay = TimeOfDay()
		expectedTimeOfDay.hour = 15
		expectedTimeOfDay.minute = 23
		restriction.timeOfDay = expectedTimeOfDay

		// when
		let actualTimeOfDay = try! restriction.value(of: Me.timeAttribute) as! TimeOfDay

		// then
		XCTAssertEqual(actualTimeOfDay, expectedTimeOfDay)
	}

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.timeAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenTimeAttributeAndValidValue_setAttributeTo_setsTimeOfDayToCorrectValue() {
		// given
		var timeOfDay = TimeOfDay()
		timeOfDay.hour = 18
		timeOfDay.minute = 52

		// when
		try! restriction.set(attribute: Me.timeAttribute, to: timeOfDay)

		// then
		XCTAssertEqual(restriction.timeOfDay, timeOfDay)
	}

	func testGivenSampleWithNonDateValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
		}
	}

	func testGivenSampleWithDateForGivenAttributeThatIsBeforeSpecifiedTimeOfDay_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		var timeOfDay = TimeOfDay()
		timeOfDay.hour = 1
		timeOfDay.minute = 0
		restriction.timeOfDay = timeOfDay
		let date = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 0, of: Date())!
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: date))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsAfterSpecifiedTimeOfDay_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		var timeOfDay = TimeOfDay()
		timeOfDay.hour = 0
		timeOfDay.minute = 0
		restriction.timeOfDay = timeOfDay
		let date = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 1, of: Date())!
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: date))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
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
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let otherAttributed: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: restriction.timeOfDay)

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
		let otherAttributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let otherAttributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}