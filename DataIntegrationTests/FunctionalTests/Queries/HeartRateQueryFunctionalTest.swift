//
//  HeartRateQueryFunctionalTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/23/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class HeartRateQueryFunctionalTest: QueryFunctionalTest {

	fileprivate var query: HeartRateQueryImpl!

	override func setUp() {
		super.setUp()
		query = HeartRateQueryImpl()
		HeartRateDataTestUtil.ensureAuthorized()
	}

	override func tearDown() {
		HeartRateDataTestUtil.deleteAllHeartRates()
		super.tearDown()
	}

	func testGivenNoHeartRatesInHealthKit_runQuery_returnsNoSamplesFoundError() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			XCTAssert(waitError == nil)
			var message = ""
			if self.error == nil {
				message = "Found " + String(self.samples.count) + " samples"
			}
			XCTAssert(self.error != nil, message)
			XCTAssert(self.error is NoSamplesFoundQueryError, self.error?.localizedDescription ?? "")
		}
	}

	func testGivenOneHeartRateInHealthKit_runQuery_returnsThatHeartRate() {
		// given
		let heartRate = HeartRate()
		heartRate.heartRate = 89
		heartRate.timestamp = Date()
		HeartRateDataTestUtil.saveHeartRates(heartRate)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(heartRate), self.expected(heartRate, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleHeartRatesInHealthKitAndRestrictionOnHeartRateThatShouldOnlyReturnOneHeartRate_runQuery_returnsThatOneHeartRate() {
		// given
		let value = 83.7
		let expectedHeartRate = HeartRate(value)
		let unexpectedHeartRate = HeartRate(value - 1)
		HeartRateDataTestUtil.saveHeartRates(expectedHeartRate, unexpectedHeartRate)

		let heartRateRestriction = EqualToNumericAttributeRestriction(attribute: HeartRate.heartRate, value: value)
		query.attributeRestrictions.append(heartRateRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedHeartRate), self.expected(expectedHeartRate, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleMoodsInDatabaseThatMatchGivenHeartRateRestriction_runQuery_returnsAllMatchingHeartRates() {
		// given
		let value = 54.6
		let expectedHeartRate1 = HeartRate(value)
		let expectedHeartRate2 = HeartRate(value - 1)
		let unexpectedHeartRate = HeartRate(value + 1)
		HeartRateDataTestUtil.saveHeartRates(expectedHeartRate1, expectedHeartRate2, unexpectedHeartRate)

		let heartRateRestriction = LessThanOrEqualToNumericAttributeRestriction(attribute: HeartRate.heartRate, value: value)
		query.attributeRestrictions.append(heartRateRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedHeartRate1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedHeartRate2) }))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleHeartRatesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatHeartRate() {
		// given
		let value = 54.6
		let expectedHeartRate = HeartRate(value, Date() - 2.days)
		let unexpectedHeartRate1 = HeartRate(value - 2)
		let unexpectedHeartRate2 = HeartRate(value - 1)
		let unexpectedHeartRate3 = HeartRate()
		HeartRateDataTestUtil.saveHeartRates(expectedHeartRate, unexpectedHeartRate1, unexpectedHeartRate2, unexpectedHeartRate3)

		let heartRateRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: HeartRate.heartRate, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(attribute: CommonSampleAttributes.timestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(heartRateRestriction)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedHeartRate), self.expected(expectedHeartRate, butGot: self.samples[0]))
			}
		}
	}
}
