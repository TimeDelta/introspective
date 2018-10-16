//
//  WellnessMoodImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/15/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

// This has to be a functional test because can't make a constructor for WellnessMoodImporter that doesn't require standing up CoreData
final class WellnessMoodImporterFunctionalTests: FunctionalTest {

	private typealias Me = WellnessMoodImporterFunctionalTests
	private static let url = URL(fileURLWithPath: "/")
	private static let date1Text = "4/4/18, 17:18"
	private static let date1 = CalendarUtilImpl().date(from: date1Text, format: "M/d/yy, HH:mm")!
	private static let date2Text = "4/4/18, 19:27"
	private static let date2 = CalendarUtilImpl().date(from: date2Text, format: "M/d/yy, HH:mm")!
	private static let date3Text = "4/5/18, 10:39"
	private static let date3 = CalendarUtilImpl().date(from: date3Text, format: "M/d/yy, HH:mm")!
	private static let date4Text = "4/5/18, 11:24"
	private static let date4 = CalendarUtilImpl().date(from: date4Text, format: "M/d/yy, HH:mm")!
	private static let date5Text = "4/6/18, 15:06"
	private static let date5 = CalendarUtilImpl().date(from: date5Text, format: "M/d/yy, HH:mm")!
	private static let note1 = "Uncertain about future\nFrustrated with work\nPinched nerve in my neck all day"
	private static let note2 = "Just got a great massage from Nicole for my pinched neck. It feels a lot better"
	private static let note3 = "Longing for a closer fit to my dream job\nDisheartened about current job because it doesn’t seem to be what I was hoping for"
	private static let note4 = "Feeling a little better after talking to Nicole and crying"
	private static let importFileText = """
Date,Time,Rating,Note
\(date1Text),4,\(note1)
\(date2Text),6,\(note2)
\(date3Text),2,\(note3)
\(date4Text),3,\(note4)
\(date5Text),4,
"""

	private final var importer: WellnessMoodImporterImpl!
	private final var mockSampleFactory: SampleFactoryMock!
	private final var mood1: MoodMock!
	private final var mood2: MoodMock!
	private final var mood3: MoodMock!
	private final var mood4: MoodMock!
	private final var mood5: MoodMock!

	final override func setUp() {
		super.setUp()

		importer = try! DependencyInjector.db.new(objectType: WellnessMoodImporterImpl.self)
		mockSampleFactory = SampleFactoryMock()
		mood1 = MoodMock()
		mood2 = MoodMock()
		mood3 = MoodMock()
		mood4 = MoodMock()
		mood5 = MoodMock()

		Given(ioUtil, .contentsOf(.value(Me.url), willReturn: Me.importFileText))
		Given(injectionProvider, .sampleFactory(willReturn: mockSampleFactory))
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Date()
		importer.importOnlyNewData = false
		Given(mockSampleFactory, .mood(willReturn: mood1, mood2, mood3, mood4, mood5))

		// when
		try importer.importData(from: Me.url)

		// then
		verifyMood1()
		verifyMood2()
		verifyMood3()
		verifyMood4()
		verifyMood5()
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrueAndLastImportDateEqualToDate2_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.date2
		importer.importOnlyNewData = true
		Given(mockSampleFactory, .mood(willReturn: mood3, mood4, mood5))

		// when
		try importer.importData(from: Me.url)

		// then
		verifyMood3()
		verifyMood4()
		verifyMood5()
	}

	private final func verifyMood1() {
		Verify(mood1, 1, .timestamp(set: .value(Me.date1)))
		Verify(mood1, 1, .maxRating(set: .value(7.0)))
		Verify(mood1, 1, .rating(set: .value(4.0)))
		Verify(mood1, 1, .note(set: .value(Me.note1)))
	}

	private final func verifyMood2() {
		Verify(mood2, 1, .timestamp(set: .value(Me.date2)))
		Verify(mood2, 1, .maxRating(set: .value(7.0)))
		Verify(mood2, 1, .rating(set: .value(6.0)))
		Verify(mood2, 1, .note(set: .value(Me.note2)))
	}

	private final func verifyMood3() {
		Verify(mood3, 1, .timestamp(set: .value(Me.date3)))
		Verify(mood3, 1, .maxRating(set: .value(7.0)))
		Verify(mood3, 1, .rating(set: .value(2.0)))
		Verify(mood3, 1, .note(set: .value(Me.note3)))
	}

	private final func verifyMood4() {
		Verify(mood4, 1, .timestamp(set: .value(Me.date4)))
		Verify(mood4, 1, .maxRating(set: .value(7.0)))
		Verify(mood4, 1, .rating(set: .value(3.0)))
		Verify(mood4, 1, .note(set: .value(Me.note4)))
	}

	private final func verifyMood5() {
		Verify(mood5, 1, .timestamp(set: .value(Me.date5)))
		Verify(mood5, 1, .maxRating(set: .value(7.0)))
		Verify(mood5, 1, .rating(set: .value(4.0)))
		Verify(mood5, 0, .note(set: .any))
	}
}
