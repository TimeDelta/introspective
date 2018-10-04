//
//  HeartRateQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

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

	func testGivenNoHeartRatesInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneHeartRateInHealthKitWithUnrestrictedQuery_runQuery_returnsThatHeartRate() {
		// given
		let expected = HeartRate(89)
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

	func testGivenMultipleHeartRatesInHealthKitAndRestrictionOnHeartRateThatShouldOnlyReturnOneHeartRate_runQuery_returnsThatOneHeartRate() {
		// given
		let value = 83.7
		let expected = HeartRate(value)
		HealthKitDataTestUtil.save([
			expected,
			HeartRate(value - 1),
		])

		let heartRateRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		query.attributeRestrictions.append(heartRateRestriction)

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

	func testGivenMultipleHeartRatesInDatabaseThatMatchGivenHeartRateRestriction_runQuery_returnsAllMatchingHeartRates() {
		// given
		let value = 54.6
		let expected1 = HeartRate(value)
		let expected2 = HeartRate(value - 1)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			HeartRate(value + 1),
		])

		let heartRateRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		query.attributeRestrictions.append(heartRateRestriction)

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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleHeartRatesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatHeartRate() {
		// given
		let value = 54.6
		let expected = HeartRate(value, Date() - 2.days)
		HealthKitDataTestUtil.save([
			expected,
			HeartRate(value - 2),
			HeartRate(value - 1),
			HeartRate(),
		])

		let heartRateRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(heartRateRestriction)
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
