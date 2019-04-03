//
//  ActivityResultsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class ActivityResultsUITests: UITest {

	func testDeletingOnlyActivityInResults_goesBackToQueryScreen() {
		// given
		let definition = ActivityDefinition(name: "fdshjkl")
		createActivityDefinition(definition)
		addActivity(name: definition.name)
		runAllActivitiesQuery()

		// when
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()

		// then
		XCTAssert(app.navigationBars.buttons["Explore"].exists)
	}

	func testDeleteAllActivityResults_goesBackToQueryScreen() {
		// given
		let definition = ActivityDefinition(name: "fnsjka")
		createActivityDefinition(definition)
		addActivity(name: definition.name)
		runAllActivitiesQuery()

		// when
		app.buttons["actions button"].tap()
		app.buttons["Delete these activity entries"].tap()
		app.buttons["Yes"].tap()

		// then
		// the navigation item is asynchronously popped so UI test doesn't know how to wait for it
		sleep(1)
		XCTAssert(app.navigationBars.buttons["Explore"].exists)
	}

	// MARK: - Helper Functions

	private final func runAllActivitiesQuery() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		app.tables.cells.allElementsBoundByIndex[0].tap()
		setPicker(to: "Activity")
		app.buttons["save button"].tap()
		app.buttons["Run"].tap()
	}

	private final func addActivity(name: String) {
		app.tables.cells.staticTexts[name].swipeLeft()
		app.tables.buttons["+"].tap()
		app.buttons["Save"].tap()
	}
}
