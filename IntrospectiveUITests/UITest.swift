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
		app.launchArguments.append("--testing")
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

	// MARK: - Generic UI Helpers

	final func tapCoordinate(x: Double, y: Double) {
		let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
		let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
		coordinate.tap()
	}

	// MARK: - Picker Helpers

	final func setPicker(_ pickerQueryText: String? = nil, to value: String, changeCase: Bool = true) {
		let pickers = app.pickers
		var value = value
		if changeCase {
			value = value.localizedCapitalized
		}
		if let pickerQueryText = pickerQueryText {
			pickers[pickerQueryText].pickerWheels.allElementsBoundByIndex[0].adjust(toPickerWheelValue: value)
		} else {
			pickers.pickerWheels.allElementsBoundByIndex[0].adjust(toPickerWheelValue: value)
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
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateStrings[.month]!)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateStrings[.day]!)
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.year]!)
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
		dateFormatter.dateFormat = "YYYY"
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

	private final func moodNoteButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood note button"]
	}

	private final func moodRatingButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood button"]
	}

	private final func moodRatingTextField() -> XCUIElement {
		return app.textFields["mood rating"]
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
		app.tabBars.buttons["Record Data"].tap()
		for mood in moods {
			moodRatingButton().tap()
			moodRatingTextField().tap()
			moodRatingTextField().tap()
			moodRatingTextField().typeText(String(mood.rating))
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
}
