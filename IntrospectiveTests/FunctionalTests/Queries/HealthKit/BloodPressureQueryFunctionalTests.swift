//
//  BloodPressureQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class BloodPressureQueryFunctionalTests: QueryFunctionalTest {

	private var query: BloodPressureQueryImpl!

	override func setUp() {
		super.setUp()
		query = BloodPressureQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(BloodPressure.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(BloodPressure.self)
		super.tearDown()
	}

	func testGivenNoBloodPressuresInHealthKit_runQuery_returnsNoSamplesFoundError() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			XCTAssert(waitError == nil)
			var message = ""
			if self.error == nil && self.result != nil {
				message = "Found " + String(self.samples.count) + " samples"
			} else if self.error == nil {
				message = "Probably have to delete the app from the simulator, including its data"
			}
			XCTAssert(self.error != nil, message)
			XCTAssert(self.error is NoHealthKitSamplesFoundQueryError, self.error?.localizedDescription ?? "")
		}
	}

	func testGivenOneBloodPressureInHealthKitWithUnrestrictedQuery_runQuery_returnsThatBloodPressures() {
		// given
		let expected = BloodPressure(systolic: 100, diastolic: 45, Date())
		HealthKitDataTestUtil.save([expected])

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expected), self.expected(expected, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleBloodPressuresInHealthKitAndRestrictionOnSystolicPressureThatShouldOnlyReturnOneBloodPressure_runQuery_returnsThatOneBloodPressure() {
		// given
		let value = 83.7
		let expected = BloodPressure(systolic: value)
		HealthKitDataTestUtil.save([
			expected,
			BloodPressure(systolic: value - 1),
		])

		let systolicRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: value)
		query.attributeRestrictions.append(systolicRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expected), self.expected(expected, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleBloodPressuresInDatabaseThatMatchGivenBloodPressureRestrictions_runQuery_returnsAllMatchingBloodPressures() {
		// given
		let systolicValue = 120.0
		let diastolicValue = 80.0
		let expected1 = BloodPressure(systolic: systolicValue, diastolic: diastolicValue + 1)
		let expected2 = BloodPressure(systolic: systolicValue - 1, diastolic: diastolicValue + 50)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			BloodPressure(systolic: systolicValue + 1, diastolic: diastolicValue + 1),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue - 1),
			BloodPressure(systolic: systolicValue + 1, diastolic: diastolicValue - 1),
		])

		let systolicRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: systolicValue)
		let diastolicRestriction = GreaterThanDoubleAttributeRestriction(restrictedAttribute: BloodPressure.diastolic, value: diastolicValue)
		query.attributeRestrictions.append(systolicRestriction)
		query.attributeRestrictions.append(diastolicRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expected1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expected2) }))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBloodPressuresInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBloodPressure() {
		// given
		let systolicValue = 54.6
		let diastolicValue =  18.3
		let expected = BloodPressure(systolic: systolicValue, diastolic: diastolicValue, Date() - 2.days)
		HealthKitDataTestUtil.save([
			expected,
			BloodPressure(systolic: diastolicValue, diastolic: systolicValue, Date() - 2.days),
			BloodPressure(systolic: systolicValue - 1, diastolic: diastolicValue, Date() - 2.days),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue + 2, Date() - 2.days),
			BloodPressure(Date() - 2.days),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue)
		])

		let systolicRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: systolicValue)
		let diastolicRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.diastolic, value: diastolicValue)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(systolicRestriction)
		query.attributeRestrictions.append(diastolicRestriction)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expected), self.expected(expected, butGot: self.samples[0]))
			}
		}
	}
}