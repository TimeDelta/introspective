//
//  EasyPillMedicationImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

//sourcery: AutoMockable
public protocol EasyPillMedicationImporter: Importer {}

public final class EasyPillMedicationImporterImpl: NSManagedObject, EasyPillMedicationImporter, CoreDataObject {

	// MARK: - Static Variables

	public static let entityName = "EasyPillMedicationImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "medications"
	public final let sourceName: String = "EasyPill"
	public final var importOnlyNewData: Bool = true

	private final var lineNumber = -1
	private final let log = Log()
	private final var cancelled = false

	private final let uuid = UUID()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.util.io.contentsOf(url)
		lineNumber = 2
		do {
			for line in contents.components(separatedBy: "\n")[1...] {
				if cancelled { return }
				try processLine(line)
				lineNumber += 1
			}
			try DependencyInjector.util.importer.cleanUpImportedData(forType: Medication.self)
			lastImport = Date()
			try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
		} catch {
			log.error("Failed to import medications from EasyPill: %@", errorInfo(error))
			do {
				try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: Medication.fetchRequest())
			} catch {
				log.error("Failed to delete medications from current import: %@", errorInfo(error))
			}
			throw error
		}
	}

	public final func cancel() {
		// because there could me multiple imports from the same source happening simultaneously and we want to cancel all of them
		cancelled = true
		do {
			try DependencyInjector.util.importer.deleteImportedEntities(fetchRequest: Medication.fetchRequest())
		} catch {
			log.error("Failed to delete medications from current import on cancel: %@", errorInfo(error))
		}
	}

	public final func resetLastImportDate() throws {
		lastImport = nil
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	public final func equalTo(_ otherImporter: Importer) -> Bool {
		guard let other = otherImporter as? EasyPillMedicationImporterImpl else { return false }
		return uuid == other.uuid
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String) throws {
		let parts = line.components(separatedBy: ",")
		var medicationName = try getColumn(0, from: parts, errorMessage: "Line \(lineNumber) is empty.")
		var currentIndex = 1
		if medicationName.isEmpty {
			let nextColumnText = try getColumn(currentIndex, from: parts, errorMessage: "No name found on line \(lineNumber).")
			medicationName += "," + nextColumnText
			currentIndex += 1
		}
		let originalNotesIndex = currentIndex
		var notes = try getColumn(currentIndex, from: parts, errorMessage: "Line \(lineNumber) does not have the right number of columns.")
		currentIndex += 1
		var dosageText = try getColumn(currentIndex, from: parts, errorMessage: "Line \(lineNumber) does not have the right number of columns.")
		let originalFrequencyIndex = currentIndex + 1
		var frequencyText = try getColumn(originalFrequencyIndex, from: parts, errorMessage: "Line \(lineNumber) does not have the right number of columns.")
		var additionalColumns = 0
		while !frequencyTextIsValid(frequencyText) && parts.count > currentIndex + additionalColumns + 1 {
			additionalColumns += 1
			if frequencyText.starts(with: "every") && isNumber(String(frequencyText.suffix(1))) {
				frequencyText += "." + parts[originalFrequencyIndex + additionalColumns]
			} else {
				frequencyText = parts[originalFrequencyIndex + additionalColumns]
			}
		}
		if parts.count <= currentIndex + additionalColumns + 1 {
			throw InvalidFileFormatError("Unable to align columns on line \(lineNumber).")
		}
		if additionalColumns > 0 {
			var numberOfFrequencyColumns = 1
			if frequencyText.starts(with: "every") {
				numberOfFrequencyColumns = 2
			}
			dosageText = parts[originalFrequencyIndex + additionalColumns - numberOfFrequencyColumns]
			let newNotesMaxIndex = originalFrequencyIndex + additionalColumns - numberOfFrequencyColumns - 1
			notes = parts[originalNotesIndex...newNotesMaxIndex].joined(separator: ",")
		}
		currentIndex = originalFrequencyIndex + additionalColumns + 3
		let startedOnText = try getColumn(currentIndex, from: parts, errorMessage: "Could not get started on date from line \(lineNumber).")
		let startedOn = DependencyInjector.util.calendar.date(from: startedOnText, format: "M/d/yy")!

		try storeMedication(named: medicationName, startedOn: startedOn, dosage: Dosage(dosageText), notes: notes, frequencyText: frequencyText)
	}

	private final func getColumn(_ index: Int, from parts: [String], errorMessage: String? = nil) throws -> String {
		guard parts.count > index else { throw InvalidFileFormatError(errorMessage) }
		return parts[index]
	}

	private final func storeMedication(named name: String, startedOn: Date, dosage: Dosage?, notes: String, frequencyText: String) throws {
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		let medicationsWithCurrentName: [Medication]
		do {
			medicationsWithCurrentName = try DependencyInjector.db.query(medicationsWithCurrentNameFetchRequest)
		} catch {
			log.error("Failed to check for existing medications named '%@': %@", name, errorInfo(error))
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for existing medications named \(name).")
		}

		if medicationsWithCurrentName.count == 0 {
			do {
				if cancelled { return }
				let medication = try DependencyInjector.db.new(Medication.self)
				let allMedications = try DependencyInjector.db.query(Medication.fetchRequest())
				medication.recordScreenIndex = Int16(allMedications.count)
				medication.setSource(.easyPill)
				medication.partOfCurrentImport = true
				try setMedication(medication, name: name, startedOn: startedOn, dosage: dosage, notes: notes, frequencyText: frequencyText)
			} catch {
				throw GenericDisplayableError(
					title: "Data Write Error",
					description: "Unable to store new medication named '\(name)'.")
			}
		} else if medicationsWithCurrentName.count == 1 && !importOnlyNewData {
			let medication = medicationsWithCurrentName[0]
			try setMedication(medication, name: name, startedOn: startedOn, dosage: dosage, notes: notes, frequencyText: frequencyText)
		} else if !importOnlyNewData {
			throw AmbiguousUpdateToExistingDataError(
				"Update requested for '\(name)' but found \(medicationsWithCurrentName.count) medications with that name.")
		}
	}

	private final func setMedication(_ medication: Medication, name: String, startedOn: Date, dosage: Dosage?, notes: String, frequencyText: String) throws {
		medication.name = name
		medication.dosage = dosage
		if !frequencyText.isEmpty {
			let frequency = getFrequency(frequencyText)
			medication.frequency = frequency
		}
		if notes.isEmpty {
			medication.notes = nil
		} else {
			medication.notes = notes
		}
		medication.startedOn = startedOn
		if cancelled { return }
		try retryOnFail({ try DependencyInjector.db.save() }, maxRetries: 2)
	}

	private final func getFrequency(_ frequencyText: String) -> Frequency? {
		if frequencyText == "as needed" {
			return nil
		} else if frequencyText == "daily" {
			return Frequency(1, .day)
		} else if frequencyText == "weekly" {
			return Frequency(1, .weekOfYear)
		} else if frequencyText == "every hour" {
			return Frequency(1, .hour)
		} else if frequencyText.starts(with: "every") {
			let timeUnit = getTimeUnitFromFrequencyText(frequencyText)
			if timeUnit == nil {
				return nil
			}

			if let numberRange = DependencyInjector.util.string.rangeOfNumberIn(frequencyText) {
				let number = 1.0 / Double(frequencyText[numberRange])!
				return Frequency(number, timeUnit!)
			}
			return nil
		}
		return nil
	}

	private final func getTimeUnitFromFrequencyText(_ frequencyText: String) -> Calendar.Component? {
		if frequencyText.hasSuffix("weeks") {
			return .weekOfYear
		} else if frequencyText.hasSuffix("days") {
			return .day
		} else if frequencyText.hasSuffix("hours") {
			return .hour
		}
		return nil
	}

	private final func frequencyTextIsValid(_ frequencyText: String) -> Bool {
		return frequencyText == "as needed" ||
			frequencyText == "daily" ||
			frequencyText == "weekly" || (
				frequencyText.starts(with: "every") && (
					frequencyText.hasSuffix("hour") ||
					frequencyText.hasSuffix("hours") ||
					frequencyText.hasSuffix("days") ||
					frequencyText.hasSuffix("weeks")))
	}

	private final func isNumber(_ str: String) -> Bool {
		return DependencyInjector.util.string.isNumber(str)
	}
}
