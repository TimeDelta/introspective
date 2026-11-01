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
		let expectedSeconds = (autoIgnoreSecondsTextField().value as? String ?? "") + "5"

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
		setAutoIgnore(enabled: originallyEnabledStringValue != "1", seconds: (originalSeconds ?? "") + "5")

		// when
		app.navigationBars.buttons["Reset"].tap()

		// then
		XCTAssertEqual(autoIgnoreEnabledSwitch().value as? String, originallyEnabledStringValue)
		XCTAssertEqual(autoIgnoreSecondsTextField().value as? String, originalSeconds)
	}

	// MARK: - Helper Functions

	private final func setAutoIgnore(enabled: Bool, seconds: String) {
		guard setAutoIgnoreEnabled(true) else { return }
		setTextFor(field: autoIgnoreSecondsTextField(), to: seconds)
		setAutoIgnoreEnabled(enabled)
	}

	@discardableResult
	private func setAutoIgnoreEnabled(_ enabled: Bool) -> Bool {
		let toggle = autoIgnoreEnabledSwitch()
		let field = autoIgnoreSecondsTextField()
		let expected = enabled ? "1" : "0"
		guard waitForElement(toggle) else {
			XCTFail("Auto-ignore switch did not appear")
			return false
		}
		if toggle.value as? String != expected {
			// Set a direction rather than toggling an assumed state. A completed
			// tap alone did not guarantee a changed switch in simulator runs.
			let off = toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.5))
			let on = toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.8, dy: 0.5))
			let start = enabled ? off : on
			let end = enabled ? on : off
			start.press(forDuration: 0.1, thenDragTo: end)
		}
		let ready = NSPredicate { _, _ in
			(toggle.value as? String) == expected && field.exists && field.isEnabled == enabled
		}
		if !ready.evaluate(with: nil) {
			let expectation = XCTNSPredicateExpectation(predicate: ready, object: nil)
			let result = XCTWaiter.wait(for: [expectation], timeout: 5)
			guard result == .completed || ready.evaluate(with: nil) else {
				XCTFail("Auto-ignore did not reach enabled=\(enabled): switch=\(toggle.value ?? "missing"), field enabled=\(field.isEnabled)")
				return false
			}
		}
		return true
	}

	// MARK: - Element Functions

	private final func autoIgnoreEnabledSwitch() -> XCUIElement {
		return app.tables.cells.switches["auto-ignore enabled"]
	}

	private final func autoIgnoreSecondsTextField() -> XCUIElement {
		return app.tables.cells.textFields["auto-ignore seconds"]
	}
}
