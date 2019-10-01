//
//  WeightTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective
@testable import Samples

final class WeightTableViewCellUnitTests: UnitTest {

	private final var cell: WeightTableViewCell!
	private final var valueLabel: UILabel!
	private final var timestampLabel: UILabel!

	private final var weightSample: Weight!
	private final let weight = 12.3
	private final let timestamp = Date()

	final override func setUp() {
		super.setUp()

		valueLabel = UILabel()
		timestampLabel = UILabel()

		cell = WeightTableViewCell()
		cell.valueLabel = valueLabel
		cell.timestampLabel = timestampLabel

		weightSample = Weight(weight, timestamp)
	}

	// MARK: - weightDidSet

	func testGivenNilWeight_weightDidSet_doesNotThrowError() {
		// when
		cell.weight = nil

		// then - no errors thrown
	}

	func testGivenNonNilWeight_weightDidSet_setsValueLabelTextAsWeightValue() {
		// given
		Given(mockCalendarUtil, .string(for: .value(timestamp), inFormat: .any, willReturn: ""))
		Given(mockCalendarUtil, .string(for: .value(timestamp), dateStyle: .any, timeStyle: .any, willReturn: ""))

		// when
		cell.weight = weightSample

		// then
		XCTAssertEqual(valueLabel.text, String(weight))
	}

	func testGivenNonNilWeight_weightDidSet_setsTimestampLabelTextAsDate() {
		// given
		let timestampString = "this should be on the timestamp label"
		Given(mockCalendarUtil, .string(for: .value(timestamp), inFormat: .any, willReturn: timestampString))
		Given(mockCalendarUtil, .string(for: .value(timestamp), dateStyle: .any, timeStyle: .any, willReturn: timestampString))

		// when
		cell.weight = weightSample

		// then
		XCTAssertEqual(timestampLabel.text, timestampString)
	}
}
