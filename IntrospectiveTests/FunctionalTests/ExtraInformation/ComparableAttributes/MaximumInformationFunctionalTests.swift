//
//  MaximumInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 1/6/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class MaximumInformationFunctionalTests: FunctionalTest {

	private typealias Me = MaximumInformationFunctionalTests
	private static let restrictedAttribute = IntegerAttribute(name: "abc")

	private final var information: MaximumInformation<Int>!

	final override func setUp() {
		super.setUp()
		information = MaximumInformation<Int>(Me.restrictedAttribute)
	}

	// MARK: - compute()

	func testGivenEmptySampleArray_compute_returnsNoSamplesMessage() throws {
		// given
		let samples = [Sample]()

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "No samples matching filter")
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSampleMessage() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "No samples matching filter")
	}

	func testGivenNonEmptySampleArray_compute_returnsCorrectValue() throws {
		// given
		let highestValue = 5
		let samples = SampleCreatorTestUtil.createSamples(withValues: [highestValue, highestValue - 1], for: Me.restrictedAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(highestValue))
	}

	// MARK: - computeGraphable()

	func testGivenEmptySampleArray_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1, 2, 3, 4, 5], for: Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArray_computeGraphable_returnsCorrectValue() throws {
		// given
		let highestValue = 5
		let samples = SampleCreatorTestUtil.createSamples(withValues: [highestValue, highestValue - 1], for: Me.restrictedAttribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(highestValue))
	}

	// MARK: - equalTo()

	func testGivenTwoInformationObjectsOfDifferentTypesWithSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let otherInformation = MinimumInformation<Int>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoInformationObjectsOfSameTypeWithDifferentRestrictedAttributes_equalTo_returnsFalse() throws {
		// given
		let otherAttribute = IntegerAttribute(name: Me.restrictedAttribute.name + "some other stuff")
		let otherInformation = MaximumInformation<Int>(otherAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMaximumInformationObjectsWithDifferentGenericTypesAndSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let otherInformation = MaximumInformation<Double>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMaximumInformationObjectsWithSameGenericTypesAndSameRestrictedAttribute_equalTo_returnsTrue() throws {
		// given
		let otherInformation = MaximumInformation<Int>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssert(areEqual)
	}
}
