//
//  RestingRestingHeartRateQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

class RestingHeartRateQueryFunctionalTests: QueryFunctionalTest {

	private var query: RestingHeartRateQueryImpl!

	override func setUp() {
		super.setUp()
		query = RestingHeartRateQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(RestingHeartRate.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(RestingHeartRate.self)
		super.tearDown()
	}

	func testGivenNoRestingHeartRatesInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneRestingHeartRateInHealthKitWithUnrestrictedQuery_runQuery_returnsThatRestingHeartRate() {
		// given
		let expectedSamples = [RestingHeartRate(89)]
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

	func testGivenMultipleRestingHeartRatesInHealthKitAndRestrictionOnRestingHeartRateThatShouldOnlyReturnOneRestingHeartRate_runQuery_returnsThatOneRestingHeartRate() {
		// given
		let value = 83.7
		let expectedSamples = [RestingHeartRate(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([RestingHeartRate(value - 1)])

		let restingHeartRateRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		query.expression = restingHeartRateRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleRestingHeartRatesInDatabaseThatMatchGivenrestingHeartRateRestriction_runQuery_returnsAllMatchingRestingHeartRates() {
		// given
		let value = 54.6
		let expectedSamples = [RestingHeartRate(value), RestingHeartRate(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([RestingHeartRate(value + 1)])

		let restingHeartRateRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		query.expression = restingHeartRateRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleRestingHeartRatesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatRestingHeartRate() {
		// given
		let value = 54.6
		let expectedSamples = [RestingHeartRate(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			RestingHeartRate(value - 2),
			RestingHeartRate(value - 1),
			RestingHeartRate(),
		])

		let restingHeartRateRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(restingHeartRateRestriction, timestampRestriction)

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
