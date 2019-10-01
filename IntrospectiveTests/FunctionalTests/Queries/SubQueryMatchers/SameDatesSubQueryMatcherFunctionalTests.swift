//
//  SameDatesSubQueryMatcherFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective
@testable import Queries
@testable import Samples

class SameDatesSubQueryMatcherFunctionalTests: FunctionalTest {

	fileprivate var matcher: SameDatesSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = SameDatesSubQueryMatcher()
	}

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let subQuerySamples = [Sample]()

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleDate1 = Date()
		let querySampleDate2 = Date() - 1.days
		let subQuerySampleDate = querySampleDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = [SampleCreatorTestUtil.createSample(startDate: subQuerySampleDate)]

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
		let querySampleDate1 = Date()
		let querySampleDate2 = Date() - 1.days
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])

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

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamplesAndAllSamplesHaveStartAndEndDates_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleStartDate1 = Date() - 1.days
		let querySampleEndDate1 = Date() - 1.hours
		let querySampleStartDate2 = Date()
		let querySampleEndDate2 = Date() + 1.hours
		let subQuerySampleStartDate1 = querySampleStartDate1
		let subQuerySampleEndDate1 = querySampleEndDate1
		let subQuerySampleStartDate2 = Date() + 1.days
		let subQuerySampleEndDate2 = Date() + 2.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: querySampleStartDate1, endDate: querySampleEndDate1),
			(startDate: querySampleStartDate2, endDate: querySampleEndDate2),
		])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: subQuerySampleStartDate1, endDate: subQuerySampleEndDate1),
			(startDate: subQuerySampleStartDate2, endDate: subQuerySampleEndDate2),
		])
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
