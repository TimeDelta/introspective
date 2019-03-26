//
//  AverageInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective

final class AverageInformationFunctionalTests: FunctionalTest {

	// MARK: - description

	func test_description_containsRestrictedAttributeName() {
		// when
		let attribute = DoubleAttribute(name: "a")
		let information = AverageInformation(attribute)
		let description = information.description

		// then
		let attributeName = attribute.name.localizedLowercase
		assertThat(description.localizedLowercase, containsString(attributeName))
	}

	// MARK: - compute()

	func testGivenNoSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = AverageInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "No samples matching filter")
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

	func testGivenEndDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "No samples matching filter")
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		let average = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(average, "No samples matching filter")
	}

	// MARK: - computeGraphable()

	func testGivenNoSamples_computeGraphable_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = AverageInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			assertThat(error, instanceOf(GenericDisplayableError.self))
		}
	}

	func testGivenIntegerAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "3.0")
	}

	func testGivenOptionalIntegerAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, nil, nil, 2, 3] as [Int?], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.0")
	}

	func testGivenDoubleAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "3.0")
	}

	func testGivenOptionalDoubleAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, nil, nil, 2.0, 3.0] as [Double?], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.0")
	}

	func testGivenDosageAttribute_computeGraphable_returnsCorrectValue() throws {
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
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, Dosage(3.0, "L").description)
	}

	func testGivenOptionalDosageAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
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
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, Dosage(2.0, "L").description)
	}

	func testGivenDurationAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.hours),
			Duration(start: date, end: date + 3.hours),
			Duration(start: date, end: date + 2.hours),
			Duration(start: date, end: date + 1.hours),
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.5")
	}

	func testGivenOptionalDurationAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.hours),
			nil, nil,
			Duration(start: date, end: date + 3.hours),
			Duration(start: date, end: date + 2.hours),
			nil,
			Duration(start: date, end: date + 1.hours),
		], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "2.5")
	}

	func testGivenUnknownAttributeTypeWithNonEmptySampleArray_computeGraphable_returnsEmptyString() throws {
		// given
		let attribute = TextAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: ["a", "4"], for: attribute)
		let information = AverageInformation(attribute)

		// when
		let average = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(average, "")
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsGenericDisplayableError() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			assertThat(error, instanceOf(GenericDisplayableError.self))
		}
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsGenericDisplayableError() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = AverageInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			assertThat(error, instanceOf(GenericDisplayableError.self))
		}
	}

	// MARK: - equalTo()

	func testGivenSameObject_equalTo_returnsTrue() {
		// when
		let attribute = DoubleAttribute(name: "a")
		let information = AverageInformation(attribute)
		let areEqual = information.equalTo(information)

		// then
		XCTAssert(areEqual)
	}

	func testGivenWrongClass_equalTo_returnsFalse() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let information = AverageInformation(attribute)
		let other = MinimumInformation<Int>(attribute)

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDifferentRestrictedAttribute_equalTo_returnsFalse() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let information = AverageInformation(attribute)
		let other = AverageInformation(TextAttribute(name: "different attribute"))

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameRestrictedAttribute_equalTo_returnsTrue() {
		// given
		let attribute = DoubleAttribute(name: "a")
		let information = AverageInformation(attribute)
		let other = AverageInformation(attribute)

		// when
		let areEqual = information.equalTo(other)

		// then
		XCTAssert(areEqual)
	}
}
