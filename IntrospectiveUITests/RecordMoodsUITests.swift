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
		// when
		let ratingLabel = app.tables.staticTexts["3.5 / 7"]
		app.tables.sliders["50%"].press(forDuration: 0.5, thenDragTo: ratingLabel);

		app.tables.buttons["set mood note button"].tap()

		let noteField = app.textViews.allElementsBoundByIndex[0]
		noteField.tap()
		noteField.typeText("This is a note.")
		app.toolbars["Toolbar"].buttons["Done"].tap()

		app.tables.buttons["save mood button"].tap()

		// then
		XCTAssertEqual(app.tables.buttons["set mood note button"].value as? String, "Add Note")
		XCTAssert(app.tables.sliders["50%"].exists)
	}
}
