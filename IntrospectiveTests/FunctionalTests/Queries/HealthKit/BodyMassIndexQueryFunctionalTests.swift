//
//  BodyMassIndexQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

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

	func testGivenNoBodyMassIndexesInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneBodyMassIndexInHealthKitWithUnrestrictedQuery_runQuery_returnsThatBodyMassIndex() {
		// given
		let expected = BodyMassIndex(89)
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

	func testGivenMultipleBodyMassIndexesInHealthKitAndRestrictionOnBodyMassIndexThatShouldOnlyReturnOneBodyMassIndex_runQuery_returnsThatOneBodyMassIndex() {
		// given
		let value = 83.7
		let expected = BodyMassIndex(value)
		HealthKitDataTestUtil.save([
			expected,
			BodyMassIndex(value - 1),
		])

		let bmiRestriction = EqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
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

	func testGivenMultipleBodyMassIndexesInDatabaseThatMatchGivenBodyMassIndexRestriction_runQuery_returnsAllMatchingBodyMassIndexes() {
		// given
		let value = 54.6
		let expected1 = BodyMassIndex(value)
		let expected2 = BodyMassIndex(value - 1)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			BodyMassIndex(value + 1),
		])

		let bmiRestriction = LessThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
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

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleBodyMassIndexesInHealthKitWithOnlyOneThatMatches_runQuery_returnsThatBodyMassIndex() {
		// given
		let value = 54.6
		let expected = BodyMassIndex(value, Date() - 2.days)
		HealthKitDataTestUtil.save([
			expected,
			BodyMassIndex(value - 2),
			BodyMassIndex(value - 1),
			BodyMassIndex(),
		])

		let bmiRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: BodyMassIndex.bmi, value: value)
		let timestampRestriction = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: BodyMassIndex.timestamp, date: Date() - 1.days)
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
