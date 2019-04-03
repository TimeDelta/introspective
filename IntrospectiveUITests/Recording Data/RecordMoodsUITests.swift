//
//  RecordMoodsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/1/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class RecordMoodsUITests: UITest {

	final override func setUp() {
		super.setUp()
		app.tabBars.buttons["Record"].tap()
	}

	func testRecordMood_resetsNoteAndMoodRating() {
		// given
		app.tables.cells.sliders["mood slider"].press(forDuration: 0.5, thenDragTo: ratingRangeLabel());

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
		XCTAssertEqual(moodRatingButton().value as? String, "5.5")
	}

	func testSetMoodUsingRatingButton_correctlyUpdatesButtonTitleAndSlider() {
		// when
		moodRatingButton().tap()
		moodRatingTextField().tap()
		moodRatingTextField().tap()
		moodRatingTextField().typeText("7.75")
		app.toolbars.buttons["Save"].tap()

		// then
		XCTAssertEqual(moodRatingButton().value as? String, "7.75")
		XCTAssertEqual(moodSlider().value as? String, "75%")
	}

	func testMovingSlider_updatesSetMoodButtonTitle() {
		// when
		app.tables.cells.sliders["mood slider"].press(forDuration: 0.5, thenDragTo: ratingRangeLabel());

		// then
		XCTAssertEqual(moodRatingButton().value as? String, "10")
	}

	func testChangingRatingToValueGreaterThanMaxMood_setsRatingToMaxMood() {
		// given
		moodRatingButton().tap()
		moodRatingTextField().tap()
		moodRatingTextField().tap()

		// when
		moodRatingTextField().typeText("99")

		// then
		XCTAssertEqual(moodRatingTextField().value as? String, "10")
	}

	func testChangingRatingToValueLessThanMinMood_setsRatingToMinMood() {
		// given
		moodRatingButton().tap()
		moodRatingTextField().tap()
		moodRatingTextField().tap()

		// when
		moodRatingTextField().typeText("-1")

		// then
		XCTAssertEqual(moodRatingTextField().value as? String, "1")
	}

	// MARK: - Element Functions

	private final func ratingRangeLabel() -> XCUIElement {
		return app.tables.cells.staticTexts["rating range"]
	}

	private final func moodSlider() -> XCUIElement {
		return app.tables.cells.sliders["mood slider"]
	}
}
