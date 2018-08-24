//
//  MoodQueryFunctionalTest.swift
//  DataIntegrationTests
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import DataIntegration

class MoodQueryFunctionalTest: QueryFunctionalTest {

	fileprivate var query: MoodQuery!

	override func setUp() {
		super.setUp()
		query = MoodQueryImpl()
	}

	func testGivenNoMoodsInDatabase_runQuery_returnsNoSamplesFoundError() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			XCTAssert(waitError == nil)
			XCTAssert(self.error != nil)
			XCTAssert(self.error is NoSamplesFoundQueryError)
		}
	}

	func testGivenOneMoodInDatabaseAndQueryContainsNoRestrictions_runQuery_returnsThatMood() {
		// given
		let mood = createMood(note: "this is a test note")
		DependencyInjector.db.save()

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0] as! MoodImpl == mood)
			}
		}
	}

	func testGivenMultipleMoodsInDatabaseAndRestrictionOnNoteThatShouldOnlyReturnOneMood_runQuery_returnsThatOneMood() {
		// given
		let note = "this is a test note"
		let expectedMood = createMood(note: note)
		let _ = createMood(note: "something that doesn't contain the target note text")
		DependencyInjector.db.save()

		let noteRestriction = ContainsStringAttributeRestriction(attribute: MoodImpl.note, substring: note)
		query.attributeRestrictions.append(noteRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0] as! MoodImpl == expectedMood)
			}
		}
	}

	func testGivenMultipleMoodsInDatabaseThatMatchGivenNoteRestriction_runQuery_returnsAllMatchingMoods() {
		// given
		let note = "this is a test note"
		let expectedMood1 = createMood(note: note, rating: 1.0)
		let expectedMood2 = createMood(note: note, rating: 2.0)
		let _ = createMood()
		DependencyInjector.db.save()

		let noteRestriction = ContainsStringAttributeRestriction(attribute: MoodImpl.note, substring: note)
		query.attributeRestrictions.append(noteRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 2, "Found \(self.samples.count) samples")
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedMood1) }))
				XCTAssert(self.samples.contains(where: { m in return m.equalTo(expectedMood2) }))
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleMoodsInDatabaseWithOnlyOneThatMatches_runQuery_returnsThatMood() {
		// given
		let note = "this is a test note"
		let expectedMood = createMood(note: note, rating: 1.0)
		let _ = createMood(note: note, rating: 1.0, timestamp: Date() - 2.days)
		let _ = createMood(note: note, rating: 2.0)
		let _ = createMood(rating: 1.0)
		let _ = createMood()
		DependencyInjector.db.save()

		let noteRestriction = ContainsStringAttributeRestriction(attribute: MoodImpl.note, substring: note)
		let timestampRestriction = AfterDateAndTimeAttributeRestriction(attribute: CommonSampleAttributes.timestamp, date: Date() - 1.days)
		let ratingRestriction = LessThanNumericAttributeRestriction(attribute: MoodImpl.rating, value: 2.0)
		query.attributeRestrictions.append(noteRestriction)
		query.attributeRestrictions.append(timestampRestriction)
		query.attributeRestrictions.append(ratingRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { (waitError) in
			if self.assertNoErrors(waitError) {
				XCTAssert(self.samples.count == 1, "Found \(self.samples.count) samples")
				XCTAssert(self.samples[0].equalTo(expectedMood))
			}
		}
	}

	fileprivate func createMood(note: String? = nil, rating: Double = 0.0, timestamp: Date = Date()) -> MoodImpl {
		return MoodDataTestUtil.createMood(note: note, rating: rating, timestamp: timestamp)
	}
}
