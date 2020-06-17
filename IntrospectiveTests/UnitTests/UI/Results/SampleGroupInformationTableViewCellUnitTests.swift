//
//  SampleGroupInformationTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class SampleGroupInformationTableViewCellUnitTests: UnitTest {

	private final var cell: SampleGroupInformationTableViewCell!
	private final var keyValueLabel: UILabel!

	private final var information: SampleGroupInformationMock!
	private final let informationDescription = "description of information"
	private final let value = "value of information"

	final override func setUp() {
		super.setUp()

		keyValueLabel = UILabel()

		cell = SampleGroupInformationTableViewCell()
		cell.keyValueLabel = keyValueLabel

		information = SampleGroupInformationMock()
		Given(information, .description(getter: informationDescription))
	}

	// MARK: - sampleGroupInformationDidSet

	func testGivenNilInformation_sampleGroupInformationDidSet_doesNotThrowError() {
		// when
		cell.sampleGroupInformation = nil

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNilValue_sampleGroupInformationDidSet_doesNotThrowError() {
		// when
		cell.sampleGroupInformation = information

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNonNilValue_sampleGroupInformationDidSet_correctlySetsLabelText() {
		// given
		cell.value = value

		// when
		cell.sampleGroupInformation = information

		// then
		XCTAssertEqual(keyValueLabel.text, informationDescription.localizedCapitalized + ": " + value)
	}

	// MARK: - valueDidSet

	func testGivenNilInformation_valueDidSet_doesNotThrowError() {
		// when
		cell.value = nil

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNilValue_valueDidSet_doesNotThrowError() {
		// when
		cell.value = value

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNonNilValue_valueDidSet_correctlySetsLabelText() {
		// given
		cell.sampleGroupInformation = information

		// when
		cell.value = value

		// then
		XCTAssertEqual(keyValueLabel.text, informationDescription.localizedCapitalized + ": " + value)
	}
}
