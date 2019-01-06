//
//  AfterDateAttributeRestrictionUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
@testable import Introspective

class AfterDateAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = AfterDateAttributeRestrictionUnitTests
	fileprivate static let dateAttribute = AfterDateAttributeRestriction.dateAttribute
	fileprivate static let restrictedAttribute = DateOnlyAttribute(name: "unknown")

	fileprivate var restriction: AfterDateAttributeRestriction!

	override func setUp() {
		super.setUp()
		restriction = AfterDateAttributeRestriction(restrictedAttribute: Me.restrictedAttribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: Me.restrictedAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenDateAttribute_valueOf_returnsCorrectDate() {
		// given
		let expectedDate = oldDate()
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(expectedDate), willReturn: expectedDate))
		restriction.date = expectedDate

		// when
		let actualDate = try! restriction.value(of: Me.dateAttribute) as! Date

		// then
		XCTAssertEqual(actualDate, expectedDate)
	}

	func testGivenUnknownAttribute_setAttributeTo_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.restrictedAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.dateAttribute, to: 1 as Any)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenDateAttributeAndValidValue_setAttributeTo_setsDateToCorrectValue() {
		// given
		let expectedDate = oldDate()
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(expectedDate), willReturn: expectedDate))

		// when
		try! restriction.set(attribute: Me.dateAttribute, to: expectedDate)

		// then
		XCTAssertEqual(restriction.date, expectedDate)
	}

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

	func testGivenSampleWithDateForGivenAttributeThatIsAfterSpecifiedDate_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = oldDate()
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(restrictionDate), willReturn: restrictionDate))
		restriction.date = restrictionDate
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: Date()))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsBeforeSpecifiedDate_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = Date()
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(restrictionDate), willReturn: restrictionDate))
		restriction.date = restrictionDate
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: oldDate()))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsOnSameDayAsSpecifiedDate_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = Date(year: 2018, month: 1, day: 1, hour: 3, minute: 2, second: 1)
		let endOfRestrictionDate = Date(year: 2018, month: 1, day: 1, hour: 23, minute: 59, second: 59)
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(restrictionDate), willReturn: endOfRestrictionDate))
		restriction.date = restrictionDate
		let sampleDate = Date(year: 2018, month: 1, day: 1, hour: 4, minute: 2, second: 1)
		Given(mockSample, .value(of: .value(Me.restrictedAttribute), willReturn: sampleDate))

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
		let otherAttributed: Attributed = AfterDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToAttributed_returnsFalse() {
		// given
		let otherAttributed: Attributed = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date + 1.days)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToAttributed_returnsTrue() {
		// given
		let otherAttributed: Attributed = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date)

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
		let otherAttributed: AttributeRestriction = AfterDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalToRestriction_returnsFalse() {
		// given
		let otherAttributed: AttributeRestriction = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date + 1.days)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalToRestriction_returnsTrue() {
		// given
		let otherAttributed: AttributeRestriction = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date)

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
		let otherAttributed = AfterDateAttributeRestriction(restrictedAttribute: DateOnlyAttribute(name: "not the same attribute"))

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameClassWithSameAttributeButDifferentSubstrings_equalTo_returnsFalse() {
		// given
		let otherAttributed = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date + 1.days)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssertFalse(equal)
	}

	func testGivenSameMatcherTypeWithAllSameAttributes_equalTo_returnsTrue() {
		// given
		let otherAttributed = AfterDateAttributeRestriction(restrictedAttribute: restriction.restrictedAttribute, date: restriction.date)

		// when
		let equal = restriction.equalTo(otherAttributed)

		// then
		XCTAssert(equal)
	}
}
