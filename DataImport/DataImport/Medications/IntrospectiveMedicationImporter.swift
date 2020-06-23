//
//  IntrospectiveMedicationImporter.swift
//  DataImport
//
//  Created by Bryan Nova on 6/3/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Foundation
import CoreData
import CSV

import Common
import DependencyInjection
import Persistence
import Samples

//sourcery: AutoMockable
public protocol IntrospectiveMedicationImporter: MedicationImporter {}

public final class IntrospectiveMedicationImporterImpl: NSManagedObject, IntrospectiveMedicationImporter, CoreDataObject {

	// MARK: - Static Variables

	public typealias Me = IntrospectiveMedicationImporterImpl

	public static let entityName = "IntrospectiveMedicationImporter"

	// MARK: - Instance Variables

	public final let dataTypePluralName: String = "medications"
	public final let sourceName: String = "Introspective"
	public final let customImportMessage: String? = nil

	public final var importOnlyNewData: Bool = true
	public final var isPaused: Bool = false
	public final var isCancelled: Bool = false

	/// for testing purposes only
	public final var pauseOnRecord: Int?

	private final var recordNumber = -1
	private final var totalLines = -1
	private final let mainTransaction = DependencyInjector.get(Database.self).transaction()
	private final var csv: CSVReader!
	private final var latestDate: Date!
	private final let log = Log()

	// MARK: - Main Functions

	public final func importData(from url: URL) throws {
		csv = try DependencyInjector.get(IOUtil.self).csvReader(url: url, hasHeaderRow: true)
		recordNumber = 1
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
			log.error("Tried to resume a cancelled medication import from Introspective")
			return
		}

		// without this, pausing and returning skips a line
		var currentRow: [String]? = []
		if !isPaused { currentRow = csv.next() }
		isPaused = false
		do {
			while currentRow != nil {
				guard pauseOnRecord != recordNumber else {
					pause()
					pauseOnRecord = nil
					return
				}
				guard !isPaused && !isCancelled else { return }
				try importMedication(latestDate: &latestDate, using: mainTransaction)
				recordNumber += 1
				currentRow = csv.next()
			}

			try correctRecordScreenIndices()

			lastImport = latestDate
			try retryOnFail({ try mainTransaction.commit() }, maxRetries: 2)
		} catch {
			log.error("Failed to import medications from Introspective: %@", errorInfo(error))
			throw error
		}
	}

	// MARK: - Helper Functions

	private final func importMedication(latestDate: inout Date!, using transaction: Transaction) throws {
		var medication: Medication! = try retrieveExistingMedication(using: transaction)
		if medication == nil {
			medication = try createMedication(using: transaction)
		}

		let timestamp: Date = try getDosageTimestamp()
		if latestDate == nil { latestDate = timestamp }
		if timestamp.isAfterDate(latestDate, granularity: .nanosecond) {
			latestDate = timestamp
		}

		if shouldImport(timestamp) {
			try createDose(for: medication, using: transaction)
		}
	}

	private final func retrieveExistingMedication(using transaction: Transaction) throws -> Medication? {
		let name = try getName()
		let medicationsWithCurrentNameFetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		medicationsWithCurrentNameFetchRequest.predicate = NSPredicate(format: "%K ==[cd] %@", "name", name)
		let medicationsWithCurrentName: [Medication]
		do {
			medicationsWithCurrentName = try transaction.query(medicationsWithCurrentNameFetchRequest)
			if medicationsWithCurrentName.count == 0 {
				return nil
			} else if medicationsWithCurrentName.count == 1 {
				return medicationsWithCurrentName[0]
			} else {
				throw AmbiguousUpdateToExistingDataError(
					"Update requested for '\(name)' but found \(medicationsWithCurrentName.count) medications with that name.")
			}
		} catch {
			log.error("Failed to check for existing medications: %@", errorInfo(error))
			throw GenericDisplayableError(
				title: "Data Access Error",
				description: "Unable to check for existing medications named \(name).")
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

	private final func correctRecordScreenIndices() throws {
		let medications = try getAllMedications(using: mainTransaction).sorted(by: {
			$0.recordScreenIndex < $1.recordScreenIndex
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
		let medicationsInMainContext = Set(try DependencyInjector.get(Database.self)
			.query(Medication.fetchRequest()))
			.filter({
				let id = $0.objectID
				return !medicationsInTransaction.contains(where: { med in med.objectID == id})
			})
		return medicationsInTransaction.union(medicationsInMainContext)
	}

	// MARK: Creators

	private final func createMedication(using transaction: Transaction) throws -> Medication {
		let childTransaction = transaction.childTransaction()

		let medication: Medication
		do {
			medication = try childTransaction.new(Medication.self)
		} catch {
			log.error("Failed to create new medication")
			throw GenericDisplayableError(
				title: "Unable to create new medication",
				description: "Failed to create new medication.")
		}

		medication.name = try getName()
		medication.notes = csv[Medication.notesColumn]
		medication.recordScreenIndex = try getRecordScreenIndex(using: childTransaction)
		medication.setSource(try getSource(columnName: Medication.sourceColumn))
		medication.startedOn = try getStartedOnDate()
		medication.startedOnTimeZone = getTimeZone(for: Medication.startedOnTimeZoneColumn)

		if let frequencyText = csv[Medication.frequencyColumn] {
			medication.frequency = Frequency(frequencyText)
		}

		if let dosageText = csv[Medication.dosageColumn] {
			medication.dosage = Dosage(dosageText)
		}

		try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)

		return medication
	}

	private final func createDose(for medication: Medication, using transaction: Transaction) throws {
		let childTransaction = transaction.childTransaction()
		let dose: MedicationDose
		do {
			dose = try childTransaction.new(MedicationDose.self)
		} catch {
			log.error("Failed to create new dose")
			throw GenericDisplayableError(
				title: "Unable to create new dose",
				description: "Failed to create new dose.")
		}

		dose.medication = try childTransaction.pull(savedObject: medication)
		dose.dosage = getDosage()
		dose.setSource(try getSource(columnName: MedicationDose.sourceColumn))
		dose.date = try getDosageTimestamp()
		dose.timeZone = getTimeZone(for: MedicationDose.timeZoneColumn)

		try retryOnFail({ try childTransaction.commit() }, maxRetries: 2)
	}

	// MARK: Column Getters

	private final func getName() throws -> String {
		if let name = csv[Medication.nameColumn] {
			return name
		}
		throw MissingRequiredFieldError(Medication.nameColumn, recordNumber: recordNumber)
	}

	private final func getDosageTimestamp() throws -> Date {
		guard let dateText = csv[MedicationDose.timestampColumn] else {
			throw MissingRequiredFieldError(MedicationDose.timestampColumn, recordNumber: recordNumber)
		}
		if let date = DependencyInjector.get(CalendarUtil.self).date(from: dateText, dateStyle: .full, timeStyle: .full) {
			return date
		}
		throw InvalidFileFormatError("Invalid format for \(MedicationDose.timestampColumn) for record \(recordNumber).")
	}

	private final func getSource(columnName: String) throws -> Sources.MedicationSourceNum {
		guard let sourceString = csv[columnName] else {
			throw MissingRequiredFieldError(columnName, recordNumber: recordNumber)
		}
		guard let source = Sources.resolveMedicationSource(sourceString) else {
			throw InvalidFileFormatError("Invalid value provided for source of record \(recordNumber)")
		}
		return source
	}

	private final func getStartedOnDate() throws -> Date? {
		if let dateText = csv[Medication.startedOnColumn] {
			if let date = DependencyInjector.get(CalendarUtil.self).date(from: dateText, dateStyle: .full, timeStyle: .full) {
				return date
			}
			throw InvalidFileFormatError("Invalid format for \(Medication.startedOnColumn) for record \(recordNumber).")
		}
		return nil
	}

	private final func getRecordScreenIndex(using transaction: Transaction) throws -> Int16 {
		if let recordScreenIndexString = csv[Medication.recordScreenIndexColumn] {
			guard let index = Int16(recordScreenIndexString) else {
				throw InvalidFileFormatError("Record screen index for record \(recordNumber) is not a valid number: \(recordScreenIndexString)")
			}
			return index
		}
		return Int16(try getAllMedications(using: transaction).count)
	}

	private final func getDosage() -> Dosage? {
		if let dosageText = csv[MedicationDose.dosageColumn] {
			return Dosage(dosageText)
		}
		return nil
	}

	private final func getTimeZone(for column: String) -> TimeZone? {
		if let timeZoneIdentifier = csv[column] {
			return TimeZone(identifier: timeZoneIdentifier)
		}
		return nil
	}
}

// MARK: - CoreData Stuff

public extension IntrospectiveMedicationImporterImpl {

	@nonobjc class func fetchRequest() -> NSFetchRequest<IntrospectiveMedicationImporterImpl> {
		return NSFetchRequest<IntrospectiveMedicationImporterImpl>(entityName: "IntrospectiveMedicationImporter")
	}

	@NSManaged var lastImport: Date?
}
