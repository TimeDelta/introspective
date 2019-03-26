//
//  CountInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective

class CountInformationFunctionalTests: FunctionalTest {

	private typealias Me = CountInformationFunctionalTests
	private static let attribute = AttributeBase(name: "attribute")

	private var information: CountInformation!

	override func setUp() {
		super.setUp()
		information = CountInformation(Me.attribute)
	}

	// MARK: - compute

	func testGivenEmptySampleArray_compute_returnsZero() {
		// given
		let samples = [Sample]()

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_compute_returnsCorrectCount() {
		// given
		let expectedCount = 3
		let samples = SampleCreatorTestUtil.createSamples(count: expectedCount)
		information.startDate = nil
		information.endDate = nil

		// when
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(expectedCount))
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
		XCTAssertEqual(value, "0")
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
		XCTAssertEqual(value, "0")
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
		XCTAssertEqual(value, "0")
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
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_compute_returnsCorrectValue() {
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
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "1")
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
		XCTAssertEqual(value, "1")
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_compute_returnsCorrectValue() {
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
		let value = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "1")
	}

	// MARK: - computeGraphable

	func testGivenEmptySampleArray_computeGraphable_returnsZero() {
		// given
		let samples = [Sample]()

		// when
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithNilStartAndEndDates_computeGraphable_returnsCorrectCount() {
		// given
		let expectedCount = 3
		let samples = SampleCreatorTestUtil.createSamples(count: expectedCount)
		information.startDate = nil
		information.endDate = nil

		// when
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(expectedCount))
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsAfterAllSampleStartDates_computeGraphable_returnsZero() {
		// given
		let sampleDate1 = Date()
		let sampleDate2 = sampleDate1 + 2.hours
		let samples = SampleCreatorTestUtil.createSamples(withDates: [sampleDate1, sampleDate2])
		information.startDate = sampleDate2 + 1.hours
		information.endDate = nil

		// when
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsBeforeAllSampleEndDates_computeGraphable_returnsZero() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsBeforeAllSampleStartDatesAndEndDateThatIsBeforeAllSampleStartDates_computeGraphable_returnsZero() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithStartDateThatIsAfterAllSampleStartDatesAndEndDateThatIsAfterAllSampleStartDates_computeGraphable_returnsZero() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "0")
	}

	func testGivenNonEmptySampleArrayWithStartDateBeforeSomeSampleStartDatesAndEndDateThatIsAfterSomeEndDates_computeGraphable_returnsCorrectValue() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "1")
	}

	func testGivenNonEmptySampleArrayWithNilEndDateAndStartDateThatIsBeforeSomeSampleStartDates_computeGraphable_returnsCorrectValue() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "1")
	}

	func testGivenNonEmptySampleArrayWithNilStartDateAndEndDateThatIsAfterSomeSampleEndDates_computeGraphable_returnsCorrectValue() {
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
		let value = information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, "1")
	}

	// MARK: - equalTo

	func testGivenWrongClass_equalTo_returnsFalse() {
		// given
		let other = ModeInformation(information.attribute)

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentAttributes_equalTo_returnsFalse() {
		// given
		let other = CountInformation(TextAttribute(name: information.attribute.name + "other stuff"))

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameClassAndAttribute_equalTo_returnsTrue() {
		// given
		let other = CountInformation(information.attribute)

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenSameObject_equalTo_returnsTrue() {
		// when
		let areEqual = information.equalTo(information)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - description

	func test_description_doesNotContainAttributeName() {
		// when
		let description = information.description

		// then
		let attributeName = information.attribute.name.localizedLowercase
		assertThat(description.localizedLowercase, not(containsString(attributeName)))
	}
}
