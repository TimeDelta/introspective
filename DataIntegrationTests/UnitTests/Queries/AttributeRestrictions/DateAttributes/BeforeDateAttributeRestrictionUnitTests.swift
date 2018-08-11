//
//  BeforeDateAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class BeforeDateAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = BeforeDateAttributeRestrictionUnitTests
	fileprivate static let dateAttribute = BeforeDateAttributeRestriction.dateAttribute

	fileprivate var attribute: Attribute!
	fileprivate var restriction: BeforeDateAttributeRestriction!

	override func setUp() {
		super.setUp()
		attribute = AttributeBase(name: "attribute")
		restriction = BeforeDateAttributeRestriction(attribute: attribute)
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
		Given(mockCalendarUtil, .start(of: .value(.day), in: .value(expectedDate), willReturn: expectedDate))
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
		Given(mockCalendarUtil, .start(of: .value(.day), in: .value(expectedDate), willReturn: expectedDate))

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

	func testGivenSampleWithDateForGivenAttributeThatIsBeforeSpecifiedDate_samplePasses_returnsTrue() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = Date()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .value(restrictionDate), willReturn: restrictionDate))
		restriction.date = restrictionDate
		Given(mockSample, .value(of: .value(attribute), willReturn: oldDate()))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssert(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsAfterSpecifiedDate_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = oldDate()
		Given(mockCalendarUtil, .start(of: .value(.day), in: .value(restrictionDate), willReturn: restrictionDate))
		restriction.date = restrictionDate
		Given(mockSample, .value(of: .value(attribute), willReturn: Date()))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}

	func testGivenSampleWithDateForGivenAttributeThatIsOnSameDayAsSpecifiedDate_samplePasses_returnsFalse() {
		// given
		let mockSample = SampleMock()
		let restrictionDate = Date(year: 2018, month: 1, day: 1, hour: 3, minute: 2, second: 1)
		let startOfRestrictionDate = Date(year: 2018, month: 1, day: 1, hour: 0, minute: 0, second: 0)
		Given(mockCalendarUtil, .start(of: .value(.day), in: .value(restrictionDate), willReturn: startOfRestrictionDate))
		restriction.date = restrictionDate
		let sampleDate = Date(year: 2018, month: 1, day: 1, hour: 2, minute: 2, second: 1)
		Given(mockSample, .value(of: .value(attribute), willReturn: sampleDate))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}
}
