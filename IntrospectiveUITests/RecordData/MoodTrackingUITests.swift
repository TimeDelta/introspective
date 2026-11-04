import XCTest

final class MoodTrackingUITests: UITest {
	private func openTools() {
		app.tabBars.buttons["Record"].tap()
		app.navigationBars.buttons["Check-ins"].tap()
	}
	func testWeeklyComparisonDrillsIntoTheActualPeriodEntries() {
		let calendar = Calendar.current, now = Date()
		let recent = calendar.date(byAdding: .day, value: -1, to: now)!
		let previous = calendar.date(byAdding: .day, value: -8, to: now)!
		seed(moods: [Mood(2, "Recent period note", timestamp: recent), Mood(8, "Previous period note", timestamp: previous)])
		openTools(); app.tables.staticTexts["Weekly Review"].tap()
		XCTAssertTrue(app.tables["weeklyMoodReview"].waitForExistence(timeout: 5))
		// Resolve through the label instead of an eager cell array while the table updates.
		let recentLabel = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Recent: '")).firstMatch
		XCTAssertTrue(recentLabel.waitForExistence(timeout: 5)); recentLabel.tap()
		XCTAssertTrue(app.navigationBars["Period Check-ins"].waitForExistence(timeout: 5))
		XCTAssertTrue(app.tables.staticTexts["Recent period note"].exists)
		XCTAssertFalse(app.tables.staticTexts["Previous period note"].exists)
	}
	func testCreatePresetRecordItAndQueryItsSavedRatingAndNote() {
		openTools(); app.tables.staticTexts["Check-in Presets"].tap()
		app.navigationBars.buttons["Add"].tap()
		setTextFor(field: app.textFields["moodPresetName"], to: "Evening")
		setTextFor(field: app.textFields["moodPresetRating"], to: "7")
		setTextFor(field: app.textFields["moodPresetMinimum"], to: "1")
		setTextFor(field: app.textFields["moodPresetMaximum"], to: "10")
		setTextFor(field: app.textFields["moodPresetNote"], to: "Quiet evening", perCharacter: true)
		app.navigationBars.buttons["Save"].tap()
		let preset = app.tables.staticTexts["Evening"]
		XCTAssertTrue(preset.waitForExistence(timeout: 5)); preset.tap()
		runQueryForAll("Mood")
		XCTAssertEqual(app.tables.cells.staticTexts["mood"].value as? String, "7 (1-10)")
		XCTAssertEqual(app.tables.cells.staticTexts["note"].value as? String, "Quiet evening")
	}
	func testRemindersStartDisabledAndTimeSelectionCanBeSavedWithoutPermission() {
		openTools(); app.tables.staticTexts["Reminders"].tap()
		XCTAssertTrue(app.tables["moodReminders"].waitForExistence(timeout: 5))
		XCTAssertEqual(app.switches["Enable reminders"].value as? String, "0")
		app.tables.staticTexts["Add time"].tap()
		XCTAssertTrue(app.datePickers.firstMatch.waitForExistence(timeout: 5))
		app.navigationBars.buttons["Done"].tap()
		app.navigationBars.buttons["Save"].tap()
		XCTAssertTrue(app.navigationBars["Mood Check-ins"].waitForExistence(timeout: 5))
		app.tables.staticTexts["Reminders"].tap()
		XCTAssertEqual(app.switches["Enable reminders"].value as? String, "0")
		XCTAssertEqual(app.switches["Skip recorded days"].value as? String, "1")
	}
}
