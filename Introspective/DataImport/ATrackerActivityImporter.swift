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
import os

//sourcery: AutoMockable
public protocol ATrackerActivityImporter: Importer {}

public final class ATrackerActivityImporterImpl: NSManagedObject, ATrackerActivityImporter, CoreDataObject {

	public static let entityName = "ATrackerActivityImporter"

	public final let dataTypePluralName: String = "activity"
	public final let sourceName: String = "ATracker"
	public final var importOnlyNewData: Bool = true

	private final var lineNumber: Int = -1

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		let csv = try CSVReader(string: contents, hasHeaderRow: true)
		var createdActivities = [Activity]()
		var createdDefinitions = [ActivityDefinition]()
		lineNumber = 2
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		do {
			while csv.next() != nil {
				try importActivity(from: csv, latestDate: &latestDate, &createdActivities, &createdDefinitions)
				lineNumber += 1
			}
		} catch {
			os_log("Deleting created activities due to error: %@", error.localizedDescription)
			// db.deleteAll() can fail and throw because batch deletes don't
			// update relationships according to delete rule before end of transaction
			for activity in createdActivities {
				DependencyInjector.db.delete(activity)
			}
			for definition in createdDefinitions {
				DependencyInjector.db.delete(definition)
			}

			throw error
		}

		lastImport = latestDate
		DependencyInjector.db.save()
	}

	public func resetLastImportDate() {
		lastImport = nil
		DependencyInjector.db.save()
	}

	// MARK: - Helper Functions

	/// - Returns: `nil` if no new Activity object was created, otherwise the newly created activityObject
	private final func importActivity(
		from csv: CSVReader,
		latestDate: inout Date!,
		_ createdActivities: inout [Activity],
		_ createdDefinitions: inout [ActivityDefinition])
	throws {
		var definition: ActivityDefinition! = try retrieveExistingDefinition(from: csv)
		if definition == nil {
			definition = try createDefinition(from: csv)
			createdDefinitions.append(definition)
		}

		let startDate: Date = try getStartDate(from: csv)
		if latestDate == nil { latestDate = startDate }
		if startDate.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = startDate
		}

		if let activity = try unfinishedActivity(at: startDate, for: definition) {
			try update(activity, from: csv)
		} else if shouldImport(startDate) {
			let activity = try createActivity(for: definition, startingAt: startDate, from: csv)
			createdActivities.append(activity)
		}
	}

	private final func getStartDate(from csv: CSVReader) throws -> Date {
		if let startDateText = csv[" Start time"] {
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
		if let endDateText = csv[" End time"] {
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
		activity.note = csv[" Note"]
		DependencyInjector.db.save()
	}

	private final func retrieveExistingDefinition(from csv: CSVReader) throws -> ActivityDefinition? {
		guard let name = csv["Task name"] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		let matchingActivities = try DependencyInjector.db.query(fetchRequest)
		if matchingActivities.count > 0 {
			return matchingActivities[0]
		}
		return nil
	}

	private final func createDefinition(from csv: CSVReader) throws -> ActivityDefinition {
		guard let name = csv["Task name"] else { throw InvalidFileFormatError("No name given for activity on line \(lineNumber)")}
		let description = csv[" Task description"]
		let category = csv[" Category"]

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
		DependencyInjector.db.save()
		return definition
	}

	private final func createActivity(for definition: ActivityDefinition, startingAt start: Date, from csv: CSVReader) throws -> Activity {
		let activity = try DependencyInjector.db.new(Activity.self)
		activity.definition = try DependencyInjector.db.pull(savedObject: definition, fromSameContextAs: activity)
		activity.startDate = start
		activity.endDate = try getEndDate(from: csv)
		activity.note = csv[" Note"]
		activity.setSource(.aTracker)
		DependencyInjector.db.save()
		return activity
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
