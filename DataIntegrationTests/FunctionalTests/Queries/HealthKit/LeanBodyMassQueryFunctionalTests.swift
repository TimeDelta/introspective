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

	func testGivenNoBodyMassIndexsInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneBodyMassIndexInHealthKit_runQuery_returnsThatBodyMassIndex() {
		// given
		let expected = LeanBodyMass(89)
		HealthKitDataTestUtil.save(type: LeanBodyMass.self, [expected])

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

	func testGivenMultipleBodyMassIndexsInHealthKitAndRestrictionOnBodyMassIndexThatShouldOnlyReturnOneBodyMassIndex_runQuery_returnsThatOneBodyMassIndex() {
		// given
		let value = 83.7
		let expected = LeanBodyMass(value)
		let unexpected = LeanBodyMass(value - 1)
		HealthKitDataTestUtil.save(type: LeanBodyMass.self, [expected, unexpected])

		let bmiRestriction = EqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		query.attributeRestrictions.append(bmiRestriction)

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

	func testGivenMultipleBodyMassIndexsInDatabaseThatMatchGivenBodyMassIndexRestriction_runQuery_returnsAllMatchingBodyMassIndexs() {
		// given
		let value = 54.6
		let expected1 = LeanBodyMass(value)
		let expected2 = LeanBodyMass(value - 1)
		let unexpected = LeanBodyMass(value + 1)
		HealthKitDataTestUtil.save(type: LeanBodyMass.self, [expected1, expected2, unexpected])

		let bmiRestriction = LessThanOrEqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		query.attributeRestrictions.append(bmiRestriction)

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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBodyMassIndexsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBodyMassIndex() {
		// given
		let value = 54.6
		let expected = LeanBodyMass(value, Date() - 2.days)
		let unexpected1 = LeanBodyMass(value - 2)
		let unexpected2 = LeanBodyMass(value - 1)
		let unexpected3 = LeanBodyMass()
		HealthKitDataTestUtil.save(type: LeanBodyMass.self, [expected, unexpected1, unexpected2, unexpected3])

		let bmiRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: LeanBodyMass.leanBodyMass, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(attribute: LeanBodyMass.timestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(bmiRestriction)
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
