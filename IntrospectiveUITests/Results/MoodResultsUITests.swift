//
//  MoodResultsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

final class MoodResultsUITests: UITest {

	func testGivenNoMoods_tellsUserNoMoodEntriesFound() {
		// when
		runAllMoodsQuery()

		// then
		XCTAssert(app.alerts.staticTexts["No mood entries found."].exists)
	}

	func testGivenMood_correctlyDisplaysMoodData() {
		// given
		let mood = Mood(5, "ghfjernqjil\nfewq\nfewq\nfewq\n")
		seed(moods: [mood])

		// when
		runAllMoodsQuery()

		// then
		XCTAssertEqual(app.tables.cells.staticTexts["mood"].value as? String, "5 (1-10)")
		XCTAssertEqual(app.tables.cells.staticTexts["note"].value as? String, mood.note!)
	}

	func testEditingMood_correctlyDisplaysMoodData() {
		// given
		// Exercise a late-night PM -> morning AM edit without depending on the
		// test runner's current minute or crossing midnight during navigation.
		let calendar = Calendar.autoupdatingCurrent
		let originalDay = calendar.date(byAdding: .day, value: -3, to: calendar.startOfDay(for: Date()))!
		let originalDate = calendar.date(bySettingHour: 23, minute: 59, second: 42, of: originalDay)!
		let editedDay = calendar.date(byAdding: .day, value: -1, to: originalDay)!
		let newTimestamp = calendar.date(bySettingHour: 9, minute: 37, second: 0, of: editedDay)!
		let mood = Mood(5, "jhgeiru", timestamp: originalDate.addingTimeInterval(0.314))
		seed(moods: [mood])
		runAllMoodsQuery()

		let newRating = mood.rating + 1
		let newNote = "htmngeoq"

		// when
		app.tables.cells.staticTexts[mood.note!].tap()
		app.tables.cells.staticTexts["Date"].tap()
		setDatePicker(to: newTimestamp)
		app.buttons["save button"].tap()
		// The editor formats integral ratings without a trailing decimal zero.
		setTextFor(field: app.tables.cells.textFields["mood rating"], to: String(newRating), expectedValue: "6")
		setTextFor(field: app.tables.cells.textViews["note"], to: newNote)
		app.buttons["Save"].tap()

		// then
		let timestampText = DateFormatter.localizedString(from: newTimestamp, dateStyle: .medium, timeStyle: .short)
		XCTAssertEqual(app.tables.cells.staticTexts["timestamp"].value as? String, timestampText)
		XCTAssertEqual(app.tables.cells.staticTexts["mood"].value as? String, "6 (1-10)")
		XCTAssertEqual(app.tables.cells.staticTexts["note"].value as? String, newNote)
	}

	// MARK: - Helper Functions

	private final func runAllMoodsQuery() {
		runQueryForAll("Mood")
	}
}
