//
//  MedicationDoseTableViewCellFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective

/// Has to be functional test because cannot create instance of MedicationDose
/// without CoreData stack (can't even create mock)
final class MedicationDoseTableViewCellFunctionalTests: FunctionalTest {

	private final var cell: MedicationDoseTableTableViewCell!

	private final var nameLabel: UILabel!
	private final var doseAndTimestampLabel: UILabel!

	private final var dose: MedicationDose!
	private final let medicationName = "this is the name of the medication"
	private final let timestamp = Date()
	private final let timestampText = "this is the description of the timestamp for the dosage"
	private final let dosage = Dosage(2, "mg")

	final override func setUp() {
		super.setUp()

		let mockCalendarUtil = CalendarUtilMock()
		utilFactory.calendar = mockCalendarUtil
		Given(mockCalendarUtil, .string(for: .value(timestamp), dateStyle: .any, timeStyle: .any, willReturn: timestampText))
		Given(mockCalendarUtil, .currentTimeZone(willReturn: TimeZone.autoupdatingCurrent))
		Given(mockCalendarUtil, .convert(.value(timestamp), from: .any, to: .any, willReturn: timestamp))

		nameLabel = UILabel()
		doseAndTimestampLabel = UILabel()

		cell = MedicationDoseTableTableViewCell()
		cell.medicationNameLabel = nameLabel
		cell.doseAndTimestampLabel = doseAndTimestampLabel

		let medication = MedicationDataTestUtil.createMedication(name: medicationName)
		dose = MedicationDataTestUtil.createDose(medication: medication, dosage: dosage, timestamp: timestamp)
	}

	// MARK: - medicationDoseDidSet

	func testGivenNilMedicationDose_medicationDoseDidSet_doesNotThrowError() {
		// when
		cell.medicationDose = nil

		// then - no errors thrown
	}

	func testGivenNonNilMedicationDose_medicationDoseDidSet_includesDosageOnDosageAndTimestampLabel() {
		// when
		cell.medicationDose = dose

		// then
		XCTAssertEqual(nameLabel.text, medicationName)
		if let doseAndTimestampText = doseAndTimestampLabel.text {
			assertThat(doseAndTimestampText, containsString(dosage.description))
		} else {
			XCTFail("No dose / timestamp text")
		}
	}

	func testGivenNonNilMedicationDose_medicationDoseDidSet_includesTimesampOnDosageAndTimestampLabel() {
		// when
		cell.medicationDose = dose

		// then
		XCTAssertEqual(nameLabel.text, medicationName)
		if let doseAndTimestampText = doseAndTimestampLabel.text {
			assertThat(doseAndTimestampText, containsString(timestampText))
		} else {
			XCTFail("No dose / timestamp text")
		}
	}
}
