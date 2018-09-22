//
//  MostRecentDateInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class MostRecentDateInformationFunctionalTests: FunctionalTest {

	fileprivate typealias Me = MostRecentDateInformationFunctionalTests
	fileprivate static let attribute = CommonSampleAttributes.startDate

	fileprivate var information: MostRecentDateInformation!

	override func setUp() {
		super.setUp()
		information = MostRecentDateInformation(Me.attribute)
	}

	func testGivenEmptySampleArray_compute_returnsMessageAboutNoSamplesExiting() {
		// given
		let samples = [Sample]()

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_compute_returnsCorrectValue() {
		// given
		let expectedDate = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedDate, expectedDate - 1.hours])
		information.startDate = nil
		information.endDate = nil

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(expectedDate))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsAfterAllSampleStartDates_compute_returnsZero() {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2])
		information.startDate = sampleDate2 + 1.hours
		information.endDate = nil

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsBeforeAllSampleEndDates_compute_returnsZero() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.hours
		let sampleStartDate2 = sampleStartDate1 + 2.hours
		let sampleEndDate2 = sampleEndDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = nil
		information.endDate = sampleEndDate1 - 1.days

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsBeforeAllSampleStartDatesAndEndDateThatIsBeforeAllSampleStartDates_compute_returnsZero() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.hours
		let sampleEndDate2 = sampleEndDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = sampleStartDate1 - 1.days
		information.endDate = sampleEndDate1 - 1.hours

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsAfterAllSampleStartDatesAndEndDateThatIsAfterAllSampleStartDates_compute_returnsZero() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.hours
		let sampleEndDate2 = sampleEndDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = sampleStartDate2 + 1.hours
		information.endDate = sampleEndDate2 + 1.days

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_compute_returnsCorrectValue() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.days
		let sampleEndDate2 = sampleEndDate1 + 2.days
		let sampleStartDate3 = sampleStartDate2 + 2.days
		let sampleEndDate3 = sampleEndDate2 + 2.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
			(startDate: sampleStartDate3, endDate: sampleEndDate3),
		])
		information.startDate = sampleStartDate2 - 2.days
		information.endDate = sampleEndDate2 + 1.hours

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsBeforeSomeSampleStartDates_compute_returnsCorrectValue() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.days
		let sampleEndDate2 = sampleEndDate1 + 2.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = sampleStartDate2 - 1.hours
		information.endDate = nil

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_compute_returnsCorrectValue() {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.days
		let sampleEndDate2 = sampleEndDate1 + 2.days
		let sampleStartDate3 = sampleStartDate2 + 2.days
		let sampleEndDate3 = sampleEndDate2 + 2.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
			(startDate: sampleStartDate3, endDate: sampleEndDate3),
		])
		information.startDate = nil
		information.endDate = sampleEndDate2 + 1.hours

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	fileprivate func toString(_ date: Date) -> String {
		return DependencyInjector.util.calendarUtil.string(for: date)
	}
}
