//
//  WithinXCalendarUnitsSubQueryMatcherUnitTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 7/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import SwiftDate
@testable import DataIntegration

class WithinXCalendarUnitsSubQueryMatcherUnitTests: UnitTest {

	fileprivate var matcher: WithinXCalendarUnitsSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = WithinXCalendarUnitsSubQueryMatcher()
	}

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = createSamples(count: 2)

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = createSamples(count: 2)
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = [createSample(startDate: Date() + 1.days)] as [Sample]
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[0]), in: .value(subQuerySamples), willReturn: subQuerySamples[0]))
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[1]), in: .value(subQuerySamples), willReturn: subQuerySamples[0]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

	func testGivenMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[0]), in: .value(subQuerySamples), willReturn: subQuerySamples[0]))
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[1]), in: .value(subQuerySamples), willReturn: subQuerySamples[1]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[0]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.mostRecentOnly = true
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]
		Given(mockSampleUtil, .sort(samples: .value(subQuerySamples), by: .value(.start), in: .value(.orderedDescending), willReturn: subQuerySamples.reversed()))
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[0]), in: .value([subQuerySamples[1]]), willReturn: subQuerySamples[1]))
		Given(mockSampleUtil, .closestInTimeTo(sample: .value(querySamples[1]), in: .value([subQuerySamples[1]]), willReturn: subQuerySamples[1]))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[0]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits + 1))
		Given(mockSampleUtil, .distance(
			between: .value(querySamples[1]),
			and: .value(subQuerySamples[1]),
			in: .value(matcher.timeUnit),
			willReturn: matcher.numberOfTimeUnits))

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}
}
