//
//  SleepQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

class SleepQueryFunctionalTests: QueryFunctionalTest {

	private var query: SleepQueryImpl!

	override func setUp() {
		super.setUp()
		query = SleepQueryImpl()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(Sleep.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(Sleep.self)
		super.tearDown()
	}

	func testGivenNoSleepRecordsInHealthKit_runQuery_returnsNoSamplesFoundError() {
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

	func testGivenOneSleepInHealthKitWithUnrestrictedQuery_runQuery_returnsThatSleepRecords() {
		// given
		let expected = Sleep()
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

	func testGivenMultipleSleepRecordsInHealthKitAndRestrictionOnSleepThatShouldOnlyReturnOneSleep_runQuery_returnsThatOneSleep() {
		// given
		let date = Date()
		let expected = Sleep(date)
		HealthKitDataTestUtil.save([
			expected,
			Sleep(date - 1.days),
		])

		let timestampRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate, date: date)
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

	func testGivenMultipleSleepRecordsInDatabaseThatMatchGivenSleepRestriction_runQuery_returnsAllMatchingSleepRecords() {
		// given
		let date = Date()
		let expected1 = Sleep(date + 1.days)
		let expected2 = Sleep(date + 2.days)
		HealthKitDataTestUtil.save([
			expected1,
			expected2,
			Sleep(date - 1.days),
		])

		let timestampRestriction = AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate, date: date)
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
