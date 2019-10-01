//
//  SleepTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftDate
import SwiftyMocky
@testable import Introspective
@testable import Samples

final class SleepTableViewCellUnitTests: UnitTest {

	private final var cell: SleepTableViewCell!
	private final var valueLabel: UILabel!
	private final var timestampLabel: UILabel!

	private final var sleep: Sleep!
	private final let state = Sleep.State.asleep
	private final let startTime = Date() - 5.hours
	private final let endTime = Date()
	private final let startTimeText = "description of start time"
	private final let endTimeText = "description of end time"

	final override func setUp() {
		super.setUp()

		Given(mockCalendarUtil, .string(for: .value(startTime), dateStyle: .any, timeStyle: .any, willReturn: startTimeText))
		Given(mockCalendarUtil, .string(for: .value(endTime), dateStyle: .any, timeStyle: .any, willReturn: endTimeText))

		valueLabel = UILabel()
		timestampLabel = UILabel()

		cell = SleepTableViewCell()
		cell.valueLabel = valueLabel
		cell.timestampLabel = timestampLabel
		// need to add as subviews to avoid no common ancestor fatal error
		cell.addSubview(valueLabel)
		cell.addSubview(timestampLabel)

		sleep = Sleep(state, startDate: startTime, endDate: endTime)
	}

	// MARK: - sleepDidSet

	func testGivenNilSleep_sleepDidSet_doesNotThrowError() {
		// when
		cell.sleep = nil

		// then - no errors thrown
	}

	func testGivenNonNilSleep_sleepDidSet_setsValueLabelTextToSleepState() {
		// when
		cell.sleep = sleep

		// then
		XCTAssertEqual(valueLabel.text, state.description)
	}

	func testGivenNonNilSleep_sleepDidSet_setsTimestampLabelToStartTimeToEndTime() {
		// when
		cell.sleep = sleep

		// then
		XCTAssertEqual(timestampLabel.text, "\(startTimeText) to \(endTimeText)")
	}

	func testGivenNonNilSleep_sleepDidSet_setsTranslatesAutoresizingMaskIntoConstraintsToFalseForLabels() {
		// when
		cell.sleep = sleep

		// then
		XCTAssertFalse(valueLabel.translatesAutoresizingMaskIntoConstraints)
		XCTAssertFalse(timestampLabel.translatesAutoresizingMaskIntoConstraints)
	}
}
