//
//  SumInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class SumInformationFunctionalTests: FunctionalTest {

	func testGivenNoSamples_compute_returnsZero() {
		// given
		let samples = [Sample]()
		let information = SumInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "0")
	}

	func testGivenIntegerAttribute_compute_returnsCorrectValue() {
		// given
		let attribute = IntegerAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15")
	}

	func testGivenOptionalIntegerAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() {
		// given
		let attribute = IntegerAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, nil, nil, 4, 5] as [Int?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10")
	}

	func testGivenDoubleAttribute_compute_returnsCorrectValue() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15.0")
	}

	func testGivenOptionalDoubleAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() {
		// given
		let attribute = DoubleAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, nil, nil, 4.0, 5.0] as [Double?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10.0")
	}

	func testGivenDosageAttribute_compute_returnsCorrectValue() {
		// given
		let attribute = DosageAttribute()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Dosage(1.0, "L"),
			Dosage(20.0, "dl"),
			Dosage(300.0, "cl"),
			Dosage(4000.0, "mL"),
			Dosage(5000000.0, "µL")
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(15.0, "L").description)
	}

	func testGivenOptionalDosageAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() {
		// given
		let attribute = DosageAttribute(optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Dosage(1.0, "L"),
			nil,
			nil,
			Dosage(4000.0, "mL"),
			Dosage(5000000.0, "µL")
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(10.0, "L").description)
	}

	func testGivenUnknownAttributeTypeWithNonEmptySampleArray_compute_returnsEmptyString() {
		// given
		let attribute = TextAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: ["a", "4"], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "")
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_compute_returnsZero() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = SumInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "0")
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_compute_returnsZero() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = SumInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		let sum = information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "0")
	}
}
