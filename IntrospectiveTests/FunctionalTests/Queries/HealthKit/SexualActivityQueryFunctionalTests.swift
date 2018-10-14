//
//  SexualActivityQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

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
		let expectedSamples = [SexualActivity()]
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

	func testGivenMultipleSexualActivitiesInHealthKitAndRestrictionOnSexualActivityThatShouldOnlyReturnOneSexualActivity_runQuery_returnsThatOneSexualActivity() {
		// given
		let date = Date()
		let expectedSamples = [SexualActivity(date)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([SexualActivity(date - 1.days)])

		let timestampRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: date)
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

	func testGivenMultipleSexualActivitiesInDatabaseThatMatchGivenSexualActivityRestriction_runQuery_returnsAllMatchingSexualActivities() {
		// given
		let date = Date()
		let expectedSamples = [SexualActivity(date + 1.days), SexualActivity(date + 2.days)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([SexualActivity(date - 1.days)])

		let timestampRestriction = AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: date)
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
