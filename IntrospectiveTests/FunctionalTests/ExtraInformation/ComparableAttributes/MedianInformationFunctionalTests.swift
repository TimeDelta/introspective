//
//  MedianInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/14/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class MedianInformationFunctionalTests: FunctionalTest {

	private typealias Me = MedianInformationFunctionalTests
	private static let restrictedAttribute = DoubleAttribute(name: "abc")

	// MARK: - compute()

	func testGivenEmptySampleArray_compute_returnsNoSampleMessage() throws {
		// given
		let samples = [Sample]()
		let information = MedianInformation<Double>(Me.restrictedAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, information.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSampleMessage() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: Me.restrictedAttribute)
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, information.noSamplesMessage)
	}

	func testGivenNonEmptySampleArray_compute_returnsCorrectValue() throws {
		// given
		let medianValue = 5.0
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				medianValue,
				medianValue - 1,
				medianValue + 1],
			for: Me.restrictedAttribute)
		let information = MedianInformation<Double>(Me.restrictedAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(medianValue))
	}

	// MARK: - computeGraphable()

	func testGivenEmptySampleArray_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = MedianInformation<Double>(Me.restrictedAttribute)

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1], for: Me.restrictedAttribute)
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArray_computeGraphable_returnsCorrectValue() throws {
		// given
		let medianValue = 5.0
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				medianValue,
				medianValue - 1,
				medianValue + 1],
			for: Me.restrictedAttribute)
		let information = MedianInformation<Double>(Me.restrictedAttribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(medianValue))
	}

	// MARK: - equalTo()

	func testGivenTwoInformationObjectsOfDifferentTypesWithSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		let otherInformation = MaximumInformation<Double>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoInformationObjectsOfSameTypeWithDifferentRestrictedAttributes_equalTo_returnsFalse() throws {
		// given
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		let otherAttribute = DoubleAttribute(name: Me.restrictedAttribute.name + "some other stuff")
		let otherInformation = MedianInformation<Double>(otherAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMedianInformationObjectsWithDifferentGenericTypesAndSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		let otherInformation = MedianInformation<Int>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMedianInformationObjectsWithSameGenericTypesAndSameRestrictedAttribute_equalTo_returnsTrue() throws {
		// given
		let information = MedianInformation<Double>(Me.restrictedAttribute)
		let otherInformation = MedianInformation<Double>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssert(areEqual)
	}
}
