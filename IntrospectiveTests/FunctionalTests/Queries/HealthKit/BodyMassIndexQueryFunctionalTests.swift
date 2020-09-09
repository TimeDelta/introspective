//
//  BodyMassIndexQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

class BodyMassIndexQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: BodyMassIndexQueryImpl!

	override func setUp() {
		super.setUp()
		query = BodyMassIndexQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(BodyMassIndex.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(BodyMassIndex.self)
		super.tearDown()
	}

	func testGivenNoBodyMassIndexesInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneBodyMassIndexInHealthKitWithUnrestrictedQuery_runQuery_returnsThatBodyMassIndex() {
		// given
		let expectedSamples = [BodyMassIndex(89)]
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

	func testGivenMultipleBodyMassIndexesInHealthKitAndRestrictionOnBodyMassIndexThatShouldOnlyReturnOneBodyMassIndex_runQuery_returnsThatOneBodyMassIndex() {
		// given
		let value = 83.7
		let expectedSamples = [BodyMassIndex(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([BodyMassIndex(value - 1)])

		let bmiRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
		query.expression = bmiRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleBodyMassIndexesInDatabaseThatMatchGivenBodyMassIndexRestriction_runQuery_returnsAllMatchingBodyMassIndexes() {
		// given
		let value = 54.6
		let expectedSamples = [BodyMassIndex(value), BodyMassIndex(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([BodyMassIndex(value + 1)])

		let bmiRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
		query.expression = bmiRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBodyMassIndexesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBodyMassIndex() {
		// given
		let value = 54.6
		let expectedSamples = [BodyMassIndex(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			BodyMassIndex(value - 2),
			BodyMassIndex(value - 1),
			BodyMassIndex(),
		])

		let bmiRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(bmiRestriction, timestampRestriction)

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
