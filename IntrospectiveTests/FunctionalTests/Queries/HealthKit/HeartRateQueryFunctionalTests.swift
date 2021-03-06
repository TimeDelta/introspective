//
//  HeartRateQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

class HeartRateQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: HeartRateQueryImpl!

	override func setUp() {
		super.setUp()
		query = HeartRateQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(HeartRate.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(HeartRate.self)
		super.tearDown()
	}

	func testGivenNoHeartRatesInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneHeartRateInHealthKitWithUnrestrictedQuery_runQuery_returnsThatHeartRate() {
		// given
		let expectedSamples = [HeartRate(89)]
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

	func testGivenMultipleHeartRatesInHealthKitAndRestrictionOnHeartRateThatShouldOnlyReturnOneHeartRate_runQuery_returnsThatOneHeartRate() {
		// given
		let value = 83.7
		let expectedSamples = [HeartRate(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([HeartRate(value - 1)])

		let heartRateRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		query.expression = heartRateRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleHeartRatesInDatabaseThatMatchGivenHeartRateRestriction_runQuery_returnsAllMatchingHeartRates() {
		// given
		let value = 54.6
		let expectedSamples = [HeartRate(value), HeartRate(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([HeartRate(value + 1)])

		let heartRateRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		query.expression = heartRateRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleHeartRatesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatHeartRate() {
		// given
		let value = 54.6
		let expectedSamples = [HeartRate(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			HeartRate(value - 2),
			HeartRate(value - 1),
			HeartRate(),
		])

		let heartRateRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(heartRateRestriction, timestampRestriction)

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
