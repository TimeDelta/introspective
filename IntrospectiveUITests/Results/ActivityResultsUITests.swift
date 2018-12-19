//
//  ActivityResultsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class ActivityResultsUITests: UITest {

	final override func tearDown() {
		app.tabBars.buttons["Settings"].tap()
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	func testDeletingOnlyActivityInResults_goesBackToQueryScreen() {
		// given
		let activityName = "gerq"
		createActivityDefinition(name: activityName)
		addActivity(name: activityName)
		runAllActivitiesQuery()

		// when
		app.tables.cells.staticTexts[activityName].swipeLeft()
		app.tables.cells.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()

		// then
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

	private final func createActivityDefinition(name: String) {
		app.tabBars.buttons["Record Data"].tap()
		app.tables.cells.buttons["Activities"].tap()
		app.buttons["Add"].tap()
		app.tables.textFields["activity name"].tap()
		app.tables.textFields["activity name"].typeText(name)
		app.buttons["Save"].tap()
	}

	private final func addActivity(name: String) {
		app.tables.cells.staticTexts[name].swipeLeft()
		app.tables.buttons["+"].tap()
		app.buttons["Save"].tap()
	}
}
