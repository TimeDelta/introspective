//
//  RecordScreenUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

final class RecordScreenUITests: UITest {

	private typealias Me = RecordScreenUITests
	private static let minute = "15"
	private static let hour = "10"
	private static let month = "June"
	private static let day = "12"
	private static let year = "2012"

	final override func tearDown() {
		app.tabBars.buttons["Settings"].tap()
		app.tables.buttons["delete core data button"].tap()
		super.tearDown()
	}

	func testRecordMood_resetsNoteAndMoodRating() {
		// when
		let ratingLabel = app.tables.staticTexts["3.5 / 7"]
		app.tables.sliders["50%"].press(forDuration: 0.5, thenDragTo: ratingLabel);

		app.tables.buttons["set mood note button"].tap()

		let noteField = app.textViews.allElementsBoundByIndex[0]
		noteField.tap()
		noteField.typeText("This is a note.")
		app.toolbars["Toolbar"].buttons["Done"].tap()

		app.tables.buttons["save mood button"].tap()

		// then
		XCTAssertEqual(app.tables.buttons["set mood note button"].value as? String, "Add Note")
		XCTAssert(app.tables.sliders["50%"].exists)
	}

	func testAddNewMedication_usesTextFromSearchBarAsInitialName() {
		// given
		let medicationName = "Adderall"

		// when
		app.tables.buttons["Medications"].tap()
		filterMedications(by: medicationName)
		app.tables.buttons["Add"].tap()

		// then
		XCTAssertEqual(app.textFields["medication name"].value as? String, medicationName)
	}

	func testCreatingMedication_showsInListOfMedicationsAfterSave() {
		// given
		let medicationName = "Adderall"

		// when
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)

		// then
		XCTAssert(app.tables.cells.staticTexts[medicationName].exists)
	}

	func testEditMedication_showsCorrectInformationWhenEditing() {
		// given
		let medicationName = "Adderall"
		let frequency = (times: "12", unit: "Month")
		let startedOn = Date()
		let dosage = "12 mg"
		let note = "Take every morning after eating breakfast otherwise it will give you an upset stomach."
		app.tables.buttons["Medications"].tap()
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

	func testDoseTaken_showsInMedicationDosesView() {
		// given
		let medicationName = "abjkdf"
		let dosage = "123 mg"
		let doseTakenDate = Date()
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName, dosage: dosage)
		takeDoseOf(medicationName, at: doseTakenDate)

		// when
		app.buttons["last \(medicationName) dose button"].tap()

		// then
		XCTAssert(app.tables.staticTexts[doseDescription(dosage: dosage, date: doseTakenDate)].exists)
	}

	func testDeletingMedicationWhileFiltering_removesCorrectMedicationFromTableView() {
		// given
		let medicationName = "afjsdo"
		let medicationName2 = "fjeowijhwioa"
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)
		createMedication(name: medicationName2)

		filterMedications(by: medicationName)

		// when
		app.tables.staticTexts[medicationName].swipeLeft()
		app.buttons["Delete"].tap()
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
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)
		var dose1Date = Date()
		dose1Date = dose1Date - 1.months
		let dose2Date = Date()
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: dose1Date, to: dose1Date)
		let dose = doseDescription(date: dose1Date)

		// when
		app.tables.staticTexts[dose].swipeLeft()
		app.tables.buttons["Delete"].tap()
		app.buttons["Yes"].tap()
		app.tables.buttons["filter dates button"].tap()
		app.switches["from date switch"].tap()
		app.switches["to date switch"].tap()
		app.buttons["Save"].tap()

		// then
		XCTAssert(!app.tables.staticTexts[dose].exists)
		XCTAssert(app.tables.staticTexts[doseDescription(date: dose2Date)].exists)
	}

	func testReorderWhileFiltering_correcltyReordersMedications() {
		// given
		let medication1Name = "fewqgre"
		let medication2Name = "fjor"
		let medication3Name = "\(medication1Name)fdsjkl"
		app.tables.buttons["Medications"].tap()
		createMedication(name: medication1Name)
		createMedication(name: medication2Name)
		createMedication(name: medication3Name)
		app.buttons["Edit"].tap()
		filterMedications(by: medication1Name)

		// when
		let medication3ReorderButton = app.tables.buttons["Reorder \(medication3Name)"]
		app.tables.buttons["Reorder \(medication1Name)"].press(forDuration: 0.5, thenDragTo: medication3ReorderButton)
		app.buttons["Cancel"].tap()

		// then
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication2Name].frame.maxY, app.tables.staticTexts[medication3Name].frame.minY)
		XCTAssertLessThanOrEqual(app.tables.staticTexts[medication3Name].frame.maxY, app.tables.staticTexts[medication1Name].frame.minY)
	}

	func testEditingMedicationName_updatesTableViewCellInMedicationsList() {
		// given
		let medicationName = "fgqr"
		let additionalCharacters = "greqg"
		let editedMedicationName = medicationName + additionalCharacters
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)

		// when
		app.tables.staticTexts[medicationName].tap()
		app.textFields["medication name"].tap()
		app.textFields["medication name"].typeText(additionalCharacters)
		tapCoordinate(x: 0, y: 70)
		app.buttons["save medication button"].tap()

		// then
		XCTAssert(!app.tables.staticTexts[medicationName].exists)
		XCTAssert(app.tables.staticTexts[editedMedicationName].exists)
	}

	func testClearingFrequencyOnNewMedicationScreen_updatesFrequencyButtonTitle() {
		// given
		let medicationName = "fdsag"
		let frequency = (times: "12", unit: "day")
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName, frequency: frequency, save: false)

		// when
		app.buttons["clear frequency button"].tap()

		// then
		XCTAssertEqual(app.buttons["set frequency button"].value as? String, "As needed")
	}

	func testClearingStartedOnDateOnNewMedicationScreen_updatesStartedOnButtonTitle() {
		// given
		let medicationName = "fdsag"
		let startedOn = Date()
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName, startedOn: startedOn, save: false)

		// when
		app.buttons["clear started on date button"].tap()

		// then
		XCTAssertEqual(app.buttons["set started on button"].value as? String, "Not set")
	}

	func testEditingDose_updatesDoseDescriptionInDoseList() {
		// given
		let medicationName = "fhiou"
		let originalDosage = "12 mg"
		let editedDosage = "342 cL"
		let originalDoseDate = Date()
		let editedDoseDate = originalDoseDate - 1.months
		app.tables.buttons["Medications"].tap()
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

	func testPressingPreviousDateRangeButtonOnDoseList_correctlyRefiltersDosesAndDisplaysCorrectDateRangeOnDateFilterButton() {
		// given
		let medicationName = "ghrui"
		let dose1Date = Date()
		let dose2Date = dose1Date - 2.weeks + 1.days
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: dose1Date - 1.weeks, to: dose1Date + 1.days)

		// when
		app.tables.buttons["<"].tap()

		// then
		let expectedMinDate = (dose1Date - 1.weeks) - (dose1Date + 1.days - (dose1Date - 1.weeks))
		let expectedMaxDate = (dose1Date + 1.days) - (dose1Date + 1.days - (dose1Date - 1.weeks))
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
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
		app.tables.buttons["Medications"].tap()
		createMedication(name: medicationName)
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		filterDoseDates(from: dose2Date - 1.days, to: dose2Date + 1.weeks)

		// when
		app.tables.buttons[">"].tap()

		// then
		let expectedMinDate = (dose2Date - 1.days) + (dose2Date + 1.weeks - (dose2Date - 1.days))
		let expectedMaxDate = (dose2Date + 1.weeks) + (dose2Date + 1.weeks - (dose2Date - 1.days))
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		let expectedMinDateString = dateFormatter.string(from: expectedMinDate)
		let expectedMaxDateString = dateFormatter.string(from: expectedMaxDate)
		let expectedDateFilterButtonTitle = "From " + expectedMinDateString + " to " + expectedMaxDateString
		XCTAssertEqual(app.tables.buttons["filter dates button"].value as? String, expectedDateFilterButtonTitle)

		XCTAssert(app.tables.staticTexts[doseDescription(date: dose1Date)].exists)
	}

	private final func createMedication(
		name: String,
		frequency: (times: String, unit: String)? = nil,
		startedOn: Date? = nil,
		dosage: String? = nil,
		note: String? = nil,
		save: Bool = true)
	{
		app.tables.buttons["Add"].tap()

		let nameField = app.textFields["medication name"]
		nameField.tap()
		nameField.typeText(name)

		if let frequency = frequency {
			app.buttons["set frequency button"].tap()
			let numberOfTimesField = app.textFields["number of times"]
			numberOfTimesField.tap()
			numberOfTimesField.typeText(frequency.times)
			app.pickerWheels["Day"].adjust(toPickerWheelValue: frequency.unit.capitalized)
			app.buttons["Save"].tap()
		}

		if let startedOn = startedOn {
			app.buttons["set started on button"].tap()
			setDatePicker(to: startedOn)
			app.buttons["Accept"].tap()
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

		tapCoordinate(x: 0, y: 70)

		if save {
			app.buttons["save medication button"].tap()
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
		app.tables.buttons["Filter Dates"].tap()
		setFromOrToDate("from", fromDate)
		setFromOrToDate("to", toDate)
		app.buttons["Save"].tap()
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
		let dateStrings = convertDateToStringComponents(date)
		let monthAndDayText = String(dateStrings[.month]!.prefix(3)) + " " + dateStrings[.day]!
		var dosageDescription = ""
		if let dosage = dosage {
			dosageDescription = "\(dosage) on "
		}
		dosageDescription += "\(monthAndDayText), \(dateStrings[.year]!) at \(dateStrings[.hour]!):\(dateStrings[.minute]!)"
		return dosageDescription
	}
}
