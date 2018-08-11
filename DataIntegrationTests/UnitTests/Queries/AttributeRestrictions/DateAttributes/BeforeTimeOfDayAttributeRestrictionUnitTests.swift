//
//  BeforeTimeOfDayAttributeRestrictionUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import DataIntegration

class BeforeTimeOfDayAttributeRestrictionUnitTests: UnitTest {

	fileprivate typealias Me = BeforeTimeOfDayAttributeRestrictionUnitTests
	fileprivate static let timeAttribute = BeforeTimeOfDayAttributeRestriction.timeAttribute

	private var attribute: Attribute!
	private var restriction: BeforeTimeOfDayAttributeRestriction!

	override func setUp() {
		super.setUp()
		attribute = AttributeBase(name: "attribute")
		restriction = BeforeTimeOfDayAttributeRestriction(attribute: attribute)
	}

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// when
		XCTAssertThrowsError(try restriction.value(of: attribute)) { error in
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
		XCTAssertThrowsError(try restriction.set(attribute: attribute, to: 1)) { error in
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
		Given(mockSample, .value(of: .value(attribute), willReturn: 1))

		// when
		XCTAssertThrowsError(try restriction.samplePasses(mockSample)) { error in
			// then
			XCTAssertEqual(error as? SampleError, SampleError.typeMismatch)
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
		Given(mockSample, .value(of: .value(attribute), willReturn: date))

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
		Given(mockSample, .value(of: .value(attribute), willReturn: date))

		// when
		let samplePasses = try! restriction.samplePasses(mockSample)

		// then
		XCTAssertFalse(samplePasses)
	}
}