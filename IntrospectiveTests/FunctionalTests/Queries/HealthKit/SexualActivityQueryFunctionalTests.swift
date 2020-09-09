//
//  SexualActivityQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

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

	func testGivenNoSexualActivitiesInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneSexualActivityInHealthKitWithUnrestrictedQuery_runQuery_returnsThatSexualActivity() {
		// given
		let expectedSamples = [SexualActivity()]
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

	func testGivenMultipleSexualActivitiesInHealthKitAndRestrictionOnSexualActivityThatShouldOnlyReturnOneSexualActivity_runQuery_returnsThatOneSexualActivity() {
		// given
		let date = Date()
		let expectedSamples = [SexualActivity(date)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([SexualActivity(date - 1.days)])

		let timestampRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitTimestamp, date: date)
		query.expression = timestampRestriction

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				assertThat(self.samples, onlyHasExpectedSamples(expectedSamples))
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
		query.expression = timestampRestriction

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
