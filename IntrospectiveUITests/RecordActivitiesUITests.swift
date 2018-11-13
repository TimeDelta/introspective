//
//  RecordActivitiesUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

final class RecordActivitiesUITests: UITest {

	final override func setUp() {
		super.setUp()
		app.tables.buttons["Activities"].tap()
	}

	final override func tearDown() {
		app.tabBars.buttons["Settings"].tap()
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	// MARK: - ActivityDefinition

	func testAddNewActivityDefinition_usesTextFromSearchBarAsInitialName() {
		// given
		let activityName = "Watch TV"
		filterActivities(by: activityName)

		// when
		app.buttons["Add"].tap()

		// then
		XCTAssertEqual(app.textFields["activity name"].value as? String, activityName)
	}

	func testCreatingActivityDefinition_showsNameAndDescriptionInActivityListAfterSave() {
		// given
		let activityName = "this is an activity"
		let description = "this describes the activity"

		// when
		createActivityDefinition(name: activityName, description: description)

		// then
		XCTAssert(app.tables.cells.staticTexts[activityName].exists)
		XCTAssert(app.tables.cells.staticTexts[description].exists)
	}

	func testEditingActivityDefinition_correcrtlyPopulatesAllFields() {
		// given
		let activityName = "hfuewipq"
		let description = "fejhwioqp fewj qiop"
		let tags = ["fhewui", "geqr", "hyrw"]
		createActivityDefinition(name: activityName, description: description, tags: tags)

		// when
		app.tables.staticTexts[activityName].swipeRight()
		app.tables.buttons["✎ All"].tap()

		// then
		XCTAssertEqual(app.textFields["activity name"].value as? String, activityName)
		XCTAssertEqual(app.textViews["activity description"].value as? String, description)
		XCTAssertEqual(definitionTagsFieldAccessibilityValueAsSet(), Set(tags))
		app.buttons["Save"].tap() // keyboard is in the way of the settings tab so tearDown fails without this
	}

	func testDeletingDescriptionAndTagsFromActivityDefinition_correctlySaves() {
		// given
		let activityName = "hfuewipq"
		let description = "fejhwioqp fewj qiop"
		let tags = ["fhewui", "geqr", "hyrw"]
		createActivityDefinition(name: activityName, description: description, tags: tags)

		// when
		app.tables.staticTexts[activityName].swipeRight()
		app.tables.buttons["✎ All"].tap()
		deleteContentOf(textField: app.textViews["activity description"])
		delete(numberOfTags: tags.count, fromTagsField: activityDefinitionTagsField())

		// then
		XCTAssertEqual(app.textFields["activity name"].value as? String, activityName)
		XCTAssertEqual(app.textViews["activity description"].value as? String, "")
		XCTAssertEqual(activityDefinitionTagsField().value as? String, "Tags") // placeholder value is "Tags"
		app.buttons["Save"].tap() // keyboard is in the way of the settings tab so tearDown fails without this
	}

	func testEditActivityDefinitionHasEmptyNameField_saveButtonIsDisabled() {
		// when
		app.buttons["Add"].tap()

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
	}

	func testActivityDefinitionWithNameAlreadyExists_editActivityDefinitionScreenDisablesSaveButton() {
		// given
		let activityName = "greq"
		createActivityDefinition(name: activityName)

		// when
		app.buttons["Add"].tap()
		app.tables.textFields["activity name"].tap()
		app.tables.textFields["activity name"].typeText(activityName)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
		app.navigationBars.buttons["Activities"].tap()
	}

	// MARK: - Activity

	func testTapOnActivityDefinition_startsActivity() {
		// given
		let activityName = "grneoq"
		createActivityDefinition(name: activityName)

		// when
		app.tables.staticTexts[activityName].tap()

		// then
		sleep(1)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	func testTapOnActivityDefinitionThatHasRunningInstance_stopsRunningInstanceAndUpdatesLastInstanceInfo() {
		// given
		let activityName = "grnejioqu"
		createActivityDefinition(name: activityName)
		app.tables.staticTexts[activityName].tap()
		let startDate = Date()
		sleep(1)

		// when
		app.tables.staticTexts[activityName].tap()
		let endDate = Date()

		// then
		sleep(1)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		XCTAssert(app.tables.cells.staticTexts[startToEndTimeLabelText(from: startDate, to: endDate)].exists)
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "0:00:01")
		XCTAssertEqual(app.tables.cells.staticTexts["most recent duration"].value as? String, "0:00:01")
	}

	func testChangingActivityDefinitionWhileEditingLastActivity_updatesUI() {
		// given
		let activityName = "fjhwi"
		createActivityDefinition(name: activityName)
		let targetActivityName = "greqnji" + activityName
		createActivityDefinition(name: targetActivityName)

		app.tables.staticTexts[activityName].tap()
		app.tables.staticTexts[activityName].swipeLeft()
		app.tables.buttons["✎ Last"].tap()

		// when
		app.tables.staticTexts["Activity"].tap()
		setPicker(to: targetActivityName, changeCase: false)
		app.buttons["save button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[targetActivityName].exists)
	}

	func testClearingEndDateOnEditActivityScreen_updatesUI() {
		// given
		let activityName = "greq"
		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()
		sleep(1)
		app.tables.cells.staticTexts[activityName].tap()
		let endDate = Date()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.buttons["✎ Last"].tap()

		// when
		app.tables.cells.buttons["clear end date button"].tap()

		// then
		XCTAssert(!app.tables.cells.staticTexts[editActivityDateString(for: endDate)].exists)
	}

	func testChangingStartDateOnEditActivityScreen_updatesUI() {
		// given
		let activityName = "gteq"
		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		app.tables.cells.staticTexts["Start"].tap()
		setDatePicker(to: expectedStartDate)
		app.buttons["save button"].tap()

		// then
		sleep(1) // table view has to reload data before UI is updated
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
	}

	func testChangingEndDateOnEditActivityScreen_updatesUI() {
		// given
		let activityName = "gteq"
		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		app.tables.cells.staticTexts["End"].tap()
		let expectedEndDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		setDatePicker(to: expectedEndDate)
		app.buttons["save button"].tap()

		// then
		sleep(1) // table view has to reload data before UI is updated
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
	}

	func testEditingLastActivity_correctlyUpdatesCorrespondingActivityDefinitionCell() {
		// given
		let activityName = "gteq"
		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		let startDate = (Date() - 1.minutes).dateBySet(hour: nil, min: nil, secs: 0)!
		setActivityStartDate(to: startDate)

		let endDate = startDate + 1.hours + 2.minutes
		setActivityEndDate(to: endDate)

		// when
		app.buttons["Save"].tap()

		// then
		sleep(1) // table view has to reload data before UI is updated
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		XCTAssertEqual(app.tables.cells.staticTexts["last start / end time"].value as? String, startToEndTimeLabelText(from: startDate, to: endDate))
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "1:02:00")
		XCTAssertEqual(app.tables.cells.staticTexts["most recent duration"].value as? String, "1:02:00")
	}

	func testAddNewActivityScreen_startsWithCorrectActivityDefinitionSelected() {
		// given
		let activityName1 = "htgerq"
		createActivityDefinition(name: activityName1)
		let activityName2 = "gheiqu"
		createActivityDefinition(name: activityName2)

		// when
		app.tables.cells.staticTexts[activityName2].swipeLeft()
		app.tables.cells.buttons["+"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[activityName2].exists)
	}

	func testAddNewActivityScreen_savesCorrectly() {
		// given
		let activityName = "htgerq"
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		let expectedEndDate = (Date() - 1.days).dateBySet(hour: nil, min: nil, secs: 0)!

		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["+"].tap()

		setActivityStartDate(to: expectedStartDate)
		setActivityEndDate(to: expectedEndDate)

		let activityNote = "fehjorwiqj eior\nfjew\nfewq"
		setTextFor(field: app.tables.cells.textViews["activity note"], to: activityNote)

		let tags = ["c", "d", "e"]
		setTags(for: activityTagsField(), to: tags)

		// when
		app.buttons["Save"].tap()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.buttons["✎ Last"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[activityName].exists)
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
		XCTAssertEqual(app.tables.cells.textViews["activity note"].value as? String, activityNote)
		XCTAssertEqual(activityTagsFieldAccessibilityValueAsSet(), Set(tags))
	}

	func testSavingChangesToExistingActivity_savesThoseChanges() {
		// given
		let activityName = "gteq"
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		let expectedEndDate = (Date() - 1.days).dateBySet(hour: nil, min: nil, secs: 0)!

		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		setActivityStartDate(to: expectedStartDate)
		setActivityEndDate(to: expectedEndDate)

		let activityNote = "fehjorwiqj eior\nfjew\nfewq"
		setTextFor(field: app.tables.cells.textViews["activity note"], to: activityNote)

		let tags = ["c", "d", "e"]
		setTags(for: activityTagsField(), to: tags)

		// when
		app.buttons["Save"].tap()
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[activityName].exists)
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
		XCTAssertEqual(app.tables.cells.textViews["activity note"].value as? String, activityNote)
		XCTAssertEqual(activityTagsFieldAccessibilityValueAsSet(), Set(tags))
	}

	// MARK: - Quick Create / Start

	func testLongPressOnAddButtonWhenSearchBarIsEmpty_doesNotCreateActivity() {
		// when
		app.buttons["Add"].press(forDuration: 1.0)

		// then
		XCTAssertEqual(app.cells.allElementsBoundByIndex.count, 0)
	}

	func testLongPressOnAddButtonWhenSearchBarHasNameOfExistingActiviyt_doesNotCreateActivityOrClearSearchBar() {
		// given
		let activityName = "freqgr"
		createActivityDefinition(name: activityName)
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(activityName)

		// when
		app.buttons["Add"].press(forDuration: 1.0)
		app.buttons["OK"].tap() // dismiss error alert

		// then
		XCTAssertEqual(app.cells.allElementsBoundByIndex.count, 1)
		XCTAssertEqual(app.searchFields.allElementsBoundByIndex[0].value as? String, activityName)
	}

	func testLongPressOnAddButtonWhenSearchBarIsNotEmpty_createsAndStartsActivity() {
		// given
		let activityName = "fhjdskaljk"
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(activityName)

		// when
		app.buttons["Add"].press(forDuration: 1.0)
		app.buttons["Cancel"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[activityName].exists)
		sleep(1)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	// MARK: - Search Bar Filtering

	func testFilteringForNameWorks() {
		// given
		let activityName1 = "grnueio"
		let activityName2 = "htrw"
		createActivityDefinition(name: activityName1)
		createActivityDefinition(name: activityName2)

		// when
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(activityName1)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testFilteringForDescriptionWorks() {
		// given
		let activityName = "geqr"
		let searchText = "abc"
		let description = searchText + "gfjeiorq fj"
		createActivityDefinition(name: activityName, description: description)
		createActivityDefinition(name: activityName + "some other stuff")

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testFilteringForTagsWorks() {
		// given
		let activityName = "gteqrwfd"
		let searchText = "grffjieorwq"
		let tags = ["this tag " + searchText + " contains the search text"]
		createActivityDefinition(name: activityName, tags: tags)
		createActivityDefinition(name: activityName + "some other stuff")

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testClearingFilterText_correctlyUpdatesDisplayedActivities() {
		// given
		let activityName1 = "grnueio"
		let activityName2 = "htrw"
		createActivityDefinition(name: activityName1)
		createActivityDefinition(name: activityName2)
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(activityName1)

		// when
		app.searchFields["Search Activities"].buttons["Clear text"].tap()

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 2)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	// MARK: - Deleting

	func testDeletingRunningActivity_correctlyUpdatesUI() {
		// given
		let activityName = "grenqj"
		createActivityDefinition(name: activityName)
		app.tables.cells.staticTexts[activityName].tap()

		// when
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.buttons["🗑️ Last"].tap()
		app.buttons["Yes"].tap()

		// then
		sleep(2)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		XCTAssertEqual(app.tables.cells.staticTexts["last start / end time"].value as? String, "")
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "")
		XCTAssertEqual(app.tables.cells.staticTexts["most recent duration"].value as? String, "")
	}

	func testDeleteActivityDefinition_removesRowFromActivityList() {
		// given
		let activityName1 = "geq"
		let activityName2 = "tqe"
		createActivityDefinition(name: activityName1)
		createActivityDefinition(name: activityName2)

		// when
		app.tables.cells.staticTexts[activityName1].swipeRight()
		app.tables.buttons["🗑️ All"].tap()
		app.buttons["Yes"].tap()

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
	}

	// MARK: - Reordering ActivityDefinitions

	func testReorderActivityDefinitionToLowerSpot_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let activityName1 = "greq"
		let activityName2 = "geq"
		createActivityDefinition(name: activityName1)
		createActivityDefinition(name: activityName2)
		var activityCell1 = app.tables.cells.staticTexts[activityName1]
		var activityCell2 = app.tables.cells.staticTexts[activityName2]
		activityCell1.press(forDuration: 0.5, thenDragTo: activityCell2)

		// when
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.buttons["Activities"].tap()

		// then
		activityCell1 = app.tables.cells.staticTexts[activityName1]
		activityCell2 = app.tables.cells.staticTexts[activityName2]
		XCTAssertLessThanOrEqual(activityCell2.frame.maxY, activityCell1.frame.minY)
	}

	func testReorderActivityDefinitionToHigherSpot_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let activityName1 = "greq"
		let activityName2 = "geq"
		createActivityDefinition(name: activityName1)
		createActivityDefinition(name: activityName2)
		var activityCell1 = app.tables.cells.staticTexts[activityName1]
		var activityCell2 = app.tables.cells.staticTexts[activityName2]
		activityCell2.press(forDuration: 0.5, thenDragTo: activityCell1)

		// when
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.buttons["Activities"].tap()

		// then
		activityCell1 = app.tables.cells.staticTexts[activityName1]
		activityCell2 = app.tables.cells.staticTexts[activityName2]
		XCTAssertLessThanOrEqual(activityCell2.frame.maxY, activityCell1.frame.minY)
	}

	// MARK: - Helper Functions

	private final func filterActivities(by searchText: String) {
		let searchActivitiesField = app.searchFields["Search Activities"]
		searchActivitiesField.tap()
		searchActivitiesField.typeText(searchText)
	}

	private final func createActivityDefinition(name: String, description: String? = nil, tags: [String]? = nil) {
		app.buttons["Add"].tap()
		app.tables.textFields["activity name"].tap()
		app.tables.textFields["activity name"].typeText(name)
		setTextFor(field: app.tables.cells.textViews["activity description"], to: description)
		setTags(for: activityDefinitionTagsField(), to: tags)
		app.buttons["Save"].tap()
	}

	private final func addActivity(name: String, start: Date = Date(), end: Date? = nil, note: String? = nil, tags: [String]? = nil) {
		app.tables.cells.staticTexts[name].swipeLeft()
		app.tables.buttons["+"].tap()
		setActivityStartDate(to: start)
		setActivityEndDate(to: end)
		setTextFor(field: app.tables.cells.textViews["activity note"], to: note)
		setTags(for: activityTagsField(), to: tags)
		app.buttons["Save"].tap()
	}

	private final func activityDefinitionTagsField() -> XCUIElement {
		return app.tables.children(matching: .cell).element(boundBy: 2).children(matching: .textField).element
	}

	private final func activityTagsField() -> XCUIElement {
		return app.tables.children(matching: .cell).element(boundBy: 4).children(matching: .textField).element
	}

	private final func definitionTagsFieldAccessibilityValueAsSet() -> Set<String> {
		if let tags = activityDefinitionTagsField().value as? String {
			return Set(tags.split(separator: ";").map{ String($0) })
		}
		return Set()
	}

	private final func activityTagsFieldAccessibilityValueAsSet() -> Set<String> {
		if let tags = activityTagsField().value as? String {
			return Set(tags.split(separator: ";").map{ String($0) })
		}
		return Set()
	}

	private final func setActivityStartDate(to start: Date) {
		app.tables.cells.staticTexts["Start"].tap()
		setDatePicker(to: start)
		app.buttons["save button"].tap()
	}

	private final func setActivityEndDate(to end: Date? = nil) {
		if let end = end {
			app.tables.cells.staticTexts["End"].tap()
			setDatePicker(to: end)
			app.buttons["save button"].tap()
		}
	}

	private final func editActivityDateString(for date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .medium
		return dateFormatter.string(from: date)
	}

	private final func startToEndTimeLabelText(from start: Date, to end: Date? = nil) -> String {
		let timeOnlyFormatter = DateFormatter()
		timeOnlyFormatter.dateStyle = .none
		timeOnlyFormatter.timeStyle = .medium
		let dateAndTimeFormatter = DateFormatter()
		dateAndTimeFormatter.dateStyle = .short
		dateAndTimeFormatter.timeStyle = .short
		var text: String
		if isToday(start) {
			text = timeOnlyFormatter.string(from: start)
		} else {
			text = dateAndTimeFormatter.string(from: start)
		}
		text += " -"
		if let end = end {
			if isToday(start) {
				text += " " + timeOnlyFormatter.string(from: end)
			} else if isToday(end) {
				text += " Today, " + timeOnlyFormatter.string(from: end)
			} else {
				text += " " + dateAndTimeFormatter.string(from: end)
			}
		}
		return text
	}
}
