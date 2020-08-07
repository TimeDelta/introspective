//
//  IntrospectiveMoodImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import Hamcrest
import SwiftDate

@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples
@testable import Settings

class IntrospectiveMoodImporterFunctionalTests: ImporterTest {

	// MARK: - Static Variables

	private typealias Me = IntrospectiveMoodImporterFunctionalTests

	private static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full
		formatter.timeStyle = .full
		return formatter
	}()

	private static let headerRow = "\"Timestamp\",\"Time Zone\",\"Rating\",\"Minimum Allowed Rating\",\"Maximum Allowed Rating\",\"Note\",\"Source\""
	private static let moodInfo1 = MoodInfo(
		timestamp: Date(),
		timeZone: TimeZone.init(abbreviation: "GMT"),
		rating: 4,
		minRating: 1,
		maxRating: 7,
		note: "this is a note that contains a ',' comma",
		source: .introspective)
	private static let moodInfo2 = MoodInfo(
		timestamp: Date() - 2.days,
		rating: 0,
		minRating: 0,
		maxRating: 10,
		note: "this note contains a \"\"quote\"\"",
		source: .wellness)
	private static let moodInfo3 = MoodInfo(
		timestamp: Date() - 1.days,
		rating: 10,
		minRating: 1,
		maxRating: 10,
		note: "contains newline: dsjak\nfhjds ahuifp\newhui",
		source: .wellness)
	private static let validInput = inputFor([moodInfo1, moodInfo2, moodInfo3])

	// MARK: - Instsance Variables

	private final var importer: IntrospectiveMoodImporterImpl!
	private final var scaleMoods: Bool! {
		didSet {
			injected(Settings.self).setScaleMoodsOnImport(scaleMoods)
			try! injected(Settings.self).save()
		}
	}
	private var minMood = 1.0 {
		didSet {
			injected(Settings.self).setMinMood(minMood)
			try! injected(Settings.self).save()
		}
	}
	private var maxMood = 7.0 {
		didSet {
			injected(Settings.self).setMaxMood(maxMood)
			try! injected(Settings.self).save()
		}
	}

	// MARK: - Setup

	public override func setUp() {
		super.setUp()
		importer = try! injected(ImporterFactory.self).introspectiveMoodImporter() as! IntrospectiveMoodImporterImpl
		scaleMoods = false
		try! injected(Settings.self).save()
	}

	// MARK: - importData()

	// MARK: Valid Data

	func testGivenValidData_importData_correctlySetsLastImportDate() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo1]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(importer.lastImport, within(seconds: 1, of: Me.moodInfo1.timestamp))
	}

	func testGivenValidDataWithMoodNoteThatContainsComma_importData_correctlyImportsData() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo1]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
	}

	func testGivenValidDataWithMoodNoteThatContainsQuote_importData_correctlyImportsData() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo2]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo2, exists(MoodImpl.self))
	}

	func testGivenValidDataWithMoodNoteThatContainsNewline_importData_correctlyImportsData() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo3]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo3, exists(MoodImpl.self))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Date()
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
		assertThat(Me.moodInfo2, exists(MoodImpl.self))
		assertThat(Me.moodInfo3, exists(MoodImpl.self))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.moodInfo2.timestamp
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
		assertThat(Me.moodInfo2, not(exists(MoodImpl.self)))
		assertThat(Me.moodInfo3, exists(MoodImpl.self))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
		assertThat(Me.moodInfo2, exists(MoodImpl.self))
		assertThat(Me.moodInfo3, exists(MoodImpl.self))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists(MoodImpl.self))
		assertThat(Me.moodInfo2, exists(MoodImpl.self))
		assertThat(Me.moodInfo3, exists(MoodImpl.self))
	}

	func testGivenImportCancelled_importData_startsNewImport() throws {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let originalPercentComplete = importer.percentComplete()

		// when
		try importer.importData(from: url)

		// then
		XCTAssertGreaterThan(importer.percentComplete(), originalPercentComplete)
		XCTAssertFalse(importer.isCancelled)
	}

	func testGivenValidDataWithScaleMoodsEnabled_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		scaleMoods = true
		minMood = 3.0
		maxMood = 15.0

		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(scaledMood(Me.moodInfo1), exists(MoodImpl.self))
		assertThat(scaledMood(Me.moodInfo2), exists(MoodImpl.self))
		assertThat(scaledMood(Me.moodInfo3), exists(MoodImpl.self))
	}

	// MARK: Invalid Data

	func testGivenNoData_importData_doesNotThrowError() throws {
		// given
		useInput(Me.headerRow)

		// when
		try importer.importData(from: url)

		// then - no error thrown
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		importer = try injected(Database.self).pull(savedObject: importer)
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - cancel()

	func testGivenNotImporting_cancel_setsIsCancelledToTrue() {
		// when
		importer.cancel()

		// then
		XCTAssert(importer.isCancelled)
	}

	func testGivenCurrentlyImporting_cancel_stopsImportAndSetsIsCancelledToTrue() {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}

		// when
		while importer.percentComplete() == 0 {}
		importer.cancel()

		// then
		XCTAssertLessThanOrEqual(importer.percentComplete(), 1)
		XCTAssert(importer.isCancelled)
	}

	// MARK: - resume()

	func testGivenImportCancelled_resume_doesNotContinue() throws {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let expectedPerentComplete = importer.percentComplete()

		// when
		try importer.resume()

		// then
		XCTAssertEqual(importer.percentComplete(), expectedPerentComplete)
	}

	// MARK: - Helper Functions

	private final func scaledMood(_ mood: MoodInfo) -> MoodInfo {
		let newMoodInfo = mood
		newMoodInfo.rating = (maxMood - minMood) * (mood.rating - mood.minRating) / (mood.maxRating - mood.minRating) + minMood
		newMoodInfo.minRating = minMood
		newMoodInfo.maxRating = maxMood
		return newMoodInfo
	}

	// MARK: Input

	private static func inputFor(_ moods: [MoodInfo]) -> String {
		var input = Me.headerRow
		for moodInfo in moods {
			let timestampText = Me.formatter.string(from: moodInfo.timestamp)
			input += "\n\"\(timestampText)\","
			input += getTimeZoneString(moodInfo.timeZone) + ","
			input += "\"\(String(moodInfo.rating))\","
			input += "\"\(String(moodInfo.minRating))\","
			input += "\"\(String(moodInfo.maxRating))\","
			input += "\"\(moodInfo.note ?? "")\","
			input += getSourceString(moodInfo.source)
		}
		return input
	}

	private static func getTimeZoneString(_ timeZone: TimeZone?) -> String {
		return "\"" + (timeZone?.identifier ?? "") + "\""
	}

	private static func getSourceString(_ source: Sources.MoodSourceNum) -> String {
		return "\"" + source.description + "\""
	}
}
