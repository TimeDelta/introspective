//
//  BloodPressureTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class BloodPressureTableViewCellUnitTests: UnitTest {

	private final var cell: BloodPressureTableViewCell!
	private final var valueLabel: UILabel!
	private final var timestampLabel: UILabel!

	private final var bloodPressure: BloodPressure!
	private final let systolic = 123.4
	private final let diastolic = 83.1
	private final let timestamp = Date()
	private final let timestampText = "this is a description of the timestamp"

	final override func setUp() {
		super.setUp()

		Given(mockCalendarUtil, .string(for: .value(timestamp), dateStyle: .any, timeStyle: .any, willReturn: timestampText))

		valueLabel = UILabel()
		timestampLabel = UILabel()

		cell = BloodPressureTableViewCell()
		cell.valueLabel = valueLabel
		cell.timestampLabel = timestampLabel
		// need to add as subviews to avoid no common ancestor fatal error
		cell.addSubview(valueLabel)
		cell.addSubview(timestampLabel)

		bloodPressure = BloodPressure(systolic: systolic, diastolic: diastolic, timestamp)
	}

	// MARK: - sampleDidSet

	func testGivenNilSample_sampleDidSet_doesNotThrowError() {
		// when
		cell.sample = nil

		// then - no errors thrown
	}

	func testGivenNonNilSample_sampleDidSet_setsTimestampLabelTextToTimestamp() {
		// when
		cell.sample = bloodPressure

		// then
		XCTAssertEqual(timestampLabel.text, timestampText)
	}

	func testGivenNonNilSample_sampleDidSet_setsValueLabelTextToSystolicOverDiastolic() {
		// when
		cell.sample = bloodPressure

		// then
		XCTAssertEqual(valueLabel.text, "\(systolic)/\(diastolic)")
	}

	func testGivenNonNilSample_sampleDidSet_setsTranslatesAutoresizingMaskIntoConstraintsToFalseForLabels() {
		// when
		cell.sample = bloodPressure

		// then
		XCTAssertFalse(valueLabel.translatesAutoresizingMaskIntoConstraints)
		XCTAssertFalse(timestampLabel.translatesAutoresizingMaskIntoConstraints)
	}
}
