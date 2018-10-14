//
//  MedicationDoseQueryFunctionalTest.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 10/14/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
@testable import Introspective

final class MedicationDoseQueryFunctionalTest: QueryFunctionalTest {

	private var query: MedicationDoseQuery!

	final override func setUp() {
		super.setUp()
		query = MedicationDoseQueryImpl()
	}

	func testGivenNoDosesInDatabase_runQuery_returnsNoSamplesFoundError() {
		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			XCTAssert(waitError == nil)
			XCTAssert(self.error != nil)
			XCTAssert(self.error is NoSamplesFoundQueryError)
		}
	}

	func testGivenOneDoseInDatabaseAndQueryContainsNoRestrictions_runQuery_returnsThatDose() {
		// given
		let expectedSamples: [Sample] = [createDose()]
		DependencyInjector.db.save()

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForSpecificMedicationNameDosageAndTimestamp_runQuery_returnsCorrectSamples() {
		// given
		let medicationName = "this is a medication"
		let dosage = Dosage(15, "mg")
		let timestamp = Date()
		var expectedSamples = [Sample]()
		expectedSamples.append(createDose(medication: createMedication(name: medicationName), dosage: dosage, timestamp: timestamp))
		let _ = createDose(dosage: dosage, timestamp: timestamp)
		DependencyInjector.db.save()

		let medicationNameRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MedicationDose.nameAttribute, substring: medicationName)
		query.attributeRestrictions.append(medicationNameRestriction)
		let dosageRestriction = EqualToDosageAttributeRestriction(restrictedAttribute: MedicationDose.dosage, value: dosage)
		query.attributeRestrictions.append(dosageRestriction)
		let timestampRestriction = OnDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: timestamp)
		query.attributeRestrictions.append(timestampRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForAllDosesGreaterThanTwoMilligrams_runQuery_returnsCorrectSamples() {
		// given
		let targetDosage = Dosage(2, "mg")
		var expectedSamples = [Sample]()
		expectedSamples.append(createDose(dosage: Dosage(targetDosage.amount + 0.5, targetDosage.unit)))
		expectedSamples.append(createDose(dosage: Dosage(1, "dg")))
		let _ = createDose()
		let _ = createDose(dosage: Dosage(2, "µg"))
		DependencyInjector.db.save()

		let noteRestriction = GreaterThanDosageAttributeRestriction(restrictedAttribute: MedicationDose.dosage, value: targetDosage)
		query.attributeRestrictions.append(noteRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	func testGivenQueryForAllDosesLessThanOrEqualToEightCentigramsForSpecificMedication_runQuery_returnsCorrectSamples() {
		// given
		let targetMedication = createMedication(name: "this is a medication")
		let targetDosage = Dosage(8, "cg")
		var expectedSamples = [Sample]()
		expectedSamples.append(createDose(medication: targetMedication, dosage: targetDosage, timestamp: Date()))
		expectedSamples.append(createDose(medication: targetMedication, dosage: Dosage(100, "mcg"), timestamp: Date() + 1.days))
		let _ = createDose()

		DependencyInjector.db.save()

		let medicationNameRestriction = ContainsStringAttributeRestriction(restrictedAttribute: MedicationDose.nameAttribute, substring: targetMedication.name)
		query.attributeRestrictions.append(medicationNameRestriction)
		let dosageRestriction = LessThanOrEqualToDosageAttributeRestriction(restrictedAttribute: MedicationDose.dosage, value: targetDosage)
		query.attributeRestrictions.append(dosageRestriction)

		// when
		query.runQuery(callback: queryComplete)

		// then
		waitForExpectations(timeout: 0.1) { waitError in
			if self.assertNoErrors(waitError) {
				self.assertOnlyExpectedSamples(expectedSamples: expectedSamples)
			}
		}
	}

	private final func createMedication(
		name: String = "",
		frequency: Frequency? = nil,
		dosage: Dosage? = nil,
		startedOn: Date? = nil,
		note: String? = nil)
	-> Medication {
		return MedicationDataTestUtil.createMedication(name: name, frequency: frequency, dosage: dosage, startedOn: startedOn, note: note)
	}

	private final func createDose(medication: Medication? = nil, dosage: Dosage? = nil, timestamp: Date = Date()) -> MedicationDose {
		return MedicationDataTestUtil.createDose(medication: medication ?? createMedication(), dosage: dosage, timestamp: timestamp)
	}
}
