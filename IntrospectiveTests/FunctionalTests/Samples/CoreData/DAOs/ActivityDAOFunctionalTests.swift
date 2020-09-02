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
}
