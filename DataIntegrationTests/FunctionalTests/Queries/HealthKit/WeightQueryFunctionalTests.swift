//
//  WeightQueryFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class WeightQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: WeightQueryImpl!

	override func setUp() {
		super.setUp()
		query = WeightQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(.weight)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(.weight)
		super.tearDown()
	}

	func testGivenNoWeightsInHealthKit_runQuery_returnsNoSamplesFoundError() {
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
			XCTAssert(self.error is NoHealthKitSamplesFoundQueryError, self.error?.localizedDescription ?? "")
		}
	}

	func testGivenOneWeightInHealthKit_runQuery_returnsThatWeight() {
		// given
		let weight = Weight(89)
		HealthKitDataTestUtil.saveWeights(weight)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(weight), self.expected(weight, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleWeightsInHealthKitAndRestrictionOnWeightThatShouldOnlyReturnOneWeight_runQuery_returnsThatOneWeight() {
		// given
		let value = 83.7
		let expectedWeight = Weight(value)
		let unexpectedWeight = Weight(value - 1)
		HealthKitDataTestUtil.saveWeights(expectedWeight, unexpectedWeight)

		let WeightRestriction = EqualToNumericAttributeRestriction(attribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedWeight), self.expected(expectedWeight, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleWeightsInDatabaseThatMatchGivenWeightRestriction_runQuery_returnsAllMatchingWeights() {
		// given
		let value = 54.6
		let expectedWeight1 = Weight(value)
		let expectedWeight2 = Weight(value - 1)
		let unexpectedWeight = Weight(value + 1)
		HealthKitDataTestUtil.saveWeights(expectedWeight1, expectedWeight2, unexpectedWeight)

		let WeightRestriction = LessThanOrEqualToNumericAttributeRestriction(attribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedWeight1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedWeight2) }))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleWeightsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatWeight() {
		// given
		let value = 54.6
		let expectedWeight = Weight(value, Date() - 2.days)
		let unexpectedWeight1 = Weight(value - 2)
		let unexpectedWeight2 = Weight(value - 1)
		let unexpectedWeight3 = Weight()
		HealthKitDataTestUtil.saveWeights(expectedWeight, unexpectedWeight1, unexpectedWeight2, unexpectedWeight3)

		let WeightRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: Weight.weight, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(attribute: Weight.timestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(WeightRestriction)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedWeight), self.expected(expectedWeight, butGot: self.samples[0]))
			}
		}
	}
}
