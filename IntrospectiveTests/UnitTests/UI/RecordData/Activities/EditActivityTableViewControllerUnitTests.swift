//
//  EditActivityTableViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/20/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
import Hamcrest
import Presentr
@testable import Introspective
@testable import Common
@testable import Samples

class EditActivityTableViewControllerUnitTests: UnitTest {

	private typealias Class = EditActivityTableViewControllerImpl

	private final var tableView: UITableView {
		return controller.tableView
	}

	private final var saveButton: UIBarButtonItem {
		return controller.navigationItem.rightBarButtonItem!
	}

	private final var mockActivityDao: ActivityDaoMock!

	private final var controller: EditActivityTableViewControllerImpl!

	final override func setUp() {
		super.setUp()

		Given(mockUiUtil, .customPresenter(width: .any, height: .any, center: .any, willReturn: Presentr(presentationType: .alert)))

		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "editActivity") as! EditActivityTableViewControllerImpl)

		mockActivityDao = ActivityDaoMock()
		Given(injectionProvider, .get(.value(ActivityDao.self), willReturn: mockActivityDao))
		Given(mockActivityDao, .getMostRecentActivityEndDate(willReturn: nil))
	}

	// MARK: - numberOfSections()

	func test_numberOfSections_returns3() {
		// when
		let sections = controller.numberOfSections(in: tableView)

		// then
		assertThat(sections, equalTo(3))
	}

	// MARK: - tableViewNumberOfRowsInSection()

	func testGivenSection0_tableViewNumberOfRowsInSection_returns4() {
		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		assertThat(numRows, equalTo(4))
	}

	func testGivenSection1_tableViewNumberOfRowsInSection_returns1() {
		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		assertThat(numRows, equalTo(1))
	}

	func testGivenSection2_tableViewNumberOfRowsInSection_returns1() {
		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 2)

		// then
		assertThat(numRows, equalTo(1))
	}

	// MARK: - tableViewCellForRowAt()

	func testGivenDefinitionIndexWithNoDefinition_tableViewCellForRowAt_returnsCellThatSaysToChooseDefinition() {
		// given
		let index = Class.definitionIndex
		controller.definition = nil

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		assertThat(cell, hasDetailText("Choose Activity"))
	}

	func testGivenStartIndex_tableViewCellForRowAt_returnsCellThatHasStartDate() {
		// given
		let index = Class.startIndex
		let expectedStartDate = Date() - 1.days
		let expectedStartDateText = "fneijrwqhuoy"
		// force call to viewDidLoad() before setting start date or it will be overwritten
		let _ = tableView.allowsSelection
		controller.startDate = expectedStartDate
		Given(mockCalendarUtil, .string(for: .value(expectedStartDate), dateStyle: .any, timeStyle: .any, willReturn: expectedStartDateText))

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		assertThat(cell, hasDetailText(expectedStartDateText))
	}

	func testGivenEndIndexWithNoEndDate_tableViewCellForRowAt_returnsCellWithNilEndDate() {
		// given
		let index = Class.endIndex
		controller.endDate = nil
		mockTableViewCell(ActivityEndDateTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let endDateCell = cell as? ActivityEndDateTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(endDateCell.endDate, nilValue())
	}

	func testGivenEndIndexWithEndDate_tableViewCellForRowAt_returnsCellWithCorrectEndDate() {
		// given
		let index = Class.endIndex
		let expectedEndDate = Date()
		controller.endDate = expectedEndDate
		mockTableViewCell(ActivityEndDateTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let endDateCell = cell as? ActivityEndDateTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(endDateCell.endDate, equalTo(expectedEndDate))
	}

	func testGivenDurationIndexWithNoEndDate_tableViewCellForRowAt_returnsCellWithEmptyDuration() {
		// given
		let index = Class.durationIndex
		controller.endDate = nil

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		assertThat(cell, hasDetailText(""))
	}

	func testGivenDurationIndexWithEndDate_tableViewCellForRowAt_returnsCellWithCorrectDuration() {
		// given
		let index = Class.durationIndex
		let startDate = Date() - 1.days
		let endDate = Date()
		// force call to viewDidLoad() before setting start date or it will be overwritten
		let _ = tableView.allowsMultipleSelection
		controller.startDate = startDate
		controller.endDate = endDate

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		assertThat(cell, hasDetailText(Duration(start: startDate, end: endDate).description))
	}

	func testGivenNoteIndexWithAutoFocusTrue_tableViewCellForRowAt_returnsNoteCellWithAutoFocusTrue() {
		// given
		let index = Class.noteIndex
		controller.autoFocusNote = true
		mockTableViewCell(ActivityNoteTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let noteCell = cell as? ActivityNoteTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		XCTAssert(noteCell.autoFocus)
	}

	func testGivenNoteIndexWithAutoFocusFalse_tableViewCellForRowAt_returnsNoteCellWithAutoFocusFalse() {
		// given
		let index = Class.noteIndex
		controller.autoFocusNote = false
		mockTableViewCell(ActivityNoteTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let noteCell = cell as? ActivityNoteTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		XCTAssertFalse(noteCell.autoFocus)
	}

	func testGivenNoteIndexWithNoNote_tableViewCellForRowAt_returnsNoteCellWithNilNote() {
		// given
		let index = Class.noteIndex
		controller.note = nil
		mockTableViewCell(ActivityNoteTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let noteCell = cell as? ActivityNoteTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(noteCell.note, nilValue())
	}

	func testGivenNoteIndexWithNote_tableViewCellForRowAt_returnsNoteCellWithCorrectNote() {
		// given
		let index = Class.noteIndex
		let expectedNote = "gneiruoq"
		controller.note = expectedNote
		mockTableViewCell(ActivityNoteTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let noteCell = cell as? ActivityNoteTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(noteCell.note, equalTo(expectedNote))
	}

	func testGivenTagsIndexWithTags_tableViewCellForRowAt_returnsTagsCellWithCorrectTags() {
		// given
		let index = Class.tagsIndex
		let expectedTags = Set(["1", "2"])
		controller.tagNames = expectedTags
		mockTableViewCell(ActivityTagsTableViewCellMock())

		// when
		let cell = controller.tableView(tableView, cellForRowAt: index)

		// then
		guard let tagsCell = cell as? ActivityTagsTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(tagsCell.tagNames, equalTo(expectedTags))
	}

	// MARK: - tableViewHeightForRowAt()

	func testGivenDefinitionIndex_tableViewHeightForRowAt_returns44() {
		// given
		let index = Class.definitionIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(44))
	}

	func testGivenStartIndex_tableViewHeightForRowAt_returns44() {
		// given
		let index = Class.startIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(44))
	}

	func testGivenEndIndex_tableViewHeightForRowAt_returns44() {
		// given
		let index = Class.endIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(44))
	}

	func testGivenDurationIndex_tableViewHeightForRowAt_returns44() {
		// given
		let index = Class.durationIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(44))
	}

	func testGivenNoteIndex_tableViewHeightForRowAt_returns131() {
		// given
		let index = Class.noteIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(131))
	}

	func testGivenTagsIndex_tableViewHeightForRowAt_returns131() {
		// given
		let index = Class.tagsIndex

		// when
		let height = controller.tableView(tableView, heightForRowAt: index)

		// then
		assertThat(height, equalTo(131))
	}

	// MARK: - tableViewTitleForHeaderInSection()

	func testGivenDefinitionIndex_tableViewTitleForHeaderInSection_returnsNil() {
		// given
		let index = Class.definitionIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, nilValue())
	}

	func testGivenStartIndex_tableViewTitleForHeaderInSection_returnsNil() {
		// given
		let index = Class.startIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, nilValue())
	}

	func testGivenEndIndex_tableViewTitleForHeaderInSection_returnsNil() {
		// given
		let index = Class.endIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, nilValue())
	}

	func testGivenDurationIndex_tableViewTitleForHeaderInSection_returnsNil() {
		// given
		let index = Class.durationIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, nilValue())
	}

	func testGivenNoteIndex_tableViewTitleForHeaderInSection_returnsNote() {
		// given
		let index = Class.noteIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, equalTo("Note"))
	}

	func testGivenTagsIndex_tableViewTitleForHeaderInSection_returnsAdditionalTags() {
		// given
		let index = Class.tagsIndex

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: index.section)

		// then
		assertThat(title, equalTo("Additional Tags"))
	}

	// MARK: - tableViewDidSelectRowAt()

	func testGivenStartIndex_tableViewDidSelectRowAt_returnsNil() {
		// given
		let index = Class.startIndex
		// force call to viewDidLoad() before setting start date or it will be overwritten
		let _ = tableView.allowsMultipleSelection
		let startDate = Date() - 1.days
		controller.startDate = startDate
		let presentedController = mockSelectDateViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: index)

		// then
		assertThat(presentedController.initialDate, equalTo(startDate))
	}

	func testGivenEndIndex_tableViewDidSelectRowAt_returnsNil() {
		// given
		let index = Class.endIndex
		let endDate = Date() - 1.days
		controller.endDate = endDate
		let presentedController = mockSelectDateViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: index)

		// then
		assertThat(presentedController.initialDate, equalTo(endDate))
	}

	func testGivenDurationIndex_tableViewDidSelectRowAt_returnsNil() {
		// given
		let index = Class.durationIndex
		// force call to viewDidLoad() before setting start date or it will be overwritten
		let _ = tableView.allowsMultipleSelection
		let startDate = Date() - 1.days
		let endDate = Date()
		let duration = Duration(start: startDate, end: endDate)
		controller.startDate = startDate
		controller.endDate = endDate
		let presentedController = mockSelectDurationViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: index)

		// then
		assertThat(presentedController.initialDuration, equalTo(duration))
	}

	// MARK: - startDateChanged()

	func testGivenNewStartDate_startDateChanged_updatesStartDate() {
		// given
		controller.viewDidLoad()
		let originalStartDate = Date()
		controller.startDate = originalStartDate
		let newStartDate = originalStartDate + 1.days
		Given(mockUiUtil, .value(for: .value(.date), from: .any, keyIsOptional: .any, willReturn: newStartDate))

		// when
		NotificationCenter.default.post(
			name: Class.startDateChanged,
			object: nil,
			userInfo: [
				UserInfoKey.date: newStartDate
			])

		// then
		assertThat(controller.startDate, equalTo(newStartDate))
	}

	// MARK: - endDateChanged()

	func testGivenNewEndDate_endDateChanged_updatesEndDate() {
		// given
		controller.viewDidLoad()
		let originalEndDate = Date()
		controller.endDate = originalEndDate
		let newEndDate = originalEndDate + 1.days
		Given(mockUiUtil, .value(for: .value(.date), from: .any, keyIsOptional: .any, willReturn: newEndDate))

		// when
		NotificationCenter.default.post(
			name: Class.endDateChanged,
			object: nil,
			userInfo: [
				UserInfoKey.date: newEndDate
			])

		// then
		assertThat(controller.endDate, equalTo(newEndDate))
	}

	// MARK: - durationChanged()

	func testGivenNewDuration_endDateChanged_updatesEndDate() {
		// given
		controller.viewDidLoad()
		let startDate = Date()
		controller.startDate = startDate
		controller.endDate = startDate + 1.days
		let newDuration = Duration(2.days)
		Given(mockUiUtil, .value(for: .value(.duration), from: .any, keyIsOptional: .any, willReturn: newDuration))

		// when
		NotificationCenter.default.post(
			name: Class.durationChanged,
			object: nil,
			userInfo: [
				UserInfoKey.duration: newDuration
			])

		// then
		assertThat(controller.endDate, equalTo(startDate + newDuration))
	}

	// MARK: - noteChanged()

	func testGivenNewNote_noteChanged_updatesNote() {
		// given
		controller.viewDidLoad()
		let originalNote = "fnjeiu"
		controller.note = originalNote
		let newNote = originalNote + "fnreuwi"
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: newNote))

		// when
		NotificationCenter.default.post(
			name: Class.noteChanged,
			object: nil,
			userInfo: [
				UserInfoKey.text: newNote
			])

		// then
		assertThat(controller.note, equalTo(newNote))
	}

	// MARK: - tagsChanged()

	func testGivenNewTags_tagsChanged_updatesTags() {
		controller.viewDidLoad()
		let originalTags = Set(["1", "2"])
		controller.tagNames = originalTags
		let newTags = Set(["4"])
		Given(mockUiUtil, .value(for: .value(.tagNames), from: .any, keyIsOptional: .any, willReturn: newTags))

		// when
		NotificationCenter.default.post(
			name: Class.tagsChanged,
			object: nil,
			userInfo: [
				UserInfoKey.tagNames: newTags
			])

		// then
		assertThat(controller.tagNames, equalTo(newTags))
	}

	// MARK: - Helper Functions

	private final func mockTableViewCell(_ cell: UITableViewCell) {
		Given(mockUiUtil, .tableViewCell(
			from: .any,
			withIdentifier: .any,
			for: .any,
			as: .value(UITableViewCell.self),
			willReturn: cell))
	}

	@discardableResult
	private final func mockSelectDateViewController() -> SelectDateViewControllerMock {
		let controller = SelectDateViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("datePicker"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockSelectDurationViewController() -> SelectDurationViewControllerMock {
		let controller = SelectDurationViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("durationChooser"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
