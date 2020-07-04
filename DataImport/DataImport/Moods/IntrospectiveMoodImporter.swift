//
//  IntrospectiveMoodImporter.swift
//  DataImport
//
//  Created by Bryan Nova on 6/2/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import CoreData
import CSV
import Foundation

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

// sourcery: AutoMockable
public protocol IntrospectiveMoodImporter: MoodImporter {}

public final class IntrospectiveMoodImporterImpl: NSManagedObject, IntrospectiveMoodImporter, CoreDataObject {
	// MARK: - Static Variables

	private typealias Me = IntrospectiveMoodImporterImpl

	public static let entityName = "IntrospectiveMoodImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "moods"
	public final let sourceName: String = "Introspective"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false
	public final var isCancelled: Bool = false

	/// for testing purposes only
	public final var pauseOnRecord: Int?

	private final var recordNumber: Int = -1
	private final var totalLines: Int = -1
	private final let mainTransaction = DependencyInjector.get(Database.self).transaction()
	private final var csv: CSVReader!
	private final var latestDate: Date!

	private final let log = Log()

	// MARK: - Main Functions

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
			log.error("Tried to resume a cancelled mood import from Introspective")
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
			log.error("Failed to import moods from Introspective: %@", errorInfo(error))
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
			guard let rating = Double(csv[MoodImpl.ratingColumn] ?? "") else {
				throw InvalidFileFormatError(
					"Invalid rating for record \(recordNumber): \(csv[MoodImpl.ratingColumn] ?? "")"
				)
			}
			var note = csv[MoodImpl.noteColumn]
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
		using transaction: Transaction
	)
		throws {
		let currentMood = try transaction.new(MoodImpl.self)

		guard let minRatingString = csv[MoodImpl.minRatingColumn] else {
			throw MissingRequiredFieldError(MoodImpl.minRatingColumn, recordNumber: recordNumber)
		}
		guard let minRating = Double(minRatingString) else {
			throw InvalidFileFormatError("Incorrectly formatted minimum rating for record \(recordNumber)")
		}
		currentMood.minRating = minRating

		guard let maxRatingString = csv[MoodImpl.maxRatingColumn] else {
			throw MissingRequiredFieldError(MoodImpl.maxRatingColumn, recordNumber: recordNumber)
		}
		guard let maxRating = Double(maxRatingString) else {
			throw InvalidFileFormatError("Incorrectly formatted maximum rating for record \(recordNumber)")
		}
		currentMood.maxRating = maxRating

		currentMood.date = date
		currentMood.rating = rating
		currentMood.note = note
		currentMood.setSource(try getSource())
		currentMood.timeZone = getTimeZone()
		if DependencyInjector.get(Settings.self).scaleMoodsOnImport {
			DependencyInjector.get(MoodUtil.self).scaleMood(currentMood)
		}
	}

	private final func getSource() throws -> Sources.MoodSourceNum {
		guard let sourceString = csv[MoodImpl.sourceColumn] else {
			throw MissingRequiredFieldError(MoodImpl.sourceColumn, recordNumber: recordNumber)
		}
		guard let source = Sources.resolveMoodSource(sourceString) else {
			throw InvalidFileFormatError("Invalid value provided for source of record \(recordNumber)")
		}
		return source
	}

	private final func getTimeZone() -> TimeZone? {
		if let timeZoneIdentifier = csv[MoodImpl.timeZoneColumn] {
			return TimeZone(identifier: timeZoneIdentifier)
		}
		return nil
	}

	private final func getDateForCurrentRecord() throws -> Date {
		guard let dateString = csv[MoodImpl.timestampColumn] else {
			let currentLine = csv.currentRow?.joined(separator: ",") ?? ""
			throw InvalidFileFormatError("No timestamp for record \(recordNumber): \(currentLine)")
		}
		guard let date = DependencyInjector.get(CalendarUtil.self)
			.date(from: dateString, dateStyle: .full, timeStyle: .full) else {
			throw InvalidFileFormatError("Invalid date / time format for record \(recordNumber).")
		}
		return date
	}

	private final func string(_ str: String, matches regex: String) -> Bool {
		str.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}

	private final func shouldImport(_ date: Date) -> Bool {
		!importOnlyNewData || // user doesn't care about data duplication -> import everything
			lastImport == nil || ( // never imported before -> import everything
				importOnlyNewData &&
					lastImport != nil &&
					date.isAfterDate(lastImport!, granularity: .nanosecond)
			)
	}
}

// MARK: - CoreData stuff

public extension IntrospectiveMoodImporterImpl {
	@nonobjc class func fetchRequest() -> NSFetchRequest<IntrospectiveMoodImporterImpl> {
		NSFetchRequest<IntrospectiveMoodImporterImpl>(entityName: "IntrospectiveMoodImporter")
	}

	@NSManaged var lastImport: Date?
}
