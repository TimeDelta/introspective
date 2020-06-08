//
//  MedicationExporterFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/19/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
import SwiftDate
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Samples

final class MedicationExporterFunctionalTests: ExporterFunctionalTest {

	private typealias Me = MedicationExporterFunctionalTests
	private static let expectedDoseHeaderFields = [
		Medication.nameColumn,
		Medication.dosageColumn,
		Medication.frequencyColumn,
		Medication.startedOnColumn,
		Medication.startedOnTimeZoneColumn,
		Medication.notesColumn,
		Medication.sourceColumn,
		Medication.recordScreenIndexColumn,
		MedicationDose.dosageColumn,
		MedicationDose.timestampColumn,
		MedicationDose.timeZoneColumn,
		MedicationDose.sourceColumn,
	]
	private static let expectedDoseHeaderRow = headerRowFor(fields: expectedDoseHeaderFields)

	private final var exporter: MedicationExporterImpl!
	private final var outputStream: OutputStream!

	final override func setUp() {
		super.setUp()
		outputStream = try! getOutputStreamFor(MedicationDose.self)
		exporter = try! MedicationExporterImpl()
	}

	// MARK: - exportData

	// MARK: Nothing To Export

	func testGivenNothingToExport_exportData_throwsDisplayableErrorThatSaysNothingToExport() throws {
		// when
		XCTAssertThrowsError(try exporter.exportData()) { error in
			// then
			assertThat(error, instanceOf(GenericDisplayableError.self))
			if let displayableError = error as? GenericDisplayableError {
				XCTAssertEqual(displayableError.displayableTitle, "Nothing to export")
			}
		}
	}

	func testGivenNothingToExport_exportData_doesNotWriteAnythingToDisk() throws {
		// when
		do {
			try exporter.exportData()
		} catch {
			// do nothing because error is supposed to be thrown
		}

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	func testGivenOnlyMedicationsToExport_exportData_doesNotWriteAnythingToFile() throws {
		// given
		MedicationDataTestUtil.createMedication()

		// when
		do {
			try exporter.exportData()
		} catch {
			// do nothing because error is supposed to be thrown
		}

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	// MARK: Header Rows

	func testGivenDoseToExport_exportData_writesCorrectHeaderRow() throws {
		// given
		MedicationDataTestUtil.createDose()

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, line(1, equalTo(Me.expectedDoseHeaderRow)))
	}

	// MARK: Special Characters

	func testGivenMedicationWithCommaInName_exportData_correctlyExportsMedication() throws {
		// given
		let name = ",na,me,"
		let dose = MedicationDataTestUtil.createDose(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	func testGivenMedicationWithQuoteInName_exportData_correctlyExportsMedication() throws {
		// given
		let name = "\"na\"me\""
		let dose = MedicationDataTestUtil.createDose(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	func testGivenMedicationWithNewlineInName_exportData_correctlyExportsMedication() throws {
		// given
		let name = "\nna\nme\n"
		let dose = MedicationDataTestUtil.createDose(name: name)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	func testGivenMedicationWithCommaInNotes_exportData_correctlyExportsMedication() throws {
		// given
		let notes = ",not,es,"
		let medication = MedicationDataTestUtil.createMedication(note: notes)
		let dose = MedicationDataTestUtil.createDose(medication: medication)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	func testGivenMedicationWithQuoteInNotes_exportData_correctlyExportsMedication() throws {
		// given
		let notes = "\"not\"es\""
		let medication = MedicationDataTestUtil.createMedication(note: notes)
		let dose = MedicationDataTestUtil.createDose(medication: medication)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	func testGivenMedicationWithNewlineInNotes_exportData_correctlyExportsMedication() throws {
		// given
		let notes = "\nnot\nes\n"
		let medication = MedicationDataTestUtil.createMedication(note: notes)
		let dose = MedicationDataTestUtil.createDose(medication: medication)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRow(2, matching: expectedFields(for: dose)))
	}

	// MARK: Normal Exports

	func testGivenMedicationsAndDosesToExport_exportData_correctlyExportsMedicationsAndDoses() throws {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(
			name: "medication 1 name",
			note: "medication 1 note",
			source: .introspective,
			recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(
			name: "medication 2 name",
			note: "medication 2 note",
			source: .easyPill,
			recordScreenIndex: 1)

		let dose1 = MedicationDataTestUtil.createDose(
			medication: medication1,
			dosage: Dosage(1, "mg"),
			timestamp: Date() - 1.days,
			source: .easyPill)
		let dose2 = MedicationDataTestUtil.createDose(
			medication: medication2,
			dosage: Dosage(2, "mg"),
			timestamp: Date() - 1.hours,
			source: .introspective)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedDoseHeaderFields,
			expectedFields(for: dose1),
			expectedFields(for: dose2),
		]))
	}

	func testGivenDosesToExport_exportData_exportsInAscendingTimstampOrder() throws {
		// given
		let dose1 = MedicationDataTestUtil.createDose(
			name: "medication 1",
			dosage: Dosage(2, "mg"),
			timestamp: Date() - 1.days)
		let dose2 = MedicationDataTestUtil.createDose(
			name: "medication 2",
			dosage: Dosage(3, "mg"),
			timestamp: Date() - 2.days)
		let dose3 = MedicationDataTestUtil.createDose(
			name: "medication 3",
			dosage: Dosage(4, "mg"),
			timestamp: Date() - 4.hours)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedDoseHeaderFields,
			expectedFields(for: dose2),
			expectedFields(for: dose1),
			expectedFields(for: dose3),
		]))
	}

	func testGivenCancelledBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(name: "1")
		MedicationDataTestUtil.createDose(medication: medication1)

		exporter.cancel()

		let medication2 = MedicationDataTestUtil.createMedication(name: "2")
		MedicationDataTestUtil.createDose(medication: medication2)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	func testGivenPausedBeforeStart_exportData_doesNotExportAnything() throws {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(name: "1")
		MedicationDataTestUtil.createDose(medication: medication1)

		exporter.pause()

		let medication2 = MedicationDataTestUtil.createMedication(name: "2")
		MedicationDataTestUtil.createDose(medication: medication2)

		// when
		try exporter.exportData()

		// then
		let output = getTextWrittenTo(outputStream)
		XCTAssertEqual(output, "")
	}

	// MARK: Errors

	func testGivenExportStartedAndPaused_exportData_throwsError() throws {
		// given
		MedicationDataTestUtil.createDose()
		exporter.pauseOnRecord = 0
		try exporter.exportData()

		// when / then
		XCTAssertThrowsError(try exporter.exportData())
	}

	// MARK: - percentComplete

	func testGivenNothingToExport_percentComplete_returns1() {
		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 1)
	}

	func testGivenExportCancelled_percentComplete_returns1() {
		// given
		exporter.cancel()

		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 1)
	}

	func testGivenExportStartedButNotFinished_percentComplete_returnsCorrectPercent() throws {
		// given
		exporter.pauseOnRecord = 1
		MedicationDataTestUtil.createDose()
		MedicationDataTestUtil.createDose()
		try exporter.exportData()

		// when
		let percentComplete = exporter.percentComplete()

		// then
		XCTAssertEqual(percentComplete, 0.5)
	}

	// MARK: - cancel

	func testGivenExportNotAlreadyCancelled_cancel_setsIsCancelledToTrue() {
		// given
		XCTAssertFalse(exporter.isCancelled)

		// when
		exporter.cancel()

		// then
		XCTAssert(exporter.isCancelled)
	}

	func testGivenExportAlreadyCancelled_cancel_leavesIsCancelledAsTrue() {
		// given
		exporter.cancel()

		// when
		exporter.cancel()

		// then
		XCTAssert(exporter.isCancelled)
	}

	// MARK: - pause

	func testGivenExportNotAlreadyPaused_pause_setsIsPausedToTrue() {
		// given
		XCTAssertFalse(exporter.isPaused)

		// when
		exporter.pause()

		// then
		XCTAssert(exporter.isPaused)
	}

	func testGivenExportAlreadyPaused_pause_leavesIsPausedAsTrue() {
		// given
		exporter.pause()

		// when
		exporter.pause()

		// then
		XCTAssert(exporter.isPaused)
	}

	// MARK: - resume

	func testGivenExportPausedDuringDoses_resume_doesNotDuplicateAnyOutput() throws {
		// given
		let medication1 = MedicationDataTestUtil.createMedication(name: "1", recordScreenIndex: 0)
		let medication2 = MedicationDataTestUtil.createMedication(name: "2", recordScreenIndex: 1)
		let dose1 = MedicationDataTestUtil.createDose(medication: medication1)
		let dose2 = MedicationDataTestUtil.createDose(medication: medication2)
		exporter.pauseOnRecord = 3
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvWithRows([
			Me.expectedDoseHeaderFields,
			expectedFields(for: dose1),
			expectedFields(for: dose2),
		]))
	}

	func testGivenExportPaused_resume_continuesExportAndCorrectlyExportsEverything() throws {
		// given
		MedicationDataTestUtil.createDose(name: "1")
		let dose2 = MedicationDataTestUtil.createDose(name: "2")
		exporter.pauseOnRecord = 2
		try exporter.exportData()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, csvContainsRow(withFields: expectedFields(for: dose2)))
	}

	func testGivenExportCancelled_resume_doesNotContinueExport() throws {
		// given
		MedicationDataTestUtil.createDose(name: "1")
		let dose2 = MedicationDataTestUtil.createDose(name: "2")
		exporter.pauseOnRecord = 1
		try exporter.exportData()
		exporter.cancel()

		// when
		try exporter.resume()

		// then
		let output = getTextWrittenTo(outputStream)
		assertThat(output, not(csvContainsRow(withFields: expectedFields(for: dose2))))
	}

	// MARK: - Helper Functions

	private final func expectedFields(for medication: Medication) -> [String] {
		var startedOnText = ""
		if let startedOn = medication.startedOn {
			startedOnText = DependencyInjector.get(CalendarUtil.self).string(for: startedOn, dateStyle: .full, timeStyle: .full)
		}
		return [
			medication.name,
			medication.dosage?.description ?? "",
			medication.frequency?.description ?? "",
			startedOnText,
			TimeZone.autoupdatingCurrent.identifier,
			medication.notes ?? "",
			medication.getSource().description,
		]
	}

	private final func csvRow(for dose: MedicationDose) -> Matcher<String> {
		return csvRowWith(fields: expectedFields(for: dose).map{ equalTo($0) })
	}

	private final func expectedFields(for dose: MedicationDose) -> [String] {
		let dateText = DependencyInjector.get(CalendarUtil.self).string(for: dose.date, dateStyle: .full, timeStyle: .full)
		var fieldValues = expectedFields(for: dose.medication)
		fieldValues.append(contentsOf: [
			dose.dosage?.description ?? "",
			dateText,
			TimeZone.autoupdatingCurrent.identifier,
			dose.getSource().description,
		])
		return fieldValues
	}
}
