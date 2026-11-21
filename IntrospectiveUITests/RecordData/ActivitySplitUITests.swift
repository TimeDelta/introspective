import XCTest

final class ActivitySplitUITests: UITest {
	private let calendar = Calendar.autoupdatingCurrent
	private var yesterday: Date {
		calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))!
	}
	private var review: XCUIElement { app.tables["activityDayReview"] }
	private var splitEditor: XCUIElement { app.tables["activitySplitEditor"] }

	override func openInitialScreen() { openActivitiesScreen() }

	func testSplittingCompletedQueryResultRefreshesBothPartsAndKeepsOuterTimesAndNote() {
		let day = yesterday
		let start = time(9, 10, 17, on: day).addingTimeInterval(0.125)
		let end = time(11, 10, 27, on: day).addingTimeInterval(0.875)
		let boundary = time(10, 30, 0, on: day)
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let walk = ActivityDefinition(name: "Walk", autoNote: false)
		let note = "Keep this note on both parts"
		seed(activityDefinitions: [work, walk], activities: [.init(work, start: start, end: end, note: note)])
		runAllActivitiesQuery()
		tapResult(named: work.name)
		openSplit()

		splitEditor.cells["activitySplitTime"].tap()
		app.buttons["Choose time…"].tap()
		setDatePicker(to: boundary)
		app.buttons["save button"].tap()
		XCTAssertTrue(waitForElement(splitEditor))
		XCTAssertTrue(splitEditor.cells["activitySplitTime"].staticTexts[dateString(boundary)].exists)
		chooseSecondActivity(walk)
		app.buttons["saveActivitySplit"].tap()

		XCTAssertTrue(waitForElement(result(named: work.name)))
		XCTAssertTrue(waitForElement(result(named: walk.name)))
		waitForCount(2, in: app.tables.cells.containing(.staticText, identifier: note))
		tapResult(named: work.name)
		waitForValue(dateString(start), of: app.tables.cells.staticTexts["start date"])
		waitForValue(dateString(boundary), of: app.tables.cells.staticTexts["end date"])
		waitForValue(note, of: app.textViews["activity note"])
		app.navigationBars.buttons.element(boundBy: 0).tap()
		tapResult(named: walk.name)
		waitForValue(dateString(boundary), of: app.tables.cells.staticTexts["start date"])
		waitForValue(dateString(end), of: app.tables.cells.staticTexts["end date"])
		waitForValue(note, of: app.textViews["activity note"])
	}

	func testSplittingRunningRecordFiveMinutesAgoKeepsZeroSecondsAndAnotherTimerRunning() {
		let day = yesterday
		let start = time(9, 10, 17, on: day).addingTimeInterval(0.125)
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let walk = ActivityDefinition(name: "Walk", autoNote: false)
		let music = ActivityDefinition(name: "Music", autoNote: false)
		let musicStart = time(8, 30, 27, on: day).addingTimeInterval(0.875)
		seed(activityDefinitions: [work, walk, music], activities: [
			.init(work, start: start), .init(music, start: musicStart),
		])
		// Yesterday always contains the original first portion, including when
		// the five-minute estimate falls on yesterday just after midnight.
		openReview()
		tapReviewRow(running(named: work.name))
		app.buttons["Edit record"].tap()
		openSplit()
		let before = Date()
		splitEditor.cells["activitySplitTime"].tap()
		app.buttons["5 minutes ago"].tap()
		let after = Date()
		XCTAssertTrue(waitForElement(splitEditor))
		let boundary = splitEditor.cells["activitySplitTime"].staticTexts.element(boundBy: 1).label
		// The action captures now when its sheet opens. Accept either minute if
		// this interaction crosses a minute boundary; both have zero seconds.
		XCTAssertTrue([fiveMinutesAgo(before), fiveMinutesAgo(after)].contains(boundary))
		chooseSecondActivity(walk)
		app.buttons["saveActivitySplit"].tap()

		XCTAssertTrue(waitForElement(review))
		waitForCount(2, in: rows("activityReviewRunning."))
		XCTAssertTrue(running(named: walk.name).exists)
		XCTAssertTrue(running(named: music.name).exists)
		XCTAssertFalse(running(named: work.name).exists)
		tapReviewRow(record(named: work.name))
		waitForValue(dateString(start), of: app.tables.cells.staticTexts["start date"])
		waitForValue(boundary, of: app.tables.cells.staticTexts["end date"])
		leaveEditor()
		tapReviewRow(running(named: walk.name))
		app.buttons["Edit record"].tap()
		waitForValue(boundary, of: app.tables.cells.staticTexts["start date"])
		leaveEditor()
		tapReviewRow(running(named: music.name))
		app.buttons["Edit record"].tap()
		waitForValue(dateString(musicStart), of: app.tables.cells.staticTexts["start date"])
	}

	func testLeavingSplitWithoutSavingKeepsTheOriginalCompletedRecord() {
		let day = yesterday
		let start = time(9, 10, 17, on: day), end = time(11, 10, 27, on: day)
		let work = ActivityDefinition(name: "Work", autoNote: false)
		let walk = ActivityDefinition(name: "Walk", autoNote: false)
		seed(activityDefinitions: [work, walk], activities: [.init(work, start: start, end: end, note: "Original")])
		openReview()
		tapReviewRow(record(named: work.name))
		openSplit()
		chooseSecondActivity(walk)
		app.navigationBars["Split Activity"].buttons.element(boundBy: 0).tap()
		XCTAssertTrue(waitForElement(app.buttons["splitActivity"]))
		leaveEditor()

		waitForCount(1, in: rows("activityReviewRecord."))
		XCTAssertFalse(record(named: walk.name).exists)
		tapReviewRow(record(named: work.name))
		waitForValue(dateString(start), of: app.tables.cells.staticTexts["start date"])
		waitForValue(dateString(end), of: app.tables.cells.staticTexts["end date"])
		waitForValue("Original", of: app.textViews["activity note"])
	}

	func testUnsavedEditorNoteMustBeSavedBeforeOpeningSplitAndKeepsItsDraft() {
		let day = yesterday
		let work = ActivityDefinition(name: "Work", autoNote: false)
		seed(activityDefinitions: [work], activities: [
			.init(work, start: time(9, 0, 17, on: day), end: time(11, 0, 27, on: day), note: "Original"),
		])
		openReview()
		tapReviewRow(record(named: work.name))
		let note = app.textViews["activity note"]
		XCTAssertTrue(waitForHittableElement(note))
		setTextFor(field: note, to: "Original draft")
		waitForValue("Original draft", of: note)
		app.buttons["splitActivity"].tap()

		let alert = app.alerts["Save changes before splitting"]
		XCTAssertTrue(waitForElement(alert))
		XCTAssertFalse(splitEditor.exists)
		alert.buttons["OK"].tap()
		waitForValue("Original draft", of: note)
		leaveEditor()
		waitForCount(1, in: rows("activityReviewRecord."))
		tapReviewRow(record(named: work.name))
		waitForValue("Original", of: app.textViews["activity note"])
	}

	private func openReview() {
		app.navigationBars.buttons["Review activities"].tap()
		XCTAssertTrue(waitForElement(review))
	}
	private func runAllActivitiesQuery() {
		app.tabBars.buttons["Explore"].tap()
		app.collectionViews.staticTexts["Query"].tap()
		skipInstructionsIfPresent(.query)
		app.tables.cells.allElementsBoundByIndex[0].tap()
		setPicker(to: "Activity")
		app.buttons["save button"].tap()
		app.buttons["Run"].tap()
	}
	private func result(named name: String) -> XCUIElement {
		app.tables.cells.containing(.staticText, identifier: name).firstMatch
	}
	private func tapResult(named name: String) {
		let row = result(named: name)
		XCTAssertTrue(waitForHittableElement(row))
		row.tap()
	}
	private func openSplit() {
		let split = app.buttons["splitActivity"]
		XCTAssertTrue(waitForHittableElement(split))
		split.tap()
		XCTAssertTrue(waitForElement(splitEditor))
	}
	private func chooseSecondActivity(_ definition: ActivityDefinition) {
		splitEditor.cells["activitySplitDefinition"].tap()
		let chooser = app.tables["activitySplitDefinitions"]
		XCTAssertTrue(waitForElement(chooser))
		chooser.cells.containing(.staticText, identifier: definition.name).firstMatch.tap()
		XCTAssertTrue(waitForElement(splitEditor))
		XCTAssertTrue(splitEditor.cells["activitySplitDefinition"].staticTexts[definition.name].exists)
	}
	private func leaveEditor() {
		app.navigationBars.buttons.element(boundBy: 0).tap()
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
	private func fiveMinutesAgo(_ date: Date) -> String {
		let shifted = calendar.date(byAdding: .minute, value: -5, to: date)!
		return dateString(calendar.dateInterval(of: .minute, for: shifted)!.start)
	}
}
