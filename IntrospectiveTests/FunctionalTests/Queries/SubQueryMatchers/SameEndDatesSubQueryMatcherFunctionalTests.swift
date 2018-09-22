//
//  SameEndDatesSubQueryMatcherFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class SameEndDatesSubQueryMatcherFunctionalTests: FunctionalTest {

	fileprivate var matcher: SameEndDatesSubQueryMatcher!

	override func setUp() {
		super.setUp()
		matcher = SameEndDatesSubQueryMatcher()
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
		let querySampleStartDate1 = Date() - 1.days
		let querySampleEndDate1 = Date() - 1.hours
		let querySampleStartDate2 = Date() - 1.days
		let querySampleEndDate2 = Date() + 1.hours
		let subQuerySampleStartDate = Date() - 2.days
		let subQuerySampleEndDate = querySampleEndDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: querySampleStartDate1, endDate: querySampleEndDate1),
			(startDate: querySampleStartDate2, endDate: querySampleEndDate2),
		])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [(startDate: subQuerySampleStartDate, endDate: subQuerySampleEndDate)])

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
		let querySampleStartDate1 = Date() - 1.days
		let querySampleEndDate1 = Date() - 1.hours
		let querySampleStartDate2 = Date() - 1.days
		let querySampleEndDate2 = Date() + 1.hours
		let subQuerySampleStartDate1 = Date() - 2.days
		let subQuerySampleEndDate1 = Date()
		let subQuerySampleStartDate2 = Date() + 1.days
		let subQuerySampleEndDate2 = querySampleEndDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: querySampleStartDate1, endDate: querySampleEndDate1),
			(startDate: querySampleStartDate2, endDate: querySampleEndDate2),
		])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: subQuerySampleStartDate1, endDate: subQuerySampleEndDate1),
			(startDate: subQuerySampleStartDate2, endDate: subQuerySampleEndDate2),
		])

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

	func testGivenQuerySampleWithSameStartDateAsSubQuerySampleButDifferentEndDate_getSamples_doesNotReturnThem() {
		// given
		let querySampleStartDate = Date() - 1.days
		let querySampleEndDate = Date() - 1.hours
		let subQuerySampleStartDate = querySampleStartDate
		let subQuerySampleEndDate = querySampleEndDate + 3.hours
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [(startDate: querySampleStartDate, endDate: querySampleEndDate)])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [(startDate: subQuerySampleStartDate, endDate: subQuerySampleEndDate)])
		matcher.mostRecentOnly = true

		// when
		let matchingSamples = matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamplesAndAllSamplesHaveStartAndEndDates_getSamples_returnsOnlyMatchingSamples() {
		// given
		let querySampleStartDate1 = Date() - 1.days
		let querySampleEndDate1 = Date() - 1.hours
		let querySampleStartDate2 = Date()
		let querySampleEndDate2 = Date() + 1.hours
		let subQuerySampleStartDate1 = querySampleStartDate1 + 3.hours
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
