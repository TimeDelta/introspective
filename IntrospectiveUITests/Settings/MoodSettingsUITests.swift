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
		setTextFor(field: maxMoodField(), to: "-1")

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["Maximum mood must be greater than minimum mood."].exists)
	}

	func testChangingMinMood_asksToScaleExistingMoods() {
		// given
		setTextFor(field: minMoodField(), to: "-1")

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["Scale existing moods?"].exists)
	}

	func testChangingMaxMood_asksToScaleExistingMoods() {
		// given
		setTextFor(field: maxMoodField(), to: "1000")

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["Scale existing moods?"].exists)
	}

	func testChangingMinAndMaxMoods_correctlyDisplaysChangesInUI() {
		// given
		let originalMin = minMoodField().value as! String
		let originalMax = maxMoodField().value as! String
		setTextFor(field: minMoodField(), to: originalMin + "2")
		setTextFor(field: maxMoodField(), to: originalMax + "3")

		// when
		app.navigationBars.buttons["Settings"].tap()
		app.alerts.buttons["No"].tap()
		app.tables.staticTexts["Mood"].tap()

		// then
		let expectedMin = originalMin == "0" ? "2" : originalMin + "2"
		let expectedMax = originalMax == "0" ? "3" : originalMax + "3"
		XCTAssertEqual(minMoodField().value as? String, expectedMin)
		XCTAssertEqual(maxMoodField().value as? String, expectedMax)
	}

	func testEnablingDiscreteMoods_updatesRecordScreenToUseIntegerMoods() {
		// given
		let minMood = minMoodField().value as! String
		app.switches["use integers only switch"].tap()

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		app.tabBars.buttons["Record"].tap()
		let setToMinMoodButton = app.buttons["set mood to \(minMood) button"]
		setToMinMoodButton.tap() // force it to wait for the button to exist
		XCTAssert(setToMinMoodButton.exists)

		// clean up
		app.tabBars.buttons["Settings"].tap()
	}

	func testEnablingDiscreteMoods_updatesMoodResultsScreenToUseIntegerMoods() {
		// given
		runQueryForAll("Mood")

		let minMood = minMoodField().value as! String
		app.switches["use integers only switch"].tap()

		// when
		app.navigationBars.buttons["Settings"].tap()

		// then
		app.tabBars.buttons["Explore"].tap()
		let setToMinMoodButton = app.buttons["set mood to \(minMood) button"]
		setToMinMoodButton.tap() // force it to wait for the button to exist
		XCTAssert(setToMinMoodButton.exists)

		// clean up
		app.tabBars.buttons["Settings"].tap()
	}

	func testPressingReset_resetsAllASettings() {
		// given
		let originalMin = minMoodField().value as! String
		let originalMax = maxMoodField().value as! String
		let originalScaleMoodsOnImport = scaleMoodsOnImportSwitch().value as? String
		setTextFor(field: minMoodField(), to: originalMin + "2")
		setTextFor(field: maxMoodField(), to: originalMax + "3")
		scaleMoodsOnImportSwitch().tap()

		// when
		app.navigationBars.buttons["Reset"].tap()

		// then
		XCTAssertEqual(minMoodField().value as? String, originalMin)
		XCTAssertEqual(maxMoodField().value as? String, originalMax)
		XCTAssertEqual(scaleMoodsOnImportSwitch().value as? String, originalScaleMoodsOnImport)
	}

	// MARK: - Element Functions

	private final func minMoodField() -> XCUIElement {
		return app.textFields["minimum mood"]
	}

	private final func maxMoodField() -> XCUIElement {
		return app.textFields["maximum mood"]
	}

	private final func scaleMoodsOnImportSwitch() -> XCUIElement {
		return app.switches["scale moods on import"]
	}
}
