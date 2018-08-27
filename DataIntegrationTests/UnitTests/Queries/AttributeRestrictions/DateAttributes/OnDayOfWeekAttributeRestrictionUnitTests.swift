//
//  OnDayOfWeekAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class OnDayOfWeekAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = OnDayOfWeekAttributeRestrictionUnitTests
	fileprivate static let daysOfWeekAttribute = OnDayOfWeekAttributeRestriction.daysOfWeekAttribute

	private var attribute: Attribute!
	private var restriction: OnDayOfWeekAttributeRestriction!

	override func setUp() {
		super.setUp()
		attribute = AttributeBase(name: "attribute")
		restriction = OnDayOfWeekAttributeRestriction(attribute: attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: attribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
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

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: attribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.daysOfWeekAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
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

	func testGivenSampleWithWrongValueTypeForGivenAttribute_samplePasses_throwsTypeMismatchError() {
		// given
		let mockSample = SampleMock()
		Given(mockSample, .value(of: .value(attribute), willReturn: 1))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? SampleError, SampleError.typeMismatch)
		}
	}

	func testGivenSampleWithDateThatIsNotOnOneOfTheSpecifiedDaysOfTheWeek_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDaysOfWeek = Set<DayOfWeek>([DayOfWeek.Friday])
		restriction.daysOfWeek = restrictionDaysOfWeek
		let sampleDate = Date()
		Given(mockSample, .value(of: .value(attribute), willReturn: sampleDate))
		Given(mockCalendarUtil, .date(date: .value(sampleDate), isOnOneOf: .value(restrictionDaysOfWeek), willReturn: false))

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
		Given(mockSample, .value(of: .value(attribute), willReturn: sampleDate))
		Given(mockCalendarUtil, .date(date: .value(sampleDate), isOnOneOf: .value(restrictionDaysOfWeek), willReturn: true))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
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
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(attribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: restriction.daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}

	func testGivenOtherOfDifferentTypes_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = LessThanNumericAttributeRestriction(attribute: restriction.restrictedAttribute)

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
		let otherAttributed: AttributeRestriction = OnDayOfWeekAttributeRestriction(attribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let otherAttributed: AttributeRestriction = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: restriction.daysOfWeek)

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
		let otherAttributed = OnDayOfWeekAttributeRestriction(attribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		var daysOfWeek = restriction.daysOfWeek
		if daysOfWeek.count == 0 {
			daysOfWeek.insert(DayOfWeek.Saturday)
		} else {
			daysOfWeek.removeFirst()
		}
		let otherAttributed = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = OnDayOfWeekAttributeRestriction(attribute: restriction.restrictedAttribute, daysOfWeek: restriction.daysOfWeek)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
