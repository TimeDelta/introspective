//
//  RestingRestingHeartRateQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class RestingHeartRateQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: RestingHeartRateQueryImpl!

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
		let expected = RestingHeartRate(89)
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

	func testGivenMultipleRestingHeartRatesInHealthKitAndRestrictionOnRestingHeartRateThatShouldOnlyReturnOneRestingHeartRate_runQuery_returnsThatOneRestingHeartRate() {
		// given
		let value = 83.7
		let expected = RestingHeartRate(value)
		HealthKitDataTestUtil.save([
			expected,
			RestingHeartRate(value - 1),
		])

		let restingHeartRateRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		query.attributeRestrictions.append(restingHeartRateRestriction)

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

	func testGivenMultipleRestingHeartRatesInDatabaseThatMatchGivenrestingHeartRateRestriction_runQuery_returnsAllMatchingRestingHeartRates() {
		// given
		let value = 54.6
		let expected1 = RestingHeartRate(value)
		let expected2 = RestingHeartRate(value - 1)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			RestingHeartRate(value + 1),
		])

		let restingHeartRateRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		query.attributeRestrictions.append(restingHeartRateRestriction)

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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleRestingHeartRatesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatRestingHeartRate() {
		// given
		let value = 54.6
		let expected = RestingHeartRate(value, Date() - 2.days)
		HealthKitDataTestUtil.save([
			expected,
			RestingHeartRate(value - 2),
			RestingHeartRate(value - 1),
			RestingHeartRate(),
		])

		let restingHeartRateRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: RestingHeartRate.restingHeartRate, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(restingHeartRateRestriction)
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
