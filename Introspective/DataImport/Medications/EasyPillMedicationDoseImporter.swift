//
//  EasyPillMedicationDoseImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

//sourcery: AutoMockable
public protocol EasyPillMedicationDoseImporter: Importer {}

public final class EasyPillMedicationDoseImporterImpl: NSManagedObject, EasyPillMedicationDoseImporter, CoreDataObject {

	// MARK: - Static Variables

	public static let entityName = "EasyPillMedicationDoseImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "medication doses"
	public final let sourceName: String = "EasyPill"
	public final var importOnlyNewData: Bool = true

	private final var lineNumber: Int = -1
	private final let log = Log()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		lineNumber = 2
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		do {
			let transaction = DependencyInjector.db.transaction()
			for line in contents.components(separatedBy: "\n")[1...] {
				try processLine(line, latestDate: &latestDate, using: transaction)
				lineNumber += 1
			}
			lastImport = latestDate
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import medication doses from EasyPill: %@", errorInfo(error))
			throw error
		}
	}

	public final func resetLastImportDate() throws {
		let transaction = DependencyInjector.db.transaction()
		lastImport = nil
		try retryOnFail({ try transaction.commit() }, maxRetries: 2)
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String, latestDate: inout Date!, using transaction: Transaction) throws {
		let parts = line.components(separatedBy: ",")
		var medicationName = try getColumn(0, from: parts, errorMessage: "Line \(lineNumber) is empty.")
		var currentIndex = 1

		let date = try parseDate(from: parts, startingAt: &currentIndex, lineNumber: lineNumber, medicationName: &medicationName)

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

	private final func parseDate(from parts: [String], startingAt currentIndex: inout Int, lineNumber: Int, medicationName: inout String) throws -> Date {
		var nextColumnText = ""
		var date: Date? = nil
		while date == nil {
			nextColumnText = try getColumn(currentIndex, from: parts, errorMessage: "No date found on line \(lineNumber).")
			date = DependencyInjector.util.calendar.date(from: nextColumnText, format: "M/d/yy")
			if date == nil {
				medicationName += "," + nextColumnText
			}
			currentIndex += 1
		}
		let timeText = try getColumn(currentIndex, from: parts, errorMessage: "No time found on line \(lineNumber).")
		date = DependencyInjector.util.calendar.date(from: nextColumnText + " " + timeText, format: "M/d/yy HH:mm")

		guard let timestamp = date else { throw InvalidFileFormatError("On line \(lineNumber), expected time but found '\(timeText)'") }
		return timestamp
	}

	private final func storeDose(for medicationName: String, withDate date: Date, using transaction: Transaction) throws {
		let childTransaction = transaction.childTransaction()
		let medicationsWithName = try medicationsNamed(medicationName, using: childTransaction)
		if medicationsWithName.count == 0 {
			throw GenericDisplayableError(
				title: "Medication does not exist",
				description: "No medications named '\(medicationName)' exist.")
		}

		do {
			let dose = try childTransaction.new(MedicationDose.self)
			let medication = try childTransaction.pull(savedObject: medicationsWithName[0])
			dose.medication = medication
			dose.date = date
			dose.setSource(.easyPill)
			medication.addToDoses(dose)
			try childTransaction.commit()
		} catch {
			log.error("Failed to create and modify medication dose: %@", errorInfo(error))
			let dateText = DependencyInjector.util.calendar.string(for: date, dateStyle: .medium, timeStyle: .short)
			throw GenericDisplayableError(
				title: "Could not save dose",
				description: "Dose of \(medicationName) taken on \(dateText)")
		}
	}

	private final func medicationsNamed(_ medicationName: String, using transaction: Transaction) throws -> [Medication] {
		let medicationsWithNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", medicationName)
		do {
			return try transaction.query(medicationsWithNameFetchRequest)
		} catch {
			log.error("Failed to check for existing medications named '%@': %@", medicationName, errorInfo(error))
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for medication named \(medicationName).")
		}
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
