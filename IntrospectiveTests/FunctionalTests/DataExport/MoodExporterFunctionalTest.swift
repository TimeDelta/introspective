//
//  MoodExporterFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import Common
@testable import DataExport
@testable import DependencyInjection
@testable import Samples

final class MoodExporterFunctionalTest: ExporterFunctionalTest {

	private typealias Me = MoodExporterFunctionalTest
	private static let expectedMoodHeaderFields = [
		"Timestamp",
		"Time Zone",
		"Rating",
		"Minimum Allowed Rating",
		"Maximum Allowed Rating",
		"Note",
		"Source",
	]
	private static let expectedMoodHeaderRow = headerRowFor(fields: expectedMoodHeaderFields)

	private final var exporter: MoodExporterImpl!
	private final var moodOutputStream: OutputStream!

	final override func setUp() {
		super.setUp()
		moodOutputStream = try! getOutputStreamFor(MoodImpl.self)
		exporter = try! MoodExporterImpl()
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
		let moodOutput = getTextWrittenTo(moodOutputStream)
		XCTAssertEqual(moodOutput, "")
	}

	// MARK: Header Rows

	func testGivenMoodToExport_exportData_writesCorrectHeaderRow() throws {
		// given
		MoodDataTestUtil.createMood()

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, line(1, equalTo(Me.expectedMoodHeaderRow)))
	}

	// MARK: Special Characters

	func testGivenMoodWithCommaInNote_exportData_correctlyExportsMood() throws {
		// given
		let note = ",no,te,"
		let mood = MoodDataTestUtil.createMood(note: note)

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvWithRow(2, matching: expectedFields(for: mood)))
	}

	func testGivenMoodWithQuoteInNote_exportData_correctlyExportsMood() throws {
		// given
		let note = "\"no\"te\""
		let mood = MoodDataTestUtil.createMood(note: note)

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvWithRow(2, matching: expectedFields(for: mood)))
	}

	func testGivenMoodWithNewlineInNote_exportData_correctlyExportsMood() throws {
		// given
		let note = "\nno\nte\n"
		let mood = MoodDataTestUtil.createMood(note: note)

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvWithRow(2, matching: expectedFields(for: mood)))
	}

	// MARK: Normal Exports

	func testGivenMoodsToExport_exportData_correctlyExportsMoodsInAscendingTimestampOrder() throws {
		// given
		let mood1 = MoodDataTestUtil.createMood(
			note: "1",
			rating: 1,
			timestamp: Date() - 1.days,
			min: 1,
			max: 2,
			source: .wellness)
		let mood2 = MoodDataTestUtil.createMood(
			note: "2",
			rating: 2,
			timestamp: Date() - 1.hours,
			min: 2,
			max: 3,
			source: .introspective)
		let mood3 = MoodDataTestUtil.createMood(timestamp: Date() - 1.weeks)

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvWithRows([
			Me.expectedMoodHeaderFields,
			expectedFields(for: mood3),
			expectedFields(for: mood1),
			expectedFields(for: mood2),
		]))
	}

	func testGivenCancelledBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		MoodDataTestUtil.createMood(note: "1")
		exporter.cancel()
		MoodDataTestUtil.createMood(note: "2")

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		XCTAssertEqual(moodOutput, "")
	}

	func testGivenPausedBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		MoodDataTestUtil.createMood(note: "1")
		exporter.pause()
		MoodDataTestUtil.createMood(note: "2")

		// when
		try exporter.exportData()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		XCTAssertEqual(moodOutput, "")
	}

	// MARK: Errors

	func testGivenExportStartedAndPaused_exportData_throwsError() throws {
		// given
		MoodDataTestUtil.createMood()
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
		MoodDataTestUtil.createMood(note: "1")
		MoodDataTestUtil.createMood(note: "2")
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

	func testGivenExportPausedDuringMoods_resume_doesNotDuplicateAnyOutput() throws {
		// given
		let mood1 = MoodDataTestUtil.createMood(timestamp: Date() - 1.days)
		let mood2 = MoodDataTestUtil.createMood(timestamp: Date())
		exporter.pauseOnRecord = 1
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvWithRows([
			Me.expectedMoodHeaderFields,
			expectedFields(for: mood1),
			expectedFields(for: mood2),
		]))
	}

	func testGivenExportPaused_resume_continuesExportAndCorrectlyExportsRemainingRecords() throws {
		// given
		MoodDataTestUtil.createMood(note: "1", timestamp: Date() - 2.days)
		let mood2 = MoodDataTestUtil.createMood(note: "2", timestamp: Date() - 1.days)
		let mood3 = MoodDataTestUtil.createMood(note: "3", timestamp: Date())
		exporter.pauseOnRecord = 1
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, csvContainsRow(withFields: expectedFields(for: mood2)))
		assertThat(moodOutput, csvContainsRow(withFields: expectedFields(for: mood3)))
	}

	func testGivenExportCancelled_resume_doesNotContinueExport() throws {
		// given
		MoodDataTestUtil.createMood(note: "1")
		let mood2 = MoodDataTestUtil.createMood(note: "2")
		exporter.pauseOnRecord = 1
		try exporter.exportData()
		exporter.cancel()

		// when
		try exporter.resume()

		// then
		let moodOutput = getTextWrittenTo(moodOutputStream)
		assertThat(moodOutput, not(csvContainsRow(withFields: expectedFields(for: mood2))))
	}

	// MARK: - Helper Functions

	private final func csvRow(for mood: MoodImpl) -> Matcher<String> {
		return csvRowWith(fields: expectedFields(for: mood).map{ equalTo($0) })
	}

	private final func expectedFields(for mood: MoodImpl) -> [String] {
		let dateText = DependencyInjector.get(CalendarUtil.self).string(for: mood.date, dateStyle: .full, timeStyle: .full)
		return [
			dateText,
			TimeZone.autoupdatingCurrent.identifier,
			String(mood.rating),
			String(mood.minRating),
			String(mood.maxRating),
			mood.note ?? "",
			mood.getSource().description,
		]
	}
}
