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
public protocol ATrackerActivityImporter: Importer {}

public final class ATrackerActivityImporterImpl: NSManagedObject, ATrackerActivityImporter, CoreDataObject {

	// MARK: - Static Variables

	private typealias Me = ATrackerActivityImporterImpl
	private static let nameColumn = "Task name"
	private static let descriptionColumn = " Task description"
	private static let startDateColumn = " Start time"
	private static let endDateColumn = " End time"
	private static let noteColumn = " Note"
	private static let categoryColumn = " Category"

	public static let entityName = "ATrackerActivityImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "activity"
	public final let sourceName: String = "ATracker"
	public final var importOnlyNewData: Bool = true

	private final var lineNumber: Int = -1
	private final let log = Log()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		let csv = try DependencyInjector.util.io.csvReader(url: url, hasHeaderRow: true)
		lineNumber = 2
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		do {
			while csv.next() != nil {
				try importActivity(from: csv, latestDate: &latestDate)
				lineNumber += 1
				let _ = csv.dropFirst()
			}

			lastImport = latestDate
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)

			log.info("Cleaning up Activity import")
			try DependencyInjector.util.importer.cleanUpImportedData(forType: ActivityDefinition.self)
			try DependencyInjector.util.importer.cleanUpImportedData(forType: Activity.self)
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
		} catch {
			log.error("Failed to import activities from ATracker: %@", errorInfo(error))
			do {
				try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: ActivityDefinition.fetchRequest())
				try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: Activity.fetchRequest())
			} catch {
				log.error("Failed to delete activities / definitions from current import: %@", errorInfo(error))
			}

			throw error
		}
	}

	public func resetLastImportDate() throws {
		lastImport = nil
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	// MARK: - Helper Functions

	/// - Returns: `nil` if no new Activity object was created, otherwise the newly created activityObject
	private final func importActivity(from csv: CSVReader, latestDate: inout Date!) throws {
		var definition: ActivityDefinition! = try retrieveExistingDefinition(from: csv)
		if definition == nil {
			definition = try createDefinition(from: csv)
		}

		let startDate: Date = try getStartDate(from: csv)
		if latestDate == nil { latestDate = startDate }
		if startDate.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = startDate
		}

		if let activity = try unfinishedActivity(at: startDate, for: definition) {
			try update(activity, from: csv)
		} else if shouldImport(startDate) {
			try createActivity(for: definition, startingAt: startDate, from: csv)
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
		activity.endDate = try getEndDate(from: csv)
		activity.note = csv[Me.noteColumn]
	}

	private final func retrieveExistingDefinition(from csv: CSVReader) throws -> ActivityDefinition? {
		guard let name = csv[Me.nameColumn] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let matchingActivities = try DependencyInjector.db.query(fetchRequest)
		if matchingActivities.count > 0 {
			return matchingActivities[0]
		}
		return nil
	}

	private final func createDefinition(from csv: CSVReader) throws -> ActivityDefinition {
		guard let name = csv[Me.nameColumn] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let description = csv[Me.descriptionColumn]
		let category = csv[Me.categoryColumn]

		let definition = try DependencyInjector.db.new(ActivityDefinition.self)
		definition.name = name
		definition.activityDescription = description
		if let tagName = category {
			let tag = try createOrRetrieveTag(named: tagName, for: definition)
			definition.addToTags(tag)
		}
		let allDefinitions = try DependencyInjector.db.query(ActivityDefinition.fetchRequest())
		definition.recordScreenIndex = Int16(allDefinitions.count)
		definition.setSource(.aTracker)
		definition.partOfCurrentImport = true
		return definition
	}

	private final func createActivity(for definition: ActivityDefinition, startingAt start: Date, from csv: CSVReader) throws {
		let activity = try DependencyInjector.db.new(Activity.self)
		activity.definition = try DependencyInjector.db.pull(savedObject: definition, fromSameContextAs: activity)
		activity.startDate = start
		activity.endDate = try getEndDate(from: csv)
		activity.note = csv[Me.noteColumn]
		activity.setSource(.aTracker)
		activity.partOfCurrentImport = true
	}

	private final func createOrRetrieveTag(named tagName: String, for definition: ActivityDefinition) throws -> Tag {
		let tagRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
		tagRequest.predicate = NSPredicate(format: "name ==[cd] %@", tagName)
		let matchingTags = try DependencyInjector.db.query(tagRequest)
		let tag: Tag
		if matchingTags.count > 0 {
			tag = try DependencyInjector.db.pull(savedObject: matchingTags[0], fromSameContextAs: definition)
		} else {
			tag = try DependencyInjector.db.new(Tag.self)
			tag.name = tagName
		}
		return tag
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
}
