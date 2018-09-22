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
		continueAfterFailure = false
		app = XCUIApplication()
		app.launchArguments.append("--uitesting")
		app.launch()
	}
}
