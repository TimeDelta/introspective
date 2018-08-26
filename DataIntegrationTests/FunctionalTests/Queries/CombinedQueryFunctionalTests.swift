//
//  CombinedQueryFunctionalTests.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class CombinedQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: Query!

	override func setUp() {
		super.setUp()
		HeartRateDataTestUtil.ensureAuthorized()
		HeartRateDataTestUtil.deleteAllHeartRates()
	}

	override func tearDown() {
		HeartRateDataTestUtil.deleteAllHeartRates()
		super.tearDown()
	}

	func testGivenQueryForAllHeartRatesWithinTenDaysOfAMoodGreaterThanOrEqualToTwoWithNoteThatContainsTheWordSad_runQuery_returnsCorrectHeartRates() {
		// given
		let numberOfDaysWithinMood = 10
		let daySpread = 10.days
		let earliestTargetMoodDate = Date()
		let latestTargetMoodDate = earliestTargetMoodDate + daySpread

		query = HeartRateQueryImpl()
		let expectedHeartRate1 = HeartRate(earliestTargetMoodDate - 2.days)
		let expectedHeartRate2 = HeartRate(earliestTargetMoodDate - 5.days - 16.hours - 12.minutes - 3.seconds)
		let unexpectedHeartRate1 = HeartRate(earliestTargetMoodDate - numberOfDaysWithinMood.days - 1.days)
		let unexpectedHeartRate2 = HeartRate(latestTargetMoodDate + numberOfDaysWithinMood.days + 1.days)
		let unexpectedHeartRate3 = HeartRate(latestTargetMoodDate + numberOfDaysWithinMood.days + 5.days)
		HeartRateDataTestUtil.saveHeartRates(expectedHeartRate1, expectedHeartRate2, unexpectedHeartRate1, unexpectedHeartRate2, unexpectedHeartRate3)

		let subQuery = MoodQueryImpl()
		let targetSubstring = "sad"
		let similarNoteThatWillNotBeMatched = String(targetSubstring.prefix(targetSubstring.count - 1))
		let minMood = 2.0
		let noteRestriction = ContainsStringAttributeRestriction(attribute: MoodImpl.note, substring: targetSubstring)
		let ratingRestriction = GreaterThanOrEqualToNumericAttributeRestriction(attribute: MoodImpl.rating, value: minMood)
		subQuery.attributeRestrictions.append(noteRestriction)
		subQuery.attributeRestrictions.append(ratingRestriction)
		let matcher = WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: numberOfDaysWithinMood, timeUnit: .day, mostRecentOnly: false)
		let _ = createMood(note: "\(targetSubstring) some other stuff", rating: minMood, timestamp: earliestTargetMoodDate) // target mood
		let _ = createMood(note: "prefix \(targetSubstring) suffix", rating: minMood + 1, timestamp: latestTargetMoodDate) // target mood
		let _ = createMood(note: similarNoteThatWillNotBeMatched, timestamp: earliestTargetMoodDate)
		let _ = createMood(timestamp: latestTargetMoodDate)
		let _ = createMood(note: targetSubstring, rating: minMood - 0.1)
		let _ = createMood(rating: minMood + 1)
		DependencyInjector.db.save()

		query.subQuery = (matcher: matcher, query: subQuery)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedHeartRate1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedHeartRate2) }))
			}
		}
	}

	fileprivate func createMood(note: String? = nil, rating: Double = 0.0, timestamp: Date = Date()) -> MoodImpl {
		return MoodDataTestUtil.createMood(note: note, rating: rating, timestamp: timestamp)
	}
}
