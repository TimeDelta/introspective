//
//  WeightQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Common
@testable import Queries
@testable import Samples

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

	func testGivenNoWeightsInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneWeightInHealthKitWithUnrestrictedQuery_runQuery_returnsThatWeight() {
		// given
		let expectedSamples = [Weight(89)]
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

	func testGivenMultipleWeightsInHealthKitAndRestrictionOnWeightThatShouldOnlyReturnOneWeight_runQuery_returnsThatOneWeight() {
		// given
		let value = 83.7
		let expectedSamples = [Weight(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value - 1)])

		let weightRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.expression = weightRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleWeightsInDatabaseThatMatchGivenWeightRestriction_runQuery_returnsAllMatchingWeights() {
		// given
		let value = 54.6
		let expectedSamples = [Weight(value), Weight(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value + 1)])

		let weightRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		query.expression = weightRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleWeightsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatWeight() {
		// given
		let value = 54.6
		let expectedSamples = [Weight(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Weight(value - 2), Weight(value - 1), Weight()])

		let weightRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: Weight.weight, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(weightRestriction, timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
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
		let dateRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: startOfTargetDay)
		query.expression = andExpression(minWeightRestriction, dateRestriction)

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
