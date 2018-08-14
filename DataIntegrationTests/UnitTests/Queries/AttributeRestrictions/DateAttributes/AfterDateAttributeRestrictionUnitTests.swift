//
//  AfterDateAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class AfterDateAttributeRestrictionUnitTests: UnitTest {

    fileprivate typealias Me = AfterDateAttributeRestriction
	fileprivate static let dateAttribute = AfterDateAttributeRestriction.dateAttribute

	fileprivate var attribute: Attribute!
	fileprivate var restriction: AfterDateAttributeRestriction!

	override func setUp() {
		super.setUp()
		attribute = AnyAttribute(name: "attribute")
		restriction = AfterDateAttributeRestriction(attribute: attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: attribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
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
		XCTAssertThrowsError(try restriction.set(attribute: attribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenWrongValueType_setAttributeTo_throwsTypeMismatchError() {
		// when
		XCTAssertThrowsError(try restriction.set(attribute: Me.dateAttribute, to: 1)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.typeMismatch)
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
		Given(mockSample, .value(of: .value(attribute), willReturn: 1))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? SampleError, SampleError.typeMismatch)
		}
	}

	func testGivenSampleWithDateForGivenAttributeThatIsAfterSpecifiedDate_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = oldDate()
		Given(mockCalendarUtil, .end(of: .value(.day), in: .value(restrictionDate), willReturn: restrictionDate))
		restriction.date = restrictionDate
		Given(mockSample, .value(of: .value(attribute), willReturn: Date()))

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
		let sampleDate = oldDate()
		Given(mockSample, .value(of: .value(attribute), willReturn: sampleDate))

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
		Given(mockSample, .value(of: .value(attribute), willReturn: sampleDate))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}
}
