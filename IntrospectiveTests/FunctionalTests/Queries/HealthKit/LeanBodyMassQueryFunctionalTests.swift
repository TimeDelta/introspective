//
//  LeanBodyMassQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

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

	func testGivenNoLeanBodyMassesInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneLeanBodyMassInHealthKitWithUnrestrictedQuery_runQuery_returnsThatLeanBodyMasses() {
		// given
		let expectedSamples = [LeanBodyMass(89)]
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

	func testGivenMultipleLeanBodyMassesInHealthKitAndRestrictionOnLeanBodyMassThatShouldOnlyReturnOneLeanBodyMass_runQuery_returnsThatOneLeanBodyMass() {
		// given
		let value = 83.7
		let expectedSamples = [LeanBodyMass(value)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([LeanBodyMass(value - 1)])

		let leanBodyMassRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: LeanBodyMass.leanBodyMass, value: value)
		query.attributeRestrictions.append(leanBodyMassRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
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
		query.attributeRestrictions.append(leanBodyMassRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
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
		query.attributeRestrictions.append(leanBodyMassRestriction)
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
}
