//
//  WellnessMoodImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import SwiftyMocky
import CSV
@testable import Introspective

// This has to be a functional test because can't make a constructor for WellnessMoodImporter that doesn't require standing up CoreData
final class WellnessMoodImporterFunctionalTests: ImporterTest {

	// MARK: - Static Variables

	private typealias Me = WellnessMoodImporterFunctionalTests
	private static let date1Text = "4/4/18, 17:18"
	private static let date1 = CalendarUtilImpl().date(from: date1Text, format: "M/d/yy, HH:mm")!
	private static let rating1: Double = 4
	private static let date2Text = "4/4/18, 19:27"
	private static let date2 = CalendarUtilImpl().date(from: date2Text, format: "M/d/yy, HH:mm")!
	private static let rating2: Double = 6
	private static let date3Text = "4/5/18, 10:39"
	private static let date3 = CalendarUtilImpl().date(from: date3Text, format: "M/d/yy, HH:mm")!
	private static let rating3: Double = 2
	private static let date4Text = "4/5/18, 11:24"
	private static let date4 = CalendarUtilImpl().date(from: date4Text, format: "M/d/yy, HH:mm")!
	private static let rating4: Double = 3
	private static let date5Text = "4/6/18, 15:06"
	private static let date5 = CalendarUtilImpl().date(from: date5Text, format: "M/d/yy, HH:mm")!
	private static let rating5: Double = 4
	private static let note1 = "Uncertain about future\nFrustrated with work\nPinched nerve in my neck all day"
	private static let note2 = "Just got a great massage from Nicole for my pinched neck. It feels a lot better"
	private static let note3 = "Longing for a closer fit to my dream job\nDisheartened about current job because it doesn’t seem to be what I was hoping for"
	private static let note4 = "Feeling a little better after talking to Nicole and crying"
	private static let headerRow = "Date,Time,Rating,Note,Health Entry Type"
	private static let validImportFileText = """
\(headerRow)
\(date1Text),\(Int(rating1)),"\(note1)"
\(date2Text),\(Int(rating2)),"\(note2)"
\(date3Text),\(Int(rating3)),"\(note3)"
\(date5Text),\(Int(rating5)),""
\(date4Text),\(Int(rating4)),"\(note4)"
"""

	// MARK: - Instance Variables

	private final var importer: WellnessMoodImporterImpl!
	private final var scaleMoods: Bool! {
		didSet {
			DependencyInjector.settings.setScaleMoodsOnImport(scaleMoods)
			try! DependencyInjector.settings.save()
		}
	}
	private var minMood = 1.0 {
		didSet {
			DependencyInjector.settings.setMinMood(minMood)
			try! DependencyInjector.settings.save()
		}
	}
	private var maxMood = 7.0 {
		didSet {
			DependencyInjector.settings.setMaxMood(maxMood)
			try! DependencyInjector.settings.save()
		}
	}

	// MARK: - Setup

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.importer.wellnessMoodImporter() as! WellnessMoodImporterImpl
		try! DependencyInjector.settings.save()
	}

	// MARK: - importData() - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date5
		importer.importOnlyNewData = false
		scaleMoods = false
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(mood1WasImported(), "Mood 1 was not imported correctly")
		XCTAssert(mood2WasImported(), "Mood 2 was not imported correctly")
		XCTAssert(mood3WasImported(), "Mood 3 was not imported correctly")
		XCTAssert(mood4WasImported(), "Mood 4 was not imported correctly")
		XCTAssert(mood5WasImported(), "Mood 5 was not imported correctly")
		XCTAssertEqual(importer.lastImport, Me.date5)
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrueAndLastImportDateEqualToDate2_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date2
		importer.importOnlyNewData = true
		scaleMoods = false
		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssertFalse(mood1WasImported(), "Mood 1 should not have been imported")
		XCTAssertFalse(mood2WasImported(), "Mood 2 should not have been imported")
		XCTAssert(mood3WasImported(), "Mood 3 was not imported correctly")
		XCTAssert(mood4WasImported(), "Mood 4 was not imported correctly")
		XCTAssert(mood5WasImported(), "Mood 5 was not imported correctly")
		XCTAssertEqual(importer.lastImport, Me.date5)
	}

	func testGivenValidDataWithScaleMoodsEnabled_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		scaleMoods = true
		minMood = 3.0
		maxMood = 15.0

		useInput(Me.validImportFileText)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(mood1WasImported(), "Mood 1 was not imported correctly")
		XCTAssert(mood2WasImported(), "Mood 2 was not imported correctly")
		XCTAssert(mood3WasImported(), "Mood 3 was not imported correctly")
		XCTAssert(mood4WasImported(), "Mood 4 was not imported correctly")
		XCTAssert(mood5WasImported(), "Mood 5 was not imported correctly")
		XCTAssertEqual(importer.lastImport, Me.date5)
	}

	func testGivenImportCancelled_importData_startsNewImport() throws {
		// given
		useInput(Me.validImportFileText)
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

	// MARK: - importData() - Invalid Data

	func testGivenWrongNumberOfColumnsInHeaderRow_importData_throwsError() throws {
		// given
		scaleMoods = false
		useInput("""
wrong number of columns
\(Me.date1Text),\(Int(Me.rating1)),"\(Me.note1)"
\(Me.date2Text),\(Int(Me.rating2)),"\(Me.note2)"
\(Me.date3Text),\(Int(Me.rating3)),"\(Me.note3)"
\(Me.date5Text),\(Int(Me.rating5)),""
\(Me.date4Text),\(Int(Me.rating4)),"\(Me.note4)"
""")

		// when / then
		XCTAssertThrowsError(try importer.importData(from: url))
	}

	func testGivenTooFewColumnsInFirstDataRow_importData_throwsInvalidFileFormatError() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
"\(Me.note1)"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenInvalidDateFormatOnLine2_importData_throwsInvalidFileFormatError() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
2018/09/21, 14:21,4,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenInvalidDate_importData_throwsInvalidFileFormatError() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
99/99/99, 14:21,4,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenInvalidTime_importData_throwsInvalidFileFormatError() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
10/19/12, 99:99,4,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenInvalidRating_importData_throwsInvalidFileFormatError() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
10/19/12, 12:12,invalid rating,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
		}
	}

	func testGivenErrorThrownAfterValidMoodsCreated_importData_deletesMoodsFromCurrentImport() throws {
		// given
		scaleMoods = false
		useInput("""
\(Me.headerRow)
\(Me.date1Text),\(Me.rating1),"\(Me.note1)"
10/19/12, 12:12,invalid rating,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssertFalse(mood1WasImported(), "Mood 1 was not deleted after error thrown")
		}
	}

	func testGivenInvalidData_importData_doesNotDeleteMoodsNotPartOfImport() throws {
		// given
		scaleMoods = false
		MoodDataTestUtil.createMood(note: Me.note2, rating: Me.rating2, timestamp: Me.date2, min: 1, max: 7)
		useInput("""
\(Me.headerRow)
10/19/12, 12:12,invalid rating,"note"
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(mood2WasImported(), "Mood 2 was deleted")
		}
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		importer = try DependencyInjector.db.pull(savedObject: importer)
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
		useInput(Me.validImportFileText)
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
		useInput(Me.validImportFileText)
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

	final override func useInput(_ input: String) {
		Given(ioUtil, .csvReader(url: .value(url), hasHeaderRow: .value(true), willReturn: try! CSVReader(string: input, hasHeaderRow: true)))
		Given(ioUtil, .contentsOf(.value(url), willReturn: input))
	}

	private final func mood1WasImported() -> Bool {
		return moodWasImported(at: Me.date1, withRating: Me.rating1, andNote: Me.note1)
	}

	private final func mood2WasImported() -> Bool {
		return moodWasImported(at: Me.date2, withRating: Me.rating2, andNote: Me.note2)
	}

	private final func mood3WasImported() -> Bool {
		return moodWasImported(at: Me.date3, withRating: Me.rating3, andNote: Me.note3)
	}

	private final func mood4WasImported() -> Bool {
		return moodWasImported(at: Me.date4, withRating: Me.rating4, andNote: Me.note4)
	}

	private final func mood5WasImported() -> Bool {
		return moodWasImported(at: Me.date5, withRating: Me.rating5, andNote: nil)
	}

	private final func moodWasImported(at timestamp: Date, withRating rating: Double, andNote note: String?) -> Bool {
		return mood(at: timestamp, withRating: rating, andNote: note) != nil
	}

	private final func mood(at timestamp: Date, withRating rating: Double, andNote note: String?) -> MoodImpl? {
		let scaledRating = scaleMoods ? scale(rating) : rating
		let moodsFetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		moodsFetchRequest.predicate = NSPredicate(
			format: "%K == %@ AND %K == %f AND %K == %f AND %K == %f",
			"timestamp", timestamp as NSDate,
			"rating", scaledRating,
			"minRating", minMood,
			"maxRating", maxMood)
		var notePredicate: NSPredicate
		if let note = note {
			notePredicate = NSPredicate(format: "%K == %@", "note", note)
		} else {
			notePredicate = NSPredicate(format: "%K == nil", "note")
		}
		moodsFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [moodsFetchRequest.predicate!, notePredicate])
		let moods = try! DependencyInjector.db.query(moodsFetchRequest)
		if moods.count > 0 {
			return moods[0]
		}
		return nil
	}

	private final func scale(_ rating: Double) -> Double {
		let newMin = DependencyInjector.settings.minMood
		let newMax = DependencyInjector.settings.maxMood
		let oldMin = 1.0
		let oldMax = 7.0
		return ((newMax - newMin) * (rating - oldMin) / (oldMax - oldMin)) + newMin
	}
}
