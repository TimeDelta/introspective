//
//  ExtraInformationTableViewCellUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 4/16/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
@testable import Introspective

final class ExtraInformationTableViewCellUnitTests: UnitTest {

	private final var cell: ExtraInformationTableViewCell!
	private final var keyValueLabel: UILabel!

	private final var information: ExtraInformationMock!
	private final let informationDescription = "description of information"
	private final let value = "value of information"

	final override func setUp() {
		super.setUp()

		keyValueLabel = UILabel()

		cell = ExtraInformationTableViewCell()
		cell.keyValueLabel = keyValueLabel

		information = ExtraInformationMock()
		Given(information, .description(getter: informationDescription))
	}

	// MARK: - extraInformationDidSet

	func testGivenNilInformation_extraInformationDidSet_doesNotThrowError() {
		// when
		cell.extraInformation = nil

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNilValue_extraInformationDidSet_doesNotThrowError() {
		// when
		cell.extraInformation = information

		// then - no errors thrown
	}

	func testGivenNonNilInformationAndNonNilValue_extraInformationDidSet_correctlySetsLabelText() {
		// given
		cell.value = value

		// when
		cell.extraInformation = information

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
		cell.extraInformation = information

		// when
		cell.value = value

		// then
		XCTAssertEqual(keyValueLabel.text, informationDescription.localizedCapitalized + ": " + value)
	}
}
