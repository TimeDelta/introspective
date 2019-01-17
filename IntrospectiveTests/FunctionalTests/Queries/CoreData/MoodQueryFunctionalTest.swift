//
//  MoodQueryFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/21/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class MoodQueryFunctionalTest: QueryFunctionalTest {

	private var query: MoodQueryImpl!

	final override func setUp() {
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

	func testGivenOneMoodInDatabaseAndQueryContainsNoRestrictions_runQuery_returnsThatMood() throws {
		// given
		let expectedSamples = [createMood(note: "this is a test note")]

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenMultipleMoodsInDatabaseAndRestrictionOnNoteThatShouldOnlyReturnOneMood_runQuery_returnsThatOneMood() throws {
		// given
		let note = "this is a test note"
		let expectedSamples = [createMood(note: note)]
		let _ = createMood(note: "something that doesn't contain the target note text")

		let noteRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: note)
		query.attributeRestrictions.append(noteRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenMultipleMoodsInDatabaseThatMatchGivenNoteRestriction_runQuery_returnsAllMatchingMoods() throws {
		// given
		let note = "this is a test note"
		let expectedSamples = [
			createMood(note: note, rating: 1.0),
			createMood(note: note, rating: 2.0)
		]
		let _ = createMood()

		let noteRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: note)
		query.attributeRestrictions.append(noteRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryHasOneRestrictionForEachAttributeAndMultipleMoodsInDatabaseWithOnlyOneThatMatches_runQuery_returnsThatMood() throws {
		// given
		let note = "this is a test note"
		let expectedSamples = [createMood(note: note, rating: 1.0)]
		let _ = createMood(note: note, rating: 1.0, timestamp: Date() - 2.days)
		let _ = createMood(note: note, rating: 2.0)
		let _ = createMood(rating: 1.0)
		let _ = createMood()

		let noteRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: note)
		let timestampRestriction = AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: Date() - 1.days)
		let ratingRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 2.0)
		query.attributeRestrictions.append(noteRestriction)
		query.attributeRestrictions.append(timestampRestriction)
		query.attributeRestrictions.append(ratingRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	private func createMood(note: String? = nil, rating: Double = 0.0, timestamp: Date = Date()) -> MoodImpl {
		return MoodDataTestUtil.createMood(note: note, rating: rating, timestamp: timestamp)
	}
}
