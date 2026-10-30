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
		seed(activityDefinitions: [definition], activities: [.init(definition)])
		runAllActivitiesQuery()

		// when
		app.tables.cells.staticTexts[definition.name].swipeLeft()
		app.tables.cells.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()

		// then
		XCTAssert(waitForElement(app.navigationBars.buttons["Explore"]),
			"Deleting the last activity should return to the query screen")
		XCTAssert(app.tables["queryBuilder"].exists)
	}

	func testDeleteAllActivityResults_goesBackToQueryScreen() {
		// given
		let definition = ActivityDefinition(name: "fnsjka")
		seed(activityDefinitions: [definition], activities: [.init(definition)])
		runAllActivitiesQuery()

		// when
		app.buttons["actions button"].tap()
		app.buttons["Delete these activity entries"].tap()
		app.buttons["Yes"].tap()

		// then
		// Wait for the actual navigation completion.
		_ = waitForElement(app.navigationBars.buttons["Explore"])
		XCTAssert(app.navigationBars.buttons["Explore"].exists)
	}

	// MARK: - Helper Functions

	private final func runAllActivitiesQuery() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		skipInstructionsIfPresent(.query)
		app.tables.cells.allElementsBoundByIndex[0].tap()
		setPicker(to: "Activity")
		app.buttons["save button"].tap()
		app.buttons["Run"].tap()
	}

}
