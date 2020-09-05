//
//  ActivityDAOFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 9/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate

@testable import Samples

class ActivityDAOFunctionalTests: FunctionalTest {

	// MARK: Test Setup

	private typealias Me = ActivityDAOFunctionalTests

	private static let definitionInfo = ActivityDefinitionInfo(
		name: "med name",
		description: "this is a description",
		tags: ["1", "a"],
		source: .introspective,
		autoNote: true,
		recordScreenIndex: 0)

	private var dao: ActivityDAOImpl!

	public override final func setUp() {
		super.setUp()
		dao = ActivityDAOImpl()
	}

	// MARK: - getAllActivitiesForToday(_ definition:)

	func testGivenNoActivitiesForSpecifiedDefinition_getAllActivitiesForToday_returnsEmptyArray() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition()
		ActivityDataTestUtil.createActivity(definition: otherDefinition)

		// when
		let result = try dao.getAllActivitiesForToday(definition)

		// then
		assertThat(result, hasCount(0))
	}

	func testGivenActivitiesExistTodayForSpecifiedDefinition_getAllActivitiesForToday_returnsThoseActivities() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let expectedActivity1 = ActivityDataTestUtil.createActivity(definition: definition)
		let expectedActivity2 = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		let result = try dao.getAllActivitiesForToday(definition)

		// then
		assertThat(result, hasItems(expectedActivity1, expectedActivity2))
	}

	func testGivenOnlyActivitiesFromDifferentDayForSpecifiedDefinition_getAllActivitiesForToday_returnsEmptyArray() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition, startDate: Date() - 1.days)
		ActivityDataTestUtil.createActivity(definition: definition, startDate: Date() - 2.days)

		// when
		let result = try dao.getAllActivitiesForToday(definition)

		// then
		assertThat(result, hasCount(0))
	}

	func testGivenActivityStartedYesteredayAndEndsToday_getAllActivitiesForToday_returnsThatActivity() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let expectedActivity = ActivityDataTestUtil.createActivity(
			definition: definition,
			startDate: Date() - 1.days,
			endDate: Date())

		// when
		let result = try dao.getAllActivitiesForToday(definition)

		// then
		assertThat(result, hasItem(expectedActivity))
	}

	// MARK: - getMostRecentActivityEndDate()

	func testGivenNoActivitiesExist_getMostRecentActivityEndDate_returnsNil() throws {
		// given
		ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.getMostRecentActivityEndDate()

		// then
		assertThat(result, nilValue())
	}

	func testGivenActivitiesExist_getMostRecentActivityEndDate_returnsCorrectDate() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let expectedDate = Date() - 2.hours
		ActivityDataTestUtil.createActivity(definition: definition, endDate: expectedDate)
		ActivityDataTestUtil.createActivity(definition: definition, endDate: expectedDate - 1.days)

		// when
		let result = try dao.getMostRecentActivityEndDate()

		// then
		assertThat(result, equalTo(expectedDate))
	}

	// MARK: - getMostRecentlyStartedActivity(for:)

	func testGivenSpecifiedDefinitionNeverStarted_getMostRecentlyStartedActivity_returnsNil() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.getMostRecentlyStartedActivity(for: definition)

		// then
		assertThat(result, nilValue())
	}

	func testGivenOnlyActivitiesForOtherDefinition_getMostRecentlyStartedActivity_returnsNil() throws {
		// given
		let targetDefinition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition(name: "other")
		ActivityDataTestUtil.createActivity(definition: otherDefinition)

		// when
		let result = try dao.getMostRecentlyStartedActivity(for: targetDefinition)

		// then
		assertThat(result, nilValue())
	}

	func testGivenMultipleUnfinishedActivitiesForDefinition_getMostRecentlyStartedActivity_returnsMostRecentlyStarted() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition)
		let newerActivity = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		let result = try dao.getMostRecentlyStartedActivity(for: definition)

		// then
		assertThat(result, equals(newerActivity))
	}

	func testGivenMultipleFinishedActivitiesForDefinition_getMostRecentlyStartedActivity_returnsMostRecentlyStarted() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition, startDate: Date() - 1.days, endDate: Date())
		let newerActivity = ActivityDataTestUtil.createActivity(
			definition: definition,
			startDate: Date() - 1.days,
			endDate: Date()
		)

		// when
		let result = try dao.getMostRecentlyStartedActivity(for: definition)

		// then
		assertThat(result, equals(newerActivity))
	}

	func testGivenMixedActivitiesForDefinition_getMostRecentlyStartedActivity_returnsMostRecentlyStarted() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition)
		ActivityDataTestUtil.createActivity(definition: definition, endDate: Date())
		let newestActivity = ActivityDataTestUtil.createActivity(definition: definition, endDate: Date())

		// when
		let result = try dao.getMostRecentlyStartedActivity(for: definition)

		// then
		assertThat(result, equals(newestActivity))
	}

	// MARK: - getMostRecentlyStartedIncompleteActivity(definition:)


	func testGivenNoActivities_getMostRecentlyStartedIncompleteActivity_returnsNil() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.getMostRecentlyStartedIncompleteActivity(for: definition)

		// then
		assertThat(result, nilValue())
	}

	func testGivenOnlyActivitiesForOtherDefinition_getMostRecentlyStartedIncompleteActivity_returnsNil() throws {
		// given
		let targetDefinition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition(name: "other")
		ActivityDataTestUtil.createActivity(definition: otherDefinition)

		// when
		let result = try dao.getMostRecentlyStartedIncompleteActivity(for: targetDefinition)

		// then
		assertThat(result, nilValue())
	}

	func testGivenOnlyCompletedActivities_getMostRecentlyStartedIncompleteActivity_returnsNil() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition, endDate: Date())

		// when
		let result = try dao.getMostRecentlyStartedIncompleteActivity(for: definition)

		// then
		assertThat(result, nilValue())
	}

	func testGivenMultipleIncompleteActivities_getMostRecentlyStartedIncompleteActivity_returnsMostRecent() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition)
		let newerActivity = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		let result = try dao.getMostRecentlyStartedIncompleteActivity(for: definition)

		// then
		assertThat(result, equals(newerActivity))
	}

	// MARK: - getDefinitionWith(name:)

	func testGivenNoDefinitionWithName_getDefinitionWith_returnsNil() throws {
		// given
		ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.getDefinitionWith(name: "doesn't exist")

		// then
		assertThat(result, nilValue())
	}

	func testGivenDefinitionWithNameExists_getDefinitionWith_returnsThatDefinition() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.getDefinitionWith(name: definition.name)

		// then
		assertThat(result, equals(definition))
	}

	// MARK: - activityDefinitionWithNameExists()

	func testGivenNoDefinitionWithName_activityDefinitionWithNameExists_returnsFalse() throws {
		// given
		ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.activityDefinitionWithNameExists("doesn't exist")

		// then
		XCTAssertFalse(result)
	}

	func testGivenDefinitionWithNameExists_activityDefinitionWithNameExists_returnsTrue() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)

		// when
		let result = try dao.activityDefinitionWithNameExists(definition.name)

		// then
		XCTAssert(result)
	}

	// MARK: - hasUnfinishedActivity()

	func testGivenNoUnfinishedActivitiesForDefinition_hasUnfinishedActivity_returnsFalse() throws {
		// given
		let targetDefinition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		let otherDefinition = ActivityDataTestUtil.createActivityDefinition(name: "other")
		ActivityDataTestUtil.createActivity(definition: otherDefinition)

		// when
		let result = try dao.hasUnfinishedActivity(targetDefinition)

		// then
		XCTAssertFalse(result)
	}

	func testGivenUnfinishedActivity_hasUnfinishedActivity_returnsTrue() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(Me.definitionInfo)
		ActivityDataTestUtil.createActivity(definition: definition)

		// when
		let result = try dao.hasUnfinishedActivity(definition)

		// then
		XCTAssert(result)
	}
}
