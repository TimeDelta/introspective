//
//  GeneralResultsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 3/9/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest

final class GeneralResultsUITests: UITest {

	func testGivenNoDataFound_resultsScreenDisplaysErrorAndPopsItselfFromNavigationController() {
		// given
		goToQueryScreen()

		// when
		app.buttons["Run"].tap()

		// then
		XCTAssert(app.alerts.staticTexts["No activity entries found."].exists)
		app.alerts.buttons["OK"].tap()
		XCTAssert(app.buttons["Run"].exists)
	}
}
