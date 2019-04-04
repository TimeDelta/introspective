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
		let medication = Medication("Adderall")

		// when
		createMedication(medication)

		// then
		XCTAssert(app.tables.cells.staticTexts[medication.name].exists)
	}

	func testClearingFrequencyOnNewMedicationScreen_updatesFrequencyButtonTitle() {
		// given
		let medication = Medication("fdsag", frequency: (times: "12", unit: "day"))
		createMedication(medication, save: false)

		// when
		app.buttons["clear frequency button"].tap()

		// then
		XCTAssertEqual(app.buttons["set frequency button"].value as? String, "As needed")
	}

	func testClearingStartedOnDateOnNewMedicationScreen_updatesStartedOnButtonTitle() {
		// given
		let medication = Medication("fdsag", startedOn: Date())
		createMedication(medication, save: false)

		// when
		app.buttons["clear started on date button"].tap()

		// then
		XCTAssertEqual(app.buttons["set started on button"].value as? String, "Not set")
	}

	func testSettingNameToNameOfOtherMedicationOnNewMedicationScreen_disablesSaveButton() {
		// given
		let medication = Medication("grenqjik")
		createMedication(medication)

		// when
		createMedication(medication, save: false)

		// then
		XCTAssert(!app.buttons["Save"].isEnabled)
	}

	// MARK: - Editing

	func testEditMedication_showsCorrectInformationWhenEditing() {
		// given
		let medication = Medication(
			"Adderall",
			frequency: (times: "12", unit: "Month"),
			startedOn: Date(),
			dosage: "12 mg",
			note: "Take every morning after eating breakfast otherwise it will give you an upset stomach.")
		createMedication(medication)

		// when
		app.tables.staticTexts[medication.name].tap()

		// then
		let dateStrings = convertDateToStringComponents(medication.startedOn!)
		XCTAssertEqual(app.textFields["medication name"].value as? String, medication.name)
		XCTAssertEqual(app.buttons["set frequency button"].value as? String, "12 times per month")
		XCTAssertEqual(app.buttons["set started on button"].value as? String, dateStrings[.month]! + " " + dateStrings[.day]! + ", " + dateStrings[.year]!)
		XCTAssertEqual(app.textFields["medication dosage"].value as? String, medication.dosage)
		XCTAssertEqual(app.textViews["notes"].value as? String, medication.note)
	}

	func testEditingMedicationName_updatesTableViewCellInMedicationsList() {
		// given
		let medication = Medication("fgqr")
		let additionalCharacters = "greqg"
		let editedMedicationName = medication.name + additionalCharacters
		createMedication(medication)

		// when
		app.tables.staticTexts[medication.name].tap()
		app.textFields["medication name"].tap()
		app.textFields["medication name"].typeText(additionalCharacters)
		app.buttons["Save"].tap()

		// then
		XCTAssert(!app.tables.staticTexts[medication.name].exists)
		XCTAssert(app.tables.staticTexts[editedMedicationName].exists)
	}

	func testSettingNameToOriginalNameOfMedicationWithDifferentCase_doesNotDisableSaveButton() {
		// given
		let medication = Medication("gterq")
		createMedication(medication)

		// when
		app.tables.staticTexts[medication.name].tap()
		setTextFor(field: app.textFields["medication name"], to: medication.name.localizedUppercase)

		// then
		XCTAssert(app.buttons["Save"].isEnabled)
	}

	func testEditingDose_updatesDoseDescriptionInDoseList() {
		// given
		let medication = Medication("fhiou")
		let originalDosage = "12 mg"
		let editedDosage = "342 cL"
		let originalDoseDate = Date()
		let editedDoseDate = originalDoseDate - 1.months
		createMedication(medication)
		takeDoseOf(medication, at: originalDoseDate, dosage: originalDosage)
		app.buttons["last \(medication.name) dose button"].tap()

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
		let medication = Medication("abjkdf", dosage: "123 mg")
		let doseTakenDate = Date()
		createMedication(medication)
		takeDoseOf(medication, at: doseTakenDate)

		// when
		app.buttons["last \(medication.name) dose button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[doseDescription(dosage: medication.dosage, date: doseTakenDate)].exists)
	}

	// MARK - Deletion

	func testDeletingMedicationWhileFiltering_removesCorrectMedicationFromTableView() {
		// given
		let medication1 = Medication("afjsdo")
		let medication2 = Medication("fjeowijhwioa")
		createMedication(medication1)
		createMedication(medication2)

		filterMedications(by: medication1.name)

		// when
		app.tables.staticTexts[medication1.name].swipeLeft()
		app.buttons["🗑️"].tap()
		app.buttons["Yes"].tap()
		app.searchFields["Search Medications"].buttons["Clear text"].tap()

		// then
		app.buttons["Cancel"].tap()
		XCTAssert(!app.tables.cells.staticTexts[medication1.name].exists)
		XCTAssert(app.tables.cells.staticTexts[medication2.name].exists)
	}

	func testDeletingDoseWhileFiltering_removesCorrectDoseFromTableView() {
		// given
		let medication = Medication("few")
		createMedication(medication)
		let dose1Date = Date() - 1.months
		let dose2Date = Date()
		let dose3Date = Date() - 1.minutes
		let dose4Date = Date() - 2.minutes
		takeDoseOf(medication, at: dose1Date)
		takeDoseOf(medication, at: dose2Date)
		takeDoseOf(medication, at: dose3Date)
		takeDoseOf(medication, at: dose4Date)
		app.buttons["last \(medication.name) dose button"].tap()
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
		app.buttons["last \(medication.name) dose button"].tap()
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose2Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose3Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose4Date)].exists)
	}

	func testDeletingDoseWhileNotFiltering_removesCorrectDoseFromTableView() {
		// given
		let medication = Medication("few")
		createMedication(medication)
		let dose1Date = Date()
		let dose2Date = Date() - 1.days
		let dose3Date = Date() - 2.days
		takeDoseOf(medication, at: dose1Date)
		takeDoseOf(medication, at: dose2Date)
		takeDoseOf(medication, at: dose3Date)
		app.buttons["last \(medication.name) dose button"].tap()
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
		app.buttons["last \(medication.name) dose button"].tap()
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
		XCTAssert(!app.tables.staticTexts[dose2Description].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose3Date)].exists)
	}

	// MARK: - Reordering

	func testReorderWhileFiltering_correcltyReordersMedications() {
		// given
		let filterString = "filter string"
		let medication1 = Medication(filterString)
		let medication2 = Medication("fjor")
		let medication3 = Medication("\(filterString)fdsjkl")
		let medication4 = Medication("gteqrfwds\(filterString)")
		createMedication(medication1)
		createMedication(medication2)
		createMedication(medication3)
		createMedication(medication4)
		filterMedications(by: filterString)

		// when
		var medication1Cell = app.tables.cells.staticTexts[medication1.name]
		var medication3Cell = app.tables.cells.staticTexts[medication3.name]
		medication1Cell.press(forDuration: 0.5, thenDragTo: medication3Cell)
		app.buttons["Cancel"].tap()

		// then
		medication1Cell = app.tables.cells.staticTexts[medication1.name]
		medication3Cell = app.tables.cells.staticTexts[medication3.name]
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication2.name].frame.maxY, app.tables.staticTexts[medication3.name].frame.minY)
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication3.name].frame.maxY, app.tables.staticTexts[medication1.name].frame.minY)
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication1.name].frame.maxY, app.tables.staticTexts[medication4.name].frame.minY)
	}

	// MARK: - Dose History

	func testPressingPreviousDateRangeButtonOnDoseList_correctlyRefiltersDosesAndDisplaysCorrectDateRangeOnDateFilterButton() {
		// given
		let medication = Medication("ghrui")
		let dose1Date = Date()
		let dose2Date = dose1Date - 2.weeks + 1.days
		let filterRange = 8.days
		let filterStart = dose1Date - 1.weeks
		let filterEnd = filterStart + filterRange
		createMedication(medication)
		takeDoseOf(medication, at: dose1Date)
		takeDoseOf(medication, at: dose2Date)
		app.buttons["last \(medication.name) dose button"].tap()
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
		let medication = Medication("ghrui")
		let dose1Date = Date()
		let dose2Date = dose1Date - 2.weeks
		let filterRange = 10.days
		let filterStart = dose1Date - 1.weeks
		let filterEnd = filterStart + filterRange
		createMedication(medication)
		takeDoseOf(medication, at: dose1Date)
		takeDoseOf(medication, at: dose2Date)
		app.buttons["last \(medication.name) dose button"].tap()
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
		let medication = Medication("ghrui")
		createMedication(medication)
		takeDoseOf(medication, at: Date())
		app.buttons["last \(medication.name) dose button"].tap()
		app.tables.buttons["filter dates button"].tap()

		// when
		setFromOrToDate("from", Date())
		setFromOrToDate("to", Date() - 1.days)

		// then
		XCTAssertFalse(app.buttons["save button"].isEnabled)
	}

	func testSettingFromDateAfterToDateThenDisablingToDate_allowsSavingFilter() {
		// given
		let medication = Medication("ghrui")
		createMedication(medication)
		takeDoseOf(medication, at: Date())
		app.buttons["last \(medication.name) dose button"].tap()
		app.tables.buttons["filter dates button"].tap()

		// when
		setFromOrToDate("from", Date())
		setFromOrToDate("to", Date() - 1.days)
		setFromOrToDate("to", nil)

		// then
		XCTAssert(app.buttons["save button"].isEnabled)
	}

	// MARK: - Helper Functions

	private final func takeDoseOf(_ medication: Medication, at date: Date, dosage: String? = nil) {
		app.buttons["take \(medication.name) button"].tap()

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
