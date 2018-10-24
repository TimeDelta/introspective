//
//  UITest.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

class UITest: XCTestCase {

	var app: XCUIApplication!

	override func setUp() {
		super.setUp()
		continueAfterFailure = true
		app = XCUIApplication()
		app.launchArguments.append("--testing")
		app.launch()
	}

	override func tearDown() {
		app.tabBars.buttons["Settings"].tap()
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	func tapCoordinate(x: Double, y: Double) {
		let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
		let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
		coordinate.tap()
	}
}
