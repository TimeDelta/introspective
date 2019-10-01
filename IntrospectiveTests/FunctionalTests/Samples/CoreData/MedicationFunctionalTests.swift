//
//  MedicationFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Attributes
@testable import Common
@testable import DependencyInjection
@testable import Persistence
@testable import Samples
@testable import Settings

final class MedicationFunctionalTests: FunctionalTest {

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = DoubleAttribute(name: "this is not a real attribute")
		let medication = MedicationDataTestUtil.createMedication()

		// when
		XCTAssertThrowsError(try medication.value(of: unknownAttribute)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	func testGivenNameAttribute_valueOf_returnsCorrectName() throws {
		// given
		let expectedName = "this is a name"
		let medication = MedicationDataTestUtil.createMedication(name: expectedName)

		// when
		let name = try medication.value(of: Medication.nameAttribute) as? String

		// then
		XCTAssertEqual(name, expectedName)
	}

	func testGivenDosageAttribute_valueOf_returnsCorrectDosage() throws {
		// given
		let expectedDosage = Dosage(23.5, "fdhsjlk")
		let medication = MedicationDataTestUtil.createMedication(dosage: expectedDosage)

		// when
		let dosage = try medication.value(of: Medication.dosage) as? Dosage

		// then
		XCTAssertEqual(dosage, expectedDosage)
	}

	func testGivenFrequencyAttribute_valueOf_returnsCorrectFrequency() throws {
		// given
		let expectedFrequency = Frequency(6.0, .day)!
		let medication = MedicationDataTestUtil.createMedication(frequency: expectedFrequency)

		// when
		let frequency = try medication.value(of: Medication.frequency) as? Frequency

		// then
		XCTAssertEqual(frequency, expectedFrequency)
	}

	func testGivenStartedOnAttribute_valueOf_returnsCorrectStartedOn() throws {
		// given
		let expectedStartedOn = Date()
		let medication = MedicationDataTestUtil.createMedication(startedOn: expectedStartedOn)

		// when
		let startedOn = try medication.value(of: Medication.startedOn) as? Date

		// then
		XCTAssertEqual(startedOn, expectedStartedOn)
	}

	func testGivenNotesAttribute_valueOf_returnsCorrectNotes() throws {
		// given
		let expectedNotes = "this is some notes"
		let medication = MedicationDataTestUtil.createMedication(note: expectedNotes)

		// when
		let notes = try medication.value(of: Medication.notes) as? String

		// then
		XCTAssertEqual(notes, expectedNotes)
	}

	// MARK: - set(attribute: to:)

	func testGivenNameAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.nameAttribute, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenNameAttribute_set_correctlySetsName() throws {
		// given
		let expectedName = "this is a name"
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.nameAttribute, to: expectedName)

		// then
		XCTAssertEqual(expectedName, medication.name)
	}

	func testGivenDosageAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.dosage, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenDosageAttribute_set_correctlySetsDosage() throws {
		// given
		let expectedDosage = Dosage(2, "ml")
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.dosage, to: expectedDosage)

		// then
		XCTAssertEqual(expectedDosage, medication.dosage)
	}

	func testGivenFrequencyAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.frequency, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenFrequencyAttribute_set_correctlySetsFrequency() throws {
		// given
		let expectedFrequency = Frequency(4, .weekOfYear)!
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.frequency, to: expectedFrequency)

		// then
		XCTAssertEqual(expectedFrequency, medication.frequency)
	}

	func testGivenStartedOnAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.startedOn, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenStartedOnAttribute_set_correctlySetsStartedOn() throws {
		// given
		let expectedStartedOn = Date()
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.startedOn, to: expectedStartedOn)

		// then
		XCTAssertEqual(expectedStartedOn, medication.startedOn)
	}

	func testGivenStartedOnDateAttributeAndStartedOnDateTimeZoneNotYetSet_set_setsStartedOnDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		DependencyInjector.get(Settings.self).setConvertTimeZones(true)
		let transaction = DependencyInjector.get(Database.self).transaction()
		let medication = try transaction.new(Medication.self)
		let startDate = Date()

		// when
		try medication.set(attribute: Medication.startedOn, to: startDate)

		// then
		let expectedDate = DependencyInjector.get(CalendarUtil.self).convert(startDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(medication.startedOn, expectedDate)
	}

	func testGivenNotesAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.notes, to: value)) { error in
			// then
			XCTAssert(error is TypeMismatchError)
		}
	}

	func testGivenNotesAttribute_set_correctlySetsNotes() throws {
		// given
		let expectedNotes = "these are some notes about the medication"
		let medication = MedicationDataTestUtil.createMedication()

		// when
		try medication.set(attribute: Medication.notes, to: expectedNotes)

		// then
		XCTAssertEqual(expectedNotes, medication.notes)
	}

	func testGivenSourceAttributeAndWrondValueType_set_throwsUnknownAttributeError() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let value = 12

		// when
		XCTAssertThrowsError(try medication.set(attribute: Medication.sourceAttribute, to: value)) { error in
			// then
			XCTAssert(error is UnknownAttributeError)
		}
	}

	// MARK: - sortedDoses()

	func testGivenNoDoses_sortedDoses_returnsEmptyArray() {
		// given
		let medication = MedicationDataTestUtil.createMedication()

		// when
		let sortedDoses = medication.sortedDoses(ascending: true)

		// then
		assertThat(sortedDoses, hasCount(0))
	}

	func testGivenMultipleDosesWithAscendingTrue_sortedDoses_returnsDosesInAscendingOrderOfTimestamp() throws {
		// given
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(medication: medication, dosage: nil, timestamp: Date())
		let dose2 = MedicationDataTestUtil.createDose(medication: medication, dosage: nil, timestamp: Date())
		medication = try DependencyInjector.get(Database.self).pull(savedObject: medication)

		// when
		let sortedDoses = medication.sortedDoses(ascending: true)

		// then
		assertThat(sortedDoses, contains(dose1, dose2))
	}

	func testGivenMultipleDosesWithAscendingFalse_sortedDoses_returnsDosesInAscendingOrderOfTimestamp() throws {
		// given
		var medication = MedicationDataTestUtil.createMedication()
		let dose1 = MedicationDataTestUtil.createDose(medication: medication, dosage: nil, timestamp: Date())
		let dose2 = MedicationDataTestUtil.createDose(medication: medication, dosage: nil, timestamp: Date())
		medication = try DependencyInjector.get(Database.self).pull(savedObject: medication)

		// when
		let sortedDoses = medication.sortedDoses(ascending: false)

		// then
		assertThat(sortedDoses, contains(dose2, dose1))
	}

	// MARK: - setSource()

	func testGivenNewSourceValue_setSource_correctlySetsSource() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let newSource = medication.source + 1

		// when
		medication.setSource(Sources.MedicationSourceNum.init(rawValue: newSource)!)

		// then
		XCTAssertEqual(medication.source, newSource)
	}

	func testGivenIntrospectiveWithTimeZoneNotSet_setSource_setsStartedOnDateTimeZone() throws {
		// given
		let timeZoneOnSet = TimeZone(abbreviation: "PST")!
		let timeZoneOnAccess = TimeZone(abbreviation: "EST")!
		let calendarUtil = CalendarUtilImpl()
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: calendarUtil))
		calendarUtil.setTimeZone(timeZoneOnSet)

		DependencyInjector.get(Settings.self).setConvertTimeZones(true)
		let transaction = DependencyInjector.get(Database.self).transaction()
		let medication = try transaction.new(Medication.self)

		// when
		medication.setSource(.introspective)

		// then
		let startedOnDate = Date()
		medication.startedOn = startedOnDate
		let expectedDate = DependencyInjector.get(CalendarUtil.self).convert(startedOnDate, from: timeZoneOnAccess, to: timeZoneOnSet)
		calendarUtil.setTimeZone(timeZoneOnAccess)
		XCTAssertEqual(medication.startedOn, expectedDate)
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let medication = MedicationDataTestUtil.createMedication()
		let areEqual = medication == medication

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwoMedicationsWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let otherMedication = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication == otherMedication

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = HeartRate(12, Date())

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()

		// when
		let areEqual = medication.equalTo(medication as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNameMismatch_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name + "other stuff",
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDosageMismatch_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: Dosage((medication.dosage?.amount ?? 1) + 1, "mg"),
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenFrequencyMismatch_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: (medication.frequency ?? Frequency(1, .hour)!) + Frequency(1, .hour)!,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenStartedOnMismatch_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: (medication.startedOn ?? Date()) + 1.days,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNotesMismatch_equalToAttributed_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: (medication.notes ?? "") + "other stuff",
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalToAttributed_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)
		other.source = medication.source + 1

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRecordScreenIndexMismatch_equalToAttributed_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex + 1)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoMedicationsWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(medication:)

	func testGivenSameObjectTwice_equalTo_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()

		// when
		let areEqual = medication.equalTo(medication)

		// then
		XCTAssert(areEqual)
	}

	func testGivenNameMismatch_equalTo_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name + "other stuff",
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDosageMismatch_equalTo_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: Dosage((medication.dosage?.amount ?? 1) + 1, "mg"),
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenFrequencyMismatch_equalTo_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: (medication.frequency ?? Frequency(1, .hour)!) + Frequency(1, .hour)!,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenStartedOnMismatch_equalTo_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: (medication.startedOn ?? Date()) + 1.days,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenNotesMismatch_equalTo_returnsFalse() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: (medication.notes ?? "") + "other stuff",
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalTo_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)
		other.source = medication.source + 1

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenRecordScreenIndexMismatch_equalTo_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex + 1)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoMedicationsWithSameValues_equalTo_returnsTrue() {
		// given
		let medication = MedicationDataTestUtil.createMedication()
		let other = MedicationDataTestUtil.createMedication(
			name: medication.name,
			frequency: medication.frequency,
			dosage: medication.dosage,
			startedOn: medication.startedOn,
			note: medication.notes,
			recordScreenIndex: medication.recordScreenIndex)

		// when
		let areEqual = medication.equalTo(other)

		// then
		XCTAssert(areEqual)
	}
}
