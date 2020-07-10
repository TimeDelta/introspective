//
//  MinimumInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 1/6/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import Attributes
@testable import Common
@testable import SampleGroupInformation
@testable import Samples

final class MinimumInformationFunctionalTests: FunctionalTest {

	private typealias Me = MinimumInformationFunctionalTests
	private static let restrictedAttribute = IntegerAttribute(name: "abc")

	private final var information: MinimumInformation<Int>!

	final override func setUp() {
		super.setUp()
		information = MinimumInformation<Int>(Me.restrictedAttribute)
	}

	// MARK: - description

	func test_description_containsRestrictedAttributeName() {
		// when
		let description = information.description

		// then
		let attributeName = Me.restrictedAttribute.name.localizedLowercase
		assertThat(description.localizedLowercase, containsString(attributeName))
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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1], for: Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, "No samples matching filter")
	}

	func testGivenNonEmptySampleArray_compute_returnsCorrectValue() throws {
		// given
		let lowestValue = 5
		let samples = SampleCreatorTestUtil.createSamples(withValues: [lowestValue, lowestValue + 1], for: Me.restrictedAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(lowestValue))
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
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1], for: Me.restrictedAttribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArray_computeGraphable_returnsCorrectValue() throws {
		// given
		let lowestValue = 5
		let samples = SampleCreatorTestUtil.createSamples(withValues: [lowestValue, lowestValue + 1], for: Me.restrictedAttribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(lowestValue))
	}

	func testGivenDurations_computeGraphable_returnsMaxDurationInHours() throws {
		// given
		let numHours = 23
		let samples = SampleCreatorTestUtil.createSamples(withValues: [TimeDuration(numHours.hours)], for: Me.restrictedAttribute)
		let information = MinimumInformation<TimeDuration>(Me.restrictedAttribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(Double(numHours)))
	}

	// MARK: - equalTo()

	func testGivenTwoInformationObjectsOfDifferentTypesWithSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let otherInformation = MaximumInformation<Int>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoInformationObjectsOfSameTypeWithDifferentRestrictedAttributes_equalTo_returnsFalse() throws {
		// given
		let otherAttribute = IntegerAttribute(name: Me.restrictedAttribute.name + "some other stuff")
		let otherInformation = MinimumInformation<Int>(otherAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMinimumInformationObjectsWithDifferentGenericTypesAndSameRestrictedAttribute_equalTo_returnsFalse() throws {
		// given
		let otherInformation = MinimumInformation<Double>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTwoMinimumInformationObjectsWithSameGenericTypesAndSameRestrictedAttribute_equalTo_returnsTrue() throws {
		// given
		let otherInformation = MinimumInformation<Int>(Me.restrictedAttribute)

		// when
		let areEqual = information.equalTo(otherInformation)

		// then
		XCTAssert(areEqual)
	}
}
