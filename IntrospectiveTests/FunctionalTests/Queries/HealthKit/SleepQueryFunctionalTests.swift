//
//  SleepQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import Queries
@testable import Samples

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

	func testGivenNoSleepRecordsInHealthKit_runQuery_returnsEmptyArray() {
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

	func testGivenOneSleepInHealthKitWithUnrestrictedQuery_runQuery_returnsThatSleepRecords() {
		// given
		let expectedSamples = [Sleep()]
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

	func testGivenMultipleSleepRecordsInHealthKitAndRestrictionOnSleepThatShouldOnlyReturnOneSleep_runQuery_returnsThatOneSleep() {
		// given
		let date = Date()
		let expectedSamples = [Sleep(startDate: date)]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([Sleep(startDate: date - 1.days)])

		let timestampRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate, date: date)
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

	func testGivenMultipleSleepRecordsInDatabaseThatMatchGivenSleepRestriction_runQuery_returnsAllMatchingSleepRecords() {
		// given
		let startDate = Date()
		let endDate = startDate + 2.days
		let expectedSamples = [
			Sleep(.asleep, startDate: startDate + 1.days, endDate: endDate),
			Sleep(.asleep, startDate: startDate + 23.hours, endDate: endDate)
		]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			Sleep(.asleep, startDate: startDate - 1.days, endDate: endDate),
			Sleep(.asleep, startDate: startDate + 1.days, endDate: endDate + 2.days),
			Sleep(.awake, startDate: startDate + 1.days, endDate: endDate + 1.days),
			Sleep(.inBed, startDate: startDate + 1.days, endDate: endDate + 1.days),
		])

		let sleepStateRestriction = EqualToSelectOneAttributeRestriction(restrictedAttribute: Sleep.stateAttribute, value: Sleep.State.asleep, valueAttribute: Sleep.stateAttribute)
		let startDateRestriction = AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate, date: startDate)
		let endDateRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitEndDate, date: endDate)
		query.expression = andExpression(sleepStateRestriction, startDateRestriction, endDateRestriction)

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
