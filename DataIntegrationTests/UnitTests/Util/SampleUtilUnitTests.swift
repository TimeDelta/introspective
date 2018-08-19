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
import SwiftDate
@testable import DataIntegration

class SampleUtilUnitTests: UnitTest {

	fileprivate var util: SampleUtilImpl!

	override func setUp() {
		super.setUp()
		util = SampleUtilImpl()
	}

	func testGivenEmptyDayOfWeekSet_sampleOccursOnOneOf_returnsTrue() {
		// given
		let sample = createSample()

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: Set<DayOfWeek>())

		// then
		XCTAssert(onOneOf)
	}

	func testGivenEveryDayOfWeekExceptOneForDate_dateIsOnOneOf_returnsFalse() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = createSample(startDate: date)
		let daysOfWeek = Set<DayOfWeek>([
			DayOfWeek.Sunday,
			DayOfWeek.Monday,
			DayOfWeek.Tuesday,
			DayOfWeek.Wednesday,
			DayOfWeek.Thursday,
			DayOfWeek.Friday,
		])
		Given(mockCalendarUtil, .date(date: .value(date), isOnOneOf: .value(daysOfWeek), willReturn: false))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssertFalse(onOneOf)
	}

	func testGivenEveryDayOfWeek_dateIsOnOneOf_returnsTrue() {
		// given
		let sample = createSample(startDate: Date())
		let daysOfWeek = Set<DayOfWeek>(DayOfWeek.allDays)
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenOnlyDayOfWeekOnWhichDateOccurs_dateIsOnOneOf_returnsTrue() {
		// given
		let date = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = createSample(startDate: date)
		let daysOfWeek = Set<DayOfWeek>([DayOfWeek.Saturday])
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenSampleWithStartDateOnDifferentDayAndEndDateOnOneOfTheDays_dateIsOnOneOf_returnsTrue() {
		// given
		let startDate = Date()
		let endDate = DateInRegion().dateAt(.nextWeekday(.saturday)).date
		let sample = createSample(startDate: startDate, endDate: endDate)
		let daysOfWeek = Set<DayOfWeek>([DayOfWeek.Saturday])
		Given(mockCalendarUtil, .date(date: .value(startDate), isOnOneOf: .value(daysOfWeek), willReturn: false))
		Given(mockCalendarUtil, .date(date: .value(endDate), isOnOneOf: .value(daysOfWeek), willReturn: true))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssert(onOneOf)
	}

	func testGivenSampleWithStartAndEndDatesOnDifferentDays_dateIsOnOneOf_returnsFalse() {
		// given
		let sample = createSample(startDate: Date(), endDate: Date())
		let daysOfWeek = Set<DayOfWeek>(DayOfWeek.allDays)
		Given(mockCalendarUtil, .date(date: .any(Date.self), isOnOneOf: .value(daysOfWeek), willReturn: false))

		// when
		let onOneOf = util.sample(sample, occursOnOneOf: daysOfWeek)

		// then
		XCTAssertFalse(onOneOf)
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
				return createSample()
			}
		)

		// then
		XCTAssert(convertedSamples.count == 0)
	}

	func testGivenTwoSamplesThatShouldBeCombined_convertOneDateSamplesToTwoDateSamples_combinesThemWithCorrectDates() {
		// given
		let expectedStartDate = Date()
		let expectedEndDate = Calendar.autoupdatingCurrent.date(byAdding: .year, value: 1, to: expectedStartDate)!
		let samples = createSamples(withDates: [expectedStartDate, expectedEndDate])
		Given(mockCalendarUtil, .compare(date1: .value(expectedStartDate), date2: .value(expectedEndDate), willReturn: .orderedAscending))
		Given(mockCalendarUtil, .compare(date1: .value(expectedEndDate), date2: .value(expectedStartDate), willReturn: .orderedDescending))

		// when
		let convertedSamples = util.convertOneDateSamplesToTwoDateSamples(
			samples,
			samplesShouldNotBeJoined: { (_, _) -> Bool in
				return false
			},
			joinSamples: { (_, start: Date, end: Date) -> Sample in
				return createSample(startDate: start, endDate: end)
			}
		)

		// then
		XCTAssert(convertedSamples.count == 1)
		XCTAssert(convertedSamples[0].dates()[.start] == expectedStartDate)
		XCTAssert(convertedSamples[0].dates()[.end] == expectedEndDate)
	}
}
