import XCTest

/// End-to-end coverage uses the existing isolated SQLite fixture path. The
/// explanation screen must inspect the same saved definition the builder runs.
final class QueryInspectionUITests: UITest {
	private let queryName = "Inspection moods"
	private let olderNote = "Inspection earlier mood"
	private let newerNote = "Inspection latest mood"

	private func launchSavedMoodQuery() {
		let at = Date(timeIntervalSince1970: 1_700_000_000.125)
		var fixtures = UITestFixtures(moods: [
			.init(2, olderNote, timestamp: at),
			.init(8, newerNote, timestamp: at.addingTimeInterval(3600)),
		])
		fixtures.dashboardQueries = [.init(name: queryName)]
		launchApp(fixtures: fixtures)
		goToQueryScreen()
		app.buttons["Load"].tap()
		let saved = app.tables["savedQueries"].staticTexts[queryName]
		XCTAssertTrue(waitForHittableElement(saved)); saved.tap()
		XCTAssertTrue(waitForElement(app.tables["queryBuilder"]))
	}

	func testBuilderPreviewWaitsForExplicitInspectionAndDoesNotChangeActualResults() {
		launchSavedMoodQuery()
		let explain = app.navigationBars.buttons["explainBuilderQuery"]
		XCTAssertTrue(waitForHittableElement(explain)); explain.tap()
		XCTAssertTrue(waitForElement(app.tables["queryInspection"]))
		assertInspectionRow("status", contains: "No records have been read")
		assertInspectionRow("q0/results", contains: "Count not inspected")
		app.navigationBars.buttons["inspectQueryCounts"].tap()
		assertInspectionRow("q0/all", contains: "2 matching records")
		assertInspectionRow("q0/results", contains: "2 matching records")
		// UIKit shortens this bar's back title to "Back" beside Inspect Counts.
		let back = app.navigationBars["Query Explanation"].buttons["Back"]
		guard waitForHittableElement(back) else {
			XCTFail("The explanation's Back button did not become reachable")
			return
		}
		back.tap()
		XCTAssertTrue(waitForElement(app.tables["queryBuilder"]))
		app.buttons["Run"].tap()
		for note in [olderNote, newerNote] {
			let field = app.tables.cells.staticTexts.matching(identifier: "note")
				.matching(NSPredicate(format: "value == %@", note)).firstMatch
			XCTAssertTrue(waitForElement(field), "Inspection must preserve the query's actual matching records")
		}
	}

	func testWhyMatchedChecksTheSelectedRecordsStableIdentityInTheSnapshot() {
		launchSavedMoodQuery()
		app.buttons["Run"].tap()
		let row = app.tables.cells.containing(.staticText, identifier: newerNote).firstMatch
		XCTAssertTrue(waitForHittableElement(row)); row.swipeRight()
		let why = app.buttons["Why Matched?"]
		XCTAssertTrue(waitForHittableElement(why)); why.tap()
		XCTAssertTrue(waitForElement(app.tables["queryInspection"]))
		XCTAssertTrue(app.navigationBars["Why This Record Matched"].exists)
		assertInspectionRow("q0/results", contains: "Count not inspected")
		app.navigationBars.buttons["inspectQueryCounts"].tap()
		assertInspectionRow("q0/results", contains: "2 matching records")
		assertInspectionRow("q0/results", contains: "Selected record: matches")
		app.navigationBars.buttons["Results"].tap()
		let note = app.tables.cells.staticTexts.matching(identifier: "note")
			.matching(NSPredicate(format: "value == %@", newerNote)).firstMatch
		XCTAssertTrue(waitForElement(note), "Explaining a record must leave its note and query results unchanged")
	}
}

extension UITest {
	/// A row's accessibility label includes its text and count. Wait for the
	/// actual published value rather than relying on a loading animation ending.
	func assertInspectionRow(_ path: String, contains text: String,
		file: StaticString = #file, line: UInt = #line) {
		let row = app.tables["queryInspection"].cells.matching(identifier: "queryExplanation." + path)
			.matching(NSPredicate(format: "label CONTAINS %@", text)).firstMatch
		XCTAssertTrue(waitForElement(row), "Expected inspection row \(path) to contain \(text)", file: file, line: line)
	}

	/// Retain the existing empty-query cases while checking the new useful
	/// destination, its explicit diagnostic action, and both return paths.
	func assertEmptyQueryCanBeExplainedAndReturnToBuilder(file: StaticString = #file, line: UInt = #line) {
		XCTAssertTrue(waitForElement(app.staticTexts["emptyQueryResults"]), file: file, line: line)
		XCTAssertFalse(app.alerts.firstMatch.exists, file: file, line: line)
		app.buttons["actions button"].tap()
		XCTAssertFalse(app.buttons["Graph"].exists, file: file, line: line)
		XCTAssertFalse(app.buttons["Add Information"].exists, file: file, line: line)
		XCTAssertTrue(app.buttons["Refresh"].exists, file: file, line: line)
		let explain = app.buttons["Explain Query"]
		XCTAssertTrue(waitForHittableElement(explain), file: file, line: line); explain.tap()
		XCTAssertTrue(waitForElement(app.tables["queryInspection"]), file: file, line: line)
		assertInspectionRow("q0/results", contains: "Count not inspected", file: file, line: line)
		app.navigationBars.buttons["inspectQueryCounts"].tap()
		assertInspectionRow("q0/all", contains: "0 matching records", file: file, line: line)
		assertInspectionRow("q0/results", contains: "0 matching records", file: file, line: line)
		let diagnostic = app.tables["queryInspection"].cells["queryExplanation.diagnostic.1"]
		for _ in 0..<3 {
			if diagnostic.exists && diagnostic.isHittable { break }
			app.tables["queryInspection"].swipeUp()
		}
		assertInspectionRow("diagnostic.1", contains: "No visible records", file: file, line: line)
		app.navigationBars.buttons["Results"].tap()
		XCTAssertTrue(waitForElement(app.staticTexts["emptyQueryResults"]), file: file, line: line)
		app.navigationBars.buttons["Query"].tap()
		XCTAssertTrue(waitForElement(app.tables["queryBuilder"]), file: file, line: line)
		XCTAssertTrue(app.buttons["Run"].exists, file: file, line: line)
	}
}
