//
//  QueryScreenUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/18/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

final class QueryScreenUITests: UITest {

	final override func setUp() {
		super.setUp()
		goToQueryScreen()
	}

	// MARK: - Changing Parts

	func testChangingMainSampleType_changesDisplayedTextToNewSampleTypeName() {
		// given
		app.tables.cells.allElementsBoundByIndex[0].tap()

		// when
		app.pickerWheels["Activity"].adjust(toPickerWheelValue: "Heart Rate")
		app.buttons["save button"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Heart Rate"].exists)
	}

	func testChangingSubQuerySampleType_changesDisplayedTextToNewSampleTypeName() {
		// given
		addDataTypeToQuery()

		// when
		app.tables.cells.allElementsBoundByIndex[1].tap()
		app.pickerWheels["Activity"].adjust(toPickerWheelValue: "Body Mass Index")
		app.scrollViews.otherElements.buttons["save data type button"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Body Mass Index"].exists)
	}

	func testChangingSubQueryMatcher_changesDisplayedTextInTableViewCell() {
		// given
		addDataTypeToQuery()

		// when
		app.tables.cells.allElementsBoundByIndex[1].tap()
		app.pickerWheels["Start and end timestamps are the same as"].adjust(toPickerWheelValue: "Within <number> <time_unit>s of")
		app.switches.allElementsBoundByIndex[0].tap()
		app.scrollViews.otherElements.buttons["set time unit button"].tap()
		app.pickerWheels["Day"].adjust(toPickerWheelValue: "Hour")
		app.buttons["save button"].tap()
		app.scrollViews.otherElements.buttons["set number of time units button"].tap()
		app.textFields.containing(.button, identifier:"Clear text").element.tap()
		app.textFields.allElementsBoundByIndex[0].typeText("7")
		app.buttons["save button"].tap()
		app.scrollViews.otherElements.buttons["save data type button"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Within 57 hours of most recent"].exists)
	}

	func testChangingAttributeRestriction_changesDisplayedTextInTableViewCell() {
		// given
		app.tables.cells.allElementsBoundByIndex[0].tap()
		app.pickerWheels["Activity"].adjust(toPickerWheelValue: "Blood Pressure")
		app.buttons["save button"].tap()
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()

		// when
		app.tables.staticTexts["Diastolic blood pressure < 0.0"].tap()
		app.pickerWheels["Diastolic blood pressure"].adjust(toPickerWheelValue: "Timestamp")
		app.pickerWheels["Before date"].adjust(toPickerWheelValue: "After date")
		app.buttons["set date button"].tap()
		app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "June")
		app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "18")
		app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2012")
		app.buttons["save button"].tap()
		app.buttons["save attribute restriction button"].tap()

		// then
		XCTAssert(app.tables.staticTexts["After June 18, 2012"].exists)
	}

	// MARK: - Edit Attribute Restrictions Screen

	func testChangingRestrictedAttributeToAttributeOfSameType_doesNotChangeAttributeRestrictionValues() {
		// given
		let date = Date() - 1.days
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .none
		let dateText = dateFormatter.string(from: date)
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
		app.tables.cells.allElementsBoundByIndex[1].tap()
		setPicker("restricted attribute", to: "Start Date")
		app.buttons["set date button"].tap()
		setDatePicker(to: date)
		app.buttons["save button"].tap()

		// when
		setPicker("restricted attribute", to: "End Date")

		// then
		XCTAssertEqual(app.buttons["set date button"].value as? String, dateText)
	}

	func testChangingRestrictedAttributeToAttributeOfSameType_updatesAttributeRestrictionDescription() {
		// given
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
		app.tables.cells.allElementsBoundByIndex[1].tap()
		setPicker("restricted attribute", to: "Note")
		app.buttons["save attribute restriction button"].tap()

		// when
		app.tables.cells.allElementsBoundByIndex[1].tap()
		setPicker("restricted attribute", to: "Name")
		app.buttons["save attribute restriction button"].tap()

		// then
		XCTAssert(app.tables.cells.staticTexts["Name contains ''"].exists)
	}

	func testChangingAttributeRestrictionToRestrictionWithMatchingAttribute_keepsSameValueForThatAttribute() {
		// given
		let date = Date() - 1.days
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .none
		let dateText = dateFormatter.string(from: date)
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
		app.tables.cells.allElementsBoundByIndex[1].tap()
		setPicker("restricted attribute", to: "Start Date")
		app.buttons["set date button"].tap()
		setDatePicker(to: date)
		app.buttons["save button"].tap()

		// when
		setPicker("attribute restriction", to: "After date", changeCase: false)

		// then
		XCTAssertEqual(app.buttons["set date button"].value as? String, dateText)
	}

	// MARK: - Reordering

	func testMovingSampleTypeAboveAttributeRestriction_correctlyChangesAttributeRestriction() {
		// given
		addAttributeRestrictionToQuery()
		addDataTypeToQuery("Body Mass Index")

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

	func testMovingSubSampleTypeBelowChildAttributeRestriction_correctlyChangesAttributeRestriction() {
		// given
		addDataTypeToQuery("Body Mass Index")
		addAttributeRestrictionToQuery()

		// when
		app.tables.buttons["Edit"].tap()
		let attributeRestrictionReorderButton = app.buttons.containing(
			NSPredicate(format: "%K BEGINSWITH[cd] %@", "label", "reorder less than")
		).allElementsBoundByIndex[0]
		app.tables.buttons["Reorder Data Type"].press(forDuration: 0.5, thenDragTo: attributeRestrictionReorderButton)
		app.tables.buttons["Done"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Duration ≤ 0:00:00"].exists)
	}

	// MARK: - Deleting Parts

	func testDeletingDataTypeWithAttributeRestrictionsUnderneath_correctlyReassignsAttributeRestrictionsUnderneath() {
		// given
		addDataTypeToQuery("Body Mass Index")
		addAttributeRestrictionToQuery()

		// when
		app.tables.cells.allElementsBoundByIndex[1].swipeLeft()
		app.tables.buttons["🗑️"].tap()

		// then
		XCTAssert(app.tables.staticTexts["Duration ≤ 0:00:00"].exists)
	}

	// MARK: - Other

	func testPressingEditButton_changesTitleOfEditButtonToDone() {
		// when
		app.tables.buttons["Edit"].tap()

		// then
		XCTAssert(app.tables.buttons["Done"].exists)
	}
}
