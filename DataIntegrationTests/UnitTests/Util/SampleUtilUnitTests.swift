//
//  SampleUtilUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import HealthKit
import SwiftyMocky
@testable import DataIntegration

class SampleUtilUnitTests: UnitTest {

	fileprivate var util: SampleUtilImpl!

    override func setUp() {
        super.setUp()
		util = SampleUtilImpl()
    }

	func testGivenEmptyDayOfWeekSet_sampleOccursOnOneOf_returnsTrue() {
		// given
		let sample = createSample(5.0)

		// when
		let occurs = util.sample(sample, occursOnOneOf: Set<DayOfWeek>())

		// then
		XCTAssert(occurs)
	}

	func testGivenEmptySamplesArray_convertOneDateSamplesToTwoDateSamples_returnsEmptyArray() {
		// given
		let samples = [Sample]()

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return true
			},
			joinSamples: { (_ , _, _) -> Sample in
				return createSample(0.0)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 0)
	}

	func testGivenTwoSamplesThatShouldBeCombined_convertOneDateSamplesToTwoDateSamples_combinesThemWithCorrectDates() {
		// given
		let expectedStartDate = Date()
		let expectedEndDate = Calendar.autoupdatingCurrent.date(byAdding: .year, value: 1, to: expectedStartDate)!
		let samples = createSamples(withValues: [
			(date: expectedStartDate, value: 0.0),
			(date: expectedEndDate, value: 0.0),
		])
		Given(mockCalendarUtil, .compare(date1: .value(expectedStartDate), date2: .value(expectedEndDate), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(expectedEndDate), date2: .value(expectedStartDate), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return false
			},
			joinSamples: { (_, start: Date, end: Date) -> Sample in
				return createSample(start: start, end: end, value: 0.0)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 1)
		XCTAssert(convertedSamples[0].dates[.start] == expectedStartDate)
		XCTAssert(convertedSamples[0].dates[.end] == expectedEndDate)
	}

	// TODO - finish writing unit tests
}
