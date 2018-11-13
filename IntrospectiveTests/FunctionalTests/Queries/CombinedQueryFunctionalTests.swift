//
//  CombinedQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class CombinedQueryFunctionalTests: QueryFunctionalTest {

	fileprivate var query: Query!

	override func setUp() {
		super.setUp()
		HealthKitDataTestUtil.ensureAuthorized()
		HealthKitDataTestUtil.deleteAll(HeartRate.self)
		HealthKitDataTestUtil.deleteAll(Weight.self)
		HealthKitDataTestUtil.deleteAll(BodyMassIndex.self)
		HealthKitDataTestUtil.deleteAll(LeanBodyMass.self)
	}

	override func tearDown() {
		HealthKitDataTestUtil.deleteAll(HeartRate.self)
		HealthKitDataTestUtil.deleteAll(Weight.self)
		HealthKitDataTestUtil.deleteAll(BodyMassIndex.self)
		HealthKitDataTestUtil.deleteAll(LeanBodyMass.self)
		super.tearDown()
	}

	func testGivenQueryForAllHeartRatesWithinTenDaysOfAMoodGreaterThanOrEqualToTwoWithNoteThatContainsTheWordSad_runQuery_returnsCorrectHeartRates() {
		// given
		let numberOfDaysWithinMood = 10
		let daySpread = 10
		let earliestTargetMoodDate = Date()
		let latestTargetMoodDate = earliestTargetMoodDate + daySpread.days

		query = HeartRateQueryImpl()
		let expectedSamples = [
			HeartRate(1, earliestTargetMoodDate - 2.days),
			HeartRate(2, earliestTargetMoodDate - 5.days - 16.hours - 12.minutes - 3.seconds)
		]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			HeartRate(3, earliestTargetMoodDate - numberOfDaysWithinMood.days - 1.days),
			HeartRate(4, latestTargetMoodDate + numberOfDaysWithinMood.days + 1.days),
			HeartRate(5, latestTargetMoodDate + numberOfDaysWithinMood.days + 5.days),
		])

		let subQuery = MoodQueryImpl()
		let targetSubstring = "sad"
		let similarNoteThatWillNotBeMatched = String(targetSubstring.prefix(targetSubstring.count - 1))
		let minMood = 2.0
		let noteRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: targetSubstring)
		let ratingRestriction = GreaterThanOrEqualToDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: minMood)
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
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForHeartRatesOnDaysWithAWeightGreaterThan170AndAMoodLessThan2_runQuery_returnsCorrectHeartRates() {
		// given
		let startOfTargetDay = CalendarUtilImpl().start(of: .day, in: Date())

		query = HeartRateQueryImpl()
		let expectedSamples = [
			HeartRate(1, startOfTargetDay + 2.hours),
			HeartRate(2, startOfTargetDay + 5.hours + 17.minutes + 2.seconds)
		]
		HealthKitDataTestUtil.save(expectedSamples)
		HealthKitDataTestUtil.save([
			HeartRate(3, startOfTargetDay - 1.minutes),
			HeartRate(4, startOfTargetDay + 1.days),
			HeartRate(5, startOfTargetDay + 5.days),
		])

		let moodSubQuery = MoodQueryImpl()
		let maxMood = 2.0
		let ratingRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: maxMood)
		moodSubQuery.attributeRestrictions.append(ratingRestriction)
		let _ = createMood(rating: 0.0, timestamp: startOfTargetDay) // target mood
		let _ = createMood(rating: maxMood - 0.1, timestamp: startOfTargetDay) // target mood
		let _ = createMood(rating: maxMood + 1, timestamp: startOfTargetDay - 1.hours)
		let _ = createMood(rating: maxMood + 2, timestamp: startOfTargetDay + 1.days)
		let _ = createMood(rating: maxMood + 2, timestamp: startOfTargetDay + 5.days) // on same wrong day as an expected weight
		DependencyInjector.db.save()

		let weightSubQuery = WeightQueryImpl()
		let minWeight = 170.0
		HealthKitDataTestUtil.save([
			Weight(minWeight + 1, startOfTargetDay + 17.hours + 23.minutes + 34.seconds), // target
			Weight(minWeight + 5, startOfTargetDay + 5.days), // expected on wrong day
			Weight(minWeight - 1, startOfTargetDay - 1.hours),
			Weight(minWeight - 23, startOfTargetDay + 1.days),
		])

		let matcher = InSameCalendarUnitSubQueryMatcher(timeUnit: .day, mostRecentOnly: false)
		moodSubQuery.subQuery = (matcher: matcher, query: weightSubQuery)
		query.subQuery = (matcher: matcher, query: moodSubQuery)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	fileprivate func createMood(note: String? = nil, rating: Double = 0.0, timestamp: Date = Date()) -> MoodImpl {
		return MoodDataTestUtil.createMood(note: note, rating: rating, timestamp: timestamp)
	}
}
