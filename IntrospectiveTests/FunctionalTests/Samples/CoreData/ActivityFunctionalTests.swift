//
//  ActivityFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class ActivityFunctionalTests: FunctionalTest {

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = DoubleAttribute(name: "this is not a real attribute")
		let activity = ActivityDataTestUtil.createActivity()

		// when
		XCTAssertThrowsError(try activity.value(of: unknownAttribute)) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenNameAttribute_valueOf_returnsCorrectName() throws {
		// given
		let expectedName = "this is a name"
		let activity = ActivityDataTestUtil.createActivity(name: expectedName)

		// when
		let name = try activity.value(of: Activity.nameAttribute) as? String

		// then
		XCTAssertEqual(name, expectedName)
	}

	func testGivenDurationAttribute_valueOf_returnsCorrectDuration() throws {
		// given
		let startDate = Date() - 10.days
		let endDate = Date()
		let expectedDuration = Duration(start: startDate, end: endDate)
		let activity = ActivityDataTestUtil.createActivity(startDate: startDate, endDate: endDate)

		// when
		let duration = try activity.value(of: Activity.durationAttribute) as? Duration

		// then
		XCTAssertEqual(duration, expectedDuration)
	}

	func testGivenStartDateAttribute_valueOf_returnsCorrectStartDate() throws {
		// given
		let expectedStartDate = Date()
		let activity = ActivityDataTestUtil.createActivity(startDate: expectedStartDate)

		// when
		let startDate = try activity.value(of: CommonSampleAttributes.startDate) as? Date

		// then
		XCTAssertEqual(startDate, expectedStartDate)
	}

	func testGivenEndDateAttribute_valueOf_returnsCorrectEndDate() throws {
		// given
		let expectedEndDate = Date()
		let activity = ActivityDataTestUtil.createActivity(endDate: expectedEndDate)

		// when
		let endDate = try activity.value(of: Activity.endDateAttribute) as? Date

		// then
		XCTAssertEqual(endDate, expectedEndDate)
	}

	func testGivenNoteAttribute_valueOf_returnsCorrectNote() throws {
		// given
		let expectedNote = "this is a note"
		let activity = ActivityDataTestUtil.createActivity(note: expectedNote)

		// when
		let notes = try activity.value(of: Activity.noteAttribute) as? String

		// then
		XCTAssertEqual(notes, expectedNote)
	}

	func testGivenTagsAttribute_valueOf_returnsCorrectTags() throws {
		// given
		let expectedDefinitionTag = TagDataTestUtil.createTag(name: "expected definition tag")
		let definition = ActivityDataTestUtil.createActivityDefinition(tags: [expectedDefinitionTag])
		let expectedActivityTag = TagDataTestUtil.createTag(name: "expected activity tag")
		let expectedTags = [expectedActivityTag, expectedDefinitionTag]
		let activity = ActivityDataTestUtil.createActivity(definition: definition, tags: [expectedActivityTag])

		// when
		let tags = try activity.value(of: Activity.tagsAttribute) as? [Tag]

		// then
		XCTAssertEqual(tags, expectedTags)
	}

	// MARK: - set(attribute:to:)

	func testGivenNameAttribute_set_correctlySetsName() throws {
		// given
		let expectedName = "this is a name"
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.nameAttribute, to: expectedName)

		// then
		XCTAssertEqual(expectedName, activity.definition.name)
	}

	func testGivenDurationAttribute_set_throwsUnknownAttributeException() throws {
		// given
		let activity = ActivityDataTestUtil.createActivity()

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.durationAttribute, to: Duration(0))) { error in
			// then
			XCTAssertEqual(error as? AttributeError, AttributeError.unknownAttribute)
		}
	}

	func testGivenStartDateAttribute_set_correctlySetsStartDate() throws {
		// given
		let expectedStartDate = Date()
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: CommonSampleAttributes.startDate, to: expectedStartDate)

		// then
		XCTAssertEqual(activity.startDate, expectedStartDate)
	}

	func testGivenEndDateAttribute_set_correctlySetsEndDate() throws {
		// given
		let expectedEndDate = Date()
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.endDateAttribute, to: expectedEndDate)

		// then
		XCTAssertEqual(activity.endDate, expectedEndDate)
	}

	func testGivenNotesAttribute_set_correctlySetsNotes() throws {
		// given
		let expectedNote = "this is a note about the activity"
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.noteAttribute, to: expectedNote)

		// then
		XCTAssertEqual(expectedNote, activity.note)
	}

	func testGivenTagsAttribute_set_correctlySetsTags() throws {
		// given
		let expectedTags = [TagDataTestUtil.createTag(name: "expected tag 1"), TagDataTestUtil.createTag(name: "expected tag 2")]
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.tagsAttribute, to: expectedTags)

		// then
		XCTAssert(activity.tagsArray().elementsEqual(expectedTags, by: { $0.equalTo($1) }))
	}
}
