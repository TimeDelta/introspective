//
//  IntrospectiveActivityImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import Hamcrest
import SwiftDate

@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

class IntrospectiveActivityImporterFunctionalTests: ImporterTest {

	private typealias Me = IntrospectiveActivityImporterFunctionalTests

	private static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full
		formatter.timeStyle = .full
		return formatter
	}()

	private static let headerRow = "\"Name\",\"Description\",\"Definition Tags\",\"Definition Source\",\"Auto Note\",\"Record Screen Index\",\"Start\",\"Start Time Zone\",\"End\",\"End Time Zone\",\"Note\",\"Extra Tags\",\"Instance Source\""
	private static let definitionInfo1 = ActivityDefinitionInfo(
		name: ",f,new,ou",
		description: "this is a description and it contains a ',' comma",
		tags: [],
		source: .introspective,
		autoNote: true,
		recordScreenIndex: 0)
	private static let definitionInfo2 = ActivityDefinitionInfo(
		name: "jhfiu",
		description: "this description contains a \"\"quote\"\"",
		tags: ["\"\"quote\"\""],
		source: .aTracker,
		autoNote: false,
		recordScreenIndex: 1)
	private static let activityInfo1 = ActivityInfo(
		definition: definitionInfo1,
		startDate: Date(),
		startTimeZone: TimeZone.init(abbreviation: "GMT"),
		endDate: Date() + 3.hours,
		note: "this is a note that contains a ',' comma",
		tags: ["Hobbies", "co,mma"])
	private static let activityInfo2 = ActivityInfo(
		definition: definitionInfo2,
		startDate: Date() - 2.days,
		endDate: Date() - 2.hours)
	private static let activityInfo3 = ActivityInfo(
		definition: definitionInfo1,
		startDate: Date(),
		startTimeZone: nil,
		note: "grnjaihfijopsa jkof dsjak\nfhjds ahuifp\newhui")
	private static let validInput = inputFor([activityInfo1, activityInfo2, activityInfo3])

	private final var importer: IntrospectiveActivityImporterImpl!

	public override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.get(ImporterFactory.self).introspectiveActivityImporter() as! IntrospectiveActivityImporterImpl
	}

	// MARK: - importData()

	// MARK: Valid Data

	func testGivenValidDataWithNewActivityDefinition_importData_correctlyImportsActivityDefinition() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.inputFor([Me.activityInfo1]))

		// when
		try importer.importData(from: url)

		// then
		let expectedDefinitionInfo = Me.definitionInfo1.copy()
		expectedDefinitionInfo.recordScreenIndex = 0
		assertThat(expectedDefinitionInfo, exists(ActivityDefinition.self))
	}

	func testGivenValidDataWithNewActivityDefinitionThatContainsQuote_importData_correctlyImportsActivityDefinition() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.inputFor([Me.activityInfo2]))

		// when
		try importer.importData(from: url)

		// then
		let expectedDefinitionInfo = Me.definitionInfo2.copy()
		expectedDefinitionInfo.recordScreenIndex = 0
		assertThat(expectedDefinitionInfo, exists(ActivityDefinition.self))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.activityInfo1.startDate
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.activityInfo1, exists(Activity.self))
		assertThat(Me.activityInfo2, exists(Activity.self))
		assertThat(Me.activityInfo3, exists(Activity.self))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.activityInfo2.startDate
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.activityInfo1, exists(Activity.self))
		assertThat(Me.activityInfo2, not(exists(Activity.self)))
		assertThat(Me.activityInfo3, exists(Activity.self))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.activityInfo1, exists(Activity.self))
		assertThat(Me.activityInfo2, exists(Activity.self))
		assertThat(Me.activityInfo3, exists(Activity.self))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.activityInfo1, exists(Activity.self))
		assertThat(Me.activityInfo2, exists(Activity.self))
		assertThat(Me.activityInfo3, exists(Activity.self))
	}

	func testGivenActivityDefinitionWithNameAlreadyExists_importData_usesExistingDefinition() throws {
		// given
		let secondActivityDefinition = ActivityDefinitionInfo(
			name: Me.activityInfo1.definition.name,
			description: "this is not the same description",
			tags: [],
			source: Me.activityInfo1.definition.source,
			autoNote: !Me.activityInfo1.definition.autoNote,
			recordScreenIndex: Me.activityInfo1.definition.recordScreenIndex + 1
		)
		let secondActivity = ActivityInfo(
			definition: secondActivityDefinition,
			startDate: Date() + 3.days,
			startTimeZone: nil,
			endDate: nil,
			note: "drtsetriyktlguhoim niugh"
		)

		importer.lastImport = nil
		useInput(Me.inputFor([Me.activityInfo1, secondActivity]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.activityInfo1, exists(Activity.self))
		assertThat(
			ActivityInfo(
				definition: Me.activityInfo1.definition,
				startDate: secondActivity.startDate,
				startTimeZone: secondActivity.startTimeZone,
				endDate: secondActivity.endDate,
				endTimeZone: secondActivity.endTimeZone,
				note: secondActivity.note
			),
			exists(Activity.self))
		assertThat(secondActivity, not(exists(Activity.self)))
	}

	func testGivenUnfinishedActivityWithSameNameAndSameStartDate_importData_updatesExistingActivity() throws {
		// given
		let expectedNote = "this is a new note for the activity to be imported"
		let existingActivity = Me.activityInfo1.copy()
		existingActivity.endDate = nil
		let definitionToImport = ActivityDefinitionInfo(
			name: existingActivity.definition.name,
			description: existingActivity.definition.description,
			tags: existingActivity.definition.tags,
			source: existingActivity.definition.source,
			autoNote: existingActivity.definition.autoNote,
			recordScreenIndex: existingActivity.definition.recordScreenIndex
		)
		let activityToImport = ActivityInfo(
			definition: definitionToImport,
			startDate: existingActivity.startDate,
			startTimeZone: existingActivity.startTimeZone,
			endDate: Date() + 3.days,
			endTimeZone: TimeZone.init(abbreviation: "GMT"),
			note: expectedNote,
			tags: existingActivity.tags,
			source: existingActivity.source
		)
		createActivity(existingActivity)
		useInput(Me.inputFor([activityToImport]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(existingActivity, not(exists(Activity.self)))
		assertThat(activityToImport, exists(Activity.self))
	}

	func testGivenOtherDefinitionsCreatedOutsideOfImport_importData_doesNotAllowDuplicateRecordScreenIndexes() throws {
		ActivityDataTestUtil.createActivityDefinition(name: "definition 1", recordScreenIndex: 0)
		ActivityDataTestUtil.createActivityDefinition(name: "definition 2", recordScreenIndex: 1)
		useInput(Me.validInput)
		importer.pauseOnRecord = 3

		// when
		try importer.importData(from: url)

		ActivityDataTestUtil.createActivityDefinition(name: "definition 1 created during import", recordScreenIndex: 2)
		ActivityDataTestUtil.createActivityDefinition(name: "definition 2 created during import", recordScreenIndex: 3)

		try importer.resume()

		// then
		let definitions = try DependencyInjector.get(Database.self).query(ActivityDefinition.fetchRequest())
		let definitionIndexes = definitions.map{ d -> Int16 in d.recordScreenIndex }
		var previousIndex: Int16 = -1
		for index in definitionIndexes.sorted() {
			if index == previousIndex {
				XCTFail("Duplicate index detected: " + String(index))
			}
			previousIndex = index
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

	// MARK: Entity Creation

	@discardableResult
	private final func createActivity(_ activityInfo: ActivityInfo) -> Activity {
		let definitionTags = activityInfo.definition.tags.map{ (tagName) -> Tag in
			return TagDataTestUtil.createTag(name: tagName)
		}
		let definition = ActivityDataTestUtil.createActivityDefinition(
			name: activityInfo.definition.name,
			description: activityInfo.definition.description,
			tags: definitionTags,
			source: activityInfo.definition.source,
			recordScreenIndex: activityInfo.definition.recordScreenIndex,
			autoNote: activityInfo.definition.autoNote)
		let instanceTags: [Tag]
		if let tags = activityInfo.tags {
			instanceTags = tags.map{ (tagName) -> Tag in
				return TagDataTestUtil.createTag(name: tagName)
			}
		} else {
			instanceTags = [Tag]()
		}
		return ActivityDataTestUtil.createActivity(
			definition: definition,
			startDate: activityInfo.startDate,
			startTimeZone: activityInfo.startTimeZone,
			endDate: activityInfo.endDate,
			endTimeZone: activityInfo.endTimeZone,
			note: activityInfo.note,
			source: activityInfo.source,
			tags: instanceTags)
	}

	// MARK: Input

	private static func inputFor(_ activities: [ActivityInfo]) -> String {
		var input = Me.headerRow
		for activityInfo in activities {
			let startDateText = Me.formatter.string(from: activityInfo.startDate)
			let endDateText: String
			if let endDate = activityInfo.endDate {
				endDateText = Me.formatter.string(from: endDate)
			} else {
				endDateText = ""
			}
			input += "\n\"\(activityInfo.definition.name)\","
			input += "\"\(activityInfo.definition.description ?? "")\","
			input += getTagsString(activityInfo.definition.tags) + ","
			input += getSourceString(activityInfo.definition.source) + ","
			input += "\"\(String(activityInfo.definition.autoNote))\","
			input += "\"\(String(activityInfo.definition.recordScreenIndex))\","
			input += "\"\(startDateText)\","
			input += getTimeZoneString(activityInfo.startTimeZone) + ","
			input += "\"\(endDateText)\","
			input += getTimeZoneString(activityInfo.endTimeZone) + ","
			input += "\"\(activityInfo.note ?? "")\","
			input += getTagsString(activityInfo.tags) + ","
			input += getSourceString(activityInfo.source)
		}
		return input
	}

	private static func getTagsString(_ tags: [String]?) -> String {
		return "\"" + (tags?.joined(separator: "|") ?? "") + "\""
	}

	private static func getSourceString(_ source: Sources.ActivitySourceNum) -> String {
		return "\"" + source.description + "\""
	}

	private static func getTimeZoneString(_ timeZone: TimeZone?) -> String {
		return "\"" + (timeZone?.identifier ?? "") + "\""
	}

	// MARK: - Classes

	private class ActivityDefinitionInfo: Info {
		var name: String
		var description: String?
		var tags: [String]
		var source: Sources.ActivitySourceNum
		var autoNote: Bool
		var recordScreenIndex: Int16

		public init(
			name: String,
			description: String?,
			tags: [String],
			source: Sources.ActivitySourceNum,
			autoNote: Bool,
			recordScreenIndex: Int16
		) {
			self.name = name
			self.description = description
			self.tags = tags
			self.source = source
			self.autoNote = autoNote
			self.recordScreenIndex = recordScreenIndex
		}

		public override func getPredicates() -> [String : NSPredicate] {
			let descriptionKey = "activityDescription"
			return [
				"name": NSPredicate(format: "name ==[cd] %@", name),
				descriptionKey: self.optionalStringPredicate(for: description, fieldName: descriptionKey),
				"autoNote": NSPredicate(format: "autoNote = %d", autoNote),
				"tags": self.tagsPredicate(for: tags, fieldName: "tags"),
				"recordScreenIndex": NSPredicate(format: "recordScreenIndex == %i", recordScreenIndex),
				"source": NSPredicate(format: "source == %i", source.rawValue),
			]
		}

		public final func copy() -> ActivityDefinitionInfo {
			return ActivityDefinitionInfo(
				name: name,
				description: description,
				tags: tags,
				source: source,
				autoNote: autoNote,
				recordScreenIndex: recordScreenIndex)
		}
	}

	private class ActivityInfo: Info {
		var definition: ActivityDefinitionInfo
		var startDate: Date
		var startTimeZone: TimeZone?
		var endDate: Date?
		var endTimeZone: TimeZone?
		var note: String?
		var tags: [String]?
		var source: Sources.ActivitySourceNum

		public init(
			definition: ActivityDefinitionInfo,
			startDate: Date,
			startTimeZone: TimeZone? = nil,
			endDate: Date? = nil,
			endTimeZone: TimeZone? = nil,
			note: String? = nil,
			tags: [String]? = nil,
			source: Sources.ActivitySourceNum = .introspective
		) {
			self.definition = definition
			self.startDate = startDate
			self.startTimeZone = startTimeZone
			self.endDate = endDate
			self.endTimeZone = endTimeZone
			self.note = note
			self.tags = tags
			self.source = source
		}

		public override func getPredicates() -> [String : NSPredicate] {
			let descriptionKey = "definition.activityDescription"
			return [
				"definition.name": NSPredicate(format: "definition.name ==[cd] %@", definition.name),
				descriptionKey: self.optionalStringPredicate(for: definition.description, fieldName: descriptionKey),
				"definition.tags": self.tagsPredicate(for: definition.tags, fieldName: "definition.tags"),
				"definition.source": NSPredicate(format: "definition.source == %i", definition.source.rawValue),
				"definition.autoNote": NSPredicate(format: "definition.autoNote = %d", definition.autoNote),
				"definition.recordScreenIndex": NSPredicate(format: "definition.recordScreenIndex == %i", definition.recordScreenIndex),
				"startDate": self.datePredicateFor(fieldName: "startDate", withinOneSecondOf: startDate),
				"startDateTimeZoneId": self.timeZonePredicate(for: startTimeZone, field: "startDateTimeZoneId"),
				"endDate": self.datePredicateFor(fieldName: "endDate", withinOneSecondOf: endDate),
				"endDateTimeZoneId": self.timeZonePredicate(for: endTimeZone, field: "endDateTimeZoneId"),
				"note": self.optionalStringPredicate(for: note, fieldName: "note"),
				"tags": self.tagsPredicate(for: tags, fieldName: "tags"),
				"source": NSPredicate(format: "source == %i", source.rawValue),
			]
		}

		public final func copy() -> ActivityInfo {
			return ActivityInfo(
				definition: definition.copy(),
				startDate: startDate,
				startTimeZone: startTimeZone,
				endDate: endDate,
				endTimeZone: endTimeZone,
				note: note,
				tags: tags,
				source: source)
		}
	}
}
