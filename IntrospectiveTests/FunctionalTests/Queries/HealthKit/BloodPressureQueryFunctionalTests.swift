//
//  BloodPressureQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

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

	func testGivenNoBloodPressuresInHealthKit_runQuery_returnsEmptyArray() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			XCTAssert(waitError == nil)
			if let error = self.error {
				XCTFail(error.localizedDescription)
			}
			assertThat(self.samples, hasCount(0))
		}
	}

	func testGivenOneBloodPressureInHealthKitWithUnrestrictedQuery_runQuery_returnsThatBloodPressures() {
		// given
		let expectedSamples = [BloodPressure(systolic: 100, diastolic: 45, Date())]
		HealthKitDataTestUtil.save(expectedSamples)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleBloodPressuresInHealthKitAndRestrictionOnSystolicPressureThatShouldOnlyReturnOneBloodPressure_runQuery_returnsThatOneBloodPressure() {
		// given
		let value = 83.7
		let expectedSamples = [BloodPressure(systolic: value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([BloodPressure(systolic: value - 1)])

		let systolicRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: value)
		query.expression = systolicRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleBloodPressuresInDatabaseThatMatchGivenBloodPressureRestrictions_runQuery_returnsAllMatchingBloodPressures() {
		// given
		let systolicValue = 120.0
		let diastolicValue = 80.0
		let expectedSamples = [
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue + 1),
			BloodPressure(systolic: systolicValue - 1, diastolic: diastolicValue + 50),
		]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			BloodPressure(systolic: systolicValue + 1, diastolic: diastolicValue + 1),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue - 1),
			BloodPressure(systolic: systolicValue + 1, diastolic: diastolicValue - 1),
		])

		let systolicRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: systolicValue)
		let diastolicRestriction = GreaterThanDoubleAttributeRestriction(restrictedAttribute: BloodPressure.diastolic, value: diastolicValue)
		query.expression = andExpression(systolicRestriction, diastolicRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBloodPressuresInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBloodPressure() {
		// given
		let systolicValue = 54.6
		let diastolicValue =  18.3
		let expectedSamples = [BloodPressure(systolic: systolicValue, diastolic: diastolicValue, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			BloodPressure(systolic: diastolicValue, diastolic: systolicValue, Date() - 2.days),
			BloodPressure(systolic: systolicValue - 1, diastolic: diastolicValue, Date() - 2.days),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue + 2, Date() - 2.days),
			BloodPressure(Date() - 2.days),
			BloodPressure(systolic: systolicValue, diastolic: diastolicValue)
		])

		let systolicRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.systolic, value: systolicValue)
		let diastolicRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BloodPressure.diastolic, value: diastolicValue)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(systolicRestriction, diastolicRestriction, timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}
}
