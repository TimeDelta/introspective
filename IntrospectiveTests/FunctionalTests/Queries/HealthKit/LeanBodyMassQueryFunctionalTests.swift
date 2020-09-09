//
//  LeanBodyMassQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

final class LeanBodyMassQueryFunctionalTests: QueryFunctionalTest {

	private var query: LeanBodyMassQueryImpl!

	override func setUp() {
		super.setUp()
		query = LeanBodyMassQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(LeanBodyMass.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(LeanBodyMass.self)
		super.tearDown()
	}

	func testGivenNoLeanBodyMassesInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneLeanBodyMassInHealthKitWithUnrestrictedQuery_runQuery_returnsThatLeanBodyMasses() {
		// given
		let expectedSamples = [LeanBodyMass(89)]
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

	func testGivenMultipleLeanBodyMassesInHealthKitAndRestrictionOnLeanBodyMassThatShouldOnlyReturnOneLeanBodyMass_runQuery_returnsThatOneLeanBodyMass() {
		// given
		let value = 83.7
		let expectedSamples = [LeanBodyMass(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([LeanBodyMass(value - 1)])

		let leanBodyMassRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: LeanBodyMass.leanBodyMass, value: value)
		query.expression = leanBodyMassRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenMultipleLeanBodyMassesInDatabaseThatMatchGivenLeanBodyMassRestriction_runQuery_returnsAllMatchingLeanBodyMasses() {
		// given
		let value = 54.6
		let expectedSamples = [LeanBodyMass(value), LeanBodyMass(value - 1)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([LeanBodyMass(value + 1)])

		let leanBodyMassRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: LeanBodyMass.leanBodyMass, value: value)
		query.expression = leanBodyMassRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleLeanBodyMassesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatLeanBodyMass() {
		// given
		let value = 54.6
		let expectedSamples = [LeanBodyMass(value, Date() - 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			LeanBodyMass(value - 2),
			LeanBodyMass(value - 1),
			LeanBodyMass(),
		])

		let leanBodyMassRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: LeanBodyMass.leanBodyMass, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: Date() - 1.days)
		query.expression = andExpression(leanBodyMassRestriction, timestampRestriction)

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
