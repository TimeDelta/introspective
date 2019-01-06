//
//  InSameCalendarUnitSubQueryMatcherFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import XCTest
import SwiftDate
@testable import Introspective

final class InSameCalendarUnitSubQueryMatcherFunctionalTests: FunctionalTest {

	private var matcher: InSameCalendarUnitSubQueryMatcher!

	final override func setUp() {
		super.setUp()
		matcher = InSameCalendarUnitSubQueryMatcher()
	}

	func testGivenEmptyArrayOfQuerySamplesAndEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = [Sample]()
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfQuerySamplesAndNonEmptyArrayOfSubQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = [AnySample]()
		let subQuerySamples = SampleCreatorTestUtil.createSamples(count: 2)
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenEmptyArrayOfSubQuerySamplesAndNonEmptyArrayOfQuerySamples_getSamples_returnsEmptyArray() throws {
		// given
		let querySamples = SampleCreatorTestUtil.createSamples(count: 2)
		let subQuerySamples = [Sample]()
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 0, "Found \(matchingSamples.count) samples")
	}

	func testGivenOneSubQuerySampleAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate = querySampleDate1
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = [SampleCreatorTestUtil.createSample(startDate: subQuerySampleDate)]
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() + 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenQuerySamplesWithEndDatesInSameCalendarUnitButStartDatesNotInSameCalendarUnitAsSubQuerySample_getSamples_returnsSamplesWithEndDatesInSameCalendarUnit() throws {
		// given
		let querySampleStartDate1 = Date() - 2.days
		let querySampleEndDate1 = Date()
		let querySampleStartDate2 = Date() - 1.days
		let querySampleEndDate2 = Date() + 1.days
		let subQuerySampleStartDate1 = querySampleStartDate1 + 2.days
		let subQuerySampleEndDate1 = querySampleEndDate1 - 1.nanoseconds
		let subQuerySampleStartDate2 = querySampleStartDate2 + 2.days
		let subQuerySampleEndDate2 = querySampleEndDate2 + 2.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: querySampleStartDate1, endDate: querySampleEndDate1),
			(startDate: querySampleStartDate2, endDate: querySampleEndDate2),
		])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: subQuerySampleStartDate1, endDate: subQuerySampleEndDate1),
			(startDate: subQuerySampleStartDate2, endDate: subQuerySampleEndDate2),
		])
		matcher.timeUnit = .day

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamples_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleDate1 = Date() - 1.days
		let querySampleDate2 = Date()
		let subQuerySampleDate1 = querySampleDate1
		let subQuerySampleDate2 = Date() - 2.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [querySampleDate1, querySampleDate2])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [subQuerySampleDate1, subQuerySampleDate2])
		matcher.timeUnit = .day
		matcher.mostRecentOnly = true

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[0]),
				"Expected \(querySamples[0].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}

	func testGivenMostRecentOnlyIsTrueAndMultipleSubQuerySamplesAndMultipleQuerySamplesAndAllSamplesHaveStartAndEndDates_getSamples_returnsOnlyMatchingSamples() throws {
		// given
		let querySampleStartDate1 = Date() - 1.days
		let querySampleEndDate1 = Date() - 1.days
		let querySampleStartDate2 = Date() + 1.days
		let querySampleEndDate2 = Date() + 1.days
		let subQuerySampleStartDate1 = querySampleStartDate2
		let subQuerySampleEndDate1 = querySampleEndDate2
		let subQuerySampleStartDate2 = querySampleStartDate2 - 1.days
		let subQuerySampleEndDate2 = querySampleEndDate2 - 1.days
		let querySamples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: querySampleStartDate1, endDate: querySampleEndDate1),
			(startDate: querySampleStartDate2, endDate: querySampleEndDate2),
		])
		let subQuerySamples: [Sample] = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: subQuerySampleStartDate1, endDate: subQuerySampleEndDate1),
			(startDate: subQuerySampleStartDate2, endDate: subQuerySampleEndDate2),
		])
		matcher.timeUnit = .day
		matcher.mostRecentOnly = true

		// when
		let matchingSamples = try matcher.getSamples(from: querySamples, matching: subQuerySamples)

		// then
		XCTAssert(matchingSamples.count == 1, "Found \(matchingSamples.count) samples")
		if matchingSamples.count > 0 {
			XCTAssert(
				matchingSamples[0].equalTo(querySamples[1]),
				"Expected \(querySamples[1].debugDescription) but got \(matchingSamples[0].debugDescription)")
		}
	}
}
