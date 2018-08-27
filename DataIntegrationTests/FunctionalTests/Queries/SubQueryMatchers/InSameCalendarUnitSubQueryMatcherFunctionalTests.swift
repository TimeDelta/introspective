//
//  InSameCalendarUnitSubQueryMatcherFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import XCTest
import SwiftDate
@testable import DataIntegration

class InSameCalendarUnitSubQueryMatcherFunctionalTests: FunctionalTest {

	fileprivate var matcher: InSameCalendarUnitSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = InSameCalendarUnitSubQueryMatcher()
	}

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let subQuerySamples = [Sample]()
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate = querySampleDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = [SampleCreatorTestUtil.createSample(startDate: subQuerySampleDate)]
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		let timeUnit: Calendar.Component = .day
		matcher.timeUnit = timeUnit
		matcher.mostRecentOnly = true

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}
}
