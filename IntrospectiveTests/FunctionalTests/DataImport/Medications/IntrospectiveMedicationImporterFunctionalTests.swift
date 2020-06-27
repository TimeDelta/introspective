//
//  IntrospectiveMedicationImporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/4/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import XCTest
import CoreData
import Hamcrest
import SwiftDate

@testable import Common
@testable import DataImport
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

class IntrospectiveMedicationImporterFunctionalTests: ImporterTest {

	private typealias Me = IntrospectiveMedicationImporterFunctionalTests

	private static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .full
		formatter.timeStyle = .full
		return formatter
	}()

	private static let headerRow = "\"Name\",\"Normal Dosage\",\"Frequency\",\"Started On\",\"Started On Time Zone\",\"Notes\",\"Definition Source\",\"Record Screen Index\",\"Dosage\",\"Timestamp\",\"Time Zone\",\"Instance Source\""
	private static let medicationInfo1 = MedicationInfo(
		name: ",f,new,ou",
		dosage: nil,
		frequency: nil,
		startedOn: Date(),
		startedOnTimeZone: TimeZone.init(abbreviation: "GMT"),
		notes: "this is a note that contains a ',' comma",
		source: .introspective,
		recordScreenIndex: 0)
	private static let medicationInfo2 = MedicationInfo(
		name: "abc",
		dosage: Dosage(12.5, "mg"),
		frequency: Frequency(2, .day),
		startedOn: Date() - 20.days,
		startedOnTimeZone: nil,
		notes: "this is a note that contains a \"\"quote\"\".",
		source: .easyPill,
		recordScreenIndex: 1)
	private static let medicationInfo3 = MedicationInfo(
		name: "def",
		dosage: Dosage(25, "µg"),
		frequency: Frequency(3, .weekOfYear),
		startedOn: Date() - 10.days,
		startedOnTimeZone: nil,
		notes: "this is a note that contains a \n newline",
		source: .introspective,
		recordScreenIndex: 2)
	private static let doseInfo1 = MedicationDoseInfo(
		medication: medicationInfo1,
		dosage: Dosage(8, "g"),
		timestamp: Date(),
		timeZone: TimeZone.init(abbreviation: "GMT"),
		source: .introspective)
	private static let doseInfo2 = MedicationDoseInfo(
		medication: medicationInfo2,
		dosage: medicationInfo2.dosage,
		timestamp: Date() - 1.days,
		timeZone: nil,
		source: .easyPill)
	private static let doseInfo3 = MedicationDoseInfo(
		medication: medicationInfo3,
		dosage: medicationInfo3.dosage,
		timestamp: Date() - 3.days,
		timeZone: TimeZone.init(abbreviation: "GMT"),
		source: .introspective)
	private static let validInput = inputFor([doseInfo1, doseInfo2, doseInfo3])

	private final var importer: IntrospectiveMedicationImporterImpl!

	public override func setUp() {
		super.setUp()
		importer = try! DependencyInjector.get(ImporterFactory.self).introspectiveMedicationImporter() as! IntrospectiveMedicationImporterImpl
	}

	// MARK: - importData()

	// MARK: Valid Data

	func testGivenValidDataWithNewMedication_importData_correctlyImportsMedication() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.inputFor([Me.doseInfo1]))

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.doseInfo1.medication, exists(Medication.self))
	}

	func testGivenValidDataWithNewMedicationThatContainsQuote_importData_correctlyImportsMedication() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.inputFor([Me.doseInfo2]))

		// when
		try importer.importData(from: url)

		// then
		let expectedMedicationInfo = Me.doseInfo2.medication.copy()
		expectedMedicationInfo.recordScreenIndex = 0
		assertThat(expectedMedicationInfo, exists(Medication.self))
	}

	func testGivenValidDataWithNewMedicationThatContainsNewline_importData_correctlyImportsMedication() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.inputFor([Me.doseInfo3]))

		// when
		try importer.importData(from: url)

		// then
		let expectedMedicationInfo = Me.doseInfo3.medication.copy()
		expectedMedicationInfo.recordScreenIndex = 0
		assertThat(expectedMedicationInfo, exists(Medication.self))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.doseInfo1.timestamp
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.doseInfo1, exists(MedicationDose.self))
		assertThat(Me.doseInfo2, exists(MedicationDose.self))
		assertThat(Me.doseInfo3, exists(MedicationDose.self))
		assertThat(try getAllDoses(), hasCount(3))
	}

	func testGivenValidDataWithPreviousImportAndImportNewDataOnlyEqualToTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = Me.doseInfo2.timestamp
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.doseInfo1, exists(MedicationDose.self))
		assertThat(Me.doseInfo2, not(exists(MedicationDose.self)))
		assertThat(Me.doseInfo3, not(exists(MedicationDose.self)))
		assertThat(try getAllDoses(), hasCount(1))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsTrue_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = true
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.doseInfo1, exists(MedicationDose.self))
		assertThat(Me.doseInfo2, exists(MedicationDose.self))
		assertThat(Me.doseInfo3, exists(MedicationDose.self))
		assertThat(try getAllDoses(), hasCount(3))
	}

	func testGivenNeverImportedBeforeAndImportOnlyNewDataEqualsFalse_importData_correctlyImportsData() throws {
		// given
		importer.lastImport = nil
		importer.importOnlyNewData = false
		useInput(Me.validInput)

		// when
		try importer.importData(from: url)

		// then
		assertThat(Me.doseInfo1, exists(MedicationDose.self))
		assertThat(Me.doseInfo2, exists(MedicationDose.self))
		assertThat(Me.doseInfo3, exists(MedicationDose.self))
		assertThat(try getAllDoses(), hasCount(3))
	}

	func testGivenOtherMedicationsCreatedOutsideOfImport_importData_doesNotAllowDuplicateRecordScreenIndexes() throws {
		MedicationDataTestUtil.createMedication(name: "medication 1", recordScreenIndex: 0)
		MedicationDataTestUtil.createMedication(name: "medication 2", recordScreenIndex: 1)
		useInput(Me.validInput)
		importer.pauseOnRecord = 3

		// when
		try importer.importData(from: url)

		MedicationDataTestUtil.createMedication(name: "medication 1 created during import", recordScreenIndex: 2)
		MedicationDataTestUtil.createMedication(name: "medication 2 created during import", recordScreenIndex: 3)

		try importer.resume()

		// then
		let medications = try DependencyInjector.get(Database.self).query(Medication.fetchRequest())
		let medicationIndexes = medications.map{ m -> Int16 in m.recordScreenIndex }
		var previousIndex: Int16 = -1
		for index in medicationIndexes.sorted() {
			if index == previousIndex {
				XCTFail("Duplicate index detected: " + String(index))
			}
			previousIndex = index
		}
	}

	func testGivenImportCancelled_importData_startsNewImport() throws {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let originalPercentComplete = importer.percentComplete()

		// when
		try importer.importData(from: url)

		// then
		XCTAssertGreaterThan(importer.percentComplete(), originalPercentComplete)
		XCTAssertFalse(importer.isCancelled)
	}

	// MARK: Invalid Data

	func testGivenNoData_importData_doesNotThrowError() throws {
		// given
		useInput(Me.headerRow)

		// when
		try importer.importData(from: url)

		// then - no error thrown
	}

	// MARK: - resetLastImportDate()

	func testGivenNonNilLastImportDate_resetLastImportDate_setsLastImportToNil() throws {
		// given
		importer.lastImport = Date()

		// when
		try importer.resetLastImportDate()

		// then
		importer = try DependencyInjector.get(Database.self).pull(savedObject: importer)
		XCTAssertNil(importer.lastImport)
	}

	// MARK: - cancel()

	func testGivenNotImporting_cancel_setsIsCancelledToTrue() {
		// when
		importer.cancel()

		// then
		XCTAssert(importer.isCancelled)
	}

	func testGivenCurrentlyImporting_cancel_stopsImportAndSetsIsCancelledToTrue() {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}

		// when
		while importer.percentComplete() == 0 {}
		importer.cancel()

		// then
		XCTAssertLessThanOrEqual(importer.percentComplete(), 1)
		XCTAssert(importer.isCancelled)
	}

	// MARK: - resume()

	func testGivenImportCancelled_resume_doesNotContinue() throws {
		// given
		useInput(Me.validInput)
		DispatchQueue.global(qos: .background).async {
			try! self.importer.importData(from: self.url)
		}
		while importer.percentComplete() == 0 {}
		importer.cancel()
		let expectedPerentComplete = importer.percentComplete()

		// when
		try importer.resume()

		// then
		XCTAssertEqual(importer.percentComplete(), expectedPerentComplete)
	}

	// MARK: - Helper Functions

	private final func getAllDoses() throws -> [MedicationDose] {
		return try DependencyInjector.get(Database.self).query(MedicationDose.fetchRequest())
	}

	// MARK: Input

	private static func inputFor(_ medications: [MedicationDoseInfo]) -> String {
		var input = Me.headerRow
		for doseInfo in medications {
			var startedOnDateText: String = ""
			if let date = doseInfo.medication.startedOn {
				startedOnDateText = Me.formatter.string(from: date)
			}
			let timestampText = Me.formatter.string(from: doseInfo.timestamp)
			input += "\n\"\(doseInfo.medication.name)\","
			input += "\"\(doseInfo.medication.dosage?.description ?? "")\","
			input += "\"\(doseInfo.medication.frequency?.description ?? "")\","
			input += "\"\(startedOnDateText)\","
			input += getTimeZoneString(doseInfo.medication.startedOnTimeZone) + ","
			input += "\"\(doseInfo.medication.notes ?? "")\","
			input += getSourceString(doseInfo.medication.source) + ","
			input += "\"\(String(doseInfo.medication.recordScreenIndex))\","
			input += "\"\(doseInfo.dosage?.description ?? "")\","
			input += "\"\(timestampText)\","
			input += getTimeZoneString(doseInfo.timeZone) + ","
			input += getSourceString(doseInfo.source)
		}
		return input
	}

	private static func getSourceString(_ source: Sources.MedicationSourceNum) -> String {
		return "\"" + source.description + "\""
	}

	private static func getTimeZoneString(_ timeZone: TimeZone?) -> String {
		return "\"" + (timeZone?.identifier ?? "") + "\""
	}

	// MARK: - Info Classes

	// TODO Move these to more publicly accessible place
	private class MedicationInfo: Info {

		var name: String
		var dosage: Dosage?
		var frequency: Frequency?
		var startedOn: Date?
		var startedOnTimeZone: TimeZone?
		var notes: String?
		var source: Sources.MedicationSourceNum
		var recordScreenIndex: Int16

		public init(
			name: String,
			dosage: Dosage?,
			frequency: Frequency?,
			startedOn: Date?,
			startedOnTimeZone: TimeZone?,
			notes: String?,
			source: Sources.MedicationSourceNum,
			recordScreenIndex: Int16
		) {
			self.name = name
			self.dosage = dosage
			self.frequency = frequency
			self.startedOn = startedOn
			self.startedOnTimeZone = startedOnTimeZone
			self.notes = notes
			self.source = source
			self.recordScreenIndex = recordScreenIndex
		}

		public func getPredicates() -> [String: NSPredicate] {
			return [
				"name": NSPredicate(format: "name ==[cd] %@", name),
				"storedStartedOn": self.datePredicateFor(fieldName: "storedStartedOn", withinOneSecondOf: startedOn),
				"startedOnTimeZoneId": self.timeZonePredicate(for: startedOnTimeZone, field: "startedOnTimeZoneId"),
				"dosage": self.dosagePredicate(for: dosage, fieldName: "dosage"),
				"frequency": self.frequencyPredicate(for: frequency, fieldName: "frequency"),
				"notes": self.optionalStringPredicate(for: notes, fieldName: "notes"),
				"source": NSPredicate(format: "source == %i", source.rawValue),
				"recordScreenIndex": NSPredicate(format: "recordScreenIndex == %i", recordScreenIndex),
			]
		}

		public func copy() -> MedicationInfo {
			return MedicationInfo(
				name: name,
				dosage: dosage,
				frequency: frequency,
				startedOn: startedOn,
				startedOnTimeZone: startedOnTimeZone,
				notes: notes,
				source: source,
				recordScreenIndex: recordScreenIndex
			)
		}
	}

	private class MedicationDoseInfo: Info {

		var medication: MedicationInfo
		var dosage: Dosage?
		var timestamp: Date
		var timeZone: TimeZone?
		var source: Sources.MedicationSourceNum

		public init(
			medication: MedicationInfo,
			dosage: Dosage?,
			timestamp: Date,
			timeZone: TimeZone?,
			source: Sources.MedicationSourceNum
		) {
			self.medication = medication
			self.dosage = dosage
			self.timestamp = timestamp
			self.timeZone = timeZone
			self.source = source
		}

		public func getPredicates() -> [String: NSPredicate] {
			return [
				"medication.name": NSPredicate(format: "medication.name ==[cd] %@", medication.name),
				"medication.storedStartedOn": self.datePredicateFor(
					fieldName: "medication.storedStartedOn",
					withinOneSecondOf: medication.startedOn),
				"medication.startedOnTimeZoneId": self.timeZonePredicate(
					for: medication.startedOnTimeZone,
					field: "medication.startedOnTimeZoneId"),
				"medication.dosage": self.dosagePredicate(for: medication.dosage, fieldName: "medication.dosage"),
				"medication.frequency": self.frequencyPredicate(
					for: medication.frequency,
					fieldName: "medication.frequency"),
				"medication.notes": self.optionalStringPredicate(for: medication.notes, fieldName: "medication.notes"),
				"medication.source": NSPredicate(format: "medication.source == %i", medication.source.rawValue),
				"medication.recordScreenIndex": NSPredicate(
					format: "medication.recordScreenIndex == %i",
					medication.recordScreenIndex),
				"timestamp": self.datePredicateFor(fieldName: "timestamp", withinOneSecondOf: timestamp),
				"dosage": self.dosagePredicate(for: dosage, fieldName: "dosage"),
				"timestampTimeZoneId": self.timeZonePredicate(for: timeZone, field: "timestampTimeZoneId"),
				"source": NSPredicate(format: "source == %i", source.rawValue),
			]
		}

		public func copy() -> MedicationDoseInfo {
			return MedicationDoseInfo(
				medication: medication.copy(),
				dosage: dosage,
				timestamp: timestamp,
				timeZone: timeZone,
				source: source
			)
		}
	}
}
