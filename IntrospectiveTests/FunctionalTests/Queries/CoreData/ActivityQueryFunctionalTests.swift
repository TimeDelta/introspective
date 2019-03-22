//
//  ActivityQueryFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

class ActivityQueryFunctionalTests: QueryFunctionalTest {

	private var query: ActivityQuery!

	final override func setUp() {
		super.setUp()
		query = ActivityQueryImpl()
	}

	func testGivenNoActivitiesInDatabase_runQuery_returnsNoSamplesFoundError() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			XCTAssert(waitError == nil)
			XCTAssert(self.error != nil)
			XCTAssert(self.error is NoSamplesFoundQueryError)
		}
	}

	func testGivenOneActivityInDatabaseAndQueryContainsNoRestrictions_runQuery_returnsThatActivity() throws {
		// given
		let expectedSamples: [Sample] = [createActivity(name: "expected")]

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForSpecificActivityName_runQuery_returnsCorrectSamples() {
		// given
		let expectedActivityName = "name of the target activity"
		let expectedSamples: [Sample] = [createActivity(name: expectedActivityName)]
		let _ = createActivity(name: "unexpected")

		let nameRestriction = EqualToStringAttributeRestriction(restrictedAttribute: Activity.nameAttribute, value: expectedActivityName)
		query.attributeRestrictions.append(nameRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForSpecificTag_runQuery_returnsCorrectSamples() {
		// given
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let expectedSamples: [Sample] = [createActivity(name: "expected", tags: [targetTag])]
		let _ = createActivity(name: "unexpected")

		let tagRestriction = HasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: targetTag)
		query.attributeRestrictions.append(tagRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForAllActivitiesStartingAfterSpecificDate_runQuery_returnsCorrectSamples() {
		// given
		let targetDate = Date()
		let expectedSamples: [Sample] = [createActivity(name: "expected", startDate: targetDate + 1.days)]
		let _ = createActivity(name: "unexpected", startDate: targetDate - 10.days)

		let startDateRestriction = AfterDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.startDate, date: targetDate)
		query.attributeRestrictions.append(startDateRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForAllActivitiesEndingBeforeSpecificDate_runQuery_returnsCorrectSamples() {
		// given
		let targetDate = Date() + 2.days
		let expectedSamples: [Sample] = [createActivity(name: "expected", endDate: targetDate - 1.hours)]
		let _ = createActivity(name: "unexpected", endDate: targetDate + 10.days)

		let endDateRestriction = BeforeDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.optionalEndDate, date: targetDate)
		query.attributeRestrictions.append(endDateRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForActivitiesWithSpecificTagThatIsOnlyOnDefinition_runQuery_returnsCorrectSamples() {
		// given
		let targetTag = TagDataTestUtil.createTag(name: "target tag")
		let targetDefinition = createActivityDefinition(name: "expected", tags: [targetTag])
		let expectedSamples: [Sample] = [createActivity(definition: targetDefinition)]
		let _ = createActivity(name: "unexpected")

		let tagRestriction = HasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: targetTag)
		query.attributeRestrictions.append(tagRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForActivitiesWithNoteContainingText_runQuery_returnsCorrectSamples() {
		// given
		let targetNoteSubstring = "part of a note"
		let expectedSamples: [Sample] = [createActivity(name: "expected", note: "other " + targetNoteSubstring + " stuff")]
		let _ = createActivity(name: "unexpected", note: "does not contain target substring")

		let noteRestriction = ContainsStringAttributeRestriction(restrictedAttribute: Activity.noteAttribute, substring: targetNoteSubstring)
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

	private final func createActivityDefinition(name: String = "", description: String? = nil, tags: [Tag] = []) -> ActivityDefinition {
		return ActivityDataTestUtil.createActivityDefinition(name: name, description: description, tags: tags)
	}

	private final func createActivity(
		definition: ActivityDefinition? = nil,
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		tags: [Tag] = [])
	-> Activity {
		return ActivityDataTestUtil.createActivity(
			definition: definition ?? createActivityDefinition(),
			startDate: startDate,
			endDate: endDate,
			note: note,
			tags: tags)
	}

	public final func createActivity(
		name: String,
		startDate: Date = Date(),
		endDate: Date? = nil,
		note: String? = nil,
		tags: [Tag] = [])
	-> Activity {
		return ActivityDataTestUtil.createActivity(name: name, startDate: startDate, endDate: endDate, note: note, tags: tags)
	}
}
