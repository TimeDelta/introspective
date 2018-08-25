//
//  WithinXCalendarUnitsSubQueryMatcherFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/26/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class WithinXCalendarUnitsSubQueryMatcherFunctionalTests: FunctionalTest {

	var matcher: WithinXCalendarUnitsSubQueryMatcher!

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
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0)
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
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
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = [SampleCreatorTestUtil.createSample(startDate: Date() + 1.days)] as [Sample]

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
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 5.days, Date()])
		let subQuerySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(matchingSamples[0].equalTo(querySamples[1]), matchingSamples[0].debugDescription + " did not match " + querySamples[1].debugDescription)
		}
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		matcher.mostRecentOnly = true
		matcher.numberOfTimeUnits = 1
		matcher.timeUnit = .day
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 1.days, Date()])
		let subQuerySamples = SampleCreatorTestUtil.createSamples(withDates: [Date() - 3.days + 1.hours, Date() + 1.days]) as [Sample]

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1)
		XCTAssert(matchingSamples[0].equalTo(querySamples[1]))
	}

}
