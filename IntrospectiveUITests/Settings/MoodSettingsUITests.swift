//
//  MoodSettingsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class MoodSettingsUITests: UITest {

	final override func setUp() {
		super.setUp()
		app.tabBars.buttons["Settings"].tap()
		app.tables.staticTexts["Mood"].tap()
	}

	final override func tearDown() {
		tapIfExists(app.alerts.buttons["OK"])
		tapIfExists(app.alerts.buttons["No"])
		tapIfExists(app.navigationBars.buttons["Reset"])
		tapIfExists(app.navigationBars.buttons["Settings"])
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	func testGivenMaxMoodLessThanMinMood_cannotSaveSettings() {
		// given
		setTextFor(field: app.textFields["maximum mood"], to: "-1")

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["Maximum mood must be greater than minimum mood."].exists)
	}

	func testChangingMinMood_asksToScaleExistingMoods() {
		// given
		setTextFor(field: app.textFields["minimum mood"], to: "-1")

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["Scale existing moods?"].exists)
	}

	func testChangingMinAndMaxMoods_correctlyDisplaysChangesInUI() {
		// given
		let originalMin = app.textFields["minimum mood"].value as! String
		let originalMax = app.textFields["maximum mood"].value as! String
		setTextFor(field: app.textFields["minimum mood"], to: originalMin + "2")
		setTextFor(field: app.textFields["maximum mood"], to: originalMax + "3")

		// when
		app.navigationBars.buttons["Settings"].tap()
		app.alerts.buttons["No"].tap()
		app.tables.staticTexts["Mood"].tap()

		// then
		XCTAssertEqual(app.textFields["minimum mood"].value as? String, "12")
		XCTAssertEqual(app.textFields["maximum mood"].value as? String, "13")
	}

	func testPressingReset_resetsAllASettings() {
		// given
		let originalMin = app.textFields["minimum mood"].value as! String
		let originalMax = app.textFields["maximum mood"].value as! String
		setTextFor(field: app.textFields["minimum mood"], to: originalMin + "2")
		setTextFor(field: app.textFields["maximum mood"], to: originalMax + "3")

		// when
		app.navigationBars.buttons["Reset"].tap()

		// then
		XCTAssertEqual(app.textFields["minimum mood"].value as? String, originalMin)
		XCTAssertEqual(app.textFields["maximum mood"].value as? String, originalMax)
	}
}
