//
//  ATrackerActivityImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 12/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import CSV

//sourcery: AutoMockable
public protocol ATrackerActivityImporter: ActivityImporter {}

public final class ATrackerActivityImporterImpl: NSManagedObject, ATrackerActivityImporter, CoreDataObject {

	// MARK: - Static Variables

	private typealias Me = ATrackerActivityImporterImpl
	private static let nameColumn = "Task name"
	private static let descriptionColumn = " Task description"
	private static let startDateColumn = " Start time"
	private static let endDateColumn = " End time"
	private static let noteColumn = " Note"
	private static let tagsColumn = " Tag"

	public static let entityName = "ATrackerActivityImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "activities"
	public final let sourceName: String = "ATracker"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false

	/// for testing purposes only
	public final var pauseOnLine: Int?

	private final var lineNumber: Int = -1
	private final let mainTransaction = DependencyInjector.db.transaction()
	private final var csv: CSVReader!
	private final var latestDate: Date!
	private final let log = Log()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		csv = try DependencyInjector.util.io.csvReader(url: url, hasHeaderRow: true)
		lineNumber = 2
		latestDate = lastImport // use temp var to avoid bug where initial import doesn't import anything
		try resume()
	}

	public final func resetLastImportDate() throws {
		let transaction = DependencyInjector.db.transaction()
		lastImport = nil
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
	}

	public final func pause() {
		isPaused = true
	}

	public final func resume() throws {
		// without this, pausing and returning skips a line
		var currentRow: [String]? = []
		if !isPaused { currentRow = csv.next() }
		isPaused = false
		do {
			while currentRow != nil {
				guard pauseOnLine != lineNumber else {
					pause()
					pauseOnLine = nil
					return
				}
				guard !isPaused else { return }
				try importActivity(from: csv, latestDate: &latestDate, using: mainTransaction)
				lineNumber += 1
				currentRow = csv.next()
			}

			try correctRecordScreenIndices()

			lastImport = latestDate
			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import activities from ATracker: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func importActivity(from csv: CSVReader, latestDate: inout Date!, using transaction: Transaction) throws {
		var definition: ActivityDefinition! = try retrieveExistingDefinition(from: csv, using: transaction)
		if definition == nil {
			definition = try createDefinition(from: csv, using: transaction)
		}

		let startDate: Date = try getStartDate(from: csv)
		if latestDate == nil { latestDate = startDate }
		if startDate.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = startDate
		}

		if let activity = try unfinishedActivity(at: startDate, for: definition) {
			try update(activity, from: csv)
		} else if shouldImport(startDate) {
			try createActivity(for: definition, startingAt: startDate, from: csv, using: transaction)
		}
	}

	private final func getStartDate(from csv: CSVReader) throws -> Date {
		if let startDateText = csv[Me.startDateColumn] {
			if let startDate = DependencyInjector.util.calendar.date(from: startDateText, format: "YYYY-MM-dd HH:mm") {
				return startDate
			} else {
				throw InvalidFileFormatError("Invalid format for start date / time on line \(lineNumber).")
			}
		} else {
			throw InvalidFileFormatError("Missing start date / time on line \(lineNumber).")
		}
	}

	private final func getEndDate(from csv: CSVReader) throws -> Date?  {
		if let endDateText = csv[Me.endDateColumn] {
			if !endDateText.isEmpty {
				if let endDate = DependencyInjector.util.calendar.date(from: endDateText, format: "YYYY-MM-dd HH:mm") {
					return endDate
				}
				throw InvalidFileFormatError("Invalid format for end date / time on line \(lineNumber).")
			}
		}
		return nil
	}

	private final func update(_ activity: Activity, from csv: CSVReader) throws {
		activity.end = try getEndDate(from: csv)
		activity.note = csv[Me.noteColumn]
	}

	private final func retrieveExistingDefinition(from csv: CSVReader, using transaction: Transaction) throws -> ActivityDefinition? {
		guard let name = csv[Me.nameColumn] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		// query from the transaction to include definitions created in this import
		let matchingActivities = try transaction.query(fetchRequest)
		if matchingActivities.count > 0 {
			return matchingActivities[0]
		}
		return nil
	}

	private final func createDefinition(from csv: CSVReader, using transaction: Transaction) throws -> ActivityDefinition {
		guard let name = csv[Me.nameColumn] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let description = csv[Me.descriptionColumn]
		let tagNames = csv[Me.tagsColumn]?.split(separator: "|")

		let childTransaction = transaction.childTransaction()

		let definition = try childTransaction.new(ActivityDefinition.self)
		definition.name = name
		definition.activityDescription = description
		if let tagNames = tagNames {
			for tagName in tagNames {
				let trimmedTagName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
				if !tagName.isEmpty {
					let tag = try createOrRetrieveTag(named: trimmedTagName, for: definition, using: childTransaction)
					definition.addToTags(tag)
				}
			}
		}
		let allDefinitions = try getAllActivityDefinitions(using: childTransaction)
		definition.recordScreenIndex = Int16(allDefinitions.count)
		definition.setSource(.aTracker)

		try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)
		return try transaction.pull(savedObject: definition)
	}

	private final func createActivity(
		for definition: ActivityDefinition,
		startingAt start: Date,
		from csv: CSVReader,
		using transaction: Transaction)
	throws {
		let childTransaction = transaction.childTransaction()
		let activity = try childTransaction.new(Activity.self)
		activity.definition = try childTransaction.pull(savedObject: definition)
		activity.start = start
		activity.end = try getEndDate(from: csv)
		activity.note = csv[Me.noteColumn]
		activity.setSource(.aTracker)
		try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)
	}

	private final func createOrRetrieveTag(
		named tagName: String,
		for definition: ActivityDefinition,
		using transaction: Transaction)
	throws -> Tag {
		let tagRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		tagRequest.predicate = NSPredicate(format: "name ==[cd] %@", tagName)
		let matchingTags = try transaction.query(tagRequest)
		let tag: Tag
		if matchingTags.count > 0 {
			tag = try DependencyInjector.db.pull(savedObject: matchingTags[0], fromSameContextAs: definition)
		} else {
			let childTransaction = transaction.childTransaction()
			tag = try childTransaction.new(Tag.self)
			tag.name = tagName
			try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)
		}
		return try transaction.pull(savedObject: tag)
	}

	private final func unfinishedActivity(at startDate: Date, for definition: ActivityDefinition) throws -> Activity? {
		let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
		fetchRequest.predicate = NSPredicate(
			format: "definition.name ==[cd] %@ AND startDate == startDate AND endDate == nil",
			definition.name,
			startDate as NSDate)
		let unfinishedActivities = try DependencyInjector.db.query(fetchRequest)
		if unfinishedActivities.count > 0 {
			return unfinishedActivities[0]
		}
		return nil
	}

	private final func shouldImport(_ date: Date) -> Bool {
		return !importOnlyNewData || // user doesn't care about data duplication -> import everything
			lastImport == nil || (   // never imported before -> import everything
				importOnlyNewData &&
				lastImport != nil &&
				date.isAfterDate(lastImport!, granularity: .nanosecond)
			)
	}

	private final func correctRecordScreenIndices() throws {
		let definitions = try getAllActivityDefinitions(using: mainTransaction).sorted(by: {
			$0.recordScreenIndex < $1.recordScreenIndex || ($0.getSource() == .introspective && $1.getSource() != .introspective)
		})
		var index = 0
		for var definition in definitions {
			definition = try mainTransaction.pull(savedObject: definition)
			definition.recordScreenIndex = Int16(index)
			index += 1
		}
	}

	private final func getAllActivityDefinitions(using transaction: Transaction) throws -> Set<ActivityDefinition> {
		let definitionsInTransaction = Set(try transaction.query(ActivityDefinition.fetchRequest()))
		let definitionsInMainContext = Set(try DependencyInjector.db.query(ActivityDefinition.fetchRequest())).filter({
			let id = $0.objectID
			return !definitionsInTransaction.contains(where: { def in def.objectID == id})
		})
		return definitionsInTransaction.union(definitionsInMainContext)
	}
}
