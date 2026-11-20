import XCTest
import CoreGraphics

final class ActivityRecordingUndoUITests: UITest {
	private var review: XCUIElement { app.tables["activityDayReview"] }
	private var undo: XCUIElement { app.buttons["undoActivityRecording"] }

	override func openInitialScreen() { openActivitiesScreen() }

	func testUndoStartRemovesTheNewRecordFromTodayReview() {
		let work = ActivityDefinition(name: "Work", autoNote: false)
		seed(activityDefinitions: [work])
		tapActivity(work)
		XCTAssertTrue(waitForHittableElement(undo))
		openTodayReview()
		waitForCount(1, in: rows("activityReviewRunning."))
		XCTAssertTrue(running(named: work.name).exists)

		XCTAssertTrue(waitForHittableElement(undo))
		undo.tap()

		waitForCount(0, in: rows("activityReviewRunning."))
		waitForCount(0, in: rows("activityReviewRecord."))
		XCTAssertFalse(running(named: work.name).exists)
	}

	func testUndoStopRestoresTheOriginalStartAndNoteWhileAnotherTimerKeepsRunning() {
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let music = ActivityDefinition(name: "Music", autoNote: false)
		let workStart = Date(timeIntervalSince1970: Date().timeIntervalSince1970.rounded(.down) - 7200 + 0.125)
		let musicStart = workStart.addingTimeInterval(3600.75)
		let note = "Keep this note"
		seed(activityDefinitions: [work, music], activities: [
			.init(work, start: workStart, note: note), .init(music, start: musicStart),
		])
		tapActivity(work)
		XCTAssertTrue(waitForHittableElement(undo))
		waitForCount(1, in: app.activityIndicators)

		undo.tap()
		openTodayReview()

		waitForCount(2, in: rows("activityReviewRunning."))
		waitForCount(0, in: rows("activityReviewRecord."))
		XCTAssertTrue(running(named: work.name).exists)
		XCTAssertTrue(running(named: music.name).exists)
		openRunningEditor(named: work.name)
		waitForValue(dateString(workStart), of: app.tables.cells.staticTexts["start date"])
		waitForValue(note, of: app.textViews["activity note"])
	}

	func testUndoSwitchRestoresTheSourceAndRemovesOnlyTheNewTargetTimer() {
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let music = ActivityDefinition(name: "Music", autoNote: false)
		let lunch = ActivityDefinition(name: "Lunch", autoNote: false)
		let workStart = Date(timeIntervalSince1970: Date().timeIntervalSince1970.rounded(.down) - 7200 + 0.125)
		seed(activityDefinitions: [work, music, lunch], activities: [
			.init(work, start: workStart), .init(music, start: workStart.addingTimeInterval(60.75)),
		])
		openTimeActions(for: lunch)
		app.buttons["Switch from…"].tap()
		let source = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Work · started ")).firstMatch
		XCTAssertTrue(waitForHittableElement(source))
		source.tap()
		app.buttons["Now"].tap()
		XCTAssertTrue(waitForHittableElement(undo))
		let table = app.tables["recordActivities"]
		waitForCount(1, in: table.cells.containing(.staticText, identifier: lunch.name).firstMatch.activityIndicators)
		waitForCount(0, in: table.cells.containing(.staticText, identifier: work.name).firstMatch.activityIndicators)

		undo.tap()
		openTodayReview()

		waitForCount(2, in: rows("activityReviewRunning."))
		waitForCount(0, in: rows("activityReviewRecord."))
		XCTAssertTrue(running(named: work.name).exists)
		XCTAssertTrue(running(named: music.name).exists)
		XCTAssertFalse(running(named: lunch.name).exists)
		openRunningEditor(named: work.name)
		waitForValue(dateString(workStart), of: app.tables.cells.staticTexts["start date"])
	}

	private func tapActivity(_ definition: ActivityDefinition) {
		let row = app.tables["recordActivities"].cells.containing(.staticText, identifier: definition.name).firstMatch
		XCTAssertTrue(waitForHittableElement(row))
		row.tap()
	}

	private func openTimeActions(for definition: ActivityDefinition) {
		let table = app.tables["recordActivities"]
		let row = table.cells.containing(.staticText, identifier: definition.name).firstMatch
		XCTAssertTrue(waitForHittableElement(row))
		let start = row.coordinate(withNormalizedOffset: CGVector(dx: 0.85, dy: 0.5))
		let end = row.coordinate(withNormalizedOffset: CGVector(dx: 0.25, dy: 0.5))
		start.press(forDuration: 0.05, thenDragTo: end)
		let action = table.buttons["backdate or switch \(definition.name)"]
		XCTAssertTrue(waitForHittableElement(action))
		action.tap()
	}

	private func openTodayReview() {
		app.navigationBars.buttons["Review activities"].tap()
		XCTAssertTrue(waitForElement(review))
		app.segmentedControls["activityReviewDay"].buttons["Today"].tap()
	}

	private func rows(_ prefix: String) -> XCUIElementQuery {
		review.cells.matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix))
	}

	private func running(named name: String) -> XCUIElement {
		rows("activityReviewRunning.").containing(.staticText, identifier: name).firstMatch
	}

	private func openRunningEditor(named name: String) {
		let row = running(named: name)
		XCTAssertTrue(waitForHittableElement(row))
		row.tap()
		app.buttons["Edit record"].tap()
	}

	private func dateString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .medium
		return formatter.string(from: date)
	}
}
