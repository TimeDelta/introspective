//
//  OldestDateInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class OldestDateInformationFunctionalTests: FunctionalTest {

	private typealias Me = OldestDateInformationFunctionalTests
	private static let attribute = CommonSampleAttributes.startDate

	private var information: OldestDateInformation!

	override func setUp() {
		super.setUp()
		information = OldestDateInformation(Me.attribute)
	}

	// MARK: - compute()

	func testGivenEmptySampleArray_compute_returnsMessageAboutNoSamplesExiting() throws {
		// given
		let samples = [Sample]()

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, OldestDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_compute_returnsCorrectValue() throws {
		// given
		let expectedDate = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedDate, expectedDate + 1.hours])
		information.startDate = nil
		information.endDate = nil

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(expectedDate))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsAfterAllSampleStartDates_compute_returnsZero() throws {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2])
		information.startDate = sampleDate2 + 1.hours
		information.endDate = nil

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, OldestDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsBeforeAllSampleEndDates_compute_returnsZero() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, OldestDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsBeforeAllSampleStartDatesAndEndDateThatIsBeforeAllSampleStartDates_compute_returnsZero() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, OldestDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsAfterAllSampleStartDatesAndEndDateThatIsAfterAllSampleStartDates_compute_returnsZero() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, OldestDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_compute_returnsCorrectValue() throws {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.days
		let sampleEndDate2 = sampleEndDate1 + 2.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = sampleStartDate1 - 1.days
		information.endDate = sampleEndDate1 + 1.hours

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate1))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsBeforeSomeSampleStartDates_compute_returnsCorrectValue() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenSampleArrayWithCorrectDateAfterIndexTwoAndNilStartAndEndDates_compute_returnsCorrectValue() throws {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 - 2.hours
		let sampleDate3 = sampleDate2 - 5.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2, sampleDate3])
		information.startDate = nil
		information.endDate = nil

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleDate3))
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_compute_returnsCorrectValue() throws {
		// given
		let sampleStartDate1 = Date()
		let sampleEndDate1 = sampleStartDate1 + 1.days
		let sampleStartDate2 = sampleStartDate1 + 2.days
		let sampleEndDate2 = sampleEndDate1 + 2.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			(startDate: sampleStartDate1, endDate: sampleEndDate1),
			(startDate: sampleStartDate2, endDate: sampleEndDate2),
		])
		information.startDate = nil
		information.endDate = sampleEndDate1 + 1.hours

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate1))
	}

	// MARK: - Helper Functions

	private func toString(_ date: Date) -> String {
		return DependencyInjector.util.calendar.string(for: date, dateStyle: .short, timeStyle: .short)
	}
}
