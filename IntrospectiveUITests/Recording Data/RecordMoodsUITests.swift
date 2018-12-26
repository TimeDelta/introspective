//
//  RecordMoodsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class RecordMoodsUITests: UITest {

	final override func tearDown() {
		app.tabBars.buttons["Settings"].tap()
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	func testRecordMood_resetsNoteAndMoodRating() {
		// given
		app.tables.cells.sliders["mood slider"].press(forDuration: 0.5, thenDragTo: maxRatingLabel());

		app.tables.buttons["set mood note button"].tap()

		let noteField = app.textViews.allElementsBoundByIndex[0]
		noteField.tap()
		noteField.typeText("This is a note.")
		app.toolbars["Toolbar"].buttons["Save"].tap()

		// when
		app.tables.buttons["save mood button"].tap()

		// then
		XCTAssertEqual(moodNoteButton().value as? String, "Add Note")
		XCTAssertEqual(moodSlider().value as? String, "50%")
		XCTAssertEqual(moodRatingButton().value as? String, "3.5")
	}

	func testSetMoodUsingRatingButton_correctlyUpdatesButtonTitleAndSlider() {
		// when
		moodRatingButton().tap()
		moodRatingTextField().tap()
		moodRatingTextField().tap()
		moodRatingTextField().typeText("5.25")
		app.toolbars.buttons["Save"].tap()

		// then
		XCTAssertEqual(moodRatingButton().value as? String, "5.25")
		XCTAssertEqual(moodSlider().value as? String, "75%")
	}

	func testMovingSlider_updatesSetMoodButtonTitle() {
		// when
		app.tables.cells.sliders["mood slider"].press(forDuration: 0.5, thenDragTo: maxRatingLabel());

		// then
		XCTAssertEqual(moodRatingButton().value as? String, "7")
	}

	// MARK: - Element Functions

	private final func maxRatingLabel() -> XCUIElement {
		return app.tables.cells.staticTexts["max rating"]
	}

	private final func moodSlider() -> XCUIElement {
		return app.tables.cells.sliders["mood slider"]
	}

	private final func moodNoteButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood note button"]
	}

	private final func moodRatingButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood button"]
	}

	private final func moodRatingTextField() -> XCUIElement {
		return app.textFields["mood rating"]
	}
}
