//
//  SexualActivityQueryFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class SexualActivityQueryFunctionalTests: QueryFunctionalTest {

	private var query: SexualActivityQueryImpl!

	override func setUp() {
		super.setUp()
		query = SexualActivityQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(SexualActivity.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(SexualActivity.self)
		super.tearDown()
	}

	func testGivenNoSexualActivitiesInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneSexualActivityInHealthKitWithUnrestrictedQuery_runQuery_returnsThatSexualActivities() {
		// given
		let expected = SexualActivity()
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

	func testGivenMultipleSexualActivitiesInHealthKitAndRestrictionOnSexualActivityThatShouldOnlyReturnOneSexualActivity_runQuery_returnsThatOneSexualActivity() {
		// given
		let date = Date()
		let expected = SexualActivity(date)
		HealthKitDataTestUtil.save([
			expected,
			SexualActivity(date - 1.days),
		])

		let timestampRestriction = OnDateAttributeRestriction(attribute: SexualActivity.timestamp, date: date)
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

	func testGivenMultipleSexualActivitiesInDatabaseThatMatchGivenSexualActivityRestriction_runQuery_returnsAllMatchingSexualActivities() {
		// given
		let date = Date()
		let expected1 = SexualActivity(date + 1.days)
		let expected2 = SexualActivity(date + 2.days)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			SexualActivity(date - 1.days),
		])

		let timestampRestriction = AfterDateAndTimeAttributeRestriction(attribute: SexualActivity.timestamp, date: date)
		query.attributeRestrictions.append(timestampRestriction)

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
}
