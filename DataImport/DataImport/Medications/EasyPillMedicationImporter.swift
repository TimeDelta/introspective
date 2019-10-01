//
//  EasyPillMedicationImporter.swift
//  Introspective
//
//  Created by Bryan Nova on 10/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData

import Common
import DependencyInjection
import Persistence
import Samples

//sourcery: AutoMockable
public protocol EasyPillMedicationImporter: MedicationImporter {}

public final class EasyPillMedicationImporterImpl: NSManagedObject, EasyPillMedicationImporter, CoreDataObject {

	// MARK: - Static Variables

	public static let entityName = "EasyPillMedicationImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "medications"
	public final let sourceName: String = "EasyPill"
	public final let customImportMessage: String? = "This will not import any medications with the name of one that you have already saved."

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false
	public final var isCancelled: Bool = false

	/// for testing purposes only
	public final var pauseOnRecord: Int?

	private final var recordNumber = -1
	private final var totalLines = -1
	private final let mainTransaction = DependencyInjector.get(Database.self).transaction()
	private final var latestDate: Date!
	private final var lines = [String]()
	private final let log = Log()

	// MARK: - Functions

	public final func importData(from url: URL) throws {
		let contents = try DependencyInjector.get(IOUtil.self).contentsOf(url)
		lines = contents.components(separatedBy: "\n")
		lines.removeFirst()
		recordNumber = 1
		totalLines = lines.count

		isPaused = false
		isCancelled = false

		lastImport = Date()

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
			log.error("Tried to resume a cancelled medicaiton import from EasyPill")
			return
		}

		isPaused = false
		do {
			// note: EasyPill does not allow multi-line notes
			while lines.count > 0 {
				if pauseOnRecord == recordNumber {
					pause()
					pauseOnRecord = nil
					return
				}
				guard !isPaused && !isCancelled else { return }
				let line = lines.removeFirst()
				try processLine(line, mainTransaction)
				recordNumber += 1
			}

			try correctRecordScreenIndices()

			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import medications from EasyPill: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func processLine(_ line: String, _ transaction: Transaction) throws {
		let parts = line.components(separatedBy: ",")
		var medicationName = try getColumn(0, from: parts, errorMessage: "Record \(recordNumber) is empty.")
		var currentIndex = 1
		if medicationName.isEmpty {
			let nextColumnText = try getColumn(currentIndex, from: parts, errorMessage: "No name found for record \(recordNumber).")
			medicationName += "," + nextColumnText
			currentIndex += 1
		}
		let originalNotesIndex = currentIndex
		var notes = try getColumn(currentIndex, from: parts, errorMessage: "Record \(recordNumber) does not have the right number of columns.")
		currentIndex += 1
		var dosageText = try getColumn(currentIndex, from: parts, errorMessage: "Record \(recordNumber) does not have the right number of columns.")
		let originalFrequencyIndex = currentIndex + 1
		var frequencyText = try getColumn(originalFrequencyIndex, from: parts, errorMessage: "Record \(recordNumber) does not have the right number of columns.")
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
			throw InvalidFileFormatError("Unable to align columns for record \(recordNumber).")
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
		let startedOnText = try getColumn(currentIndex, from: parts, errorMessage: "Could not get Started On date for record \(recordNumber).")
		let startedOn = DependencyInjector.get(CalendarUtil.self).date(from: startedOnText, format: "M/d/yy")!

		try storeMedication(
			named: medicationName,
			startedOn: startedOn,
			dosage: Dosage(dosageText),
			notes: notes,
			frequencyText: frequencyText,
			using: transaction)
	}

	private final func getColumn(_ index: Int, from parts: [String], errorMessage: String? = nil) throws -> String {
		guard parts.count > index else { throw InvalidFileFormatError(errorMessage) }
		return parts[index]
	}

	private final func storeMedication(
		named name: String,
		startedOn: Date,
		dosage: Dosage?,
		notes: String,
		frequencyText: String,
		using transaction: Transaction)
	throws {
		let childTransaction = transaction.childTransaction()
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		let medicationsWithCurrentName: [Medication]
		do {
			medicationsWithCurrentName = try DependencyInjector.get(Database.self).query(medicationsWithCurrentNameFetchRequest)
		} catch {
			log.error("Failed to check for existing medications named '%@': %@", name, errorInfo(error))
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for existing medications named \(name).")
		}

		if medicationsWithCurrentName.count == 0 {
			do {
				let medication = try childTransaction.new(Medication.self)
				let allMedications = try getAllMedications(using: childTransaction)
				medication.recordScreenIndex = Int16(allMedications.count)
				medication.setSource(.easyPill)
				try setMedication(
					medication,
					name: name,
					startedOn: startedOn,
					dosage: dosage,
					notes: notes,
					frequencyText: frequencyText,
					using: childTransaction)
			} catch {
				throw GenericDisplayableError(
					title: "Data Write Error",
					description: "Unable to store new medication named '\(name)'.")
			}
		} else if medicationsWithCurrentName.count == 1 && !importOnlyNewData {
			let medication = medicationsWithCurrentName[0]
			try setMedication(
				medication,
				name: name,
				startedOn: startedOn,
				dosage: dosage,
				notes: notes,
				frequencyText: frequencyText,
				using: childTransaction)
		} else if !importOnlyNewData {
			throw AmbiguousUpdateToExistingDataError(
				"Update requested for '\(name)' but found \(medicationsWithCurrentName.count) medications with that name.")
		}
		try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)
	}

	private final func setMedication(
		_ medication: Medication,
		name: String,
		startedOn: Date,
		dosage: Dosage?,
		notes: String,
		frequencyText: String,
		using transaction: Transaction)
	throws {
		let medication = try transaction.pull(savedObject: medication)
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
	}

	private final func getFrequency(_ frequencyText: String) -> Frequency? {
		if frequencyText == "as needed" {
			return nil
		} else if frequencyText == "daily" {
			return Frequency(1, .day)!
		} else if frequencyText == "weekly" {
			return Frequency(1, .weekOfYear)!
		} else if frequencyText == "every hour" {
			return Frequency(1, .hour)!
		} else if frequencyText.starts(with: "every") {
			guard let timeUnit = getTimeUnitFromFrequencyText(frequencyText) else { return nil }
			if let numberRange = DependencyInjector.get(StringUtil.self).rangeOfNumberIn(frequencyText) {
				let number = 1.0 / Double(frequencyText[numberRange])!
				return Frequency(number, timeUnit)!
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
		return DependencyInjector.get(StringUtil.self).isNumber(str)
	}

	private final func correctRecordScreenIndices() throws {
		let medications = try getAllMedications(using: mainTransaction).sorted(by: {
			$0.recordScreenIndex < $1.recordScreenIndex || ($0.getSource() == .introspective && $1.getSource() != .introspective)
		})
		var index = 0
		for var medication in medications {
			medication = try mainTransaction.pull(savedObject: medication)
			medication.recordScreenIndex = Int16(index)
			index += 1
		}
	}

	private final func getAllMedications(using transaction: Transaction) throws -> Set<Medication> {
		let medicationsInTransaction = Set(try transaction.query(Medication.fetchRequest()))
		let medicationsInMainContext = Set(try DependencyInjector.get(Database.self).query(Medication.fetchRequest())).filter({
			let id = $0.objectID
			return !medicationsInTransaction.contains(where: { med in med.objectID == id})
		})
		return medicationsInTransaction.union(medicationsInMainContext)
	}
}
