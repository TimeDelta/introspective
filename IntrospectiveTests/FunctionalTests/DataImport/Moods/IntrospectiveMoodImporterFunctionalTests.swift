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
			DependencyInjector.get(Settings.self).setScaleMoodsOnImport(scaleMoods)
			try! DependencyInjector.get(Settings.self).save()
		}
	}
	private var minMood = 1.0 {
		didSet {
			DependencyInjector.get(Settings.self).setMinMood(minMood)
			try! DependencyInjector.get(Settings.self).save()
		}
	}
	private var maxMood = 7.0 {
		didSet {
			DependencyInjector.get(Settings.self).setMaxMood(maxMood)
			try! DependencyInjector.get(Settings.self).save()
		}
	}

	// MARK: - Setup

	public override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.get(ImporterFactory.self).introspectiveMoodImporter() as! IntrospectiveMoodImporterImpl
		scaleMoods = false
		try! DependencyInjector.get(Settings.self).save()
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
		assertThat(Me.moodInfo1, exists())
	}

	func testGivenValidDataWithMoodNoteThatContainsQuote_importData_correctlyImportsData() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo2]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo2, exists())
	}

	func testGivenValidDataWithMoodNoteThatContainsNewline_importData_correctlyImportsData() throws {
		// given
		useInput(Me.inputFor([Me.moodInfo3]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo3, exists())
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Date()
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists())
		assertThat(Me.moodInfo2, exists())
		assertThat(Me.moodInfo3, exists())
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.moodInfo2.timestamp
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists())
		assertThat(Me.moodInfo2, not(exists()))
		assertThat(Me.moodInfo3, exists())
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists())
		assertThat(Me.moodInfo2, exists())
		assertThat(Me.moodInfo3, exists())
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.moodInfo1, exists())
		assertThat(Me.moodInfo2, exists())
		assertThat(Me.moodInfo3, exists())
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
		assertThat(scaledMood(Me.moodInfo1), exists())
		assertThat(scaledMood(Me.moodInfo2), exists())
		assertThat(scaledMood(Me.moodInfo3), exists())
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
		importer = try DependencyInjector.get(Database.self).pull(savedObject: importer)
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
		var newMoodInfo = mood
		newMoodInfo.rating = (maxMood - minMood) * (mood.rating - mood.minRating) / (mood.maxRating - mood.minRating) + minMood
		newMoodInfo.minRating = minMood
		newMoodInfo.maxRating = maxMood
		return newMoodInfo
	}

	// MARK: Matchers

	private final func exists() -> Hamcrest.Matcher<MoodInfo> {
		return Matcher("") { moodInfo -> MatchResult in
			let fetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
			var predicates = [NSPredicate]()
			predicates.append(self.datePredicateFor(fieldName: "timestamp", withinOneSecondOf: moodInfo.timestamp))
			predicates.append(NSPredicate(format: "rating == %f", moodInfo.rating))
			predicates.append(NSPredicate(format: "minRating == %f", moodInfo.minRating))
			predicates.append(NSPredicate(format: "maxRating == %f", moodInfo.maxRating))
			predicates.append(self.timeZonePredicate(for: moodInfo.timeZone, field: "timestampTimeZoneId"))
			predicates.append(self.notePredicate(for: moodInfo.note))
			predicates.append(NSPredicate(format: "source == %i", moodInfo.source.rawValue))
			fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
			do {
				let moods = try DependencyInjector.get(Database.self).query(MoodImpl.fetchRequest())
				if moods.count == 0 {
					return .mismatch("No moods exist")
				}
				let matchingMoods = try DependencyInjector.get(Database.self).query(fetchRequest)
				if matchingMoods.count == 0 {
					return .mismatch("No matching moods found")
				}
				if matchingMoods.count == 1 {
					return .match
				}
				return .mismatch("Found \(matchingMoods.count) matching mood entries")
			} catch {
				return .mismatch("FetchRequest failed: " + error.localizedDescription)
			}
		}
	}

	private final func datePredicateFor(fieldName: String, withinOneSecondOf date: Date) -> NSPredicate {
		// within a second of the input start date
		// can't use == expected date because it always fails for some unknown reason
		return NSPredicate(
			format: "%K >= %@ AND %K <= %@",
			fieldName,
			date.addingTimeInterval(-1) as NSDate,
			fieldName,
			date.addingTimeInterval(1) as NSDate
		)
	}

	private final func timeZonePredicate(for timeZone: TimeZone?, field: String) -> NSPredicate {
		if let timeZone = timeZone {
			return NSPredicate(format: "%K ==[cd] %@", field, timeZone.identifier)
		}
		return NSPredicate(format: "%K == nil", field)
	}

	private final func notePredicate(for note: String?) -> NSPredicate {
		if let note = note {
			let unescapedNote = note.replacingOccurrences(of: "\"\"", with: "\"")
			return NSPredicate(format: "note == %@", unescapedNote)
		}
		return NSPredicate(format: "note == nil || note == %@", "")
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

	// MARK: - Structs

	private struct MoodInfo {
		var timestamp: Date
		var timeZone: TimeZone?
		var note: String?
		var rating: Double
		var minRating: Double
		var maxRating: Double
		var source: Sources.MoodSourceNum

		public init(
			timestamp: Date,
			timeZone: TimeZone? = nil,
			rating: Double,
			minRating: Double,
			maxRating: Double,
			note: String? = nil,
			source: Sources.MoodSourceNum
		) {
			self.timestamp = timestamp
			self.timeZone = timeZone
			self.rating = rating
			self.minRating = minRating
			self.maxRating = maxRating
			self.note = note
			self.source = source
		}
	}
}
