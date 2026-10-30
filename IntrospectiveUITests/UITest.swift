//
//  UITest.swift
//  IntrospectiveUITests
//
//  Created by Bryan Nova on 6/28/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate

class UITest: XCTestCase {

	// MARK: - Set up / tear down

	private var application: XCUIApplication!
	private var hasLaunched = false
	final var app: XCUIApplication {
		if !hasLaunched { launchApp() }
		return application
	}

	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		application = XCUIApplication()
		application.launchArguments.append("--ui-testing")
		hasLaunched = false
	}

	/// Each case still launches once into its own clean SQLite database. A test can
	/// supply its starting records before the first UI interaction triggers launch.
	final func launchApp(fixtures: UITestFixtures = UITestFixtures(), file: StaticString = #file, line: UInt = #line) {
		guard !hasLaunched else {
			XCTFail("Fixtures must be configured before the first UI interaction", file: file, line: line)
			return
		}
		do {
			application.launchEnvironment[UITestFixtures.environmentKey] = try fixtures.encoded()
		} catch {
			XCTFail("Could not encode UI fixtures: \(error)", file: file, line: line)
			return
		}
		let launchStarted = ProcessInfo.processInfo.systemUptime
		application.launch()
		hasLaunched = true
		print("CI_UI_LAUNCH_SECONDS \(ProcessInfo.processInfo.systemUptime - launchStarted)")
		openInitialScreen()
	}

	/// Override navigation, rather than setUp(), to allow pre-launch fixture setup.
	func openInitialScreen() {}

	final func seed(activityDefinitions: [ActivityDefinition] = [], activities: [UITestFixtures.Activity] = [],
		medications: [Medication] = [], doses: [UITestFixtures.Dose] = [], moods: [Mood] = [],
		file: StaticString = #file, line: UInt = #line) {
		launchApp(fixtures: UITestFixtures(activityDefinitions: activityDefinitions, activities: activities,
			medications: medications, doses: doses, moods: moods), file: file, line: line)
	}

	// MARK: - Instructions Helpers

	enum InstructionScreen: Hashable {
		case query, activities, medications, date
	}

	// The app persists tutorial completion across launch(), even though each case
	// gets a fresh database. Check each context once even if a previous runner
	// already dismissed it; workers use isolated app containers and runner processes.
	private static var checkedInstructionScreens = Set<InstructionScreen>()

	final func skipInstructionsIfPresent(_ screen: InstructionScreen) {
		let skipInstructionsButton = app.buttons["skip instructions"]
		var present = skipInstructionsButton.exists
		if !present && !UITest.checkedInstructionScreens.contains(screen) {
			let waitStarted = ProcessInfo.processInfo.systemUptime
			present = skipInstructionsButton.waitForExistence(timeout: 1)
			print("CI_UI_INSTRUCTION_WAIT_SECONDS \(ProcessInfo.processInfo.systemUptime - waitStarted)")
		}
		UITest.checkedInstructionScreens.insert(screen)
		if present {
			skipInstructionsButton.tap()
		}
	}

	// MARK: - Generic UI Helpers

	@discardableResult
	final func waitForElement(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
		// XCTest polls after a delay even when the control is already on screen.
		// Keep the full wait available for controls that are still loading.
		return element.exists || element.waitForExistence(timeout: timeout)
	}

	final func waitForValue(_ value: String, of element: XCUIElement, timeout: TimeInterval = 5,
		file: StaticString = #file, line: UInt = #line) {
		let predicate = NSPredicate(format: "exists == true AND value == %@", value)
		if !predicate.evaluate(with: element) {
			let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
			XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), .completed,
				"Expected value \(value), got \(element.value ?? "missing")", file: file, line: line)
		}
	}

	final func waitForCount(_ count: Int, in elements: XCUIElementQuery, timeout: TimeInterval = 5,
		file: StaticString = #file, line: UInt = #line) {
		if elements.count != count {
			let expectation = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in elements.count == count }, object: nil)
			XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: timeout), .completed,
				"Expected \(count) elements, got \(elements.count)", file: file, line: line)
		}
	}

	final func tapCoordinate(x: Double, y: Double) {
		let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
		let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
		coordinate.tap()
	}

	final func tapIfExists(_ element: XCUIElement) {
		if element.exists {
			element.tap()
		}
	}

	// MARK: - Go To Screen Helpers

	final func openActivitiesScreen() {
		goToTabIfNotSelected("Record")
		if !app.tables["recordActivities"].exists {
			guard tapRecordRow("Activities") else { return }
		}
		skipInstructionsIfPresent(.activities)
		XCTAssertTrue(waitForElement(app.tables["recordActivities"]), "Activity list did not appear")
	}

	final func openMedicationsScreen() {
		goToTabIfNotSelected("Record")
		if !app.tables["recordMedications"].exists {
			guard tapRecordRow("Medications") else { return }
		}
		skipInstructionsIfPresent(.medications)
		XCTAssertTrue(waitForElement(app.tables["recordMedications"]), "Medication list did not appear")
	}

	private func tapRecordRow(_ title: String) -> Bool {
		let row = app.tables.cells.containing(.staticText, identifier: title).firstMatch
		guard waitForElement(row) else {
			XCTFail("Record row did not appear: \(title)")
			return false
		}
		// The Activities row can sit below the mood/pain/fatigue controls.
		// Tapping its off-screen label produced a (-1, -1) hit point in CI.
		for _ in 0..<3 {
			if row.isHittable { break }
			app.tables.firstMatch.swipeUp()
		}
		guard row.isHittable else {
			XCTFail("Record row could not be scrolled into view: \(title)")
			return false
		}
		row.tap()
		return true
	}

	final func goToQueryScreen() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		skipInstructionsIfPresent(.query)
		XCTAssertTrue(waitForElement(app.tables["queryBuilder"]), "Query builder did not appear")
	}

	final func goToTabIfNotSelected(_ tabName: String) {
		if !app.tabBars.buttons[tabName].isSelected {
			app.tabBars.buttons[tabName].tap()
		}
	}

	// MARK: - Picker Helpers

	final func setPicker(_ pickerQueryText: String? = nil, to value: String, changeCase: Bool = true) {
		let pickers = app.pickers
		var value = value
		if changeCase {
			value = value.localizedCapitalized
		}
		if let pickerQueryText = pickerQueryText {
			let pickerWheels = pickers[pickerQueryText].pickerWheels.allElementsBoundByIndex
			if pickerWheels.count < 1 {
				XCTFail("No pickers matching given query text found")
			} else {
				pickerWheels[0].adjust(toPickerWheelValue: value)
			}
		} else {
			let pickerWheels = pickers.pickerWheels.allElementsBoundByIndex
			if pickerWheels.count < 1 {
				XCTFail("No pickers detected")
			} else {
				pickerWheels[0].adjust(toPickerWheelValue: value)
			}
		}
	}

	final func setDatePicker(_ queryString: String? = nil, to date: Date) {
		skipInstructionsIfPresent(.date)
		// UIKit exposes date-and-time wheels without a DatePicker ancestor on some
		// simulator versions. Keep named range pickers scoped by identifier regardless
		// of their accessibility element type; the single-picker editor needs no scope.
		let datePickerWheels: XCUIElementQuery
		if let identifier = queryString {
			datePickerWheels = app.descendants(matching: .any).matching(identifier: identifier).firstMatch.pickerWheels
		} else {
			let scopedWheels = app.datePickers.firstMatch.pickerWheels
			// Attribute editors also contain ordinary wheels behind the date modal.
			// Prefer the DatePicker scope whenever UIKit exposes it.
			datePickerWheels = scopedWheels.firstMatch.exists ? scopedWheels : app.pickerWheels
		}
		guard waitForElement(datePickerWheels.firstMatch) else {
			let hierarchy = XCTAttachment(string: app.debugDescription)
			hierarchy.name = "Missing date picker accessibility hierarchy"
			hierarchy.lifetime = .keepAlways
			add(hierarchy)
			XCTFail("Date picker wheels did not appear")
			return
		}
		guard [3, 4].contains(datePickerWheels.count) else {
			XCTFail("Unexpected date picker wheel count: \(datePickerWheels.count)")
			return
		}
		let dateStrings = convertDateToStringComponents(date)
		if datePickerWheels.count == 3 { // date only
			// changing the order of these can break things when the date picker has a min / max date. make sure to run all UI tests if doing so
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.year]!)
			datePickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateStrings[.month]!)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateStrings[.day]!)
		} else { // date and time
			let formatter = DateFormatter()
			formatter.dateFormat = "MMM d"
			let monthAndDayText = formatter.string(from: date)
			formatter.dateFormat = "MMM"
			let monthText = formatter.string(from: date)
			var hourText = dateStrings[.hour]!
			let hour = Int(hourText)!
			hourText = String(hour % 12 == 0 ? 12 : hour % 12)
			let dayWheel = datePickerWheels.element(boundBy: 0)
			dayWheel.adjust(toPickerWheelValue: monthAndDayText)
			// Choose AM/PM before the hour. A valid morning target can otherwise
			// be clamped as a future evening time by a maximum-date constraint.
			datePickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: dateStrings[.timeZone]!)
			datePickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: hourText)
			datePickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateStrings[.minute]!)
			// The hour wheel carries AM/PM when scrolling across 12 (for example,
			// 1 AM -> 12 selects noon). Keep the initial period selection above
			// for constrained dates, then correct any carry after setting the time.
			let periodWheel = datePickerWheels.element(boundBy: 3)
			if !(periodWheel.value as? String ?? "").localizedCaseInsensitiveContains(dateStrings[.timeZone]!) {
				periodWheel.adjust(toPickerWheelValue: dateStrings[.timeZone]!)
			}
			// Wheel scrolling can carry the date across midnight while changing
			// the hour or AM/PM. Finish on the requested calendar day, after time
			// changes, and check every selected component before allowing Save.
			let numbers: (String) -> [Int] = { value in
				value.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
			}
			let matchesDay: (String) -> Bool = { value in
				let calendar = Calendar.autoupdatingCurrent
				switch value.lowercased() {
				case "today": return calendar.isDateInToday(date)
				case "yesterday": return calendar.isDateInYesterday(date)
				case "tomorrow": return calendar.isDateInTomorrow(date)
				default:
					return value.localizedCaseInsensitiveContains(monthText) && numbers(value).contains(Int(dateStrings[.day]!)!)
				}
			}
			if !matchesDay(dayWheel.value as? String ?? "") {
				dayWheel.adjust(toPickerWheelValue: monthAndDayText)
			}
			let selected = datePickerWheels.allElementsBoundByIndex.map { $0.value as? String ?? "" }
			print("CI_UI_DATE_SELECTION expected=\(date) wheels=\(selected)")
			guard selected.count == 4 else {
				XCTFail("Date picker changed its wheel count during editing: \(selected)")
				return
			}
			XCTAssertTrue(matchesDay(selected[0]) && numbers(selected[1]).first == Int(hourText) &&
				numbers(selected[2]).first == Int(dateStrings[.minute]!) &&
				selected[3].localizedCaseInsensitiveContains(dateStrings[.timeZone]!),
				"Date picker did not select \(date): \(selected)")
		}
	}

	// MARK: - Value Helpers

	final func convertDateToStringComponents(_ date: Date) -> [Calendar.Component: String]{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		let month = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "yyyy"
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

	final func getCommaSeparatedList(_ values: [String]) -> String {
		var list = ""
		for value in values {
			list += value + ", "
		}
		list.removeLast()
		list.removeLast()
		return list
	}

	final func isToday(_ date: Date) -> Bool {
		Calendar.autoupdatingCurrent.isDateInToday(date)
	}

	// MARK: - Text Field Helpers

	final func setTextFor(field: XCUIElement, to text: String? = nil, expectedValue: String? = nil) {
		guard waitForElement(field) else {
			XCTFail("Text input did not appear: \(field)")
			return
		}
		if let value = field.value as? String, !value.isEmpty, value != field.placeholderValue {
			guard deleteContentOf(textField: field) else { return }
		}
		if let text = text, !text.isEmpty {
			field.tap()
			// A field can exist and accept a tap while its keyboard is still
			// appearing. Wait for an interactive software key before sending the
			// complete string; otherwise simulator input can deliver only a prefix.
			let key = app.keyboards.firstMatch.keys.firstMatch
			let ready = NSPredicate { _, _ in key.exists && key.isHittable }
			if !ready.evaluate(with: key) {
				let expectation = XCTNSPredicateExpectation(predicate: ready, object: key)
				guard XCTWaiter.wait(for: [expectation], timeout: 5) == .completed || ready.evaluate(with: key) else {
					XCTFail("Software keyboard was not ready for text input")
					return
				}
			}
			field.typeText(text)
			// Validation can intentionally normalize the typed text (for example,
			// clamping a mood to its allowed range). Ordinary entry still waits for
			// every character so a save cannot race partially delivered keyboard input.
			let expected = expectedValue ?? text
			let complete = NSPredicate { _, _ in (field.value as? String) == expected }
			if !complete.evaluate(with: field) {
				let expectation = XCTNSPredicateExpectation(predicate: complete, object: field)
				let result = XCTWaiter.wait(for: [expectation], timeout: 5)
				// A single accessibility snapshot can consume the wait's deadline.
				// Require the exact final value even when that last snapshot was late.
				if result != .completed {
					let actual = field.value as? String
					XCTAssertEqual(actual, expected,
						"Text input did not finish before saving: expected \(String(reflecting: expected)), got \(String(reflecting: actual))")
				}
			}
		}
	}

	@discardableResult
	final func deleteContentOf(textField: XCUIElement) -> Bool {
		textField.tap()
		// Some storyboard fields clear on focus. Check again after tapping: an
		// empty field has neither a clear button nor a Select All menu action.
		let currentText = textField.value as? String ?? ""
		if currentText.isEmpty || currentText == textField.placeholderValue {
			return true
		}
		// Tap the trailing lower edge to put the caret after the displayed text,
		// then use the software keyboard's Delete events. No edit-menu selection
		// or attached hardware keyboard is required. The final empty check below
		// prevents a partial deletion from being mistaken for success.
		let frame = textField.frame
		var visibleBottom = frame.maxY - 5
		let keyboard = app.keyboards.firstMatch
		if keyboard.exists { visibleBottom = min(visibleBottom, keyboard.frame.minY - 5) }
		let trailingY = max(0.05, min(0.95, (visibleBottom - frame.minY) / max(frame.height, 1)))
		textField.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: trailingY)).tap()
		let textToDelete = textField.value as? String ?? ""
		if !textToDelete.isEmpty && textToDelete != textField.placeholderValue {
			textField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: textToDelete.utf16.count))
		}
		let empty = NSPredicate { _, _ in
			let value = textField.value as? String ?? ""
			return value.isEmpty || value == textField.placeholderValue
		}
		if !empty.evaluate(with: textField) {
			let cleared = XCTNSPredicateExpectation(predicate: empty, object: textField)
			let result = XCTWaiter.wait(for: [cleared], timeout: 5)
			if result != .completed && !empty.evaluate(with: textField) {
				XCTFail("Text input was not cleared: \(textField.value ?? "nil")")
				return false
			}
		}
		return true
	}

	final func delete(numberOfTags: Int, fromTagsField tagsField: XCUIElement) {
		tagsField.tap()
		for _ in 0 ..< numberOfTags * 2 { // you have to press backspace twice to delete a tag
			app.keyboards.keys["delete"].tap()
		}
	}

	final func setTags(for tagsField: XCUIElement, to tags: [String]? = nil, from originalTags: [String]? = nil) {
		if let originalTags = originalTags {
			tagsField.tap()
			for _ in 0 ..< originalTags.count * 2 { // you have to press backspace twice to delete a tag
				app.keyboards.keys["delete"].tap()
			}
		}
		if let tags = tags {
			for tag in tags {
				tagsField.tap()
				tagsField.typeText(tag + "\n")
			}
		}
	}

	// MARK: - Element Functions

	final func moodNoteButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood note button"]
	}

	final func moodRatingButton() -> XCUIElement {
		return app.tables.cells.buttons["set mood button"]
	}

	final func moodRatingTextField() -> XCUIElement {
		return app.textFields["mood rating"]
	}

	final func activityDefinitionNameField() -> XCUIElement {
		return app.tables.cells.textFields["activity name"]
	}

	final func activityDefinitionAutoNoteField() -> XCUIElement {
		return app.tables.cells.switches["auto note"]
	}

	final func activityDefinitionTagsField() -> XCUIElement {
		return app.tables.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element
	}

	// MARK: - Sample Creators

	typealias Mood = UITestFixtures.Mood
	typealias ActivityDefinition = UITestFixtures.ActivityDefinition
	typealias Medication = UITestFixtures.Medication

	final func createMoods(_ moods: [Mood]) {
		app.tabBars.buttons["Record"].tap()
		for mood in moods {
			if app.sliders["mood slider"].exists {
				moodRatingButton().tap()
				setTextFor(field: moodRatingTextField(), to: String(mood.rating))
				app.toolbars.buttons["Save"].tap()
			} else {
				app.buttons["set mood to \(Int(mood.rating)) button"].tap()
			}
			if let note = mood.note {
				app.tables.buttons["set mood note button"].tap()
				let noteField = app.textViews.allElementsBoundByIndex[0]
				setTextFor(field: noteField, to: note)
				app.toolbars.buttons["Save"].tap()
			}

			app.tables.buttons["save mood button"].tap()
		}
	}

	final func createActivityDefinitions(_ definitions: [ActivityDefinition]) {
		openActivitiesScreen()
		for definition in definitions {
			createActivityDefinition(definition, goToRecordActivitiesScreen: false)
		}
	}

	final func createActivityDefinition(_ definition: ActivityDefinition, goToRecordActivitiesScreen: Bool = true) {
		// Creating another definition already returns here. Avoid popping to the
		// Record menu and reopening the same screen for every fixture record.
		if goToRecordActivitiesScreen { openActivitiesScreen() }
		skipInstructionsIfPresent(.activities)
		app.navigationBars.buttons["+"].tap()
		setTextFor(field: app.tables.textFields["activity name"], to: definition.name)
		if let autoNote = definition.autoNote {
			let currentlyEnabled = activityDefinitionAutoNoteField().value as? String == "1"
			if currentlyEnabled != autoNote {
				activityDefinitionAutoNoteField().tap()
			}
		}
		setTextFor(field: app.tables.cells.textViews["activity description"], to: definition.description)
		setTags(for: activityDefinitionTagsField(), to: definition.tags)
		app.buttons["Save"].tap()
	}

	final func createMedication(_ medication: Medication, save: Bool = true) {
		openMedicationsScreen()

		app.buttons["+"].tap()

		let nameField = app.textFields["medication name"]
		setTextFor(field: nameField, to: medication.name)

		if let frequency = medication.frequency {
			app.buttons["set frequency button"].tap()
			let numberOfTimesField = app.textFields["number of times"]
			setTextFor(field: numberOfTimesField, to: frequency.times)
			app.pickerWheels["Day"].adjust(toPickerWheelValue: frequency.unit.capitalized)
			app.buttons["save button"].tap()
		}

		if let startedOn = medication.startedOn {
			app.buttons["set started on button"].tap()
			setDatePicker(to: startedOn)
			app.buttons["save button"].tap()
		}

		if let dosage = medication.dosage {
			let dosageField = app.textFields["medication dosage"]
			setTextFor(field: dosageField, to: dosage)
		}

		if let note = medication.note {
			setTextFor(field: app.textViews["notes"], to: note)
		}

		if save {
			app.buttons["Save"].tap()
		}
	}

	// MARK: - Query Screen Helpers

	final func runQueryForAll(_ type: String) {
		goToQueryScreen()
		setMainDataTypeForQuery(type)
		app.buttons["Run"].tap()
	}

	final func addAttributeRestrictionToQuery() {
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Attribute Restriction"].tap()
	}

	final func addAndToQuery() {
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["And"].tap()
	}

	final func setMainDataTypeForQuery(_ type: String) {
		app.tables.cells.allElementsBoundByIndex[0].tap()
		setPicker(to: type)
		app.buttons["save button"].tap()
	}

	final func addDataTypeToQuery(_ type: String? = nil) {
		app.tables.buttons["Add"].tap()
		app.sheets["What would you like to add?"].buttons["Data Type"].tap()
		if let type = type {
			// A just-inserted restriction can still be missing from the previous
			// accessibility snapshot. Find the new sample row by its stable label.
			let sampleRows = app.tables.cells.matching(identifier: "Data Type")
			guard waitForElement(sampleRows.firstMatch) else {
				XCTFail("New query data type row did not appear")
				return
			}
			sampleRows.element(boundBy: sampleRows.count - 1).tap()
			setPicker("data type", to: type, changeCase: false)
			app.buttons["save data type button"].tap()
		}
	}
}
