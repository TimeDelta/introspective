//
//  EditActivityTableViewControllerFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate
import Presentr
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Persistence

class EditActivityTableViewControllerFunctionalTests: FunctionalTest {

	private typealias Class = EditActivityTableViewControllerImpl

	private final var tableView: UITableView {
		return controller.tableView
	}

	private final var controller: EditActivityTableViewControllerImpl!

	final override func setUp() {
		super.setUp()

		Given(uiUtil, .customPresenter(width: .any, height: .any, center: .any, willReturn: Presentr(presentationType: .alert)))

		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "editActivity") as! EditActivityTableViewControllerImpl)

		controller.notificationToSendOnAccept = Notification.Name("")
		let _ = tableView.allowsMultipleSelection
	}

	// MARK: - viewDidLoad()

	func testGivenActivityExists_viewDidLoad_setsInitialStartDateOfEndDateForLastActivity() {
		// given
		let expectedStartDate = Date() - 1.days
		ActivityDataTestUtil.createActivity(endDate: expectedStartDate)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.startDate, equalTo(expectedStartDate))
	}

	func testGivenNoActivitiesExist_viewDidLoad_setsInitialStartDateToCurrentTime() {
		// given
		let beforeLoad = Date()

		// when
		controller.viewDidLoad()

		// then
		let afterLoad = Date()
		assertThat(controller.startDate, greaterThan(beforeLoad))
		assertThat(controller.startDate, lessThan(afterLoad))
	}

	// MARK: - activityDidSet()

	func testGivenActivity_activityDidSet_setsStartDateAsActivityStartDate() {
		// given
		let expectedStartDate = Date() - 1.days
		let activity = ActivityDataTestUtil.createActivity(startDate: expectedStartDate)

		// when
		controller.activity = activity

		// then
		assertThat(controller.startDate, equalTo(expectedStartDate))
	}

	func testGivenActivity_activityDidSet_setsDefinitionAsActivityDefinition() {
		// given
		let expectedDefinition = ActivityDataTestUtil.createActivityDefinition()
		let activity = ActivityDataTestUtil.createActivity(definition: expectedDefinition)

		// when
		controller.activity = activity

		// then
		assertThat(controller.definition, equals(expectedDefinition))
	}

	func testGivenActivityWithEndDate_activityDidSet_setsEndDateAsActivityEndDate() {
		// given
		let expectedEndDate = Date() - 1.days
		let activity = ActivityDataTestUtil.createActivity(endDate: expectedEndDate)

		// when
		controller.activity = activity

		// then
		assertThat(controller.endDate, equalTo(expectedEndDate))
	}

	func testGivenActivityWithNote_activityDidSet_setsNoteAsActivityNote() {
		// given
		let expectedNote = "fhjoewio"
		let activity = ActivityDataTestUtil.createActivity(note: expectedNote)

		// when
		controller.activity = activity

		// then
		assertThat(controller.note, equalTo(expectedNote))
	}

	func testGivenActivityWithTags_activityDidSet_setsTagsAsActivityTags() {
		// given
		let expectedTagNames = ["1", "2"]
		let activity = ActivityDataTestUtil.createActivity(tags: TagDataTestUtil.createTags(names: expectedTagNames))

		// when
		controller.activity = activity

		// then
		assertThat(controller.tagNames, equalTo(Set(expectedTagNames)))
	}

	// MARK: - tableViewCellForRowAt()

	func testGivenDefinitionIndexWithDefinition_tableViewCellForRowAt_returnsCellThatHasDefinitionName() {
		// given
		let index = Class.definitionIndex
		let expectedDefinitionName = "fhueirwq"
		controller.definition = ActivityDataTestUtil.createActivityDefinition(name: expectedDefinitionName)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		assertThat(cell, hasDetailText(expectedDefinitionName))
	}

	// MARK: - tableViewDidSelectRowAt()

	func testGivenDefinitionIndex_tableViewDidSelectRowAt_setsSelectedDefinitionOnPresentedController() {
		// given
		let index = Class.definitionIndex
		let expectedDefinition = ActivityDataTestUtil.createActivityDefinition()
		controller.definition = expectedDefinition
		let presentedController = mockChooseActivityDefinitionViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: index)

		// then
		assertThat(presentedController.selectedDefinition, equals(expectedDefinition))
	}

	// MARK: - activityDefinitionChanged()

	func testGivenNewDefinition_activityDefinitionChanged_updatesDefinition() {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(name: "fjhruei")
		let newDefinition = ActivityDataTestUtil.createActivityDefinition(name: "jiormieq")
		controller.definition = definition
		Given(uiUtil, .value(for: .value(.activityDefinition), from: .any, keyIsOptional: .any, willReturn: newDefinition))

		// when
		NotificationCenter.default.post(
			name: Class.activityDefinitionChanged,
			object: nil,
			userInfo: [
				UserInfoKey.activityDefinition: newDefinition
			])

		// then
		assertThat(controller.definition, equals(newDefinition))
	}

	// MARK: - startDateChanged()

	func testGivenNewStartDate_startDateChanged_updatesStartDate() {
		// given
		let originalDate = Date()
		let newDate = originalDate + 1.days
		controller.startDate = originalDate
		Given(uiUtil, .value(for: .value(.date), from: .any, keyIsOptional: .any, willReturn: newDate))

		// when
		 NotificationCenter.default.post(
			name: Class.startDateChanged,
			object: nil,
			userInfo: [
				UserInfoKey.date: newDate,
			])

		// then
		assertThat(controller.startDate, equalTo(newDate))
	}

	// MARK: - endDateChanged()

	func testGivenNewEndDate_endDateChanged_updatesEndDate() {
		// given
		let originalDate = Date()
		let newDate = originalDate + 1.days
		controller.endDate = originalDate
		Given(uiUtil, .value(for: .value(.date), from: .any, keyIsOptional: .any, willReturn: newDate))

		// when
		 NotificationCenter.default.post(
			name: Class.endDateChanged,
			object: nil,
			userInfo: [
				UserInfoKey.date: newDate,
			])

		// then
		assertThat(controller.endDate, equalTo(newDate))
	}

	// MARK: - durationChanged()

	func testGivenNewDuration_durationChanged_updatesEndDate() {
		// given
		let startDate = Date()
		let duration = TimeDuration(1.days)
		controller.startDate = startDate
		Given(uiUtil, .value(for: .value(.duration), from: .any, keyIsOptional: .any, willReturn: duration))

		// when
		NotificationCenter.default.post(
			name: Class.durationChanged,
			object: nil,
			userInfo: [
				UserInfoKey.duration: duration,
			])

		// then
		assertThat(controller.endDate, equalTo(startDate + duration))
	}

	// MARK: - noteChanged()

	func testGivenNewNote_noteChanged_updatesNote() {
		// given
		let originalNote = "fejrwio"
		let newNote = originalNote + "other stuff"
		controller.note = originalNote
		Given(uiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: newNote))

		// when
		NotificationCenter.default.post(
			name: Class.noteChanged,
			object: nil,
			userInfo: [
				UserInfoKey.text: newNote,
			])

		// then
		assertThat(controller.note, equalTo(newNote))
	}

	// MARK: - tagsChanged()

	func testGivenNewTags_tagsChanged_updatesTags() {
		// given
		let originalTags = Set(["1", "2"])
		let newTags = Set(["3"])
		controller.tagNames = originalTags
		Given(uiUtil, .value(for: .value(.tagNames), from: .any, keyIsOptional: .any, willReturn: newTags))

		// when
		NotificationCenter.default.post(
			name: Class.tagsChanged,
			object: nil,
			userInfo: [
				UserInfoKey.tagNames: newTags,
			])

		// then
		assertThat(controller.tagNames, equalTo(newTags))
	}

	// MARK: - saveButtonPressed()

	func testGivenNoInitialActivity_saveButtonPressed_createsActivityWithCorrectValues() throws {
		// given
		let definition = ActivityDataTestUtil.createActivityDefinition(name: "jfieor")
		controller.definition = definition
		let startDate = Date() - 1.days
		controller.startDate = startDate
		let endDate = startDate + 2.days
		controller.endDate = endDate
		let note = "njfeopwjiop fdjosajf enwj nqfi"
		controller.note = note
		let tagNames = Set(["1", "2", "3"])
		controller.tagNames = tagNames

		// when
		controller.saveButtonPressed(self)

		// then
		assertThat(injected(Database.self), activityExists(hasDefinition(definition)))
		assertThat(injected(Database.self), activityExists(hasStartDate(startDate)))
		assertThat(injected(Database.self), activityExists(hasEndDate(endDate)))
		assertThat(injected(Database.self), activityExists(hasNote(note)))
		assertThat(injected(Database.self), activityExists(hasTags(tagNames)))
		assertThat(injected(Database.self), activityExists(allOf(
			hasDefinition(definition),
			hasStartDate(startDate),
			hasEndDate(endDate),
			hasNote(note),
			hasTags(tagNames)
		)))
	}

	// MARK: - Helper Functions

	@discardableResult
	private final func mockChooseActivityDefinitionViewController() -> ChooseActivityDefinitionViewControllerMock {
		let controller = ChooseActivityDefinitionViewControllerMock()
		Given(uiUtil, .controller(
			named: .value("chooseActivityDefinition"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
