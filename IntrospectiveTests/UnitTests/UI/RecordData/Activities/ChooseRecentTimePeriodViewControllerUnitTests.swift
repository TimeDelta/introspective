//
//  ChooseRecentTimePeriodViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 6/10/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import Hamcrest
import SwiftyMocky
import XCTest

@testable import Introspective

class ChooseRecentTimePeriodViewControllerUnitTests: UnitTest {

	private typealias TestedClass = ChooseRecentTimePeriodViewControllerImpl

	private final var controller: ChooseRecentTimePeriodViewControllerImpl!
	private final var timeUnitPicker: UIPickerView!
	private final var numTimeUnitsField: UITextField!

	final override func setUp() {
		super.setUp()

		let storyboard = UIStoryboard(name: "RecordData", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "chooseRecentTimePeriod") as! ChooseRecentTimePeriodViewControllerImpl)
		timeUnitPicker = UIPickerView()
		numTimeUnitsField = UITextField()
		controller.timeUnitPicker = timeUnitPicker
		controller.numTimeUnitsField = numTimeUnitsField
	}

	// MARK: - viewDidLoad()

	func testGivenInitialTimeUnit_viewDidLoad_correctlySelectsThatTimeUnit() {
		// given
		SwiftyMocky.Given(mockStringUtil, .isNumber(.any, willReturn: true))
		let selectedIndex = 0
		controller.initialTimeUnit = TestedClass.supportedTimeUnits[selectedIndex]

		// when
		controller.viewDidLoad()

		// then
		assertThat(timeUnitPicker.selectedRow(inComponent: 0), equalTo(selectedIndex))
	}
}
