import XCTest

/// Seed the records so these scenarios exercise catch-up, without spending the
/// runner's time creating definitions or typing unrelated setup through the UI.
final class ActivityCatchUpUITests: UITest {
	private let calendar = Calendar.autoupdatingCurrent
	private var yesterday: Date {
		calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))!
	}
	private var review: XCUIElement { app.tables["activityDayReview"] }

	override func openInitialScreen() { openActivitiesScreen() }

	func testFillingUnknownInterval_preservesExactNeighborTimes() {
		let day = yesterday
		let nextDay = calendar.date(byAdding: .day, value: 1, to: day)!
		let gapStart = time(9, 10, 17, on: day).addingTimeInterval(0.125)
		let gapEnd = time(9, 30, 27, on: day).addingTimeInterval(0.875)
		let before = ActivityDefinition(name: "Before", autoNote: false)
		let after = ActivityDefinition(name: "After", autoNote: false)
		let walk = ActivityDefinition(name: "Walk", autoNote: false)
		seed(activityDefinitions: [before, after, walk], activities: [
			.init(before, start: day, end: gapStart),
			.init(after, start: gapEnd, end: nextDay),
		])
		openReview()
		waitForCount(1, in: rows("activityReviewGap."))

		tapReviewRow(rows("activityReviewGap.").firstMatch)
		let editor = app.tables["activityGapEditor"]
		XCTAssertTrue(waitForElement(editor))
		editor.cells["activityGapDefinition"].tap()
		app.tables["activityGapDefinitions"].cells.staticTexts[walk.name].tap()
		app.navigationBars["Record Past Activity"].buttons["Save"].tap()

		XCTAssertTrue(waitForElement(review))
		// Rounding either boundary inward would leave a fractional gap; rounding
		// outward would overlap a neighbor and be rejected by the writer.
		waitForCount(0, in: rows("activityReviewGap."))
		waitForCount(3, in: rows("activityReviewRecord."))
		tapReviewRow(record(named: walk.name))
		waitForValue(dateString(gapStart), of: app.tables.cells.staticTexts["start date"])
		waitForValue(dateString(gapEnd), of: app.tables.cells.staticTexts["end date"])
	}

	func testEndingForgottenTimerEarlier_preservesOtherRunningActivity() {
		let day = yesterday
		let workStart = time(9, 10, 17, on: day).addingTimeInterval(0.125)
		let musicStart = time(8, 0, 37, on: day)
		let actualEnd = time(12, 30, 0, on: day)
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let music = ActivityDefinition(name: "Music", autoNote: false)
		seed(activityDefinitions: [work, music], activities: [
			.init(work, start: workStart), .init(music, start: musicStart),
		])
		openReview()
		tapReviewRow(running(named: work.name))
		app.buttons["End earlier…"].tap()
		setDatePicker(to: actualEnd)
		app.buttons["save button"].tap()

		waitForCount(1, in: rows("activityReviewRunning."))
		XCTAssertTrue(running(named: music.name).exists)
		XCTAssertFalse(running(named: work.name).exists)
		let timeFormatter = DateFormatter()
		timeFormatter.timeStyle = .medium
		XCTAssertTrue(running(named: music.name).staticTexts[
			"Started \(timeFormatter.string(from: musicStart)) · Still running"].exists)
		tapReviewRow(record(named: work.name))
		waitForValue(dateString(workStart), of: app.tables.cells.staticTexts["start date"])
		// The edited end must keep zero seconds, even though the original start
		// and the picker's untouched initial value have finer precision.
		waitForValue(dateString(actualEnd), of: app.tables.cells.staticTexts["end date"])
	}

	func testTimelineReview_keepsYesterdayOverlapsWhenChangingDays() {
		let day = yesterday
		let now = Date()
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let music = ActivityDefinition(name: "Music", autoNote: false)
		let walk = ActivityDefinition(name: "Walk", autoNote: false)
		seed(activityDefinitions: [work, music, walk], activities: [
			.init(work, start: time(9, 0, 13, on: day), end: time(12, 0, 23, on: day)),
			.init(music, start: time(10, 0, 17, on: day), end: time(11, 0, 27, on: day)),
			.init(walk, start: calendar.startOfDay(for: now), end: now),
		])
		XCTAssertTrue(goToTabIfNotSelected("Explore"))
		let timeline = app.collectionViews.cells.containing(.staticText, identifier: "Timeline").firstMatch
		XCTAssertTrue(waitForHittableElement(timeline))
		timeline.tap()
		app.navigationBars.buttons["Review Activities"].tap()
		XCTAssertTrue(waitForElement(review))
		let days = app.segmentedControls["activityReviewDay"]
		XCTAssertTrue(days.buttons["Today"].isSelected)
		days.buttons["Yesterday"].tap()
		XCTAssertTrue(days.buttons["Yesterday"].isSelected)
		XCTAssertTrue(record(named: work.name).exists)
		XCTAssertTrue(record(named: music.name).exists)

		days.buttons["Today"].tap()
		XCTAssertTrue(waitForElement(record(named: walk.name)))
		XCTAssertFalse(record(named: work.name).exists)
		XCTAssertFalse(app.buttons["Next day"].isEnabled)
		days.buttons["Yesterday"].tap()

		XCTAssertTrue(waitForElement(record(named: work.name)))
		XCTAssertTrue(record(named: music.name).exists)
		// Review leaves both original overlapping intervals untouched.
		tapReviewRow(record(named: music.name))
		waitForValue(dateString(time(10, 0, 17, on: day)), of: app.tables.cells.staticTexts["start date"])
		waitForValue(dateString(time(11, 0, 27, on: day)), of: app.tables.cells.staticTexts["end date"])
	}

	private func openReview() {
		app.navigationBars.buttons["Review activities"].tap()
		XCTAssertTrue(waitForElement(review))
	}
	private func rows(_ prefix: String) -> XCUIElementQuery {
		review.cells.matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix))
	}
	private func record(named name: String) -> XCUIElement {
		rows("activityReviewRecord.").containing(.staticText, identifier: name).firstMatch
	}
	private func running(named name: String) -> XCUIElement {
		rows("activityReviewRunning.").containing(.staticText, identifier: name).firstMatch
	}
	private func tapReviewRow(_ row: XCUIElement) {
		XCTAssertTrue(waitForElement(row))
		for _ in 0..<3 {
			if row.isHittable { break }
			review.swipeUp()
		}
		XCTAssertTrue(row.isHittable, "Review row could not be scrolled into view")
		row.tap()
	}
	private func time(_ hour: Int, _ minute: Int, _ second: Int, on day: Date) -> Date {
		calendar.date(bySettingHour: hour, minute: minute, second: second, of: day)!
	}
	private func dateString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium; formatter.timeStyle = .medium
		return formatter.string(from: date)
	}
}
