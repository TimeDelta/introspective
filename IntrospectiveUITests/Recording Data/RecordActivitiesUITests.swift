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
		app.tables.cells.staticTexts["Activities"].tap()
		skipInstructionsIfPresent()
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
		let definition = ActivityDefinition(name: "this is an activity", description: "this describes the activity")

		// when
		createActivityDefinition(definition)

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition.description!].exists)
	}

	func testEditingActivityDefinition_correctlyPopulatesAllFields() {
		// given
		let definition = ActivityDefinition(
			name: "hfuewipq",
			autoNote: true,
			description: "fejhwioqp fewj qiop",
			tags: ["fhewui", "geqr", "hyrw"])
		createActivityDefinition(definition)

		// when
		app.tables.staticTexts[definition.name].swipeRight()
		app.tables.buttons["✎ All"].tap()

		// then
		XCTAssertEqual(activityDefinitionNameField().value as? String, definition.name)
		XCTAssertEqual(app.textViews["activity description"].value as? String, definition.description)
		XCTAssertEqual(definitionTagsFieldAccessibilityValueAsSet(), Set(definition.tags!))
		XCTAssertEqual(activityDefinitionAutoNoteField().value as? String, "1")
		app.buttons["Save"].tap() // keyboard is in the way of the settings tab so tearDown fails without this
	}

	func testDeletingDescriptionAndTagsFromActivityDefinition_correctlySaves() {
		// given
		let definition = ActivityDefinition(
			name: "hfuewipq",
			description: "fejhwioqp fewj qiop",
			tags: ["fhewui", "geqr", "hyrw"])
		createActivityDefinition(definition)

		// when
		app.tables.staticTexts[definition.name].swipeRight()
		app.tables.buttons["✎ All"].tap()
		deleteContentOf(textField: app.textViews["activity description"])
		delete(numberOfTags: definition.tags!.count, fromTagsField: activityDefinitionTagsField())

		// then
		XCTAssertEqual(activityDefinitionNameField().value as? String, definition.name)
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
		let definition = ActivityDefinition(name: "greq")
		createActivityDefinition(definition)

		// when
		app.buttons["Add"].tap()
		setTextFor(field: activityDefinitionNameField(), to: definition.name)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
		app.navigationBars.buttons["Activities"].tap()
	}

	// MARK: - Activity

	func testTapOnActivityDefinition_startsActivity() {
		// given
		let definition = ActivityDefinition(name: "grneoq")
		createActivityDefinition(definition)

		// when
		app.tables.staticTexts[definition.name].tap()

		// then
		sleep(1)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	func testTapOnActivityDefinitionThatHasRunningInstance_stopsRunningInstanceAndUpdatesLastInstanceInfo() {
		// given
		let definition = ActivityDefinition(name: "grnejioqu")
		createActivityDefinition(definition)
		app.tables.staticTexts[definition.name].tap()
		let startDate = Date()
		sleep(1)

		// when
		app.tables.staticTexts[definition.name].tap()
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
		let definition = ActivityDefinition(name: "fjhwi")
		createActivityDefinition(definition)
		let targetDefinition = ActivityDefinition(name: "greqnji" + definition.name)
		createActivityDefinition(targetDefinition)

		app.tables.staticTexts[definition.name].tap()
		app.tables.staticTexts[definition.name].swipeLeft()
		app.tables.buttons["✎ Last"].tap()

		// when
		app.tables.staticTexts["Activity"].tap()
		setPicker(to: targetDefinition.name, changeCase: false)
		app.buttons["save button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[targetDefinition.name].exists)
	}

	func testClearingEndDateOnEditActivityScreen_updatesUI() {
		// given
		let definition = ActivityDefinition(name: "greq")
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(1)
		app.tables.cells.staticTexts[definition.name].tap()
		let endDate = Date()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.buttons["✎ Last"].tap()

		// when
		app.tables.cells.buttons["clear end date button"].tap()

		// then
		XCTAssert(!app.tables.cells.staticTexts[editActivityDateString(for: endDate)].exists)
	}

	func testChangingStartDateOnEditActivityScreen_updatesUI() {
		// given
		let definition = ActivityDefinition(name: "gteq")
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		app.tables.cells.staticTexts[definition.name].swipeLeft()
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
		let definition = ActivityDefinition(name: "gteq")
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
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
		let definition = ActivityDefinition(name: "gteq")
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
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
		let definition1 = ActivityDefinition(name: "htgerq")
		createActivityDefinition(definition1)
		let definition2 = ActivityDefinition(name: "gheiqu")
		createActivityDefinition(definition2)

		// when
		app.tables.cells.staticTexts[definition2.name].swipeLeft()
		app.tables.cells.buttons["+"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[definition2.name].exists)
	}

	func testAddNewActivityScreen_savesCorrectly() {
		// given
		let definition = ActivityDefinition(name: "htgerq")
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		let expectedEndDate = (Date() - 1.days).dateBySet(hour: nil, min: nil, secs: 0)!

		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["+"].tap()

		setActivityStartDate(to: expectedStartDate)
		setActivityEndDate(to: expectedEndDate)

		let activityNote = "fehjorwiqj eior\nfjew\nfewq"
		setTextFor(field: app.tables.cells.textViews["activity note"], to: activityNote)

		let tags = ["c", "d", "e"]
		setTags(for: activityTagsField(), to: tags)

		// when
		app.buttons["Save"].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.buttons["✎ Last"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
		XCTAssertEqual(app.tables.cells.textViews["activity note"].value as? String, activityNote)
		XCTAssertEqual(activityTagsFieldAccessibilityValueAsSet(), Set(tags))
	}

	func testSavingChangesToExistingActivity_savesThoseChanges() {
		// given
		let definition = ActivityDefinition(name: "gteq")
		let expectedStartDate = (Date() - 1.days - 1.hours).dateBySet(hour: nil, min: nil, secs: 0)!
		let expectedEndDate = (Date() - 1.days).dateBySet(hour: nil, min: nil, secs: 0)!

		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		setActivityStartDate(to: expectedStartDate)
		setActivityEndDate(to: expectedEndDate)

		let activityNote = "fehjorwiqj eior\nfjew\nfewq"
		setTextFor(field: app.tables.cells.textViews["activity note"], to: activityNote)

		let tags = ["c", "d", "e"]
		setTags(for: activityTagsField(), to: tags)

		// when
		app.buttons["Save"].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
		XCTAssertEqual(app.tables.cells.textViews["activity note"].value as? String, activityNote)
		XCTAssertEqual(activityTagsFieldAccessibilityValueAsSet(), Set(tags))
	}

	func testSettingStartDateAfterEndDate_disablesSaveButtonOnEditActivityScreen() {
		// given
		let definition = ActivityDefinition(name: "gteqas")
		let startDate = Date() + 1.days

		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(1)
		app.tables.cells.staticTexts[definition.name].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		setActivityStartDate(to: startDate)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
	}

	func testSettingEndDateBeforeStartDate_disablesSaveButtonOnEditActivityScreen() {
		// given
		let definition = ActivityDefinition(name: "gteqas")
		let endDate = Date() - 1.days

		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(1)
		app.tables.cells.staticTexts[definition.name].tap()
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		setActivityEndDate(to: endDate)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
	}

	func testAutoIgnoreEnabledAndActivityStoppedBeforeMinimumTime_doesNotSaveActivity() {
		// given
		let definition = ActivityDefinition(name: "grehuiq")
		let minTime = 2
		createActivityDefinition(definition)
		app.tabBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()
		setAutoIgnore(enabled: true, seconds: String(minTime))
		app.navigationBars.buttons["Settings"].tap()
		app.tabBars.buttons["Record"].tap()

		// when
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(UInt32(minTime) - 1)
		app.tables.cells.staticTexts[definition.name].tap()

		// then
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "")
	}

	func testAutoIgnoreEnabledAndActivityStoppedAfterMinimumTime_savesActivity() {
		// given
		let definition = ActivityDefinition(name: "grehuiq")
		let minTime = 1
		createActivityDefinition(definition)
		app.tabBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()
		setAutoIgnore(enabled: true, seconds: String(minTime))
		app.navigationBars.buttons["Settings"].tap()
		app.tabBars.buttons["Record"].tap()

		// when
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(UInt32(minTime) + 1)
		app.tables.cells.staticTexts[definition.name].tap()

		// then
		var seconds = String(minTime + 1)
		if seconds.count == 1 {
			seconds = "0" + seconds
		}
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "0:00:" + seconds)
	}

	func testFinishingActivityWithAutoNoteEnabled_showsEditActivityScreen() {
		// given
		let definition = ActivityDefinition(name: "njgkort", autoNote: true)
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()

		// when
		app.tables.cells.staticTexts[definition.name].tap()

		// then
		XCTAssert(app.tables.cells.textViews["activity note"].exists)

		// clean up
		app.navigationBars.buttons["Activities"].tap() // keyboard is hiding tab bar
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
		let definition = ActivityDefinition(name: "freqgr")
		createActivityDefinition(definition)
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition.name)

		// when
		app.buttons["Add"].press(forDuration: 1.0)
		app.buttons["OK"].tap() // dismiss error alert

		// then
		XCTAssertEqual(app.cells.allElementsBoundByIndex.count, 1)
		XCTAssertEqual(app.searchFields.allElementsBoundByIndex[0].value as? String, definition.name)
	}

	func testLongPressOnAddButtonWhenSearchBarIsNotEmpty_createsAndStartsActivity() {
		// given
		let definition = ActivityDefinition(name: "fhjdskaljk")
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition.name)

		// when
		app.buttons["Add"].press(forDuration: 1.0)
		app.buttons["Cancel"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		sleep(1)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	// MARK: - Search Bar Filtering

	func testFilteringForNameWorks() {
		// given
		let definition1 = ActivityDefinition(name: "grnueio")
		let definition2 = ActivityDefinition(name: "htrw")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)

		// when
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition1.name)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testFilteringForDescriptionWorks() {
		// given
		let searchText = "abc"
		let definition = ActivityDefinition(name: "geqr", description: searchText + "gfjeiorq fj")
		let otherDefinition = ActivityDefinition(name: definition.name + "some other stuff")
		createActivityDefinition(definition)
		createActivityDefinition(otherDefinition)

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testFilteringForTagsWorks() {
		// given
		let searchText = "grffjieorwq"
		let definition = ActivityDefinition(
			name: "gteqrwfd",
			tags: ["this tag " + searchText + " contains the search text"])
		let otherDefinition = ActivityDefinition(name: definition.name + "some other stuff")
		createActivityDefinition(definition)
		createActivityDefinition(otherDefinition)

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	func testClearingFilterText_correctlyUpdatesDisplayedActivities() {
		// given
		let definition1 = ActivityDefinition(name: "grnueio")
		let definition2 = ActivityDefinition(name: "htrw")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition1.name)

		// when
		app.searchFields["Search Activities"].buttons["Clear text"].tap()

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 2)
		app.buttons["Cancel"].tap() // hide keyboard
	}

	// MARK: - Deleting

	/// This test is flaky - run it a few times before believing a failure
	func testDeletingRunningActivity_correctlyUpdatesUI() {
		// given
		let definition = ActivityDefinition(name: "grenqj")
		createActivityDefinition(definition)
		app.tables.cells.staticTexts[definition.name].tap()

		// when
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.buttons["🗑️ Last"].tap()
		app.buttons["Yes"].tap()

		// then
		sleep(2)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		XCTAssertEqual(app.tables.cells.staticTexts["last start / end time"].value as? String, "")
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "")
		XCTAssertEqual(app.tables.cells.staticTexts["most recent duration"].value as? String, "")
	}

	func testDeleteActivityDefinitionWhileNotFiltering_removesCorrectRowFromActivityList() {
		// given
		let definition1 = ActivityDefinition(name: "geq")
		let definition2 = ActivityDefinition(name: "tqe")
		let definition3 = ActivityDefinition(name: "ghrjeq")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)
		createActivityDefinition(definition3)

		// when
		app.tables.cells.staticTexts[definition2.name].swipeRight()
		app.tables.buttons["🗑️ All"].tap()
		app.buttons["Yes"].tap()

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 2)
		XCTAssert(app.tables.cells.staticTexts[definition1.name].exists)
		XCTAssert(!app.tables.cells.staticTexts[definition2.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition3.name].exists)
	}

	func testDeletingActivityDefinitionWhileFiltering_removesCorrectRowFromActivityList() {
		// given
		let definition1 = ActivityDefinition(name: "doesn't contain filter string")
		let definition2 = ActivityDefinition(name: "z")
		let definition3 = ActivityDefinition(name: "zz")
		let definition4 = ActivityDefinition(name: "zzz")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)
		createActivityDefinition(definition3)
		createActivityDefinition(definition4)
		filterActivities(by: "z")

		// when
		app.tables.cells.staticTexts[definition3.name].swipeRight()
		app.tables.buttons["🗑️ All"].tap()
		app.buttons["Yes"].tap()
		app.buttons["Cancel"].tap() // clear search text

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 3)
		XCTAssert(app.tables.cells.staticTexts[definition1.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition2.name].exists)
		XCTAssert(!app.tables.cells.staticTexts[definition3.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition4.name].exists)
	}

	// MARK: - Reordering ActivityDefinitions

	func testReorderActivityDefinitionToLowerSpot_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let definition1 = ActivityDefinition(name: "greq")
		let definition2 = ActivityDefinition(name: "geq")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)
		var activityCell1 = app.tables.cells.staticTexts[definition1.name]
		var activityCell2 = app.tables.cells.staticTexts[definition2.name]
		activityCell1.press(forDuration: 0.5, thenDragTo: activityCell2)

		// when
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.staticTexts["Activities"].tap()

		// then
		activityCell1 = app.tables.cells.staticTexts[definition1.name]
		activityCell2 = app.tables.cells.staticTexts[definition2.name]
		XCTAssertLessThanOrEqual(activityCell2.frame.maxY, activityCell1.frame.minY)
	}

	func testReorderActivityDefinitionToHigherSpot_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let definition1 = ActivityDefinition(name: "greq")
		let definition2 = ActivityDefinition(name: "geq")
		createActivityDefinition(definition1)
		createActivityDefinition(definition2)
		var activityCell1 = app.tables.cells.staticTexts[definition1.name]
		var activityCell2 = app.tables.cells.staticTexts[definition2.name]
		activityCell2.press(forDuration: 0.5, thenDragTo: activityCell1)

		// when
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.staticTexts["Activities"].tap()

		// then
		activityCell1 = app.tables.cells.staticTexts[definition1.name]
		activityCell2 = app.tables.cells.staticTexts[definition2.name]
		XCTAssertLessThanOrEqual(activityCell2.frame.maxY, activityCell1.frame.minY)
	}

	// MARK: - Helper Functions

	private final func filterActivities(by searchText: String) {
		let searchActivitiesField = app.searchFields["Search Activities"]
		searchActivitiesField.tap()
		searchActivitiesField.typeText(searchText)
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

	private final func setAutoIgnore(enabled: Bool, seconds: String) {
		var currentlyEnabled = autoIgnoreEnabledSwitch().value as? String == "1"
		if currentlyEnabled {
			setTextFor(field: autoIgnoreSecondsTextField(), to: seconds)
		} else {
			autoIgnoreEnabledSwitch().tap()
			setTextFor(field: autoIgnoreSecondsTextField(), to: seconds)
		}

		currentlyEnabled = autoIgnoreEnabledSwitch().value as? String == "1"
		if currentlyEnabled != enabled {
			autoIgnoreEnabledSwitch().tap()
		}
	}

	// MARK: - Element Functions

	private final func activityTagsField() -> XCUIElement {
		return app.tables.children(matching: .cell).element(boundBy: 4).children(matching: .textField).element
	}

	private final func autoIgnoreEnabledSwitch() -> XCUIElement {
		return app.tables.cells.switches["auto-ignore enabled"]
	}

	private final func autoIgnoreSecondsTextField() -> XCUIElement {
		return app.tables.cells.textFields["auto-ignore seconds"]
	}
}
