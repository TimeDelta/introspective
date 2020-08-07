//
//  ActivityFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 11/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
import Hamcrest
import CSV
@testable import Introspective
@testable import AttributeRestrictions
@testable import Attributes
@testable import Common
@testable import DependencyInjection
@testable import Persistence
@testable import Samples
@testable import Settings

final class ActivityFunctionalTests: FunctionalTest {

	// MARK: - duration

	func testGivenDifferentTimeZonesForStartAndEnd_duration_returnsCorrectDuration() throws {
		// given
		injected(Settings.self).setConvertTimeZones(true)
		do {
			try injected(Settings.self).save()
		} catch {
			XCTFail("Failed to save convert time zone setting")
		}

		let transaction = injected(Database.self).transaction()
		let activity = try transaction.new(Activity.self)

		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		let expectedInterval: DateComponents = 3.hours

		let startTimeZone = TimeZone(abbreviation: "PST")!
		calendarUtil.setTimeZone(startTimeZone)
		let startDate = Date()
		activity.start = startDate

		let endTimeZone = TimeZone(abbreviation: "EST")!
		calendarUtil.setTimeZone(endTimeZone)
		activity.end = startDate + expectedInterval

		// when
		let duration = activity.duration

		// then
		let expectedDuration = TimeDuration(expectedInterval)
		assertThat(duration, equalTo(expectedDuration))
	}

	// MARK: - export(to:)

	func testGivenNilStartDateTimeZone_exportTo_doesNotThrowError() throws {
		// given
		let transaction = database.transaction()
		let definition = ActivityDataTestUtil.createActivityDefinition()
		let activity = try transaction.new(Activity.self)
		let csv = try CSVWriter(stream: OutputStream.toMemory())
		activity.definition = try transaction.pull(savedObject: definition)
		activity.setSource(.aTracker)
		activity.start = Date()

		// when
		try activity.export(to: csv)

		// then - no error thrown
	}

	func testGivenNilEndDate_exportTo_doesNotThrowError() throws {
		// given
		let activity = ActivityDataTestUtil.createActivity(endDate: nil)
		let csv = try CSVWriter(stream: OutputStream.toMemory())

		// when
		try activity.export(to: csv)

		// then - no error thrown
	}

	func testGivenNilEndDateTimeZone_exportTo_doesNotThrowError() throws {
		// given
		let transaction = database.transaction()
		let definition = ActivityDataTestUtil.createActivityDefinition()
		let activity = try transaction.new(Activity.self)
		activity.definition = try transaction.pull(savedObject: definition)
		activity.start = Date()
		let csv = try CSVWriter(stream: OutputStream.toMemory())

		// when
		try activity.export(to: csv)

		// then - no error thrown
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = DoubleAttribute(name: "this is not a real attribute")
		let activity = ActivityDataTestUtil.createActivity()

		// when
		XCTAssertThrowsError(try activity.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
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
		let expectedDuration = TimeDuration(start: startDate, end: endDate)
		let activity = ActivityDataTestUtil.createActivity(startDate: startDate, endDate: endDate)

		// when
		let duration = try activity.value(of: Activity.durationAttribute) as? TimeDuration

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
		let endDate = try activity.value(of: CommonSampleAttributes.optionalEndDate) as? Date

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

	func testGivenNameAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let value = 23

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.nameAttribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenNameAttribute_set_correctlySetsName() throws {
		// given
		let expectedName = "this is a name"
		ActivityDataTestUtil.createActivityDefinition(name: expectedName)
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.nameAttribute, to: expectedName)

		// then
		XCTAssertEqual(expectedName, activity.definition.name)
	}

	func testGivenNameAttributeWithNameOfNonExistentDefinition_set_throwsUnsupportedValueError() throws {
		// given
		let nonExistentName = "this doesn't exist"
		let activity = ActivityDataTestUtil.createActivity()

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.nameAttribute, to: nonExistentName)) { error in
			// then
			XCTAssert(error is UnsupportedValueError)
		}
	}

	func testGivenDurationAttribute_set_throwsUnknownAttributeException() throws {
		// given
		let activity = ActivityDataTestUtil.createActivity()

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.durationAttribute, to: TimeDuration(0))) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenStartDateAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let value = 23

		// when
		XCTAssertThrowsError(try activity.set(attribute: CommonSampleAttributes.startDate, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenStartDateAttribute_set_correctlySetsStartDate() throws {
		// given
		let expectedStartDate = Date()
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: CommonSampleAttributes.startDate, to: expectedStartDate)

		// then
		XCTAssertEqual(activity.start, expectedStartDate)
	}

	func testGivenStartDateAttributeAndStartDateTimeZoneNotYetSet_set_setsStartDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		injected(Settings.self).setConvertTimeZones(true)
		do {
			try injected(Settings.self).save()
		} catch {
			XCTFail("Failed to save convert time zone setting")
		}
		let transaction = injected(Database.self).transaction()
		let activity = try transaction.new(Activity.self)
		let startDate = Date()

		// when
		try activity.set(attribute: CommonSampleAttributes.startDate, to: startDate)

		// then
		let expectedDate = injected(CalendarUtil.self).convert(startDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(activity.start, expectedDate)
	}

	func testGivenEndDateAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let value = 23

		// when
		XCTAssertThrowsError(try activity.set(attribute: CommonSampleAttributes.optionalEndDate, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenEndDateAttribute_set_correctlySetsEndDate() throws {
		// given
		let expectedEndDate = Date()
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: CommonSampleAttributes.optionalEndDate, to: expectedEndDate)

		// then
		XCTAssertEqual(activity.end, expectedEndDate)
	}

	func testGivenEndDateAttributeAndEndDateTimeZoneNotYetSet_set_setsEndDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		injected(Settings.self).setConvertTimeZones(true)
		do {
			try injected(Settings.self).save()
		} catch {
			XCTFail("Failed to save convert time zone setting")
		}
		let transaction = injected(Database.self).transaction()
		let activity = try transaction.new(Activity.self)
		let endDate = Date()

		// when
		try activity.set(attribute: CommonSampleAttributes.optionalEndDate, to: endDate)

		// then
		let expectedDate = injected(CalendarUtil.self).convert(endDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(activity.end, expectedDate)
	}

	func testGivenNoteAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let value = 23

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.noteAttribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenNoteAttribute_set_correctlySetsNotes() throws {
		// given
		let expectedNote = "this is a note about the activity"
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.noteAttribute, to: expectedNote)

		// then
		XCTAssertEqual(expectedNote, activity.note)
	}

	func testGivenTagsAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let value = 23

		// when
		XCTAssertThrowsError(try activity.set(attribute: Activity.tagsAttribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenTagsAttribute_set_correctlySetsTags() throws {
		// given
		let expectedTag1 = TagDataTestUtil.createTag(name: "expected tag 1")
		let expectedTag2 = TagDataTestUtil.createTag(name: "expected tag 2")
		let activity = ActivityDataTestUtil.createActivity()

		// when
		try activity.set(attribute: Activity.tagsAttribute, to: [expectedTag1, expectedTag2] as Any)

		// then
		assertThat(activity.tagsArray(), containsInAnyOrder(expectedTag1, expectedTag2))
	}

	// MARK: - setTags()

	func testGivenActivityAlreadyHasTags_setTags_replacesExistingTagsWithSpecifiedOnes() throws {
		// given
		let originalTag1 = TagDataTestUtil.createTag(name: "original 1")
		let originalTag2 = TagDataTestUtil.createTag(name: "original 2")

		let expectedTag1 = TagDataTestUtil.createTag(name: "expected 1")
		let expectedTag2 = TagDataTestUtil.createTag(name: "expected 2")

		let activity = ActivityDataTestUtil.createActivity(tags: [originalTag1, originalTag2])

		// when
		try activity.setTags([expectedTag1, expectedTag2])

		// then
		assertThat(activity.tagsArray(), containsInAnyOrder(expectedTag1, expectedTag2))
		assertThat(activity.tagsArray(), not(containsInAnyOrder(originalTag1, originalTag2)))
	}

	// MARK: - setSource()

	func testGivenIntrospectiveWithTimeZoneNotSet_setSource_setsStartDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		injected(Settings.self).setConvertTimeZones(true)
		do {
			try injected(Settings.self).save()
		} catch {
			XCTFail("Failed to save convert time zone setting")
		}
		let transaction = injected(Database.self).transaction()
		let activity = try transaction.new(Activity.self)

		// when
		activity.setSource(.introspective)

		// then
		let startDate = Date()
		activity.start = startDate
		let expectedDate = injected(CalendarUtil.self).convert(startDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(activity.start, expectedDate)
	}

	func testGivenIntrospectiveWithTimeZoneNotSet_setSource_setsEndDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		injected(Settings.self).setConvertTimeZones(true)
		do {
			try injected(Settings.self).save()
		} catch {
			XCTFail("Failed to save convert time zone setting")
		}
		let transaction = injected(Database.self).transaction()
		let activity = try transaction.new(Activity.self)

		// when
		activity.setSource(.introspective)

		// then
		let endDate = Date()
		activity.end = endDate
		let expectedDate = injected(CalendarUtil.self).convert(endDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(activity.end, expectedDate)
	}

	// MARK: - graphableValue(of:)

	func testGivenDurationAttribute_graphableValueOf_returnsDurationInHoursAsDouble() throws {
		// given
		let startDate = Date()
		let endDate = startDate + 4.hours + 15.minutes
		let activity = ActivityDataTestUtil.createActivity(startDate: startDate, endDate: endDate)

		// when
		let graphableDuration = try activity.graphableValue(of: Activity.durationAttribute) as? Double

		// then
		XCTAssertEqual(graphableDuration, 4.25)
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let activity = ActivityDataTestUtil.createActivity()
		let areEqual = activity == activity

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwoActivitiesWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let otherActivity = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity == otherActivity

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = EqualToDoubleAttributeRestriction(restrictedAttribute: DoubleAttribute(name: ""))

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let activity = ActivityDataTestUtil.createActivity()
		let areEqual = activity.equalTo(activity as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenStartDateMismatch_equalToAttributed_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start + 1.days,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalToAttributed_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: (activity.end ?? Date()) + 1.days,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDefinitionMismatch_equalToAttributed_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			name: activity.definition.name + "other stuff",
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalToAttributed_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: (activity.note ?? "") + "other stuff",
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalToAttributed_returnsFalse() {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag")
		let activity = ActivityDataTestUtil.createActivity(tags: [tag])
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: [otherTag])

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalToAttributed_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())
		other.source = activity.source + 1

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoActivitiesWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	func testGivenWrongClass_equalToSample_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = HeartRate(12, Date())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToSample_returnsTrue() {
		// when
		let activity = ActivityDataTestUtil.createActivity()
		let areEqual = activity.equalTo(activity as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenStartDateMismatch_equalToSample_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start + 1.days,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalToSample_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: (activity.end ?? Date()) + 1.days,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDefinitionMismatch_equalToSample_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			name: activity.definition.name + "other stuff",
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalToSample_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: (activity.note ?? "") + "other stuff",
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalToSample_returnsFalse() {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag")
		let activity = ActivityDataTestUtil.createActivity(tags: [tag])
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: [otherTag])

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalToSample_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())
		other.source = activity.source + 1

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoActivitiesWithSameValues_equalToSample_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other as Sample)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(activity:)

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// when
		let activity = ActivityDataTestUtil.createActivity()
		let areEqual = activity.equalTo(activity)

		// then
		XCTAssert(areEqual)
	}

	func testGivenStartDateMismatch_equalTo_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start + 1.days,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenEndDateMismatch_equalTo_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: (activity.end ?? Date()) + 1.days,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDefinitionMismatch_equalTo_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			name: activity.definition.name + "other stuff",
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNoteMismatch_equalTo_returnsFalse() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: (activity.note ?? "") + "other stuff",
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTagsMismatch_equalTo_returnsFalse() {
		// given
		let tag = TagDataTestUtil.createTag(name: "tag")
		let activity = ActivityDataTestUtil.createActivity(tags: [tag])
		let otherTag = TagDataTestUtil.createTag(name: "other tag")
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: [otherTag])

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalTo_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())
		other.source = activity.source + 1

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoActivitiesWithSameValues_equalTo_returnsTrue() {
		// given
		let activity = ActivityDataTestUtil.createActivity()
		let other = ActivityDataTestUtil.createActivity(
			definition: activity.definition,
			startDate: activity.start,
			endDate: activity.end,
			note: activity.note,
			tags: activity.tagsArray())

		// when
		let areEqual = activity.equalTo(other)

		// then
		XCTAssert(areEqual)
	}
}
