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

	final override func openInitialScreen() {
		openActivitiesScreen()
	}

	// MARK: - ActivityDefinition

	func testAddNewActivityDefinition_usesTextFromSearchBarAsInitialName() {
		// given
		let activityName = "Watch TV"
		filterActivities(by: activityName)

		// when
		app.buttons["+"].tap()

		// then
		XCTAssertEqual(app.textFields["activity name"].value as? String, activityName)
	}

	func testCreatingActivityDefinition_showsNameAndDescriptionInActivityListAfterSave() {
		// given
		let definition = ActivityDefinition(name: "this is an activity", autoNote: true,
			description: "this describes the activity", tags: ["restful", "reading"])

		// when
		createActivityDefinition(definition)

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition.description!].exists)
		// Preserve creation coverage for optional fields now that other cases seed setup.
		app.tables.staticTexts[definition.name].gentleSwipe(.right)
		app.tables.buttons["edit \(definition.name)"].tap()
		XCTAssertEqual(activityDefinitionNameField().value as? String, definition.name)
		XCTAssertEqual(app.textViews["activity description"].value as? String, definition.description)
		XCTAssertEqual(definitionTagsFieldAccessibilityValueAsSet(), Set(definition.tags!))
		XCTAssertEqual(activityDefinitionAutoNoteField().value as? String, "1")
	}

	func testEditingActivityDefinition_correctlyPopulatesAllFields() {
		// given
		let definition = ActivityDefinition(
			name: "hfuewipq",
			autoNote: true,
			description: "fejhwioqp fewj qiop",
			tags: ["fhewui", "geqr", "hyrw"])
		seed(activityDefinitions: [definition])

		// when
		// this is triggering the navigate back gesture all of the sudden
		app.tables.staticTexts[definition.name].gentleSwipe(.right)
		app.tables.buttons["edit \(definition.name)"].tap()

		// then
		XCTAssertEqual(activityDefinitionNameField().value as? String, definition.name)
		XCTAssertEqual(app.textViews["activity description"].value as? String, definition.description)
		XCTAssertEqual(definitionTagsFieldAccessibilityValueAsSet(), Set(definition.tags!))
		XCTAssertEqual(activityDefinitionAutoNoteField().value as? String, "1")
	}

	func testDeletingDescriptionAndTagsFromActivityDefinition_correctlySaves() {
		// given
		let definition = ActivityDefinition(
			name: "hfuewipq",
			description: "fejhwioqp fewj qiop",
			tags: ["fhewui", "geqr", "hyrw"])
		seed(activityDefinitions: [definition])

		// when
		app.tables.staticTexts[definition.name].gentleSwipe(.right)
		app.tables.buttons["edit \(definition.name)"].tap()
		deleteContentOf(textField: app.textViews["activity description"])
		delete(numberOfTags: definition.tags!.count, fromTagsField: activityDefinitionTagsField())

		// then
		XCTAssertEqual(activityDefinitionNameField().value as? String, definition.name)
		XCTAssertEqual(app.textViews["activity description"].value as? String, "")
		XCTAssertEqual(activityDefinitionTagsField().value as? String, "Tags") // placeholder value is "Tags"
	}

	func testEditActivityDefinitionHasEmptyNameField_saveButtonIsDisabled() {
		// when
		app.buttons["+"].tap()

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
	}

	func testActivityDefinitionWithNameAlreadyExists_editActivityDefinitionScreenDisablesSaveButton() {
		// given
		let definition = ActivityDefinition(name: "greq")
		seed(activityDefinitions: [definition])

		// when
		app.buttons["+"].tap()
		setTextFor(field: activityDefinitionNameField(), to: definition.name)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
		app.navigationBars.buttons["Activities"].tap()
	}

	// MARK: - Activity

	func testTapOnActivityDefinition_startsActivity() {
		// given
		let definition = ActivityDefinition(name: "grneoq")
		seed(activityDefinitions: [definition])

		// when
		app.tables.staticTexts[definition.name].tap()

		// then
		waitForCount(1, in: app.activityIndicators)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	func testTapOnActivityDefinitionThatHasRunningInstance_stopsRunningInstanceAndUpdatesLastInstanceInfo() {
		// given
		let definition = ActivityDefinition(name: "grnejioqu")
		seed(activityDefinitions: [definition])
		let earliestStart = Date()
		app.tables.staticTexts[definition.name].tap()
		let latestStart = Date()
		sleep(1)

		// when
		let earliestEnd = Date()
		app.tables.staticTexts[definition.name].tap()
		let latestEnd = Date()

		// then: automation itself takes time, so bracket the actual tap events.
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		let displayedTimes = app.tables.cells.staticTexts["last start / end time"].value as? String
		let starts = wholeSecondDates(from: earliestStart, to: latestStart)
		let ends = wholeSecondDates(from: earliestEnd, to: latestEnd)
		XCTAssertTrue(starts.contains { start in ends.contains { end in
			startToEndTimeLabelText(from: start, to: end) == displayedTimes
		} }, "Recorded start/end times must fall within the start/stop tap events")
		let total = app.tables.cells.staticTexts["total duration for today"].value as? String
		let recent = app.tables.cells.staticTexts["most recent duration"].value as? String
		XCTAssertEqual(total, recent)
		assertRecordedDuration(in: earliestEnd.timeIntervalSince(latestStart)...latestEnd.timeIntervalSince(earliestStart))
	}

	func testChangingActivityDefinitionWhileEditingLastActivity_updatesUI() {
		// given
		let definition = ActivityDefinition(name: "fjhwi")
		let targetDefinition = ActivityDefinition(name: "greqnji" + definition.name)
		seed(activityDefinitions: [definition, targetDefinition], activities: [.init(definition)])

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
		let endDate = Date()
		seed(activityDefinitions: [definition], activities: [.init(definition, start: Date().addingTimeInterval(-60), end: endDate)])
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.buttons["✎ Last"].tap()

		// when
		app.tables.cells.buttons["clear end date button"].tap()

		// then
		waitForValue("", of: app.tables.cells.staticTexts["end date"])
		XCTAssert(!app.tables.cells.staticTexts[editActivityDateString(for: endDate)].exists)
	}

	func testChangingStartDateOnEditActivityScreen_updatesUI() {
		// given
		let definition = ActivityDefinition(name: "gteq")
		let calendar = Calendar.autoupdatingCurrent
		let day = calendar.date(byAdding: .day, value: -3, to: calendar.startOfDay(for: Date()))!
		let initialStartDate = calendar.date(bySettingHour: 1, minute: 30, second: 42, of: day)!
		let expectedStartDate = calendar.date(bySettingHour: 0, minute: 30, second: 0, of: day)!
		// Always exercise the 1 -> 12 hour-wheel carry, regardless of CI time.
		seed(activityDefinitions: [definition], activities: [.init(definition, start: initialStartDate)])
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		app.tables.cells.staticTexts["Start"].tap()
		setDatePicker(to: expectedStartDate)
		app.buttons["save button"].tap()

		// then
		waitForValue(editActivityDateString(for: expectedStartDate), of: app.tables.cells.staticTexts["start date"])
		XCTAssertEqual(app.tables.cells.staticTexts["start date"].value as? String, editActivityDateString(for: expectedStartDate))
	}

	func testChangingEndDateOnEditActivityScreen_updatesUI() {
		// given
		let definition = ActivityDefinition(name: "gteq")
		let calendar = Calendar.autoupdatingCurrent
		let day = calendar.date(byAdding: .day, value: -3, to: calendar.startOfDay(for: Date()))!
		let startDate = calendar.date(bySettingHour: 0, minute: 30, second: 0, of: day)!
		let initialEndDate = calendar.date(bySettingHour: 11, minute: 30, second: 42, of: day)!
		let expectedEndDate = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: day)!
		// Exercise the opposite carry into noon, with a valid earlier start.
		seed(activityDefinitions: [definition], activities: [.init(definition, start: startDate, end: initialEndDate)])
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		// when
		app.tables.cells.staticTexts["End"].tap()
		setDatePicker(to: expectedEndDate)
		app.buttons["save button"].tap()

		// then
		waitForValue(editActivityDateString(for: expectedEndDate), of: app.tables.cells.staticTexts["end date"])
		XCTAssertEqual(app.tables.cells.staticTexts["end date"].value as? String, editActivityDateString(for: expectedEndDate))
	}

	func testEditingLastActivity_correctlyUpdatesCorrespondingActivityDefinitionCell() {
		// given
		let definition = ActivityDefinition(name: "gteq")
		let calendar = Calendar.autoupdatingCurrent
		let today = calendar.startOfDay(for: Date())
		// Keep the entire 62-minute activity within today. Relative-to-now
		// dates made this same-day total assertion invalid near midnight.
		let startDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!
		// A real minute change must occur. Selecting the already displayed minute
		// is an unchanged edit and correctly preserves the original seconds.
		seed(activityDefinitions: [definition], activities: [.init(definition, start: startDate - 10.minutes)])
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["✎ Last"].tap()

		setActivityStartDate(to: startDate)

		let endDate = startDate + 1.hours + 2.minutes
		setActivityEndDate(to: endDate)

		// when
		app.buttons["Save"].tap()

		// then
		waitForValue(startToEndTimeLabelText(from: startDate, to: endDate), of: app.tables.cells.staticTexts["last start / end time"])
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 0)
		XCTAssertEqual(app.tables.cells.staticTexts["last start / end time"].value as? String, startToEndTimeLabelText(from: startDate, to: endDate))
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "1:02:00")
		XCTAssertEqual(app.tables.cells.staticTexts["most recent duration"].value as? String, "1:02:00")
	}

	func testAddNewActivityScreen_startsWithCorrectActivityDefinitionSelected() {
		// given
		let definition1 = ActivityDefinition(name: "htgerq")
		let definition2 = ActivityDefinition(name: "gheiqu")
		seed(activityDefinitions: [definition1, definition2])

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

		seed(activityDefinitions: [definition])
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

		seed(activityDefinitions: [definition], activities: [.init(definition)])
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

		seed(activityDefinitions: [definition], activities: [.init(definition, start: Date().addingTimeInterval(-60), end: Date())])
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

		seed(activityDefinitions: [definition], activities: [.init(definition, start: Date().addingTimeInterval(-60), end: Date())])
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
		let minTime = 60
		seed(activityDefinitions: [definition])
		app.tabBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()
		setAutoIgnore(enabled: true, seconds: String(minTime))
		app.navigationBars.buttons["Settings"].tap()
		app.tabBars.buttons["Record"].tap()

		// when
		let began = Date()
		app.tables.cells.staticTexts[definition.name].tap()
		sleep(1)
		app.tables.cells.staticTexts[definition.name].tap()

		// then
		XCTAssertLessThan(Date().timeIntervalSince(began), Double(minTime), "Automation must stop the activity before the configured threshold")
		XCTAssertEqual(app.tables.cells.staticTexts["total duration for today"].value as? String, "")
	}

	func testAutoIgnoreEnabledAndActivityStoppedAfterMinimumTime_savesActivity() {
		// given
		let definition = ActivityDefinition(name: "grehuiq")
		let minTime = 1
		seed(activityDefinitions: [definition])
		app.tabBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()
		setAutoIgnore(enabled: true, seconds: String(minTime))
		app.navigationBars.buttons["Settings"].tap()
		app.tabBars.buttons["Record"].tap()

		// when
		let earliestStart = Date()
		app.tables.cells.staticTexts[definition.name].tap()
		let latestStart = Date()
		sleep(UInt32(minTime) + 1)
		let earliestEnd = Date()
		app.tables.cells.staticTexts[definition.name].tap()
		let latestEnd = Date()

		// then
		assertRecordedDuration(in: earliestEnd.timeIntervalSince(latestStart)...latestEnd.timeIntervalSince(earliestStart))
	}

	func testFinishingActivityWithAutoNoteEnabled_showsEditActivityScreen() {
		// given
		let definition = ActivityDefinition(name: "njgkort", autoNote: true)
		seed(activityDefinitions: [definition])
		app.tables.cells.staticTexts[definition.name].tap()

		// when
		app.tables.cells.staticTexts[definition.name].tap()

		// then
		XCTAssert(app.tables.cells.textViews["activity note"].exists)
	}

	// MARK: - Quick Create / Start

	func testLongPressOnAddButtonWhenSearchBarIsEmpty_doesNotCreateActivity() {
		// when
		app.buttons["+"].press(forDuration: 1.0)

		// then
		XCTAssertEqual(app.cells.allElementsBoundByIndex.count, 0)
	}

	func testLongPressOnAddButtonWhenSearchBarHasNameOfExistingActiviyt_doesNotCreateActivityOrClearSearchBar() {
		// given
		let definition = ActivityDefinition(name: "freqgr")
		seed(activityDefinitions: [definition])
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition.name)

		// when
		app.buttons["+"].press(forDuration: 1.0)
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
		app.buttons["+"].press(forDuration: 1.0)
		app.buttons["Cancel"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts[definition.name].exists)
		waitForCount(1, in: app.activityIndicators)
		XCTAssertEqual(app.activityIndicators.allElementsBoundByIndex.count, 1)
	}

	// MARK: - Search Bar Filtering

	func testFilteringForNameWorks() {
		// given
		let definition1 = ActivityDefinition(name: "grnueio")
		let definition2 = ActivityDefinition(name: "htrw")
		seed(activityDefinitions: [definition1, definition2])

		// when
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition1.name)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
	}

	func testFilteringForDescriptionWorks() {
		// given
		let searchText = "abc"
		let definition = ActivityDefinition(name: "geqr", description: searchText + "gfjeiorq fj")
		let otherDefinition = ActivityDefinition(name: definition.name + "some other stuff")
		seed(activityDefinitions: [definition, otherDefinition])

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
	}

	func testFilteringForTagsWorks() {
		// given
		let searchText = "grffjieorwq"
		let definition = ActivityDefinition(
			name: "gteqrwfd",
			tags: ["this tag " + searchText + " contains the search text"])
		let otherDefinition = ActivityDefinition(name: definition.name + "some other stuff")
		seed(activityDefinitions: [definition, otherDefinition])

		// when
		filterActivities(by: searchText)

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 1)
	}

	func testClearingFilterText_correctlyUpdatesDisplayedActivities() {
		// given
		let definition1 = ActivityDefinition(name: "grnueio")
		let definition2 = ActivityDefinition(name: "htrw")
		seed(activityDefinitions: [definition1, definition2])
		app.searchFields["Search Activities"].tap()
		app.searchFields["Search Activities"].typeText(definition1.name)

		// when
		app.searchFields["Search Activities"].buttons["Clear text"].tap()

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 2)
	}

	// MARK: - Deleting

	/// Wait for the deletion to reach the visible cell before checking its values.
	func testDeletingRunningActivity_correctlyUpdatesUI() {
		// given
		let definition = ActivityDefinition(name: "grenqj")
		seed(activityDefinitions: [definition], activities: [.init(definition)])

		// when
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.buttons["delete most recent \(definition.name)"].tap()
		app.buttons["Yes"].tap()

		// then
		waitForCount(0, in: app.activityIndicators)
		waitForValue("", of: app.tables.cells.staticTexts["last start / end time"])
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
		seed(activityDefinitions: [definition1, definition2, definition3])

		// when
		app.tables.cells.staticTexts[definition2.name].gentleSwipe(.right)
		app.tables.buttons["🗑️ All"].tap()
		app.buttons["Yes"].tap()
		XCTAssertTrue(app.alerts.buttons["Cancel"].waitForExistence(timeout: 3))
		app.alerts.buttons["Yes"].tap()

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
		seed(activityDefinitions: [definition1, definition2, definition3, definition4])
		filterActivities(by: "z")

		// when
		app.tables.cells.staticTexts[definition3.name].gentleSwipe(.right)
		app.tables.buttons["🗑️ All"].tap()
		app.buttons["Yes"].tap()
		XCTAssertTrue(app.alerts.buttons["Cancel"].waitForExistence(timeout: 3))
		app.alerts.buttons["Yes"].tap()
		app.buttons["Cancel"].tap() // clear search text

		// then
		XCTAssertEqual(app.tables.cells.allElementsBoundByIndex.count, 3)
		XCTAssert(app.tables.cells.staticTexts[definition1.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition2.name].exists)
		XCTAssert(!app.tables.cells.staticTexts[definition3.name].exists)
		XCTAssert(app.tables.cells.staticTexts[definition4.name].exists)
	}

	// MARK: - Reordering ActivityDefinitions

	func testReorderToLowerSpotWhileFiltering_correcltyReordersDefinitions() {
		// given
		let filterString = "filter string"
		let definition1 = ActivityDefinition(name: filterString)
		let definition2 = ActivityDefinition(name: "definition 2")
		let definition3 = ActivityDefinition(name: "\(filterString) definition 3")
		let definition4 = ActivityDefinition(name: "definition 4 \(filterString)")
		seed(activityDefinitions: [definition1, definition2, definition3, definition4])
		filterActivities(by: filterString)

		// when
		definitionCell(definition1).press(forDuration: 1, thenDragTo: definitionCell(definition4))
		app.buttons["Cancel"].tap()

		// then
		XCTAssertLessThanOrEqual(definitionCell(definition2).frame.maxY, definitionCell(definition3).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition3).frame.maxY, definitionCell(definition4).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition4).frame.maxY, definitionCell(definition1).frame.minY)
	}

	func testReorderToHigherSpotWhileFiltering_correcltyReordersDefinitions() {
		// given
		let filterString = "filter string"
		let definition1 = ActivityDefinition(name: filterString)
		let definition2 = ActivityDefinition(name: "definition 2")
		let definition3 = ActivityDefinition(name: "\(filterString) definition 3")
		let definition4 = ActivityDefinition(name: "definition 4 \(filterString)")
		seed(activityDefinitions: [definition1, definition2, definition3, definition4])
		filterActivities(by: filterString)

		// when
		definitionCell(definition3).press(forDuration: 1, thenDragTo: definitionCell(definition1))
		app.buttons["Cancel"].tap()

		// then
		XCTAssertLessThanOrEqual(definitionCell(definition3).frame.maxY, definitionCell(definition1).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition1).frame.maxY, definitionCell(definition2).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition2).frame.maxY, definitionCell(definition4).frame.minY)
	}

	func testReorderToLowerSpotWhileNotFiltering_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let definition1 = ActivityDefinition(name: "definition 1")
		let definition2 = ActivityDefinition(name: "definition 2")
		let definition3 = ActivityDefinition(name: "definition 3")
		seed(activityDefinitions: [definition1, definition2, definition3])

		// when - re-order
		// Hold beyond UILongPressGestureRecognizer's default 0.5-second threshold
		// before moving, so event scheduling cannot turn the drag into a scroll.
		definitionCell(definition1).press(forDuration: 1, thenDragTo: definitionCell(definition2))

		// then - correct order before
		XCTAssertLessThanOrEqual(definitionCell(definition2).frame.maxY, definitionCell(definition1).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition1).frame.maxY, definitionCell(definition3).frame.minY)

		// when - go back to record screen and then view activities again
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.staticTexts["Activities"].tap()

		// then - correct order after
		XCTAssertLessThanOrEqual(definitionCell(definition2).frame.maxY, definitionCell(definition1).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition1).frame.maxY, definitionCell(definition3).frame.minY)
	}

	func testReorderToHigherSpotWhileNotFiltering_persistsAfterGoingBackAndThenViewingRecordActivitiesScreenAgain() {
		// given
		let definition1 = ActivityDefinition(name: "definition 1")
		let definition2 = ActivityDefinition(name: "definition 2")
		let definition3 = ActivityDefinition(name: "definition 3")
		seed(activityDefinitions: [definition1, definition2, definition3])

		// when - re-order
		definitionCell(definition3).press(forDuration: 1, thenDragTo: definitionCell(definition2))

		// then - correct order before
		XCTAssertLessThanOrEqual(definitionCell(definition1).frame.maxY, definitionCell(definition3).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition3).frame.maxY, definitionCell(definition2).frame.minY)

		// when - go back to record screen and then view activities again
		app.navigationBars.buttons["Back"].tap()
		app.tables.cells.staticTexts["Activities"].tap()

		// then - correct order after
		XCTAssertLessThanOrEqual(definitionCell(definition1).frame.maxY, definitionCell(definition3).frame.minY)
		XCTAssertLessThanOrEqual(definitionCell(definition3).frame.maxY, definitionCell(definition2).frame.minY)
	}

	// MARK: - Helper Functions

	private final func assertRecordedDuration(in interval: ClosedRange<TimeInterval>, file: StaticString = #file, line: UInt = #line) {
		let possible = (Int(interval.lowerBound)...Int(interval.upperBound)).map {
			String(format: "%d:%02d:%02d", $0 / 3600, ($0 / 60) % 60, $0 % 60)
		}
		let actual = app.tables.cells.staticTexts["total duration for today"].value as? String
		XCTAssertTrue(possible.contains(actual ?? ""), "Duration \(actual ?? "missing") must match the measured tap interval \(interval)", file: file, line: line)
	}

	private final func wholeSecondDates(from start: Date, to end: Date) -> [Date] {
		return (Int(floor(start.timeIntervalSince1970))...Int(floor(end.timeIntervalSince1970))).map {
			Date(timeIntervalSince1970: TimeInterval($0))
		}
	}

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
		return app.tables.children(matching: .cell).children(matching: .textField).element(boundBy: 0)
	}

	private final func autoIgnoreEnabledSwitch() -> XCUIElement {
		return app.tables.cells.switches["auto-ignore enabled"]
	}

	private final func autoIgnoreSecondsTextField() -> XCUIElement {
		return app.tables.cells.textFields["auto-ignore seconds"]
	}
	private final func definitionCell(_ definition: ActivityDefinition) -> XCUIElement {
		return app.tables.cells.staticTexts[definition.name]
	}
}
