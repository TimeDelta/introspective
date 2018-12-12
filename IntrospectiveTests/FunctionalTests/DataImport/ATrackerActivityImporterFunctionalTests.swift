//
//  ATrackerActivityImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import CoreData
@testable import Introspective

final class ATrackerActivityImporterFunctionalTests: ImporterTest {

	private typealias Me = ATrackerActivityImporterFunctionalTests
	private static let dateFormat = "YYYY-MM-dd HH:mm"

	private static let activityName1 = ",f,new,ou"
	private static let description1 = "this is a description and it contains a ',' comma"
	private static let startDate1Text = "2017-11-27 20:21"
	private static let endDate1Text = "2017-11-27 21:19"
	private static let note1 = "this is a note that contains a ',' comma"
	private static let category1 = "Hobbies"
	private static let startDate1 = CalendarUtilImpl().date(from: startDate1Text, format: dateFormat)!
	private static let endDate1 = CalendarUtilImpl().date(from: endDate1Text, format: dateFormat)!

	private static let activityName2 = "jhfiu"
	private static let description2: String? = nil
	private static let startDate2Text = "2018-01-08 14:15"
	private static let endDate2Text = "2018-01-08 17:15"
	private static let note2: String? = nil
	private static let category2: String? = nil
	private static let startDate2 = CalendarUtilImpl().date(from: startDate2Text, format: dateFormat)!
	private static let endDate2 = CalendarUtilImpl().date(from: endDate2Text, format: dateFormat)!

	private static let activityName3 = activityName1
	private static let description3: String? = nil
	private static let startDate3Text = "2018-02-07 21:17"
	private static let endDate3Text = ""
	private static let note3 = "grnjaihfijopsa jkof dsjak\nfhjds ahuifp\newhui"
	private static let category3: String? = nil
	private static let startDate3 = CalendarUtilImpl().date(from: startDate3Text, format: dateFormat)!
	private static let endDate3: Date? = nil

	private static let headerRow = "Task name, Task description, Start time, End time, Duration,Duration in hours, Note, Category"
	private static let activityRow2 = "\"\(activityName2)\",\"\(description2 ?? "")\",\"\(startDate2Text)\",\"\(endDate2Text)\",\"00:42:50\",0.6973508,\"\(note2 ?? "")\",\"\(category2 ?? "")\""
	private static let validInput = """
\(headerRow)
"\(activityName1)","\(description1)","\(startDate1Text)","\(endDate1Text)","00:41:50",0.6973508,"\(note1)","\(category1)"
\(activityRow2)
"\(activityName3)","\(description3 ?? "")","\(startDate3Text)","\(endDate3Text)","00:43:50",0.6973508,"\(note3)","\(category3 ?? "")"
"""

	private final var importer: ATrackerActivityImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.db.new(ATrackerActivityImporterImpl.self)
	}

	// MARK: - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.startDate3
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssert(try activity2WasImported())
		XCTAssert(try activity3WasImported())
		XCTAssertEqual(importer.lastImport, Me.startDate3)
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.startDate2
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssertFalse(try activity1WasImported())
		XCTAssertFalse(try activity2WasImported())
		XCTAssert(try activity3WasImported())
		XCTAssertEqual(importer.lastImport, Me.startDate3)
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssert(try activity2WasImported())
		XCTAssert(try activity3WasImported())
		XCTAssertEqual(importer.lastImport, Me.startDate3)
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssert(try activity2WasImported())
		XCTAssert(try activity3WasImported())
		XCTAssertEqual(importer.lastImport, Me.startDate3)
	}

	func testGivenActivityDefinitionWithNameAlreadyExists_importData_usesExistingDefinition() throws {
		// given
		let existingDescription = "this description is not the same as the description supplied for activity1 in the input data"
		let existingTag = "this tag is not the same as the tag supplied for activity1 in the input data"
		let tag = TagDataTestUtil.createTag(name: existingTag)
		let _ = ActivityDataTestUtil.createActivityDefinition(name: Me.activityName1, description: existingDescription, tags: [tag])

		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssertFalse(try activity1WasImported())
		XCTAssert(try activityExists(
			name: Me.activityName1,
			from: Me.startDate1,
			to: Me.endDate1,
			description: existingDescription,
			note: Me.note1,
			tag: existingTag))
		XCTAssert(try activity2WasImported())
		XCTAssert(try activity3WasImported())
		XCTAssertEqual(importer.lastImport, Me.startDate3)
	}

	func testGivenUnfinishedActivityWithSameNameAndSameStartDate_importData_updatesExistingActivity() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: Me.category1)
		let definition = ActivityDataTestUtil.createActivityDefinition(name: Me.activityName1, description: Me.description1, tags: [tag])
		let _ = ActivityDataTestUtil.createActivity(definition: definition, startDate: Me.startDate1, endDate: nil, note: nil)

		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssertFalse(try activityExists(name: Me.activityName1, from: Me.startDate1, to: nil, description: Me.description1, note: nil, tag: Me.category1))
	}

	// MARK: - Invalid Data

	func testGivenInvalidStartDateFormat_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidInput = """
\(Me.headerRow)
\(Me.activityRow2)
"\(Me.activityName1)","","12-1-12 at 7:43 AM","\(Me.endDate1Text)","00:41:50",0.6973508,"",""
"""
		useInput(invalidInput)
		importer.lastImport = nil
		importer.importOnlyNewData = false

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
			XCTAssert(try! noActivitiesExist())
			XCTAssert(try! noDefinitionsExist())
		}
	}

	func testGivenInvalidEndDateFormat_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidInput = """
\(Me.headerRow)
\(Me.activityRow2)
"\(Me.activityName1)","","\(Me.startDate1Text)","12-1-12 at 7:43 AM","00:41:50",0.6973508,"",""
"""
		useInput(invalidInput)
		importer.lastImport = nil
		importer.importOnlyNewData = false

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(error is InvalidFileFormatError)
			XCTAssert(try! noActivitiesExist())
			XCTAssert(try! noDefinitionsExist())
		}
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() {
		// given
		importer.lastImport = Date()

		// when
		importer.resetLastImportDate()

		// then
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - Helper Functions

	private final func createAllDefinitions() {
		let _ = ActivityDataTestUtil.createActivityDefinition(name: Me.activityName1)
		let _ = ActivityDataTestUtil.createActivityDefinition(name: Me.activityName2)
	}

	private final func activity1WasImported() throws -> Bool {
		return try activityExists(name: Me.activityName1, from: Me.startDate1, to: Me.endDate1, description: Me.description1, note: Me.note1, tag: Me.category1)
	}

	private final func activity2WasImported() throws -> Bool {
		return try activityExists(name: Me.activityName2, from: Me.startDate2, to: Me.endDate2, description: Me.description2, note: Me.note2, tag: Me.category2)
	}

	private final func activity3WasImported() throws -> Bool {
		return try activityExists(name: Me.activityName3, from: Me.startDate3, to: Me.endDate3, description: Me.description3, note: Me.note3, tag: Me.category3)
	}

	private final func noActivitiesExist() throws -> Bool {
		return try DependencyInjector.db.query(Activity.fetchRequest()).count == 0
	}

	private final func noDefinitionsExist() throws -> Bool {
		return try DependencyInjector.db.query(ActivityDefinition.fetchRequest()).count == 0
	}

	private final func activityExists(name: String, from startDate: Date, to endDate: Date?, description: String?, note: String?, tag: String?) throws -> Bool {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(format: "definition.name ==[cd] %@ AND startDate == %@", name, startDate as NSDate))
		if let endDate = endDate {
			predicates.append(NSPredicate(format: "endDate == %@", endDate as NSDate))
		} else {
			predicates.append(NSPredicate(format: "endDate == nil"))
		}
		if let description = description {
			predicates.append(NSPredicate(format: "definition.activityDescription == %@", description))
		}
		if let tag = tag {
			predicates.append(NSPredicate(format: "SUBQUERY(definition.tags, $tag, $tag.name ==[cd] %@) .@count > 0", tag))
		}
		if let note = note {
			predicates.append(NSPredicate(format: "note == %@", note))
		}
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		let activities = try DependencyInjector.db.query(fetchRequest)
		return activities.count > 0
	}
}
