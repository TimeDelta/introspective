//
//  RecordScreenUITests.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 10/19/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest

final class RecordScreenUITests: UITest {

	private typealias Me = RecordScreenUITests
	private static let minute = "15"
	private static let hour = "10"
	private static let month = "June"
	private static let day = "12"
	private static let year = "2012"

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
		let searchBar = app.searchFields["Search Medications"]
		searchBar.tap()
		searchBar.typeText(medicationName)
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
		let startedOn = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 5, of: Date())!
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

		let searchMedicationsField = app.searchFields["Search Medications"]
		searchMedicationsField.tap()
		searchMedicationsField.typeText(medicationName)

		// when
		app.tables.staticTexts[medicationName].swipeLeft()
		app.buttons["Delete"].tap()
		app.buttons["Yes"].tap()
		searchMedicationsField.buttons["Clear text"].tap()

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
		var dose1Date = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 5, of: Date())!
		dose1Date = Calendar.autoupdatingCurrent.date(byAdding: .month, value: -1, to: dose1Date)!
		let dose2Date = Calendar.autoupdatingCurrent.date(bySetting: .hour, value: 7, of: Date())!
		takeDoseOf(medicationName, at: dose1Date)
		takeDoseOf(medicationName, at: dose2Date)
		app.buttons["last \(medicationName) dose button"].tap()
		app.tables.buttons["Filter Dates"].tap()
		app.switches["from date switch"].tap()
		setDatePicker("from date picker", to: dose1Date)
		app.switches["to date switch"].tap()
		setDatePicker("to date picker", to: dose1Date)
		app.buttons["Save"].tap()
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

	private final func createMedication(
		name: String,
		frequency: (times: String, unit: String)? = nil,
		startedOn: Date? = nil,
		dosage: String? = nil,
		note: String? = nil)
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

		app.buttons["save medication button"].tap()
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

		app.buttons["save dosage button"].tap()
	}

	/// Assumes AM time
	private final func setDatePicker(_ queryString: String? = nil, to date: Date) {
		let datePickers = app.datePickers
		let datePickerWheels: XCUIElementQuery
		if let queryString = queryString {
			datePickerWheels = datePickers[queryString].pickerWheels
		} else {
			datePickerWheels = datePickers.pickerWheels
		}
		let dateStrings = convertDateToStringComponents(date)
		if datePickerWheels.count == 3 { // date only
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateStrings[.month]!)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateStrings[.day]!)
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.year]!)
		} else { // date and time
			let monthAndDayText = String(dateStrings[.month]!.prefix(3)) + " " + dateStrings[.day]!
			var hourText = dateStrings[.hour]!
			let hour = Int(hourText)!
			if hour > 12 {
				hourText = String(hour - 12)
			}
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: monthAndDayText)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: hourText)
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.minute]!)
			datePickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: dateStrings[.timeZone]!)
		}
	}

	private final func convertDateToStringComponents(_ date: Date) -> [Calendar.Component: String]{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		let month = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "YYYY"
		let year = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "d"
		let day = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "H"
		let hour = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "mm"
		let minute = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "a"
		let amPm = dateFormatter.string(from: date)

		return [.year: year, .month: month, .day: day, .hour: hour, .minute: minute, .timeZone: amPm]
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
