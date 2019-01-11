//
//  WellnessMoodImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 9/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

//sourcery: AutoMockable
public protocol WellnessMoodImporter: Importer {}

public final class WellnessMoodImporterImpl: NSManagedObject, WellnessMoodImporter, CoreDataObject {

	private typealias Me = WellnessMoodImporterImpl
	public static let entityName = "WellnessMoodImporter"
	private static let dateRegex = "^\\d\\d?/\\d\\d?/\\d\\d, \\d\\d:\\d\\d"
	private static let cancelImports = Notification.Name("cancelWellnessMoodImporter")

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Wellness"
	public final var importOnlyNewData: Bool = true

	private final var currentMood: Mood? = nil
	private final var lineNumber: Int = -1
	private final var currentNote = ""

	private final let log = Log()

	private final var cancelled = false
	private final var processingLine = false

	private final let uuid = UUID()

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		currentMood = nil
		lineNumber = 2
		currentNote = ""
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		do {
			for line in contents.components(separatedBy: "\n")[1...] {
				if cancelled { return }
				try processLine(line, latestDate: &latestDate)
				lineNumber += 1
			}
			if !currentNote.isEmpty {
				currentMood?.note = currentNote // make sure to save the final note
			}
			lastImport = latestDate
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)

			log.info("Cleaning up mood import")
			try DependencyInjector.util.importer.cleanUpImportedData(forType: MoodImpl.self)
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
		} catch {
			log.error("Failed to import moods from Wellness: %@", errorInfo(error))
			do {
				try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: MoodImpl.fetchRequest())
			} catch {
				log.error("Failed to delete moods from current import: %@", errorInfo(error))
			}

			throw error
		}
	}

	public final func cancel() {
		cancelled = true
		do {
			try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: MoodImpl.fetchRequest())
		} catch {
			log.error("Failed to delete moods from current import on cancel: %@", errorInfo(error))
		}
	}

	public final func resetLastImportDate() throws {
		lastImport = nil
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	public final func equalTo(_ otherImporter: Importer) -> Bool {
		guard let other = otherImporter as? WellnessMoodImporterImpl else { return false }
		return uuid == other.uuid
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String, latestDate: inout Date!) throws {
		if string(line, matches: Me.dateRegex) { // new mood record
			if !currentNote.isEmpty {
				currentMood?.note = currentNote
			}
			let parts = line.components(separatedBy: ",")
			guard let date = DependencyInjector.util.calendar.date(from: parts[0...1].joined(), format: "M/d/yy HH:mm") else {
				throw InvalidFileFormatError("Unexpected date / time on line \(lineNumber): \(parts[0...1].joined())")
			}
			if latestDate == nil { latestDate = date }
			if date.isAfterDate(latestDate, granularity: .nanosecond) {
				latestDate = date
			}
			if shouldImport(date) {
				guard let rating = Double(parts[2]) else {
					throw InvalidFileFormatError("Invalid rating on line \(lineNumber): \(parts[2])")
				}
				if cancelled { return }
				try createAndScaleMood(withDate: date, andRating: rating)
				currentNote = parts[3...].joined()
			} else {
				currentMood = nil
			}
		} else if lineNumber == 2 { // first non-header row
			throw InvalidFileFormatError("Invalid or missing date / time for mood on line 2")
		} else {
			if !currentNote.isEmpty {
				currentNote += "\n"
			}
			currentNote += line
		}
	}

	private final func createAndScaleMood(withDate date: Date, andRating rating: Double) throws {
		currentMood = try DependencyInjector.sample.mood()
		currentMood!.timestamp = date
		currentMood!.minRating = 1
		currentMood!.maxRating = 7
		currentMood!.rating = rating
		currentMood!.setSource(.wellness)
		currentMood!.partOfCurrentImport = true
		if DependencyInjector.settings.scaleMoodsOnImport {
			DependencyInjector.util.mood.scaleMood(currentMood!)
		}
	}

	private final func string(_ str: String, matches regex: String) -> Bool {
		return str.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
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
