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

final class MostRecentDateInformationFunctionalTests: FunctionalTest {

	private typealias Me = MostRecentDateInformationFunctionalTests
	private static let attribute = CommonSampleAttributes.startDate

	private final var information: MostRecentDateInformation!

	final override func setUp() {
		super.setUp()
		information = MostRecentDateInformation(Me.attribute)
	}

	// MARK: - compute()

	func testGivenEmptySampleArray_compute_returnsMessageAboutNoSamplesExiting() throws {
		// given
		let samples = [Sample]()

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_compute_returnsCorrectValue() throws {
		// given
		let expectedDate = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedDate, expectedDate - 1.hours])
		information.startDate = nil
		information.endDate = nil

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(expectedDate))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsAfterAllSampleStartDates_compute_returnsNoSamplesMessage() throws {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2])
		information.startDate = sampleDate2 + 1.hours
		information.endDate = nil

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsBeforeAllSampleEndDates_compute_returnsNoSamplesMessage() throws {
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
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsBeforeAllSampleStartDatesAndEndDateThatIsBeforeAllSampleStartDates_compute_returnsNoSamplesMessage() throws {
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
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsAfterAllSampleStartDatesAndEndDateThatIsAfterAllSampleStartDates_compute_returnsNoSamplesMessage() throws {
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
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_compute_returnsCorrectValue() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
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

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_compute_returnsCorrectValue() throws {
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
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		information.endDate = Date() - 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		information.startDate = Date() + 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, MostRecentDateInformation.noSamplesMessage)
	}

	// MARK: - computeGraphable()

	func testGivenEmptySampleArray_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_computeGraphable_returnsCorrectValue() throws {
		// given
		let expectedDate = Date()
		let samples = SampleCreatorTestUtil.createSamples(withDates: [expectedDate, expectedDate - 1.hours])
		information.startDate = nil
		information.endDate = nil

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(expectedDate))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsAfterAllSampleStartDates_computeGraphable_throwsDisplayableError() throws {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2])
		information.startDate = sampleDate2 + 1.hours
		information.endDate = nil

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsBeforeAllSampleEndDates_computeGraphable_throwsDisplayableError() throws {
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
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsBeforeAllSampleStartDatesAndEndDateThatIsBeforeAllSampleStartDates_computeGraphable_throwsDisplayableError() throws {
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
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsAfterAllSampleStartDatesAndEndDateThatIsAfterAllSampleStartDates_computeGraphable_throwsDisplayableError() throws {
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
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_computeGraphable_returnsCorrectValue() throws {
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
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsBeforeSomeSampleStartDates_computeGraphable_returnsCorrectValue() throws {
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
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_computeGraphable_returnsCorrectValue() throws {
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
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, toString(sampleStartDate2))
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		information.endDate = Date() - 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	// MARK: - Helper Functions

	private func toString(_ date: Date) -> String {
		return DependencyInjector.util.calendar.string(for: date, dateStyle: .short, timeStyle: .short)
	}
}
