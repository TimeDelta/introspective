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
		// Empty queries now retain Results so their actual conditions can be
		// diagnosed, rather than dismissing the only route to an explanation.
		assertEmptyQueryCanBeExplainedAndReturnToBuilder()
	}
}
