//
//  QueryScreenUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class QueryScreenUITests: UITest {

	func testChangingMainSampleType_changesDisplayedTextToNewSampleTypeName() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
		app.tables.staticTexts["Blood Pressure"].tap()

		// when
		app.pickerWheels["Blood Pressure"].adjust(toPickerWheelValue: "Heart Rate")
		app.buttons["Accept"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Heart Rate"].exists)
	}

	func testChangingSubQuerySampleType_changesDisplayedTextToNewSampleTypeName() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Data Type"].tap()

		// when
		app.tables.cells.allElementsBoundByIndex[1].tap()
		app.pickerWheels["Blood Pressure"].adjust(toPickerWheelValue: "Body Mass Index")
		app.scrollViews.otherElements.buttons["Accept"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Body Mass Index"].exists)
	}

	func testChangingSubQueryMatcher_changesDisplayedTextInTableViewCell() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Data Type"].tap()

		// when
		app.tables.cells.allElementsBoundByIndex[1].tap()
		app.pickerWheels["Start and end timestamps are the same as"].adjust(toPickerWheelValue: "Within <number> <time_unit>s of")
		app.switches.allElementsBoundByIndex[0].tap()
		app.scrollViews.otherElements.buttons["Minute"].tap()
		app.pickerWheels["Minute"].adjust(toPickerWheelValue: "Day")
		app.buttons["Save"].tap()
		app.scrollViews.otherElements.buttons["5"].tap()
		app.textFields.containing(.button, identifier:"Clear text").element.tap()
		app.textFields.allElementsBoundByIndex[0].typeText("7")
		app.buttons["Save"].tap()
		app.scrollViews.otherElements.buttons["Accept"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Within 57 days of most recent"].exists)
	}

	func testChangingAttributeRestriction_changesDisplayedTextInTableViewCell() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()

		// when
		app.tables.staticTexts["Diastolic blood pressure < 0.0"].tap()
		app.pickerWheels["Diastolic blood pressure"].adjust(toPickerWheelValue: "Timestamp")
		app.pickerWheels["Before date"].adjust(toPickerWheelValue: "After date")
		app.buttons.allElementsBoundByIndex[5].tap()
		app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
		app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "18")
		app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2012")
		app.buttons["Save"].tap()
		app.scrollViews.otherElements.buttons["Accept"].tap()

		// then
		XCTAssert(app.tables.staticTexts["After June 18 2012"].exists)
	}

	func testMovingSampleTypeAboveAttributeRestriction_correctlyChangesAttributeRestriction() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Data Type"].tap()
		app.tables.cells.allElementsBoundByIndex[2].tap()
		app.pickerWheels["Blood Pressure"].adjust(toPickerWheelValue: "Body Mass Index")
		app.scrollViews.otherElements.buttons["Accept"].tap()

		// when
		app.tables.buttons["Edit"].tap()
		let attributeRestrictionReorderButton = app.buttons.containing(
			NSPredicate(format: "%K BEGINSWITH[cd] %@", "label", "reorder less than")
		).allElementsBoundByIndex[0]
		app.tables.buttons["Reorder Data Type"].press(forDuration: 0.5, thenDragTo: attributeRestrictionReorderButton)
		app.tables.buttons["Done"].tap()

		// then
		XCTAssert(app.tables.staticTexts["BMI < 0.0"].exists)
	}

	func testPressingEditButton_changesTitleOfEditButtonToDone() {
		// given
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()

		// when
		app.tables.buttons["Edit"].tap()

		// then
		XCTAssert(app.tables.buttons["Done"].exists)
	}
}
