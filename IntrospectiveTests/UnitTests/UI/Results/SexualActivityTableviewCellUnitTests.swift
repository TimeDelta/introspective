//
//  SexualActivityTableviewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import Samples

final class SexualActivityTableviewCellUnitTests: UnitTest {

	private final var cell: SexualActivityTableViewCell!
	private final var valueLabel: UILabel!
	private final var timestampLabel: UILabel!

	private final var sexualActivity: SexualActivity!
	private final let protection = SexualActivity.Protection.used
	private final let timestamp = Date()
	private final let timestampText = "this is a description of the timestamp"

	final override func setUp() {
		super.setUp()

		Given(mockCalendarUtil, .string(for: .value(timestamp), dateStyle: .any, timeStyle: .any, willReturn: timestampText))

		valueLabel = UILabel()
		timestampLabel = UILabel()

		cell = SexualActivityTableViewCell()
		cell.valueLabel = valueLabel
		cell.timestampLabel = timestampLabel
		cell.addSubview(valueLabel)
		cell.addSubview(timestampLabel)

		sexualActivity = SexualActivity(timestamp, protection)
	}

	// MARK: - sampleDidSet

	func testGivenNilSample_sampleDidSet_doesNotThrowError() {
		// when
		cell.sample = nil

		// then - no error thrown
	}

	func testGivenNonNilSample_sampleDidSet_setsTimestampLabelTextToTimestamp() {
		// when
		cell.sample = sexualActivity

		// then
		XCTAssertEqual(timestampLabel.text, timestampText)
	}

	func testGivenNonNilSample_sampleDidSet_includesProtectionInValueLabelText() {
		// when
		cell.sample = sexualActivity

		// then
		if let valueLabelText = valueLabel.text {
			assertThat(valueLabelText, containsString(protection.description))
		} else {
			XCTFail("No value label text")
		}
	}

	func testGivenNonNilSample_sampleDidSet_setsTranslatesAutoresizingMaskIntoConstraintsToFalseForLabels() {
		// when
		cell.sample = sexualActivity

		// then
		XCTAssertFalse(valueLabel.translatesAutoresizingMaskIntoConstraints)
		XCTAssertFalse(timestampLabel.translatesAutoresizingMaskIntoConstraints)
	}
}
