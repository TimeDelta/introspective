//
//  UITest.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

class UITest: XCTestCase {

	// MARK: - Set up / tear down

	var app: XCUIApplication!

	override func setUp() {
		super.setUp()
		continueAfterFailure = true
		app = XCUIApplication()
		app.launchArguments.append("--ui-testing")
		app.launch()
	}

	// MARK: - Instructions Helpers

	final func skipInstructionsIfPresent() {
		sleep(1) // give the skip instructions button a chance to appear before checking if it's there
		let skipInstructionsButton = app.buttons["AccessibilityIdentifiers.skipButton"]
		if skipInstructionsButton.exists {
			skipInstructionsButton.tap()
		}
	}

	// MARK: - Generic UI Helpers

	final func tapCoordinate(x: Double, y: Double) {
		let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
		let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
		coordinate.tap()
	}

	final func tapIfExists(_ element: XCUIElement) {
		if element.exists {
			element.tap()
		}
	}

	// MARK: - Go To Screen Helpers

	final func goToQueryScreen() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		skipInstructionsIfPresent()
	}

	// MARK: - Picker Helpers

	final func setPicker(_ pickerQueryText: String? = nil, to value: String, changeCase: Bool = true) {
		let pickers = app.pickers
		var value = value
		if changeCase {
			value = value.localizedCapitalized
		}
		if let pickerQueryText = pickerQueryText {
			let pickerWheels = pickers[pickerQueryText].pickerWheels.allElementsBoundByIndex
			if pickerWheels.count < 1 {
				XCTFail("No pickers matching given query text found")
			} else {
				pickerWheels[0].adjust(toPickerWheelValue: value)
			}
		} else {
			let pickerWheels = pickers.pickerWheels.allElementsBoundByIndex
			if pickerWheels.count < 1 {
				XCTFail("No pickers detected")
			} else {
				pickerWheels[0].adjust(toPickerWheelValue: value)
			}
		}
	}

	final func setDatePicker(_ queryString: String? = nil, to date: Date) {
		let datePickers = app.datePickers
		let datePickerWheels: XCUIElementQuery
		if let queryString = queryString {
			datePickerWheels = datePickers[queryString].pickerWheels
		} else {
			datePickerWheels = datePickers.pickerWheels
		}
		let dateStrings = convertDateToStringComponents(date)
		if datePickerWheels.count == 3 { // date only
			// changing the order of these can break things when the date picker has a min / max date. make sure to run all UI tests if doing so
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.year]!)
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateStrings[.month]!)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateStrings[.day]!)
		} else { // date and time
			let monthAndDayText = String(dateStrings[.month]!.prefix(3)) + " " + dateStrings[.day]!
			var hourText = dateStrings[.hour]!
			let hour = Int(hourText)!
			if hour > 12 {
				hourText = String(hour - 12)
			}
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: monthAndDayText)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: hourText)
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.minute]!)
			datePickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: dateStrings[.timeZone]!)
		}
	}

	// MARK: - Value Helpers

	final func convertDateToStringComponents(_ date: Date) -> [Calendar.Component: String]{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		let month = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "yyyy"
		let year = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "d"
		let day = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "H"
		let hour = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "mm"
		let minute = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "a"
		let amPm = dateFormatter.string(from: date)

		return [.year: year, .month: month, .day: day, .hour: hour, .minute: minute, .timeZone: amPm]
	}

	final func getCommaSeparatedList(_ values: [String]) -> String {
		var list = ""
		for value in values {
			list += value + ", "
		}
		list.removeLast()
		list.removeLast()
		return list
	}

	final func isToday(_ date: Date) -> Bool {
		let calendar = Calendar.autoupdatingCurrent
		let dateInRegion = DateInRegion(date, region: Region(calendar: calendar, zone: calendar.timeZone))
		let startOfDay = dateInRegion.dateAtStartOf(.day).date
		return date.isAfterDate(startOfDay, orEqual: true, granularity: .nanosecond)
	}

	// MARK: - Text Field Helpers

	final func setTextFor(field: XCUIElement, to text: String? = nil) {
		if (field.value as? String)?.count ?? 0 > 0 {
			deleteContentOf(textField: field)
		}
		if let text = text {
			field.tap()
			field.typeText(text)
		}
	}

	final func deleteContentOf(textField: XCUIElement) {
		textField.tap()
		textField.tap()
		app.menuItems["Select All"].tap()
		var deleteKey = app.keyboards.keys["delete"]
		if !deleteKey.exists {
			// key label is different on number pad keyboard
			deleteKey = app.keyboards.keys["Delete"]
		}
		deleteKey.tap()
	}

	final func delete(numberOfTags: Int, fromTagsField tagsField: XCUIElement) {
		tagsField.tap()
		for _ in 0 ..< numberOfTags * 2 { // you have to press backspace twice to delete a tag
			app.keyboards.keys["delete"].tap()
		}
	}

	final func setTags(for tagsField: XCUIElement, to tags: [String]? = nil, from originalTags: [String]? = nil) {
		if let originalTags = originalTags {
			tagsField.tap()
			for _ in 0 ..< originalTags.count * 2 { // you have to press backspace twice to delete a tag
				app.keyboards.keys["delete"].tap()
			}
		}
		if let tags = tags {
			for tag in tags {
				tagsField.tap()
				tagsField.typeText(tag + "\n")
			}
		}
	}

	// MARK: - Element Functions

	final func moodNoteButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood note button"]
	}

	final func moodRatingButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood button"]
	}

	final func moodRatingTextField() -> XCUIElement {
		return app.textFields["mood rating"]
	}

	final func activityDefinitionNameField() -> XCUIElement {
		return app.tables.cells.textFields["activity name"]
	}

	final func activityDefinitionAutoNoteField() -> XCUIElement {
		return app.tables.cells.switches["auto note"]
	}

	final func activityDefinitionTagsField() -> XCUIElement {
		return app.tables.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element
	}

	// MARK: - Sample Creators

	struct Mood {
		var rating: Double
		var note: String?

		init(_ rating: Double = 0, _ note: String? = nil) {
			self.rating = rating
			self.note = note
		}
	}

	final func createMoods(_ moods: [Mood]) {
		app.tabBars.buttons["Record"].tap()
		for mood in moods {
			if app.sliders["mood slider"].exists {
				moodRatingButton().tap()
				moodRatingTextField().tap()
				moodRatingTextField().tap()
				moodRatingTextField().typeText(String(mood.rating))
			} else {
				app.buttons["set mood to \(Int(mood.rating)) button"].tap()
			}
			app.toolbars.buttons["Save"].tap()
			if let note = mood.note {
				app.tables.buttons["set mood note button"].tap()
				let noteField = app.textViews.allElementsBoundByIndex[0]
				setTextFor(field: noteField, to: note)
				app.toolbars.buttons["Save"].tap()
			}

			app.tables.buttons["save mood button"].tap()
		}
	}

	struct ActivityDefinition {
		var name: String
		var autoNote: Bool?
		var description: String?
		var tags: [String]?

		init(name: String, autoNote: Bool? = nil, description: String? = nil, tags: [String]? = nil) {
			self.name = name
			self.autoNote = autoNote
			self.description = description
			self.tags = tags
		}
	}

	final func createActivityDefinitions(_ definitions: [ActivityDefinition]) {
		app.tabBars.buttons["Record"].tap()
		app.tables.cells.staticTexts["Activities"].tap()
		skipInstructionsIfPresent()
		for definition in definitions {
			createActivityDefinition(definition, goToRecordActivitiesScreen: false)
		}
	}

	final func createActivityDefinition(_ definition: ActivityDefinition, goToRecordActivitiesScreen: Bool = true) {
		if goToRecordActivitiesScreen {
			app.tabBars.buttons["Record"].tap()
			app.tables.cells.staticTexts["Activities"].tap()
		}
		app.buttons["Add"].tap()
		setTextFor(field: app.tables.textFields["activity name"], to: definition.name)
		if let autoNote = definition.autoNote {
			let currentlyEnabled = activityDefinitionAutoNoteField().value as? String == "1"
			if currentlyEnabled != autoNote {
				activityDefinitionAutoNoteField().tap()
			}
		}
		setTextFor(field: app.tables.cells.textViews["activity description"], to: definition.description)
		setTags(for: activityDefinitionTagsField(), to: definition.tags)
		app.buttons["Save"].tap()
	}

	// MARK: - Query Screen Helpers

	final func runQueryForAll(_ type: String) {
		goToQueryScreen()
		setMainDataTypeForQuery(type)
		app.buttons["Run"].tap()
	}

	final func addAttributeRestrictionToQuery() {
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
	}

	final func setMainDataTypeForQuery(_ type: String) {
		app.tables.cells.allElementsBoundByIndex[0].tap()
		setPicker(to: type)
		app.buttons["save button"].tap()
	}

	final func addDataTypeToQuery(_ type: String? = nil) {
		let indexToEdit = app.tables.cells.allElementsBoundByIndex.count
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Data Type"].tap()
		if let type = type {
			app.tables.cells.element(boundBy: indexToEdit).tap()
			setPicker("data type", to: type, changeCase: false)
			app.buttons["save data type button"].tap()
		}
	}
}
