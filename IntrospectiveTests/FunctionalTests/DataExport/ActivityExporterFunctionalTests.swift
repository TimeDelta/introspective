//
//  ActivityExporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/18/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import CSV
import SwiftDate
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Samples

final class ActivityExporterFunctionalTests: ExporterFunctionalTest {

	private typealias Me = ActivityExporterFunctionalTests
	private static let expectedActivityHeaderFields = [
		"Name",
		"Description",
		"Definition Tags",
		"Definition Source",
		"Auto Note",
		"Record Screen Index",
		"Start",
		"Start Time Zone",
		"End",
		"End Time Zone",
		"Note",
		"Extra Tags",
		"Instance Source",
	]
	private static let expectedActivityHeaderRow = headerRowFor(fields: expectedActivityHeaderFields)

	private final var exporter: ActivityExporterImpl!
	private final var outputStream: OutputStream!

	final override func setUp() {
		super.setUp()
		outputStream = try! getOutputStreamFor(Activity.self)
		exporter = try! ActivityExporterImpl()
	}

	// MARK: - exportData

	// MARK: Nothing To Export

	func testGivenNothingToExport_exportData_throwsDisplayableErrorThatSaysNothingToExport() throws {
		// when
		XCTAssertThrowsError(try exporter.exportData()) { error in
			// then
			assertThat(error, instanceOf(GenericDisplayableError.self))
			if let displayableError = error as? GenericDisplayableError {
				XCTAssertEqual(displayableError.displayableTitle, "Nothing to export")
			}
		}
	}

	func testGivenNothingToExport_exportData_doesNotWriteAnythingToDisk() throws {
		// when
		do {
			try exporter.exportData()
		} catch {
			// do nothing because error is supposed to be thrown
		}

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	func testGivenOnlyActivityDefinitionsToExport_exportData_doesNotWriteAnything() throws {
		// given
		ActivityDataTestUtil.createActivityDefinition()

		// when
		do {
			try exporter.exportData()
		} catch {
			// do nothing because error is supposed to be thrown
		}

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	// MARK: Header Row

	func testGivenActivityToExport_exportData_writesCorrectHeaderRow() throws {
		// given
		ActivityDataTestUtil.createActivity()

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, line(1, equalTo(Me.expectedActivityHeaderRow)))
	}

	// MARK: Special Characters

	func testGivenActivityDefinitionWithCommaInName_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let name = ",na,me,"
		let activity = ActivityDataTestUtil.createActivity(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityDefinitionWithQuoteInName_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let name = "\"na\"me\""
		let activity = ActivityDataTestUtil.createActivity(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityDefinitionWithNewlineInName_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let name = "\nna\nme\n"
		let activity = ActivityDataTestUtil.createActivity(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityDefinitionWithCommaInDescription_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let description = ",descrip,tion,"
		let definition = ActivityDataTestUtil.createActivityDefinition(description: description)
		let activity = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityDefinitionWithQuoteInDescription_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let description = "\"descrip\"tion\""
		let definition = ActivityDataTestUtil.createActivityDefinition(description: description)
		let activity = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityDefinitionWithNewlineInDescription_exportData_correctlyExportsActivityDefinition() throws {
		// given
		let description = "\ndescrip\ntion\n"
		let definition = ActivityDataTestUtil.createActivityDefinition(description: description)
		let activity = ActivityDataTestUtil.createActivity(definition: definition)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityWithCommaInNote_exportData_correctlyExportsActivity() throws {
		// given
		let note = ",no,te,"
		let activity = ActivityDataTestUtil.createActivity(note: note)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityWithQuoteInNote_exportData_correctlyExportsActivity() throws {
		// given
		let note = "\"no\"te\""
		let activity = ActivityDataTestUtil.createActivity(note: note)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	func testGivenActivityWithNewlineInNote_exportData_correctlyExportsActivity() throws {
		// given
		let note = "\nno\nte\n"
		let activity = ActivityDataTestUtil.createActivity(note: note)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: activity)))
	}

	// MARK: Normal Exports

	func testGivenActivityDefinitionsAndActivitiesToExport_exportData_correctlyExportsActivities() throws {
		// given
		let tag1 = TagDataTestUtil.createTag(name: "tag 1")
		let tag2 = TagDataTestUtil.createTag(name: "tag 2")
		let tag3 = TagDataTestUtil.createTag(name: "tag 3")
		let definition1 = ActivityDataTestUtil.createActivityDefinition(
			name: "activity 1 name",
			description: "activity 1 description",
			tags: [tag1, tag2],
			source: .introspective,
			recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(
			name: "activity 2 name",
			description: "activity 2 description",
			tags: [tag3],
			source: .aTracker,
			recordScreenIndex: 1)

		let tag4 = TagDataTestUtil.createTag(name: "tag 4")
		let tag5 = TagDataTestUtil.createTag(name: "tag 5")
		let tag6 = TagDataTestUtil.createTag(name: "tag 6")
		let activity1 = ActivityDataTestUtil.createActivity(
			definition: definition1,
			startDate: Date() - 1.days,
			endDate: nil,
			note: "activity 1 note",
			source: .aTracker,
			tags: [tag4])
		let activity2 = ActivityDataTestUtil.createActivity(
			definition: definition2,
			startDate: Date() - 1.hours,
			startTimeZone: TimeZone.init(abbreviation: "GMT"),
			endDate: Date() + 3.hours,
			note: "activity 2 note",
			source: .introspective,
			tags: [tag6, tag5])

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedActivityHeaderFields,
			expectedFields(for: activity1),
			expectedFields(for: activity2),
		]))
	}

	func testGivenActivitiesToExport_exportData_exportsInAscendingStartDateOrder() throws {
		// given
		let activity1 = ActivityDataTestUtil.createActivity(name: "activity 1", startDate: Date() - 1.days, endDate: Date())
		let activity2 = ActivityDataTestUtil.createActivity(
			name: "activity 2",
			startDate: Date() - 2.days,
			endDate: Date() + 2.days)
		let activity3 = ActivityDataTestUtil.createActivity(name: "activity 3", startDate: Date() - 4.hours, endDate: nil)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedActivityHeaderFields,
			expectedFields(for: activity2),
			expectedFields(for: activity1),
			expectedFields(for: activity3),
		]))
	}

	func testGivenCancelledBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: "1")
		ActivityDataTestUtil.createActivity(definition: definition1)

		exporter.cancel()

		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "2")
		ActivityDataTestUtil.createActivity(definition: definition2)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	func testGivenPausedBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: "1")
		ActivityDataTestUtil.createActivity(definition: definition1)

		exporter.pause()

		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "2")
		ActivityDataTestUtil.createActivity(definition: definition2)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	// MARK: Errors

	func testGivenExportStartedAndPaused_exportData_throwsError() throws {
		// given
		ActivityDataTestUtil.createActivity()
		exporter.pauseOnRecord = 0
		try exporter.exportData()

		// when / then
		XCTAssertThrowsError(try exporter.exportData())
	}

	// MARK: - percentComplete

	func testGivenNothingToExport_percentComplete_returns1() {
		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 1)
	}

	func testGivenExportCancelled_percentComplete_returns1() {
		// given
		exporter.cancel()

		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 1)
	}

	func testGivenExportStartedButNotFinished_percentComplete_returnsCorrectPercent() throws {
		// given
		exporter.pauseOnRecord = 1
		ActivityDataTestUtil.createActivity()
		ActivityDataTestUtil.createActivity()
		try exporter.exportData()

		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 0.5)
	}

	// MARK: - cancel

	func testGivenExportNotAlreadyCancelled_cancel_setsIsCancelledToTrue() {
		// given
		XCTAssertFalse(exporter.isCancelled)

		// when
		exporter.cancel()

		// then
		XCTAssert(exporter.isCancelled)
	}

	func testGivenExportAlreadyCancelled_cancel_leavesIsCancelledAsTrue() {
		// given
		exporter.cancel()

		// when
		exporter.cancel()

		// then
		XCTAssert(exporter.isCancelled)
	}

	// MARK: - pause

	func testGivenExportNotAlreadyPaused_pause_setsIsPausedToTrue() {
		// given
		XCTAssertFalse(exporter.isPaused)

		// when
		exporter.pause()

		// then
		XCTAssert(exporter.isPaused)
	}

	func testGivenExportAlreadyPaused_pause_leavesIsPausedAsTrue() {
		// given
		exporter.pause()

		// when
		exporter.pause()

		// then
		XCTAssert(exporter.isPaused)
	}

	// MARK: - resume

	func testGivenExportPausedDuringActivities_resume_doesNotDuplicateAnyOutput() throws {
		// given
		let definition1 = ActivityDataTestUtil.createActivityDefinition(name: "1", recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(name: "2", recordScreenIndex: 1)
		let activity1 = ActivityDataTestUtil.createActivity(definition: definition1)
		let activity2 = ActivityDataTestUtil.createActivity(definition: definition2)
		exporter.pauseOnRecord = 3
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedActivityHeaderFields,
			expectedFields(for: activity1),
			expectedFields(for: activity2),
		]))
	}

	func testGivenExportPaused_resume_continuesExportAndCorrectlyExportsEverything() throws {
		// given
		ActivityDataTestUtil.createActivity(name: "1")
		let activity2 = ActivityDataTestUtil.createActivity(name: "2")
		exporter.pauseOnRecord = 2
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvContainsRow(withFields: expectedFields(for: activity2)))
	}

	func testGivenExportCancelled_resume_doesNotContinueExport() throws {
		// given
		ActivityDataTestUtil.createActivity(name: "1")
		let activity2 = ActivityDataTestUtil.createActivity(name: "2")
		exporter.pauseOnRecord = 1
		try exporter.exportData()
		exporter.cancel()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, not(csvContainsRow(withFields: expectedFields(for: activity2))))
	}

	// MARK: - Helper Functions

	private final func expectedFields(for definition: ActivityDefinition) -> [String] {
		let tagsText = definition.tagsArray().map{ $0.name }.joined(separator: "|")
		return [
			definition.name,
			definition.activityDescription ?? "",
			tagsText,
			definition.getSource().description,
			definition.autoNote ? "true" : "false",
			String(definition.recordScreenIndex),
		]
	}

	private final func csvRow(for activity: Activity) -> Hamcrest.Matcher<String> {
		return csvRowWith(fields: expectedFields(for: activity).map{ equalTo($0) })
	}

	private final func expectedFields(for activity: Activity) -> [String] {
		let tagsText = activity.tagsArray().map{ $0.name }.joined(separator: "|")
		let startText = injected(CalendarUtil.self).string(for: activity.start, dateStyle: .full, timeStyle: .full)
		var endText = ""
		if let end = activity.end {
			endText = injected(CalendarUtil.self).string(for: end, dateStyle: .full, timeStyle: .full)
		}
		var fieldValues = expectedFields(for: activity.definition)
		fieldValues.append(contentsOf: [
			startText,
			activity.startDateTimeZone ?? "",
			endText,
			activity.endDateTimeZone ?? "",
			activity.note ?? "",
			tagsText,
			activity.getSource().description,
		])
		return fieldValues
	}
}
