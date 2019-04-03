//
//  RecordMedicationsUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

final class RecordMedicationsUITests: UITest {

	private typealias Me = RecordMedicationsUITests
	private static let minute = "15"
	private static let hour = "10"
	private static let month = "June"
	private static let day = "12"
	private static let year = "2012"

	final override func setUp() {
		super.setUp()
		app.tabBars.buttons["Record"].tap()
		app.tables.cells.staticTexts["Medications"].tap()
		skipInstructionsIfPresent()
	}

	// MARK: - Creation

	func testAddNewMedication_usesTextFromSearchBarAsInitialName() {
		// given
		let medicationName = "Adderall"
		filterMedications(by: medicationName)

		// when
		app.buttons["Add"].tap()

		// then
		XCTAssertEqual(app.textFields["medication name"].value as? String, medicationName)
	}

	func testCreatingMedication_showsInListOfMedicationsAfterSave() {
		// given
		let medicationName = "Adderall"

		// when
		createMedication(name: medicationName)

		// then
		XCTAssert(app.tables.cells.staticTexts[medicationName].exists)
	}

	func testClearingFrequencyOnNewMedicationScreen_updatesFrequencyButtonTitle() {
		// given
		let medicationName = "fdsag"
		let frequency = (times: "12", unit: "day")
		createMedication(name: medicationName, frequency: frequency, save: false)

		// when
		app.buttons["clear frequency button"].tap()

		// then
		XCTAssertEqual(app.buttons["set frequency button"].value as? String, "As needed")
		app.buttons["Save"].tap() // keyboard is hiding the settings tab
	}

	func testClearingStartedOnDateOnNewMedicationScreen_updatesStartedOnButtonTitle() {
		// given
		let medicationName = "fdsag"
		let startedOn = Date()
		createMedication(name: medicationName, startedOn: startedOn, save: false)

		// when
		app.buttons["clear started on date button"].tap()

		// then
		XCTAssertEqual(app.buttons["set started on button"].value as? String, "Not set")
		app.buttons["Save"].tap() // keyboard is hiding the settings tab
	}

	func testSettingNameToNameOfOtherMedicationOnNewMedicationScreen_disablesSaveButton() {
		// given
		let medicationName = "grenqjik"
		createMedication(name: medicationName)

		// when
		createMedication(name: medicationName, save: false)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
		app.navigationBars.buttons["Medications"].tap() // keyboard is hiding the settings tab
	}

	// MARK: - Editing

	func testEditMedication_showsCorrectInformationWhenEditing() {
		// given
		let medicationName = "Adderall"
		let frequency = (times: "12", unit: "Month")
		let startedOn = Date()
		let dosage = "12 mg"
		let note = "Take every morning after eating breakfast otherwise it will give you an upset stomach."
		createMedication(name: medicationName, frequency: frequency, startedOn: startedOn, dosage: dosage, note: note)

		// when
		app.tables.staticTexts[medicationName].tap()

		// then
		let dateStrings = convertDateToStringComponents(startedOn)
		XCTAssertEqual(app.textFields["medication name"].value as? String, medicationName)
		XCTAssertEqual(app.buttons["set frequency button"].value as? String, "12 times per month")
		XCTAssertEqual(app.buttons["set started on button"].value as? String, dateStrings[.month]! + " " + dateStrings[.day]! + ", " + dateStrings[.year]!)
		XCTAssertEqual(app.textFields["medication dosage"].value as? String, dosage)
		XCTAssertEqual(app.textViews["notes"].value as? String, note)
	}

	func testEditingMedicationName_updatesTableViewCellInMedicationsList() {
		// given
		let medicationName = "fgqr"
		let additionalCharacters = "greqg"
		let editedMedicationName = medicationName + additionalCharacters
		createMedication(name: medicationName)

		// when
		app.tables.staticTexts[medicationName].tap()
		app.textFields["medication name"].tap()
		app.textFields["medication name"].typeText(additionalCharacters)
		app.buttons["Save"].tap()

		// then
		XCTAssert(!app.tables.staticTexts[medicationName].exists)
		XCTAssert(app.tables.staticTexts[editedMedicationName].exists)
	}

	func testSettingNameToOriginalNameOfMedicationWithDifferentCase_doesNotDisableSaveButton() {
		// given
		let medicationName = "gterq"
		createMedication(name: medicationName)

		// when
		app.tables.staticTexts[medicationName].tap()
		setTextFor(field: app.textFields["medication name"], to: medicationName.localizedUppercase)

		// then
		XCTAssert(app.buttons["Save"].isEnabled)
		app.buttons["Save"].tap() // keyboard is hiding the settings tab
	}

	func testEditingDose_updatesDoseDescriptionInDoseList() {
		// given
		let medicationName = "fhiou"
		let originalDosage = "12 mg"
		let editedDosage = "342 cL"
		let originalDoseDate = Date()
		let editedDoseDate = originalDoseDate - 1.months
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: originalDoseDate, dosage: originalDosage)
		app.buttons["last \(medicationName) dose button"].tap()

		// when
		let originalDoseDescription = doseDescription(dosage: originalDosage, date: originalDoseDate)
		app.tables.staticTexts[originalDoseDescription].tap()
		let dosageTextField = app.textFields["dosage taken text field"]
		let clearTextButton = dosageTextField.buttons["Clear text"]
		if clearTextButton.exists {
			clearTextButton.tap()
		}
		dosageTextField.tap()
		dosageTextField.typeText(editedDosage)
		setDatePicker(to: editedDoseDate)
		app.buttons["save dose button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[doseDescription(dosage: editedDosage, date: editedDoseDate)].exists)
		XCTAssert(!app.tables.staticTexts[originalDoseDescription].exists)
	}

	// MARK: - Taking Doses

	func testDoseTaken_showsInMedicationDosesView() {
		// given
		let medicationName = "abjkdf"
		let dosage = "123 mg"
		let doseTakenDate = Date()
		createMedication(name: medicationName, dosage: dosage)
		takeDoseOf(medicationName, at: doseTakenDate)

		// when
		app.buttons["last \(medicationName) dose button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[doseDescription(dosage: dosage, date: doseTakenDate)].exists)
	}

	// MARK - Deletion

	func testDeletingMedicationWhileFiltering_removesCorrectMedicationFromTableView() {
		// given
		let medicationName = "afjsdo"
		let medicationName2 = "fjeowijhwioa"
		createMedication(name: medicationName)
		createMedication(name: medicationName2)

		filterMedications(by: medicationName)

		// when
		app.tables.staticTexts[medicationName].swipeLeft()
		app.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()
		app.searchFields["Search Medications"].buttons["Clear text"].tap()

		// then
		app.buttons["Cancel"].tap()
		XCTAssert(!app.tables.cells.staticTexts[medicationName].exists)
		XCTAssert(app.tables.cells.staticTexts[medicationName2].exists)
	}

	func testDeletingDoseWhileFiltering_removesCorrectDoseFromTableView() {
		// given
		let medicationName = "few"
		createMedication(name: medicationName)
		let dose1Date = Date() - 1.months
		let dose2Date = Date()
		let dose3Date = Date() - 1.minutes
		let dose4Date = Date() - 2.minutes
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		takeDoseOf(medicationName, at: dose3Date)
		takeDoseOf(medicationName, at: dose4Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: dose2Date, to: dose4Date)
		let dose3Description = doseDescription(date: dose3Date)

		// when
		app.tables.staticTexts[dose3Description].swipeLeft()
		app.tables.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()
		XCTAssertEqual(app.alerts.allElementsBoundByIndex.count, 0, "Failed to delete dose")
		filterDoseDates()

		// then
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose2Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose3Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose4Date)].exists)
		// Go back then open up the doses view again and recheck assertions in order
		// to make sure that changes actually persisted. Do this before AND after to
		// make sure that the user is shown that the dose is deleted immediately also.
		// This specifically guards against a bug that was found where the dose was
		// deleted but the UI wasn't updated because an error was thrown.
		app.navigationBars.buttons["Medications"].tap()
		app.buttons["last \(medicationName) dose button"].tap()
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose2Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose3Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose4Date)].exists)
	}

	func testDeletingDoseWhileNotFiltering_removesCorrectDoseFromTableView() {
		// given
		let medicationName = "few"
		createMedication(name: medicationName)
		let dose1Date = Date()
		let dose2Date = Date() - 1.days
		let dose3Date = Date() - 2.days
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		takeDoseOf(medicationName, at: dose3Date)
		app.buttons["last \(medicationName) dose button"].tap()
		let dose2Description = doseDescription(date: dose2Date)

		// when
		app.tables.staticTexts[dose2Description].swipeLeft()
		app.tables.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()

		// then
		XCTAssertEqual(app.alerts.allElementsBoundByIndex.count, 0, "Failed to delete dose")
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose2Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose3Date)].exists)
		// Go back then open up the doses view again and recheck assertions in order
		// to make sure that changes actually persisted. Do this before AND after to
		// make sure that the user is shown that the dose is deleted immediately also.
		// This specifically guards against a bug that was found where the dose was
		// deleted but the UI wasn't updated because an error was thrown.
		app.navigationBars.buttons["Medications"].tap()
		app.buttons["last \(medicationName) dose button"].tap()
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose2Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose3Date)].exists)
	}

	// MARK: - Reordering

	func testReorderWhileFiltering_correcltyReordersMedications() {
		// given
		let filterString = "filter string"
		let medication1Name = filterString
		let medication2Name = "fjor"
		let medication3Name = "\(filterString)fdsjkl"
		let medication4Name = "gteqrfwds\(filterString)"
		createMedication(name: medication1Name)
		createMedication(name: medication2Name)
		createMedication(name: medication3Name)
		createMedication(name: medication4Name)
		filterMedications(by: filterString)

		// when
		var medication1Cell = app.tables.cells.staticTexts[medication1Name]
		var medication3Cell = app.tables.cells.staticTexts[medication3Name]
		medication1Cell.press(forDuration: 0.5, thenDragTo: medication3Cell)
		app.buttons["Cancel"].tap()

		// then
		medication1Cell = app.tables.cells.staticTexts[medication1Name]
		medication3Cell = app.tables.cells.staticTexts[medication3Name]
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication2Name].frame.maxY, app.tables.staticTexts[medication3Name].frame.minY)
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication3Name].frame.maxY, app.tables.staticTexts[medication1Name].frame.minY)
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication1Name].frame.maxY, app.tables.staticTexts[medication4Name].frame.minY)
	}

	// MARK: - Dose History

	func testPressingPreviousDateRangeButtonOnDoseList_correctlyRefiltersDosesAndDisplaysCorrectDateRangeOnDateFilterButton() {
		// given
		let medicationName = "ghrui"
		let dose1Date = Date()
		let dose2Date = dose1Date - 2.weeks + 1.days
		let filterRange = 8.days
		let filterStart = dose1Date - 1.weeks
		let filterEnd = filterStart + filterRange
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: filterStart, to: filterEnd)

		// when
		app.tables.buttons["<"].tap()

		// then
		let expectedMinDate = filterStart - filterRange
		let expectedMaxDate = filterEnd - filterRange
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .none
		dateFormatter.timeZone = TimeZone.autoupdatingCurrent
		let expectedMinDateString = dateFormatter.string(from: expectedMinDate)
		let expectedMaxDateString = dateFormatter.string(from: expectedMaxDate)
		let expectedDateFilterButtonTitle = "From " + expectedMinDateString + " to " + expectedMaxDateString
		XCTAssertEqual(app.tables.buttons["filter dates button"].value as? String, expectedDateFilterButtonTitle)

		XCTAssert(app.tables.staticTexts[doseDescription(date: dose2Date)].exists)
	}

	func testPressingNextDateRangeButtonOnDoseList_correctlyRefiltersDosesAndDisplaysCorrectDateRangeOnDateFilterButton() {
		// given
		let medicationName = "ghrui"
		let dose1Date = Date()
		let dose2Date = dose1Date - 2.weeks
		let filterRange = 10.days
		let filterStart = dose1Date - 1.weeks
		let filterEnd = filterStart + filterRange
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: dose2Date - 1.days, to: dose2Date + 1.weeks)

		// when
		app.tables.buttons[">"].tap()

		// then
		let expectedMinDate = filterStart + filterRange
		let expectedMaxDate = filterEnd + filterRange
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		let expectedMinDateString = dateFormatter.string(from: expectedMinDate)
		let expectedMaxDateString = dateFormatter.string(from: expectedMaxDate)
		let expectedDateFilterButtonTitle = "From " + expectedMinDateString + " to " + expectedMaxDateString
		XCTAssertEqual(app.tables.buttons["filter dates button"].value as? String, expectedDateFilterButtonTitle)

		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
	}

	func testSettingFromDateAfterToDate_doesNotAllowSavingFilter() {
		// given
		let medicationName = "ghrui"
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: Date())
		app.buttons["last \(medicationName) dose button"].tap()
		app.tables.buttons["filter dates button"].tap()

		// when
		setFromOrToDate("from", Date())
		setFromOrToDate("to", Date() - 1.days)

		// then
		XCTAssertFalse(app.buttons["save button"].isEnabled)
	}

	func testSettingFromDateAfterToDateThenDisablingToDate_allowsSavingFilter() {
		// given
		let medicationName = "ghrui"
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: Date())
		app.buttons["last \(medicationName) dose button"].tap()
		app.tables.buttons["filter dates button"].tap()

		// when
		setFromOrToDate("from", Date())
		setFromOrToDate("to", Date() - 1.days)
		setFromOrToDate("to", nil)

		// then
		XCTAssert(app.buttons["save button"].isEnabled)
	}

	// MARK: - Helper Functions

	private final func createMedication(
		name: String,
		frequency: (times: String, unit: String)? = nil,
		startedOn: Date? = nil,
		dosage: String? = nil,
		note: String? = nil,
		save: Bool = true)
	{
		app.buttons["Add"].tap()

		let nameField = app.textFields["medication name"]
		nameField.tap()
		nameField.typeText(name)

		if let frequency = frequency {
			app.buttons["set frequency button"].tap()
			let numberOfTimesField = app.textFields["number of times"]
			numberOfTimesField.tap()
			numberOfTimesField.typeText(frequency.times)
			app.pickerWheels["Day"].adjust(toPickerWheelValue: frequency.unit.capitalized)
			app.buttons["save button"].tap()
		}

		if let startedOn = startedOn {
			app.buttons["set started on button"].tap()
			setDatePicker(to: startedOn)
			app.buttons["save button"].tap()
		}

		if let dosage = dosage {
			let dosageField = app.textFields["medication dosage"]
			dosageField.tap()
			dosageField.typeText(dosage)
		}

		if let note = note {
			app.textViews["notes"].tap()
			app.textViews["notes"].typeText(note)
		}

		if save {
			app.buttons["Save"].tap()
		}
	}

	private final func takeDoseOf(_ medicationName: String, at date: Date, dosage: String? = nil) {
		app.buttons["take \(medicationName) button"].tap()

		setDatePicker(to: date)

		if let dosage = dosage {
			let dosageTextField = app.textFields["dosage taken text field"]
			let clearTextButton = dosageTextField.buttons["Clear text"]
			if clearTextButton.exists {
				clearTextButton.tap()
			}
			dosageTextField.tap()
			dosageTextField.typeText(dosage)
		}

		app.buttons["save dose button"].tap()
	}

	private final func filterDoseDates(from fromDate: Date? = nil, to toDate: Date? = nil) {
		app.tables.buttons["filter dates button"].tap()
		setFromOrToDate("from", fromDate)
		setFromOrToDate("to", toDate)
		app.buttons["save button"].tap()
	}

	private final func setFromOrToDate(_ fromOrTo: String, _ date: Date?) {
		let currentSwitchState = app.switches[fromOrTo + " date switch"].value as? String == "1"
		let dateShouldExist = date != nil
		if currentSwitchState != dateShouldExist {
			app.switches[fromOrTo + " date switch"].tap()
		}
		if let date = date {
			setDatePicker(fromOrTo + " date picker", to: date)
		}
	}

	private final func filterMedications(by searchText: String) {
		let searchMedicationsField = app.searchFields["Search Medications"]
		searchMedicationsField.tap()
		searchMedicationsField.typeText(searchText)
	}

	private final func doseDescription(dosage: String? = nil, date: Date) -> String {
		var dosageDescription = ""
		if let dosage = dosage {
			dosageDescription = "\(dosage) on "
		}
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dosageDescription += dateFormatter.string(from: date)
		return dosageDescription
	}
}
