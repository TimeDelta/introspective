//
//  ATrackerActivityImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import CoreData
import CSV
@testable import Introspective
@testable import Common
@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

final class ATrackerActivityImporterFunctionalTests: ImporterTest {

	private typealias Me = ATrackerActivityImporterFunctionalTests
	private static let dateFormat = "YYYY-MM-dd HH:mm"

	private static let startDate1Text = "2017-11-27 20:21"
	private static let endDate1Text = "2017-11-27 21:19"
	private static let activityInfo1 = ActivityInfo(
		name: ",f,new,ou",
		description: "this is a description and it contains a ',' comma",
		startDate: CalendarUtilImpl().date(from: startDate1Text, format: dateFormat)!,
		endDate: CalendarUtilImpl().date(from: endDate1Text, format: dateFormat)!,
		note: "this is a note that contains a ',' comma",
		tags: ["Hobbies"])

	private static let startDate2Text = "2018-01-08 14:15"
	private static let endDate2Text = "2018-01-08 17:15"
	private static let activityInfo2 = ActivityInfo(
		name: "jhfiu",
		startDate: CalendarUtilImpl().date(from: startDate2Text, format: dateFormat)!,
		endDate: CalendarUtilImpl().date(from: endDate2Text, format: dateFormat)!)

	private static let startDate3Text = "2018-02-07 21:17"
	private static let endDate3Text = ""
	private static let activityInfo3 = ActivityInfo(
		name: activityInfo1.name,
		startDate: CalendarUtilImpl().date(from: startDate3Text, format: dateFormat)!,
		note: "grnjaihfijopsa jkof dsjak\nfhjds ahuifp\newhui")

	private static let headerRow = "Task name, Task description, Start time, End time, TimeDuration,TimeDuration in hours, Note, Tag"
	private static let activityRow2 = "\"\(activityInfo2.name)\",\"\(activityInfo2.description ?? "")\",\"\(startDate2Text)\",\"\(endDate2Text)\",\"00:42:50\",0.6973508,\"\(activityInfo2.note ?? "")\",\"\(activityInfo2.tags?[0] ?? "")\""
	public static let validInput = inputFor([activityInfo1, activityInfo2, activityInfo3])

	private final var importer: ATrackerActivityImporterImpl!

	final override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.get(ImporterFactory.self).aTrackerActivityImporter() as! ATrackerActivityImporterImpl
	}

	// MARK: - importData() - Valid Data

	func testGivenValidDataWithImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.activityInfo3.startDate
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssert(try activity2WasImported())
		XCTAssert(try activity3WasImportedGivenActivity1ImportedFirst())
		XCTAssertEqual(importer.lastImport, Me.activityInfo3.startDate)
	}

	func testGivenValidDataWithImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.activityInfo2.startDate
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssertFalse(try activity1WasImported())
		XCTAssertFalse(try activity2WasImported())
		XCTAssert(try activity3WasImportedGivenActivity1ImportedFirst())
		XCTAssertEqual(importer.lastImport, Me.activityInfo3.startDate)
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
		XCTAssert(try activity3WasImportedGivenActivity1ImportedFirst())
		XCTAssertEqual(importer.lastImport, Me.activityInfo3.startDate)
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
		XCTAssert(try activity3WasImportedGivenActivity1ImportedFirst())
		XCTAssertEqual(importer.lastImport, Me.activityInfo3.startDate)
	}

	func testGivenActivityDefinitionWithNameAlreadyExists_importData_usesExistingDefinition() throws {
		// given
		let existingDescription = "this description is not the same as the description supplied for activity1 in the input data"
		let existingTag = "this tag is not the same as the tag supplied for activity1 in the input data"
		let tag = TagDataTestUtil.createTag(name: existingTag)
		ActivityDataTestUtil.createActivityDefinition(name: Me.activityInfo1.name, description: existingDescription, tags: [tag])

		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssertFalse(try activity1WasImported())

		var expectedActivityInfo1 = Me.activityInfo1
		expectedActivityInfo1.description = existingDescription
		expectedActivityInfo1.tags = [existingTag]
		XCTAssert(try activityExists(expectedActivityInfo1))

		XCTAssert(try activity2WasImported())

		var expectedActivityInfo3 = Me.activityInfo3
		expectedActivityInfo3.description = existingDescription
		expectedActivityInfo3.tags = [existingTag]
		XCTAssert(try activityExists(expectedActivityInfo3))

		XCTAssertEqual(importer.lastImport, Me.activityInfo3.startDate)
	}

	func testGivenUnfinishedActivityWithSameNameAndSameStartDate_importData_updatesExistingActivity() throws {
		// given
		let tag = TagDataTestUtil.createTag(name: Me.activityInfo1.tags![0])
		let definition = ActivityDataTestUtil.createActivityDefinition(
			name: Me.activityInfo1.name,
			description: Me.activityInfo1.description,
			tags: [tag])
		ActivityDataTestUtil.createActivity(definition: definition, startDate: Me.activityInfo1.startDate, endDate: nil, note: nil)
		var originalActivityInfo = Me.activityInfo1
		originalActivityInfo.endDate = nil
		originalActivityInfo.note = nil

		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activity1WasImported())
		XCTAssertFalse(try activityExists(originalActivityInfo))
	}

	func testGivenActivityWithMultipleTags_importData_correctlyImportsThatActivity() throws {
		// given
		var activityInfo = Me.activityInfo1
		activityInfo.tags = ["tag 1", "tag 2", "tag 3"]
		useInput(Me.inputFor([activityInfo]))

		// when
		try importer.importData(from: url)

		// then
		XCTAssert(try activityExists(activityInfo))
	}

	/// failure of this test can (but is not guaranteed to) cause weird re-ordering bug on record screen
	func testGivenOtherDefinitionsCreatedOutsideOfImport_importData_correctlySetsRecordScreenIndexes() throws {
		// given
		var existingDefinition1 = ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		var existingDefinition2 = ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		useInput(Me.validInput)
		importer.pauseOnRecord = 3

		// when
		try importer.importData(from: url)

		var definitionCreatedDuringImport1 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 1 created during import",
			recordScreenIndex: 2)
		var definitionCreatedDuringImport2 = ActivityDataTestUtil.createActivityDefinition(
			name: "definition 2 created during import",
			recordScreenIndex: 3)

		try importer.resume()

		// then
		existingDefinition1 = try database.pull(savedObject: existingDefinition1)
		existingDefinition2 = try database.pull(savedObject: existingDefinition2)
		definitionCreatedDuringImport1 = try database.pull(savedObject: definitionCreatedDuringImport1)
		definitionCreatedDuringImport2 = try database.pull(savedObject: definitionCreatedDuringImport2)

		let definitionsWithImported1Name = try getDefinitionsWith(name: Me.activityInfo1.name)
		assertThat(definitionsWithImported1Name, hasCount(1))
		let definitionsWithImported2Name = try getDefinitionsWith(name: Me.activityInfo2.name)
		assertThat(definitionsWithImported2Name, hasCount(1))
		// definition for activity 3 is same as definition for activity 1

		XCTAssertEqual(existingDefinition1.recordScreenIndex, 0)
		XCTAssertEqual(existingDefinition2.recordScreenIndex, 1)
		XCTAssertEqual(definitionCreatedDuringImport1.recordScreenIndex, 2)
		XCTAssertEqual(definitionCreatedDuringImport2.recordScreenIndex, 3)
		if definitionsWithImported1Name.count == 1 {
			XCTAssertEqual(definitionsWithImported1Name[0].recordScreenIndex, 4)
		}
		if definitionsWithImported2Name.count == 1 {
			XCTAssertEqual(definitionsWithImported2Name[0].recordScreenIndex, 5)
		}
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

	// MARK: - importData() - Invalid Data

	func testGivenInvalidStartDateFormat_importData_throwsInvalidFileFormatError() throws {
		// given
		let invalidInput = """
\(Me.headerRow)
\(Me.activityRow2)
"\(Me.activityInfo1.name)","","12-1-12 at 7:43 AM","\(Me.endDate1Text)","00:41:50",0.6973508,"",""
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
"\(Me.activityInfo1.name)","","\(Me.startDate1Text)","12-1-12 at 7:43 AM","00:41:50",0.6973508,"",""
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

	func testGivenErrorThrownAfterActivitiesAndDefinitionsCreated_importData_deletesActivitiesAndDefinitionsFromCurrentImport() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput("""
\(Me.headerRow)
\(Me.activityRow2)
not enough columns
""")

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(try! !activity2WasImported())
		}
	}

	func testGivenInvalidData_importData_doesNotDeleteActivitiesOrDefinitionsNotPartOfImport() throws {
		// given
		let invalidInput = """
\(Me.headerRow)
not enough columns
"""

		useInput(invalidInput)
		importer.lastImport = nil
		importer.importOnlyNewData = false

		let definition = ActivityDataTestUtil.createActivityDefinition(name: "fdsjkl")
		let activity = ActivityDataTestUtil.createActivity(definition: definition)
		// for some reason the test fails without the following lines.
		// my best guess is that the main context delays merging the object until the context actually
		// has to fetch one of the properties because the only difference with this commit is that the
		// objects are now created on child contexts
		let _ = definition.name
		let _ = activity.start

		// when
		XCTAssertThrowsError(try importer.importData(from: url)) { error in
			// then
			XCTAssert(try! objectExists(activity))
			XCTAssert(try! objectExists(definition))
		}
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

	private final func activity1WasImported() throws -> Bool {
		return try activityExists(Me.activityInfo1)
	}

	private final func activity2WasImported() throws -> Bool {
		return try activityExists(Me.activityInfo2)
	}

	private final func activity3WasImported() throws -> Bool {
		return try activityExists(Me.activityInfo3)
	}

	private final func activity3WasImportedGivenActivity1ImportedFirst() throws -> Bool {
		var expectedActivityInfo = Me.activityInfo3
		expectedActivityInfo.description = Me.activityInfo1.description
		expectedActivityInfo.tags = Me.activityInfo1.tags
		return try activityExists(expectedActivityInfo)
	}

	private final func noActivitiesExist() throws -> Bool {
		return try DependencyInjector.get(Database.self).query(Activity.fetchRequest()).count == 0
	}

	private final func noDefinitionsExist() throws -> Bool {
		return try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest()).count == 0
	}

	private final func activityExists(_ activityInfo: ActivityInfo) throws -> Bool {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		var predicates = [NSPredicate]()
		predicates.append(NSPredicate(
			format: "definition.name ==[cd] %@ AND startDate == %@",
			activityInfo.name,
			activityInfo.startDate as NSDate))
		predicates.append(endDatePredicate(for: activityInfo.endDate))
		predicates.append(descriptionPredicate(for: activityInfo.description))
		predicates.append(tagsPredicate(for: activityInfo.tags))
		predicates.append(notePredicate(for: activityInfo.note))
		fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		let activities = try DependencyInjector.get(Database.self).query(fetchRequest)
		return activities.count == 1
	}

	private final func endDatePredicate(for endDate: Date?) -> NSPredicate {
		if let endDate = endDate {
			return NSPredicate(format: "endDate == %@", endDate as NSDate)
		}
		return NSPredicate(format: "endDate == nil")
	}

	private final func descriptionPredicate(for description: String?) -> NSPredicate {
		if let description = description {
			return NSPredicate(format: "definition.activityDescription == %@", description)
		}
		return NSPredicate(format: "definition.activityDescription == nil OR definition.activityDescription == %@", "")
	}

	private final func tagsPredicate(for tags: [String]?) -> NSPredicate {
		if let tags = tags {
			var predicates = [NSPredicate]()
			for tag in tags {
				predicates.append(NSPredicate(format: "SUBQUERY(definition.tags, $tag, $tag.name ==[cd] %@) .@count > 0", tag))
			}
			return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		}
		return NSPredicate(format: "definition.tags .@count == 0 AND tags .@count == 0")
	}

	private final func notePredicate(for note: String?) -> NSPredicate {
		if let note = note {
			return NSPredicate(format: "note == %@", note)
		}
		return NSPredicate(format: "note == nil || note == %@", "")
	}

	private final func getDefinitionsWith(name: String) throws -> [ActivityDefinition] {
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		return try DependencyInjector.get(Database.self).query(fetchRequest)
	}

	private final func objectExists(_ object: NSManagedObject) throws -> Bool {
		return !(try DependencyInjector.get(Database.self).pull(savedObject: object).isFault)
	}

	private static func inputFor(_ activities: [ActivityInfo]) -> String {
		var input = Me.headerRow
		for activityInfo in activities {
			let startDateText = DependencyInjector.get(CalendarUtil.self).string(for: activityInfo.startDate, inFormat: Me.dateFormat)
			let endDateText: String
			if let endDate = activityInfo.endDate {
				endDateText = DependencyInjector.get(CalendarUtil.self).string(for: endDate, inFormat: Me.dateFormat)
			} else {
				endDateText = ""
			}
			input += "\n\"\(activityInfo.name)\","
			input += "\"\(activityInfo.description ?? "")\","
			input += "\"\(startDateText)\","
			input += "\"\(endDateText)\","
			input += "\"00:42:50\",0.6973508,"
			input += "\"\(activityInfo.note ?? "")\","
			let tagsString = activityInfo.tags?.joined(separator: "|") ?? ""
			input += "\"\(tagsString)\""
		}
		return input
	}

	// MARK: - structs

	private struct ActivityInfo {
		var name: String
		var description: String?
		var startDate: Date
		var endDate: Date?
		var note: String?
		var tags: [String]?

		public init(
			name: String,
			description: String? = nil,
			startDate: Date,
			endDate: Date? = nil,
			note: String? = nil,
			tags: [String]? = nil)
		{
			self.name = name
			self.description = description
			self.startDate = startDate
			self.endDate = endDate
			self.note = note
			self.tags = tags
		}
	}
}
