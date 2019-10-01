//
//  BeforeTimeOfDayAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Common
@testable import Queries

final class BeforeTimeOfDayAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = BeforeTimeOfDayAttributeRestrictionUnitTests
	private static let timeAttribute = BeforeTimeOfDayAttributeRestriction.timeAttribute
	private static let restrictedAttribute = DateTimeAttribute(name: "date")

	private var restriction: BeforeTimeOfDayAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsBefore() {
		// given
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: ""))

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString("Before"))
	}

	func test_description_containsTimeOfDay() {
		// given
		let timeOfDay = TimeOfDay(Date())
		restriction.timeOfDay = timeOfDay

		let expectedTimeString = "i should be in the description"
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: expectedTimeString))

		// when
		let description = restriction.description

		// then
		assertThat(description, containsString(expectedTimeString))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
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

	// MARK: - set(attribute: to:)

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.timeAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
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

	// MARK: - samplePasses()

	func testGivenSampleWithNonDateValueForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1 as Any))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
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

	func testGivenNilSampleValue_samplePasses_returnsFalse() throws {
		// given
		let sample = SampleCreatorTestUtil.createSample(withValue: nil as Any?, for: Me.restrictedAttribute)

		// when
		let samplePasses = try restriction.samplePasses(sample)

		// then
		XCTAssertFalse(samplePasses)
	}

	// MARK: - copy()

	func test_copy_returnsCopy() {
		// given
		Given(mockCalendarUtil, .string(for: .any, dateStyle: .any, timeStyle: .any, willReturn: "abc"))

		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? BeforeTimeOfDayAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() {
		// given
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentTimesOfDay_equalToOperator_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: timeOfDay)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction == other

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(attributed:)

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
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentTimesOfDay_equalToAttributed_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo(restriction:)

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherRestriction: AttributeRestriction = LessThanDoubleAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute)

		// when
		let equal = restriction.equalTo(otherRestriction)

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
		let otherRestriction: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentTimesOfDay_equalToRestriction_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let otherRestriction: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherRestriction: AttributeRestriction = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssert(equal)
	}

	// MARK: - equalTo()

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let equal = restriction.equalTo(restriction)

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalTo_returnsFalse() {
		// given
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentTimesOfDay_equalTo_returnsFalse() {
		// given
		var timeOfDay = restriction.timeOfDay
		timeOfDay.hour += 1
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: timeOfDay)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = BeforeTimeOfDayAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			timeOfDay: restriction.timeOfDay)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
