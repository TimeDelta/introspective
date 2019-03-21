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
		let expectedSamples = [Weight(89)]
		HealthKitDataTestUtil.save(expectedSamples)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenMultipleWeightsInHealthKitAndRestrictionOnWeightThatShouldOnlyReturnOneWeight_runQuery_returnsThatOneWeight() {
		// given
		let value = 83.7
		let expectedSamples = [Weight(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value - 1)])

		let WeightRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenMultipleWeightsInDatabaseThatMatchGivenWeightRestriction_runQuery_returnsAllMatchingWeights() {
		// given
		let value = 54.6
		let expectedSamples = [Weight(value), Weight(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value + 1)])

		let WeightRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.attributeRestrictions.append(WeightRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleWeightsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatWeight() {
		// given
		let value = 54.6
		let expectedSamples = [Weight(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value - 2), Weight(value - 1), Weight()])

		let WeightRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(WeightRestriction)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenAllWeightsGreaterThan170OnSpecificDate_runQuery_returnsCorrectWeights() {
		// given
		let startOfTargetDay = CalendarUtilImpl().start(of: .day, in: Date())

		let query = WeightQueryImpl()
		let minWeight = 170.0
		let expectedSamples = [
			Weight(minWeight + 1, startOfTargetDay + 17.hours + 23.minutes + 34.seconds),
		]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			Weight(minWeight + 5, startOfTargetDay + 5.days), // expected on wrong day
			Weight(minWeight - 1, startOfTargetDay - 1.hours),
			Weight(minWeight - 1, startOfTargetDay + 1.hours), // wrong weight, right day
			Weight(minWeight - 23, startOfTargetDay + 1.days),
		])

		let minWeightRestriction = GreaterThanDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: minWeight)
		query.attributeRestrictions.append(minWeightRestriction)
		let dateRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: startOfTargetDay)
		query.attributeRestrictions.append(dateRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}
}
