import XCTest

final class PinnedQueryDashboardUITests: UITest {
	private let firstName = "Dashboard moods"
	private let secondName = "Another saved mood query"

	private func launchDashboard(pinned: Bool) {
		let at = Date(timeIntervalSince1970: 1_700_000_000.125)
		var fixtures = UITestFixtures(moods: [
			.init(2, "Dashboard first stored note", timestamp: at),
			.init(8, "Dashboard second stored note", timestamp: at.addingTimeInterval(3600)),
		])
		// Deliberately use a different order from the picker's alphabetical list.
		fixtures.dashboardQueries = [.init(name: firstName, pinned: pinned), .init(name: secondName, pinned: pinned)]
		launchApp(fixtures: fixtures)
		openDashboard()
	}

	private func openDashboard() {
		app.tabBars.buttons["Explore"].tap()
		let entry = app.collectionViews.cells["pinnedQueriesExplore"]
		XCTAssertTrue(waitForHittableElement(entry)); entry.tap()
		XCTAssertTrue(waitForElement(app.tables["pinnedQueryDashboard"]))
	}

	private func dashboardRows() -> XCUIElementQuery {
		app.tables["pinnedQueryDashboard"].cells.matching(NSPredicate(format: "identifier BEGINSWITH 'dashboardQuery.'"))
	}

	private func row(named name: String) -> XCUIElement {
		app.tables["pinnedQueryDashboard"].cells.containing(.staticText, identifier: name).firstMatch
	}

	private func waitForCount(_ count: Int, on name: String) {
		let summary = row(named: name).staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "\(count) matching records available")).firstMatch
		XCTAssertTrue(waitForElement(summary), "The saved query must display its actual result count")
	}

	func testPinQueryOpenItsActualRecordsAndUnpinWithoutDeletingSavedQuery() {
		launchDashboard(pinned: false)
		XCTAssertEqual(dashboardRows().count, 0)
		app.navigationBars.buttons["Pin Queries"].tap()
		let picker = app.tables["pinnedQueryPicker"]
		XCTAssertTrue(waitForElement(picker))
		picker.staticTexts[firstName].tap()
		app.navigationBars.buttons["Done"].tap()
		waitForCount(2, on: firstName)
		row(named: firstName).tap()

		for (identifier, value) in [("mood", "2 (1-10)"), ("mood", "8 (1-10)"),
			("note", "Dashboard first stored note"), ("note", "Dashboard second stored note")] {
			let field = app.tables.cells.staticTexts.matching(identifier: identifier)
				.matching(NSPredicate(format: "value == %@", value)).firstMatch
			XCTAssertTrue(waitForElement(field), "Dashboard navigation must open the actual matching record values")
		}
		app.navigationBars.buttons["Pinned Queries"].tap()
		waitForCount(2, on: firstName)
		row(named: firstName).swipeLeft()
		let unpin = app.buttons["Unpin"]
		XCTAssertTrue(waitForHittableElement(unpin)); unpin.tap()
		waitForCount(0, in: dashboardRows())
		app.navigationBars.buttons["Pin Queries"].tap()
		XCTAssertTrue(waitForElement(app.tables["pinnedQueryPicker"].staticTexts[firstName]), "Unpin must retain the saved query")
		XCTAssertTrue(app.tables["pinnedQueryPicker"].staticTexts[secondName].exists)
	}

	func testPinnedOrderSurvivesReopeningAndRefreshesCurrentRecordedData() {
		launchDashboard(pinned: true)
		waitForCount(2, on: firstName); waitForCount(2, on: secondName)
		XCTAssertTrue(dashboardRows().element(boundBy: 0).staticTexts[firstName].exists)
		XCTAssertTrue(dashboardRows().element(boundBy: 1).staticTexts[secondName].exists)
		app.navigationBars.buttons["Explore"].tap()
		openDashboard()
		waitForCount(2, on: firstName); waitForCount(2, on: secondName)
		XCTAssertTrue(dashboardRows().element(boundBy: 0).staticTexts[firstName].exists)
		XCTAssertTrue(dashboardRows().element(boundBy: 1).staticTexts[secondName].exists)

		app.tabBars.buttons["Record"].tap()
		let saveMood = app.tables.buttons["save mood button"]
		XCTAssertTrue(waitForHittableElement(saveMood)); saveMood.tap()
		app.tabBars.buttons["Explore"].tap()
		XCTAssertTrue(waitForElement(app.tables["pinnedQueryDashboard"]))
		waitForCount(3, on: firstName); waitForCount(3, on: secondName)
		app.tables["pinnedQueryDashboard"].swipeDown()
		waitForCount(3, on: firstName); waitForCount(3, on: secondName)
		XCTAssertTrue(dashboardRows().element(boundBy: 0).staticTexts[firstName].exists)
		XCTAssertTrue(dashboardRows().element(boundBy: 1).staticTexts[secondName].exists)
	}
}
