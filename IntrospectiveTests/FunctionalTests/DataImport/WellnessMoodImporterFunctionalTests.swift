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
	private static let validImportFileText = """
Date,Time,Rating,Note
\(date1Text),\(rating1),\(note1)
\(date2Text),\(rating2),\(note2)
\(date3Text),\(rating3),\(note3)
\(date4Text),\(rating4),\(note4)
\(date5Text),\(rating5),
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
		importer = try! DependencyInjector.db.new(WellnessMoodImporterImpl.self)
		try! DependencyInjector.settings.save()
	}

	// MARK: - Valid Data

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

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - Helper Functions

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
		let scaledRating = scaleMoods ? scale(rating) : rating
		let moodsFetchRequest: NSFetchRequest<MoodImpl> = MoodImpl.fetchRequest()
		moodsFetchRequest.predicate = NSPredicate(
			format: "%K == %@ AND %K == %f AND %K == %f",
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
		return try! DependencyInjector.db.query(moodsFetchRequest).count > 0
	}

	private final func scale(_ rating: Double) -> Double {
		let newMin = DependencyInjector.settings.minMood
		let newMax = DependencyInjector.settings.maxMood
		let oldMin = 1.0
		let oldMax = 7.0
		return ((newMax - newMin) * (rating - oldMin) / (oldMax - oldMin)) + newMin
	}
}
