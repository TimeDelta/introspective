//
//  EasyPillMedicationDoseImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 10/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import os

//sourcery: AutoMockable
public protocol EasyPillMedicationDoseImporter: Importer {}

public final class EasyPillMedicationDoseImporterImpl: NSManagedObject, EasyPillMedicationDoseImporter, CoreDataObject {

	public static let entityName = "EasyPillMedicationDoseImporter"

	public final let dataTypePluralName: String = "medication doses"
	public final let sourceName: String = "EasyPill"
	public final var importOnlyNewData: Bool = true

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		var lineNumber = 2
		var latestDate: Date! = lastImport // use temp var to avoid bug where initial import doesn't import anything
		for line in contents.components(separatedBy: "\n")[1...] {
			let parts = line.components(separatedBy: ",")
			var medicationName = try getColumn(0, from: parts, errorMessage: "Line \(lineNumber) is empty.")
			var currentIndex = 1

			let date = try parseDate(from: parts, startingAt: &currentIndex, lineNumber: lineNumber, medicationName: &medicationName)

			if latestDate == nil { latestDate = date }
			if date.isAfterDate(latestDate, granularity: .nanosecond) {
				latestDate = date
			}
			if shouldImport(date) {
				try storeDose(for: medicationName, withDate: date)
			}

			lineNumber += 1
		}
		lastImport = latestDate
		DependencyInjector.db.save()
	}

	public final func resetLastImportDate() {
		lastImport = nil
		DependencyInjector.db.save()
	}

	// MARK: - Helper Functions

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

	private final func storeDose(for medicationName: String, withDate date: Date) throws {
		let medicationsWithNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", medicationName)
		let medicationsWithName: [Medication]
		do {
			medicationsWithName = try DependencyInjector.db.query(medicationsWithNameFetchRequest)
		} catch {
			os_log("Failed to check for existing medications named '%@': %@", type: .error, medicationName, error.localizedDescription)
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for medication named \(medicationName).")
		}

		if medicationsWithName.count == 0 {
			throw GenericDisplayableError(
				title: "Medication does not exist",
				description: "No medications named '\(medicationName)' exist.")
		}

		let dose = DependencyInjector.sample.medicationDose()
		do {
			let medication = try DependencyInjector.db.pull(savedObject: medicationsWithName[0], fromSameContextAs: dose)
			dose.medication = medication
			dose.timestamp = date
			medication.addToDoses(dose)
			DependencyInjector.db.save()
		} catch {
			os_log("Failed to pull medication into same context as dose: %@", type: .error, error.localizedDescription)
			let dateText = DependencyInjector.util.calendar.string(for: date, inFormat: "M/d/yy 'at' H:mm")
			throw GenericDisplayableError(
				title: "Could not save dose",
				description: "Dose of \(medicationName) taken on \(dateText)")
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
