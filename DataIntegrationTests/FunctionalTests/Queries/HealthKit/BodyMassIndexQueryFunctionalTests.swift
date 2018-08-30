//
//  BodyMassIndexQueryFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class BodyMassIndexQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: BodyMassIndexQueryImpl!

	override func setUp() {
		super.setUp()
		query = BodyMassIndexQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(.bmi)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(.bmi)
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
		let bmi = BodyMassIndex(89)
		HealthKitDataTestUtil.saveBMIs(bmi)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(bmi), self.expected(bmi, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleBodyMassIndexsInHealthKitAndRestrictionOnBodyMassIndexThatShouldOnlyReturnOneBodyMassIndex_runQuery_returnsThatOneBodyMassIndex() {
		// given
		let value = 83.7
		let expectedBodyMassIndex = BodyMassIndex(value)
		let unexpectedBodyMassIndex = BodyMassIndex(value - 1)
		HealthKitDataTestUtil.saveBMIs(expectedBodyMassIndex, unexpectedBodyMassIndex)

		let bmiRestriction = EqualToNumericAttributeRestriction(attribute: BodyMassIndex.bmi, value: value)
		query.attributeRestrictions.append(bmiRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedBodyMassIndex), self.expected(expectedBodyMassIndex, butGot: self.samples[0]))
			}
		}
	}

	func testGivenMultipleBodyMassIndexsInDatabaseThatMatchGivenBodyMassIndexRestriction_runQuery_returnsAllMatchingBodyMassIndexs() {
		// given
		let value = 54.6
		let expectedBodyMassIndex1 = BodyMassIndex(value)
		let expectedBodyMassIndex2 = BodyMassIndex(value - 1)
		let unexpectedBodyMassIndex = BodyMassIndex(value + 1)
		HealthKitDataTestUtil.saveBMIs(expectedBodyMassIndex1, expectedBodyMassIndex2, unexpectedBodyMassIndex)

		let bmiRestriction = LessThanOrEqualToNumericAttributeRestriction(attribute: BodyMassIndex.bmi, value: value)
		query.attributeRestrictions.append(bmiRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedBodyMassIndex1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedBodyMassIndex2) }))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBodyMassIndexsInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBodyMassIndex() {
		// given
		let value = 54.6
		let expectedBodyMassIndex = BodyMassIndex(value, Date() - 2.days)
		let unexpectedBodyMassIndex1 = BodyMassIndex(value - 2)
		let unexpectedBodyMassIndex2 = BodyMassIndex(value - 1)
		let unexpectedBodyMassIndex3 = BodyMassIndex()
		HealthKitDataTestUtil.saveBMIs(expectedBodyMassIndex, unexpectedBodyMassIndex1, unexpectedBodyMassIndex2, unexpectedBodyMassIndex3)

		let bmiRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: BodyMassIndex.bmi, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(attribute: BodyMassIndex.timestamp, date: Date() - 1.days)
		query.attributeRestrictions.append(bmiRestriction)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedBodyMassIndex), self.expected(expectedBodyMassIndex, butGot: self.samples[0]))
			}
		}
	}
}
