//
//  LeanBodyMassQueryFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 9/4/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

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
		let expected = LeanBodyMass(89)
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

	func testGivenMultipleLeanBodyMassesInHealthKitAndRestrictionOnLeanBodyMassThatShouldOnlyReturnOneLeanBodyMass_runQuery_returnsThatOneLeanBodyMass() {
		// given
		let value = 83.7
		let expected = LeanBodyMass(value)
		HealthKitDataTestUtil.save([
			expected,
			LeanBodyMass(value - 1),
		])

		let leanBodyMassRestriction = EqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		query.attributeRestrictions.append(leanBodyMassRestriction)

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

	func testGivenMultipleLeanBodyMassesInDatabaseThatMatchGivenLeanBodyMassRestriction_runQuery_returnsAllMatchingLeanBodyMasses() {
		// given
		let value = 54.6
		let expected1 = LeanBodyMass(value)
		let expected2 = LeanBodyMass(value - 1)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			LeanBodyMass(value + 1),
		])

		let leanBodyMassRestriction = LessThanOrEqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		query.attributeRestrictions.append(leanBodyMassRestriction)

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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleLeanBodyMassesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatLeanBodyMass() {
		// given
		let value = 54.6
		let expected = LeanBodyMass(value, Date() - 2.days)
		HealthKitDataTestUtil.save([
			expected,
			LeanBodyMass(value - 2),
			LeanBodyMass(value - 1),
			LeanBodyMass(),
		])

		let leanBodyMassRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(attribute: LeanBodyMass.timestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(leanBodyMassRestriction)
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
