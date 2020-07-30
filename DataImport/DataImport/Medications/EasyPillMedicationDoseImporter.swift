//
//  EasyPillMedicationDoseImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import CoreData
import Foundation

import Common
import DependencyInjection
import Persistence
import Samples

// sourcery: AutoMockable
public protocol EasyPillMedicationDoseImporter: MedicationImporter {}

public final class EasyPillMedicationDoseImporterImpl: NSManagedObject, EasyPillMedicationDoseImporter, CoreDataObject {
	// MARK: - Static Variables

	private typealias Me = EasyPillMedicationDoseImporterImpl

	// MARK: CoreData

	public static let entityName = "EasyPillMedicationDoseImporter"

	// MARK: Logging

	private static let log = Log()

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "medication doses"
	public final let sourceName: String = "EasyPill"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false
	public final var isCancelled: Bool = false

	private final var recordNumber: Int = -1
	private final var totalLines: Int = -1
	private final let mainTransaction = DependencyInjector.get(Database.self).transaction()
	private final var latestDate: Date!
	private final var lines = [String]()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.get(IOUtil.self).contentsOf(url)
		lines = contents.components(separatedBy: "\n")
		lines.removeFirst()
		recordNumber = 1
		totalLines = lines.count

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
		lines = []
		mainTransaction.reset()
	}

	public final func pause() {
		isPaused = true
	}

	public final func resume() throws {
		guard !isCancelled else {
			Me.log.error("Tried to resume a cancelled medicaiton dose import from EasyPill")
			return
		}
		isPaused = false
		do {
			while !lines.isEmpty {
				let line = lines.removeFirst()
				guard !isPaused && !isCancelled else { return }
				try processLine(line, latestDate: &latestDate, using: mainTransaction)
				recordNumber += 1
			}

			lastImport = latestDate
			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			Me.log.error("Failed to import medication doses from EasyPill: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String, latestDate: inout Date!, using transaction: Transaction) throws {
		let parts = line.components(separatedBy: ",")
		var medicationName = try getColumn(0, from: parts, errorMessage: "Record \(recordNumber) is empty.")
		var currentIndex = 1

		let date = try parseDate(
			from: parts,
			startingAt: &currentIndex,
			recordNumber: recordNumber,
			medicationName: &medicationName
		)

		if latestDate == nil { latestDate = date }
		if date.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = date
		}
		if shouldImport(date) {
			try storeDose(for: medicationName, withDate: date, using: transaction)
		}
	}

	private final func getColumn(_ index: Int, from parts: [String], errorMessage: String? = nil) throws -> String {
		guard parts.count > index else { throw InvalidFileFormatError(errorMessage) }
		return parts[index]
	}

	private final func parseDate(
		from parts: [String],
		startingAt currentIndex: inout Int,
		recordNumber: Int,
		medicationName: inout String
	) throws -> Date {
		var nextColumnText = ""
		var date: Date?
		while date == nil {
			nextColumnText = try getColumn(
				currentIndex,
				from: parts,
				errorMessage: "No date found for record \(recordNumber)."
			)
			date = DependencyInjector.get(CalendarUtil.self).date(from: nextColumnText, format: "M/d/yy")
			if date == nil {
				medicationName += "," + nextColumnText
			}
			currentIndex += 1
		}
		let timeText = try getColumn(
			currentIndex,
			from: parts,
			errorMessage: "No time found for record \(recordNumber)."
		)
		date = DependencyInjector.get(CalendarUtil.self)
			.date(from: nextColumnText + " " + timeText, format: "M/d/yy HH:mm")

		guard let timestamp = date else {
			throw InvalidFileFormatError("For record \(recordNumber), expected time but found '\(timeText)'")
		}
		return timestamp
	}

	private final func storeDose(
		for medicationName: String,
		withDate date: Date,
		using transaction: Transaction
	) throws {
		let childTransaction = transaction.childTransaction()
		let medicationsWithName = try medicationsNamed(medicationName, using: childTransaction)
		if medicationsWithName.isEmpty {
			throw GenericDisplayableError(
				title: "Medication does not exist",
				description: "No medications named '\(medicationName)' exist."
			)
		}

		do {
			let dose = try childTransaction.new(MedicationDose.self)
			let medication = try childTransaction.pull(savedObject: medicationsWithName[0])
			dose.medication = medication
			dose.dosage = medication.dosage
			dose.date = date
			dose.setSource(.easyPill)
			medication.addToDoses(dose)
			try childTransaction.commit()
		} catch {
			Me.log.error("Failed to create and modify medication dose: %@", errorInfo(error))
			let dateText = DependencyInjector.get(CalendarUtil.self)
				.string(for: date, dateStyle: .medium, timeStyle: .short)
			throw GenericDisplayableError(
				title: "Could not save dose",
				description: "Dose of \(medicationName) taken on \(dateText)"
			)
		}
	}

	private final func medicationsNamed(
		_ medicationName: String,
		using transaction: Transaction
	) throws -> [Medication] {
		let medicationsWithNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", medicationName)
		do {
			return try transaction.query(medicationsWithNameFetchRequest)
		} catch {
			Me.log.error("Failed to check for existing medications named '%@': %@", medicationName, errorInfo(error))
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for medication named \(medicationName)."
			)
		}
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
