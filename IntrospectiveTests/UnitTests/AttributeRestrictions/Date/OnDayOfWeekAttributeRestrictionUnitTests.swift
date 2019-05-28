//
//  OnDayOfWeekAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftyMocky
@testable import Introspective

final class OnDayOfWeekAttributeRestrictionUnitTests: UnitTest {

	private typealias Me = OnDayOfWeekAttributeRestrictionUnitTests
	private static let daysOfWeekAttribute = OnDayOfWeekAttributeRestriction.daysOfWeekAttribute
	private static let restrictedAttribute = DateTimeAttribute(name: "date")

	private var restriction: OnDayOfWeekAttributeRestriction!

	final override func setUp() {
		super.setUp()
		restriction = OnDayOfWeekAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsDaysOfWeek() {
		// given
		restriction.daysOfWeek = Set([DayOfWeek.Tuesday, DayOfWeek.Monday, DayOfWeek.Saturday])

		// when
		let description = restriction.description

		// then
		assertThat(description, containsStringsInOrder(
			DayOfWeek.Monday.abbreviation,
			DayOfWeek.Tuesday.abbreviation,
			DayOfWeek.Saturday.abbreviation
		))
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenDaysOfWeekAttribute_valueOf_returnsCorrectDaysOfWeek() {
		// given
		let expectedDaysOfWeek = Set<DayOfWeek>([DayOfWeek.Friday])
		restriction.daysOfWeek = expectedDaysOfWeek

		// when
		let actualDaysOfWeek = try! restriction.value(of: Me.daysOfWeekAttribute) as! Set<DayOfWeek>

		// then
		XCTAssertEqual(actualDaysOfWeek, expectedDaysOfWeek)
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
		XCTAssertThrowsError(try restriction.set(attribute: Me.daysOfWeekAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenDaysOfWeekAttributeAndValidValue_setAttributeTo_setsDaysOfWeekToCorrectValue() {
		// given
		let expectedDaysOfWeek = Set<DayOfWeek>([DayOfWeek.Friday])

		// when
		try! restriction.set(attribute: Me.daysOfWeekAttribute, to: expectedDaysOfWeek)

		// then
		XCTAssertEqual(restriction.daysOfWeek, expectedDaysOfWeek)
	}

	// MARK: - samplePasses()

	func testGivenSampleWithWrongValueTypeForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: 1 as Any))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenSampleWithDateThatIsNotOnOneOfTheSpecifiedDaysOfTheWeek_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDaysOfWeek = Set<DayOfWeek>([DayOfWeek.Friday])
		restriction.daysOfWeek = restrictionDaysOfWeek
		let sampleDate = Date()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: sampleDate))
		Given(mockCalendarUtil, .date(.value(sampleDate), isOnOneOf: .value(restrictionDaysOfWeek), willReturn: false))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateThatIsOnOneOfTheSpecifiedDaysOfTheWeek_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionDaysOfWeek = Set<DayOfWeek>([DayOfWeek.Friday])
		restriction.daysOfWeek = restrictionDaysOfWeek
		let sampleDate = Date()
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: sampleDate))
		Given(mockCalendarUtil, .date(.value(sampleDate), isOnOneOf: .value(restrictionDaysOfWeek), willReturn: true))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
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
		// when
		let copy = restriction.copy()

		// then
		guard let castedCopy = copy as? OnDayOfWeekAttributeRestriction else {
			XCTFail("Wrong type returned")
			return
		}
		assertThat(castedCopy, equals(restriction))
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let equal = restriction == restriction

		// then
		XCTAssert(equal)
	}

	func testGivenSameClassWithDifferentAttributes_equalToOperator_returnsFalse() {
		// given
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentDaysOfWeek_equalToOperator_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, daysOfWeek: daysOfWeek)

		// when
		let equal = restriction == other

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToOperator_returnsTrue() {
		// given
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, daysOfWeek: restriction.daysOfWeek)

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
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentDaysOfWeek_equalToAttributed_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			daysOfWeek: restriction.daysOfWeek)

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
		let otherRestriction: AttributeRestriction = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentDaysOfWeek_equalToRestriction_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let otherRestriction: AttributeRestriction = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(otherRestriction)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherRestriction: AttributeRestriction = OnDayOfWeekAttributeRestriction(
			restrictedAttribute: restriction.restrictedAttribute,
			daysOfWeek: restriction.daysOfWeek)

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
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentDaysOfWeek_equalTo_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let other = OnDayOfWeekAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, daysOfWeek: restriction.daysOfWeek)

		// when
		let equal = restriction.equalTo(other)

		// then
		XCTAssert(equal)
	}
}
