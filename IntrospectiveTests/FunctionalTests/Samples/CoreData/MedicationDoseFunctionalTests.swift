//
//  MedicationDoseFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 3/22/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import Hamcrest
@testable import Introspective

final class MedicationDoseFunctionalTests: FunctionalTest {

	private typealias Me = MedicationDoseFunctionalTests
	private static let name = "medication name"
	private static let dosage = Dosage(12, "mg")
	private static let timestamp = Date()

	private final var medication: Medication!
	private final var dose: MedicationDose!

	final override func setUp() {
		super.setUp()
		medication = MedicationDataTestUtil.createMedication(name: Me.name)
		dose = MedicationDataTestUtil.createDose(medication: medication, dosage: Me.dosage, timestamp: Me.timestamp)
	}

	// MARK: - value(of:)

	func testGivenUnknownAttribute_valueOf_throwsUnknownAttributeError() {
		// given
		let unknownAttribute = TextAttribute(name: "unknown")

		// when
		XCTAssertThrowsError(try dose.value(of: unknownAttribute)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	func testGivenNameAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try dose.value(of: MedicationDose.nameAttribute) as? String

		// then
		XCTAssertEqual(value, Me.name)
	}

	func testGivenTimestampAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try dose.value(of: CommonSampleAttributes.timestamp) as? Date

		// then
		XCTAssertEqual(value, Me.timestamp)
	}

	func testGivenDosageAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try dose.value(of: MedicationDose.dosage) as? Dosage

		// then
		XCTAssertEqual(value, Me.dosage)
	}

	func testGivenSourceAttribute_valueOf_returnsCorrectValue() throws {
		// when
		let value = try dose.value(of: MedicationDose.sourceAttribute) as? String

		// then
		XCTAssertEqual(value, "Introspective")
	}

	// MARK: - set(attribute: to:)

	func testGivenNameAttributeWithWrongValueType_set_throwsTypeMismatchError() {
		// given
		let value = 23

		// when
		XCTAssertThrowsError(try dose.set(attribute: MedicationDose.nameAttribute, to: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenNameAttribute_set_correctlySetsName() throws {
		// given
		let expectedName = medication.name + "other stuff"
		MedicationDataTestUtil.createMedication(name: expectedName)

		// when
		try dose.set(attribute: MedicationDose.nameAttribute, to: expectedName)

		// then
		XCTAssertEqual(dose.medication.name, expectedName)
	}

	func testGivenNameAttributeWithNameOfNonExistentDefinition_set_throwsUnsupportedValueError() {
		// given
		let nonExistentName = medication.name + "this doesn't exist"

		// when
		XCTAssertThrowsError(try dose.set(attribute: MedicationDose.nameAttribute, to: nonExistentName)) { error in
			// then
			assertThat(error, instanceOf(UnsupportedValueError.self))
		}
	}

	func testGivenDosageAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let value = 12

		// when
		XCTAssertThrowsError(try dose.set(attribute: MedicationDose.dosage, to: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenDosageAttributeWithCorrectValueType_set_correctlySetsDosage() throws {
		// given
		let expectedValue = Dosage(Me.dosage.amount + 1, "mg")

		// when
		try dose.set(attribute: MedicationDose.dosage, to: expectedValue)

		// then
		XCTAssertEqual(dose.dosage, expectedValue)
	}

	func testGivenTimestampAttributeAndWrongValueType_set_throwsTypeMismatchError() {
		// given
		let value = 12

		// when
		XCTAssertThrowsError(try dose.set(attribute: CommonSampleAttributes.timestamp, to: value)) { error in
			// then
			assertThat(error, instanceOf(TypeMismatchError.self))
		}
	}

	func testGivenTimestampAttributeWithCorrectValueType_set_correctlySetsTimestamp() throws {
		// given
		let expectedValue = Me.timestamp + 1.days

		// when
		try dose.set(attribute: CommonSampleAttributes.timestamp, to: expectedValue)

		// then
		XCTAssertEqual(dose.date, expectedValue)
	}

	func testGivenSourceAttribute_set_throwsUnknownAttributeError() {
		// given
		let value = 12

		// when
		XCTAssertThrowsError(try dose.set(attribute: MedicationDose.sourceAttribute, to: value)) { error in
			// then
			assertThat(error, instanceOf(UnknownAttributeError.self))
		}
	}

	// MARK: - ==

	func testGivenSameObjectTwice_equalToOperator_returnsTrue() {
		// when
		let areEqual = dose == dose

		// then
		XCTAssert(areEqual)
	}

	// https://stackoverflow.com/questions/42283715/overload-for-custom-class-is-not-always-called
	// https://stackoverflow.com/questions/6883848/why-am-i-not-able-to-override-isequal-in-my-nsmanagedobject-subclass
	func testGivenTwoMedicationsWithSameValuesButDifferentMemoryAddresses_equalToOperator_returnsFalse() {
		// given
		let otherDose = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Me.dosage,
			timestamp: Me.timestamp)

		// when
		let areEqual = dose == otherDose

		// then
		XCTAssertFalse(areEqual)
	}

	// MARK: - equalTo(attributed:)

	func testGivenWrongClass_equalToAttributed_returnsFalse() {
		// given
		let other = HeartRate(12, Date())

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSameObjectTwice_equalToAttributed_returnsTrue() {
		// when
		let areEqual = dose.equalTo(dose as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenMedicationMismatch_equalToAttributed_returnsFalse() {
		// given
		let otherMedication = MedicationDataTestUtil.createMedication(name: Me.name + "other stuff")
		let other = MedicationDataTestUtil.createDose(
			medication: otherMedication,
			dosage: Me.dosage,
			timestamp: Me.timestamp)

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenDosageMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(Me.dosage.amount + 1, "mg"),
			timestamp: Me.timestamp)

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenTimestampMismatch_equalToAttributed_returnsFalse() {
		// given
		let other = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Me.dosage,
			timestamp: Me.timestamp + 1.days)

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssertFalse(areEqual)
	}

	func testGivenSourceMismatch_equalToAttributed_returnsTrue() {
		// given
		let other = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Me.dosage,
			timestamp: Me.timestamp)
		other.source = dose.source + 1

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	func testGivenTwoDosesWithSameValues_equalToAttributed_returnsTrue() {
		// given
		let other = MedicationDataTestUtil.createDose(
			medication: medication,
			dosage: Dosage(Me.dosage.amount, Me.dosage.unit),
			timestamp: Me.timestamp)

		// when
		let areEqual = dose.equalTo(other as Attributed)

		// then
		XCTAssert(areEqual)
	}

	// MARK: - equalTo(sample:)

	// MARK: - equalTo(dose:)
}
