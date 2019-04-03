//
//  ActivitySettingsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class ActivitySettingsUITests: UITest {

	final override func setUp() {
		super.setUp()
		app.tabBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()
	}

	// MARK: - Auto-Ignore

	func testSavingChangesToAutoIgnore_correctlyDisplaysWhenRevisitingActivitySettings() {
		// given
		let originallyEnabled = autoIgnoreEnabledSwitch().value as? String == "1"
		let expectedEnabledValue = originallyEnabled ? "0" : "1"
		let expectedSeconds = autoIgnoreSecondsTextField().value as? String ?? "" + "5"

		// when
		setAutoIgnore(enabled: !originallyEnabled, seconds: expectedSeconds)
		app.navigationBars.buttons["Settings"].tap()
		app.tables.cells.staticTexts["Activity"].tap()

		// then
		XCTAssertEqual(autoIgnoreEnabledSwitch().value as? String, expectedEnabledValue)
		XCTAssertEqual(autoIgnoreSecondsTextField().value as? String, expectedSeconds)
	}

	func testPressingReset_resetsAutoIgnoreSecondsAndAutoIgnoreEnabled() {
		// given
		let originallyEnabledStringValue = autoIgnoreEnabledSwitch().value as? String
		let originalSeconds = autoIgnoreSecondsTextField().value as? String
		setAutoIgnore(enabled: originallyEnabledStringValue != "1", seconds: originalSeconds ?? "" + "5")

		// when
		app.navigationBars.buttons["Reset"].tap()

		// then
		XCTAssertEqual(autoIgnoreEnabledSwitch().value as? String, originallyEnabledStringValue)
		XCTAssertEqual(autoIgnoreSecondsTextField().value as? String, originalSeconds)
	}

	// MARK: - Helper Functions

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

	private final func autoIgnoreEnabledSwitch() -> XCUIElement {
		return app.tables.cells.switches["auto-ignore enabled"]
	}

	private final func autoIgnoreSecondsTextField() -> XCUIElement {
		return app.tables.cells.textFields["auto-ignore seconds"]
	}
}
