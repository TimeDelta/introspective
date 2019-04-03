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
		createMoods([mood])

		// when
		runAllMoodsQuery()

		// then
		XCTAssertEqual(app.tables.cells.staticTexts["mood"].value as? String, "5 (1-10)")
		XCTAssertEqual(app.tables.cells.staticTexts["note"].value as? String, mood.note!)
	}

	func testEditingMood_correctlyDisplaysMoodData() {
		// given
		let mood = Mood(5, "jhgeiru")
		createMoods([mood])
		runAllMoodsQuery()

		let newTimestamp = Date() - 1.days - 2.hours - 3.minutes
		let newRating = mood.rating + 1
		let newNote = "htmngeoq"

		// when
		app.tables.cells.staticTexts[mood.note!].tap()
		app.tables.cells.staticTexts["Date"].tap()
		setDatePicker(to: newTimestamp)
		app.buttons["save button"].tap()
		app.tables.cells.textFields["mood rating"].tap()
		app.tables.cells.textFields["mood rating"].typeText(String(newRating))
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
