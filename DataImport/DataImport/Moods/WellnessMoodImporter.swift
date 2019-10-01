//
//  WellnessMoodImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 9/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import CSV

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

//sourcery: AutoMockable
public protocol WellnessMoodImporter: MoodImporter {}

public final class WellnessMoodImporterImpl: NSManagedObject, WellnessMoodImporter, CoreDataObject {

	private typealias Me = WellnessMoodImporterImpl
	public static let entityName = "WellnessMoodImporter"
	private static let dateColumn = "Date"
	private static let timeColumn = "Time"
	private static let ratingColumn = "Rating"
	private static let noteColumn = "Note"

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Wellness"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false
	public final var isCancelled: Bool = false

	private final var recordNumber: Int = -1
	private final var totalLines: Int = -1
	private final let mainTransaction = DependencyInjector.get(Database.self).transaction()
	private final var csv: CSVReader!
	private final var latestDate: Date!

	private final let log = Log()

	public final func importData(from url: URL) throws {
		csv = try DependencyInjector.get(IOUtil.self).csvReader(url: url, hasHeaderRow: true)
		recordNumber = 1
		// a rough approximation
		totalLines = try DependencyInjector.get(IOUtil.self).contentsOf(url).split(separator: "\n").count

		isPaused = false
		isCancelled = false

		latestDate = lastImport // use temp var to avoid bug where initial import doesn't import anything

		try resume()
	}

	public final func resetLastImportDate() throws {
		let transaction = DependencyInjector.get(Database.self).transaction()
		lastImport = nil
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
	}

	public func percentComplete() -> Double {
		if totalLines == 0 { return 1 } // avoid division by 0
		if totalLines == -1 { return 0 }
		// don't count the header row in percent complete calculation
		// also, note that this is an underestimate because
		// the number of lines is >= the number of records
		return Double(recordNumber) / Double(totalLines - 1)
	}

	public final func cancel() {
		isCancelled = true
		mainTransaction.reset()
	}

	public final func pause() {
		isPaused = true
	}

	public final func resume() throws {
		guard !isCancelled else {
			log.error("Tried to resume a cancelled mood import from Wellness")
			return
		}

		// without this, pausing and returning skips a line
		var currentRow: [String]? = []
		if !isPaused { currentRow = csv.next() }
		isPaused = false
		do {
			while currentRow != nil {
				guard !isPaused && !isCancelled else { return }
				try processLine(latestDate: &latestDate, using: mainTransaction)
				recordNumber += 1
				currentRow = csv.next()
			}
			lastImport = latestDate
			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import moods from Wellness: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func processLine(latestDate: inout Date!, using transaction: Transaction) throws {
		let date = try getDateForCurrentRecord()
		if latestDate == nil { latestDate = date }
		if date.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = date
		}
		if shouldImport(date) {
			guard let rating = Double(csv[Me.ratingColumn] ?? "") else {
				throw InvalidFileFormatError("Invalid rating for record \(recordNumber): \(csv[Me.ratingColumn] ?? "")")
			}
			var note = csv[Me.noteColumn]
			if note?.isEmpty ?? false {
				note = nil
			}
			try createAndScaleMood(withDate: date, rating: rating, andNote: note, using: transaction)
		}
	}

	private final func createAndScaleMood(
		withDate date: Date,
		rating: Double,
		andNote note: String?,
		using transaction: Transaction)
	throws {
		let currentMood = try transaction.new(MoodImpl.self)
		currentMood.date = date
		currentMood.minRating = 1
		currentMood.maxRating = 7
		currentMood.rating = rating
		currentMood.note = note
		currentMood.setSource(.wellness)
		if DependencyInjector.get(Settings.self).scaleMoodsOnImport {
			DependencyInjector.get(MoodUtil.self).scaleMood(currentMood)
		}
	}

	private final func getDateForCurrentRecord() throws -> Date {
		let currentLine = csv.currentRow?.joined(separator: ",") ?? ""
		guard let dateString = csv[Me.dateColumn] else {
			throw InvalidFileFormatError(
				"No date for record \(recordNumber): \(currentLine)")
		}
		guard let timeString = csv[Me.timeColumn] else {
			throw InvalidFileFormatError(
				"No time for record \(recordNumber): \(currentLine)")
		}
		guard let date = DependencyInjector.get(CalendarUtil.self).date(from: dateString + timeString, format: "M/d/yy HH:mm") else {
			throw InvalidFileFormatError("Unexpected date / time for record \(recordNumber): \(dateString + timeString)")
		}
		return date
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
