//
//  SumInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective

final class SumInformationFunctionalTests: FunctionalTest {

	private final var information: SumInformation!
	private final var attribute: Attribute!

	final override func setUp() {
		super.setUp()
		attribute = DoubleAttribute(name: "attribute name")
		information = SumInformation(attribute)
	}

	// MARK: - description

	func test_description_containsRestrictedAttributeName() {
		// when
		let description = information.description

		// then
		let attributeName = attribute.name.localizedLowercase
		assertThat(description.localizedLowercase, containsString(attributeName))
	}

	// MARK: - compute()

	func testGivenNoSamplesForIntegerAttribute_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	func testGivenNoSamplesForDoubleAttribute_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DoubleAttribute(name: "doesn't matter"))

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	func testGivenNoSamplesForDurationAttribute_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DurationAttribute(name: "doesn't matter"))

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	func testGivenNoSamplesForDosageAttribute_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DosageAttribute(name: "doesn't matter"))

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	func testGivenIntegerAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15")
	}

	func testGivenOptionalIntegerAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, nil, nil, 4, 5] as [Int?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10")
	}

	func testGivenDoubleAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15.0")
	}

	func testGivenOptionalDoubleAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, nil, nil, 4.0, 5.0] as [Double?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10.0")
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
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(15.0, "L").description)
	}

	func testGivenOptionalDosageAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
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
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(10.0, "L").description)
	}

	func testGivenDurationAttribute_compute_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			Duration(start: date, end: date + 5.hours),
			Duration(start: date, end: date + 6.minutes),
			Duration(start: date, end: date + 7.seconds),
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "4d 5:06:07")
	}

	func testGivenOptionalDurationAttributeWithSomeSamplesHavingNilValue_compute_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			nil, nil,
			Duration(start: date, end: date + 5.hours),
			Duration(start: date, end: date + 6.minutes),
			nil,
			Duration(start: date, end: date + 7.seconds),
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "4d 5:06:07")
	}

	func testGivenUnknownAttributeTypeWithNonEmptySampleArray_compute_throwsUnknownAttributeError() throws {
		// given
		let attribute = TextAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: ["a", "4"], for: attribute)
		let information = SumInformation(attribute)

		// when
		XCTAssertThrowsError(try information.compute(forSamples: samples)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenUnknownAttributeTypeWithEmptySampleArray_compute_throwsDisplayableError() throws {
		let attribute = TextAttribute(name: "a")
		let samples = [Sample]()
		let information = SumInformation(attribute)

		// when
		XCTAssertThrowsError(try information.compute(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: attribute)
		let information = SumInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSamplesMessage() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: attribute)
		let information = SumInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		let sum = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(sum, "No samples match filter")
	}

	// MARK: - computeGraphable()

	func testGivenNoSamplesForIntegerAttribute_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(IntegerAttribute(name: "doesn't matter"))

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNoSamplesForDoubleAttribute_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DoubleAttribute(name: "doesn't matter"))

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNoSamplesForDurationAttribute_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DurationAttribute(name: "doesn't matter"))

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenNoSamplesForDosageAttribute_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = SumInformation(DosageAttribute(name: "doesn't matter"))

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenIntegerAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15")
	}

	func testGivenOptionalIntegerAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = IntegerAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, nil, nil, 4, 5] as [Int?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10")
	}

	func testGivenDoubleAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, 2.0, 3.0, 4.0, 5.0], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "15.0")
	}

	func testGivenOptionalDoubleAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DoubleAttribute(name: "a", optional: true)
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0, nil, nil, 4.0, 5.0] as [Double?], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "10.0")
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
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(15.0, "L").description)
	}

	func testGivenOptionalDosageAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
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
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, Dosage(10.0, "L").description)
	}

	func testGivenDurationAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			Duration(start: date, end: date + 5.hours),
			Duration(start: date, end: date + 6.minutes),
			Duration(start: date, end: date + 7.seconds),
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "101.10194444444444")
	}

	func testGivenOptionalDurationAttributeWithSomeSamplesHavingNilValue_computeGraphable_returnsCorrectValue() throws {
		// given
		let attribute = DurationAttribute()
		let date = Date()
		let samples = SampleCreatorTestUtil.createSamples(withValues: [
			Duration(start: date, end: date + 4.days),
			nil, nil,
			Duration(start: date, end: date + 5.hours),
			Duration(start: date, end: date + 6.minutes),
			nil,
			Duration(start: date, end: date + 7.seconds),
		], for: attribute)
		let information = SumInformation(attribute)

		// when
		let sum = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(sum, "101.10194444444444")
	}

	func testGivenUnknownAttributeTypeWithNonEmptySampleArray_computeGraphable_throwsUnknownAttributeError() throws {
		// given
		let attribute = TextAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: ["a", "4"], for: attribute)
		let information = SumInformation(attribute)

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenUnknownAttributeTypeWithEmptySampleArray_computeGraphable_throwsDisplayableError() throws {
		let attribute = TextAttribute(name: "a")
		let samples = [Sample]()
		let information = SumInformation(attribute)

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenEndDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: attribute)
		let information = SumInformation(attribute)
		information.endDate = Date() - 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	func testGivenStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let attribute = DoubleAttribute(name: "a")
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: attribute)
		let information = SumInformation(attribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is DisplayableError)
		}
	}

	// MARK: - equalTo()

	func testGivenSameObject_equalTo_returnsTrue() {
		// when
		let areEqual = information.equalTo(information)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoInformationObjectsOfDifferentTypesWithSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let restrictedAttribute = IntegerAttribute(name: "abc")
		let information = SumInformation(restrictedAttribute)
		let otherInformation = MinimumInformation<Int>(restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoInformationObjectsOfSameTypeWithDifferentRestrictedAttributes_equalTo_returnsFalse() throws {
		// given
		let restrictedAttribute = IntegerAttribute(name: "abc")
		let information = SumInformation(restrictedAttribute)
		let otherAttribute = IntegerAttribute(name: restrictedAttribute.name + "some other stuff")
		let otherInformation = SumInformation(otherAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoSumInformationObjectsWithSameRestrictedAttribute_equalTo_returnsTrue() throws {
		// given
		let restrictedAttribute = IntegerAttribute(name: "abc")
		let information = SumInformation(restrictedAttribute)
		let otherInformation = SumInformation(restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssert(areEqual)
	}
}
