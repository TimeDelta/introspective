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
public protocol WellnessMoodImporter: MoodImporter {}

public final class WellnessMoodImporterImpl: NSManagedObject, WellnessMoodImporter, CoreDataObject {

	private typealias Me = WellnessMoodImporterImpl
	public static let entityName = "WellnessMoodImporter"
	private static let dateRegex = "^\\d\\d?/\\d\\d?/\\d\\d, \\d\\d:\\d\\d"

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Wellness"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false

	private final var currentMood: Mood? = nil
	private final var lineNumber: Int = -1
	private final let mainTransaction = DependencyInjector.db.transaction()
	private final var lines = [String]()
	private final var latestDate: Date!
	private final var currentNote = ""

	private final let log = Log()

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		lines = contents.components(separatedBy: "\n")
		lines.removeFirst()
		currentMood = nil
		lineNumber = 2
		currentNote = ""
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
		isPaused = false
		do {
			while lines.count > 0 {
				let line = lines.removeFirst()
				try processLine(line, latestDate: &latestDate, using: mainTransaction)
				lineNumber += 1
			}
			if !currentNote.isEmpty {
				currentMood?.note = currentNote // make sure to save the final note
			}
			lastImport = latestDate
			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import moods from Wellness: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String, latestDate: inout Date!, using transaction: Transaction) throws {
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
				try createAndScaleMood(withDate: date, andRating: rating, using: transaction)
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

	private final func createAndScaleMood(withDate date: Date, andRating rating: Double, using transaction: Transaction) throws {
		currentMood = try transaction.new(MoodImpl.self)
		currentMood!.date = date
		currentMood!.minRating = 1
		currentMood!.maxRating = 7
		currentMood!.rating = rating
		currentMood!.setSource(.wellness)
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
