//
//  WeightQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class WeightQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: WeightQueryImpl!

	override func setUp() {
		super.setUp()
		query = WeightQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(Weight.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(Weight.self)
		super.tearDown()
	}

	func testGivenNoWeightsInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneWeightInHealthKitWithUnrestrictedQuery_runQuery_returnsThatWeight() {
		// given
		let expected = Weight(89)
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

	func testGivenMultipleWeightsInHealthKitAndRestrictionOnWeightThatShouldOnlyReturnOneWeight_runQuery_returnsThatOneWeight() {
		// given
		let value = 83.7
		let expected = Weight(value)
		HealthKitDataTestUtil.save([expected, Weight(value - 1)])

		let WeightRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

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

	func testGivenMultipleWeightsInDatabaseThatMatchGivenWeightRestriction_runQuery_returnsAllMatchingWeights() {
		// given
		let value = 54.6
		let expected1 = Weight(value)
		let expected2 = Weight(value - 1)
		HealthKitDataTestUtil.save([expected1, expected2, Weight(value + 1)])

		let WeightRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleWeightsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatWeight() {
		// given
		let value = 54.6
		let expected = Weight(value, Date() - 2.days)
		HealthKitDataTestUtil.save([expected, Weight(value - 2), Weight(value - 1), Weight()])

		let WeightRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(WeightRestriction)
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
