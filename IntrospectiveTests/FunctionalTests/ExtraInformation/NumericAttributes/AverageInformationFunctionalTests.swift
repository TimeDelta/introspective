//
//  AverageInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class AverageInformationFunctionalTests: FunctionalTest {

	// MARK: - compute()

	func testGivenNoSamples_compute_returnsZero() throws {
		// given
		let samples = [Sample]()
		let information = AverageInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "0")
	}

	func testGivenIntegerAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "3.0")
	}

	func testGivenOptionalIntegerAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, nil, nil, 2, 3] as [Int?], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.0")
	}

	func testGivenDoubleAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "3.0")
	}

	func testGivenOptionalDoubleAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, nil, nil, 2.0, 3.0] as [Double?], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.0")
	}

	func testGivenDosageAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = DosageAttribute()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Dosage(1.0, "L"),
			Dosage(20.0, "dl"),
			Dosage(300.0, "cl"),
			Dosage(4000.0, "mL"),
			Dosage(5000000.0, "µL")
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, Dosage(3.0, "L").description)
	}

	func testGivenOptionalDosageAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = DosageAttribute(optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Dosage(1.0, "L"),
			nil,
			nil,
			Dosage(2000.0, "mL"),
			Dosage(3000000.0, "µL")
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, Dosage(2.0, "L").description)
	}

	func testGivenDurationAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			Duration(start: date, end: date + 8.hours),
			Duration(start: date, end: date + 12.minutes),
			Duration(start: date, end: date + 16.seconds),
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "1d 2:03:04")
	}

	func testGivenOptionalDurationAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			nil, nil,
			Duration(start: date, end: date + 8.hours),
			Duration(start: date, end: date + 12.minutes),
			nil,
			Duration(start: date, end: date + 16.seconds),
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "1d 2:03:04")
	}

	func testGivenUnknownAttributeTypeWithNonEmptySampleArray_compute_returnsEmptyString() throws {
		// given
		let attribute = TextAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: ["a", "4"], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "")
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_compute_returnsZero() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "0")
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_compute_returnsZero() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "0")
	}
}
