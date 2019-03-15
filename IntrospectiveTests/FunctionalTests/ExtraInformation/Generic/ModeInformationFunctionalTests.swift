//
//  ModeInformationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class ModeInformationFunctionalTests: FunctionalTest {

	private typealias Me = ModeInformationFunctionalTests
	private static let doubleAttribute = DoubleAttribute(name: "double")

	// MARK: - compute()

	func testGivenEmptySampleArray_compute_returnsNoSampleMessage() throws {
		// given
		let samples = [Sample]()
		let information = ModeInformation(Me.doubleAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, information.noSamplesMessage)
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_compute_returnsNoSampleMessage() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1.0], for: Me.doubleAttribute)
		let information = ModeInformation(Me.doubleAttribute)
		information.startDate = Date() + 1.days

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, information.noSamplesMessage)
	}

	func testGivenOnlyOneSample_compute_returnsCorrectValue() throws {
		// given
		let modeValue = 5.0
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [modeValue],
			for: Me.doubleAttribute)
		let information = ModeInformation(Me.doubleAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(modeValue) + " (1 time)")
	}

	func testGivenDoubleAttribute_compute_returnsCorrectValue() throws {
		// given
		let modeValue = 5.0
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - 1,
				modeValue,
				modeValue + 1],
			for: Me.doubleAttribute)
		let information = ModeInformation(Me.doubleAttribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, String(modeValue) + " (2 times)")
	}

	func testGivenDurationAttribute_compute_returnsCorrectValue() throws {
		// given
		let modeValue = Duration([.hour: 1])
		let attribute = DurationAttribute(name: "name")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - Duration(1.minutes),
				modeValue,
				modeValue + Duration(1.minutes)],
			for: attribute)
		let information = ModeInformation(attribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, modeValue.description + " (2 times)")
	}

	func testGivenFrequencyAttribute_compute_returnsCorrectValue() throws {
		// given
		let modeValue = Frequency(1, .hour)!
		let attribute = FrequencyAttribute(name: "name")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - Frequency(1, .minute)!,
				modeValue,
				modeValue + Frequency(1, .minute)!],
			for: attribute)
		let information = ModeInformation(attribute)

		// when
		let value = try information.compute(forSamples: samples)

		// then
		XCTAssertEqual(value, modeValue.description + " (2 times)")
	}

	// MARK: - computeGraphable()

	func testGivenEmptySampleArray_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = [Sample]()
		let information = ModeInformation(Me.doubleAttribute)

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenNonEmptySampleArrayAndStartDateRestrictionThatFilterOutAllSamples_computeGraphable_throwsDisplayableError() throws {
		// given
		let samples = SampleCreatorTestUtil.createSamples(withValues: [1], for: Me.doubleAttribute)
		let information = ModeInformation(Me.doubleAttribute)
		information.startDate = Date() + 1.days

		// when
		XCTAssertThrowsError(try information.computeGraphable(forSamples: samples)) { error in
			// then
			XCTAssert(error is GenericDisplayableError)
		}
	}

	func testGivenDoubleAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let modeValue = 5.0
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - 1,
				modeValue,
				modeValue + 1],
			for: Me.doubleAttribute)
		let information = ModeInformation(Me.doubleAttribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, String(modeValue))
	}

	func testGivenDurationAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let modeValue = Duration([.hour: 1])
		let attribute = DurationAttribute(name: "name")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - Duration(1.minutes),
				modeValue,
				modeValue + Duration(1.minutes)],
			for: attribute)
		let information = ModeInformation(attribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, modeValue.description)
	}

	func testGivenFrequencyAttribute_computeGraphable_returnsCorrectValue() throws {
		// given
		let modeValue = Frequency(1, .hour)!
		let attribute = FrequencyAttribute(name: "name")
		let samples = SampleCreatorTestUtil.createSamples(
			withValues: [
				modeValue,
				modeValue - Frequency(1, .minute)!,
				modeValue,
				modeValue + Frequency(1, .minute)!],
			for: attribute)
		let information = ModeInformation(attribute)

		// when
		let value = try information.computeGraphable(forSamples: samples)

		// then
		XCTAssertEqual(value, modeValue.description)
	}
}
