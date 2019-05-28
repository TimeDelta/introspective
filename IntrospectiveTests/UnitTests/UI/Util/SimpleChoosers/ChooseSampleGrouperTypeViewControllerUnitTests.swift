//
//  ChooseSampleGrouperTypeViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective

class ChooseSampleGrouperTypeViewControllerUnitTests: UnitTest {

	private final var picker: UIPickerView!

	private final var controller: ChooseSampleGrouperTypeViewControllerImpl!

	override func setUp() {
		super.setUp()

		picker = UIPickerView()

		let storyboard = UIStoryboard(name: "Util", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "chooseSampleGrouperType") as! ChooseSampleGrouperTypeViewControllerImpl)

		controller.picker = picker
	}

	// MARK: - viewDidLoad()

	func testGivenSelectedGrouperTypeIsInPossibleGrouperTypes_viewDidLoad_selectedCorrectPickerIndex() {
		// given
		let expectedType = AdvancedSampleGrouper.self
		controller.grouperTypes = [
			SameTimeUnitSampleGrouper.self,
			expectedType,
		]
		controller.selectedGrouperType = expectedType

		// when
		controller.viewDidLoad()

		// then
		assertThat(picker, hasSelected(row: 1))
	}

	func testGivenNoSelectedGrouperType_viewDidLoad_setsSelectedTypeToFirstPossible() {
		// given
		let expectedType = AdvancedSampleGrouper.self
		controller.grouperTypes = [
			expectedType,
			SameTimeUnitSampleGrouper.self,
		]
		controller.selectedGrouperType = nil

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.selectedGrouperType, equals(expectedType))
	}

	// MARK: - numberOfComponents()

	func test_numberOfComponents_returns1() {
		// when
		let numberOfComponents = controller.numberOfComponents(in: picker)

		// then
		assertThat(numberOfComponents, equalTo(1))
	}

	// MARK: - pickerViewNumberOfRowsInComponent()

	func test_pickerViewNumberOfRowsInComponent_returnsNumberOfPossibleGrouperTypes() {
		// given
		controller.grouperTypes = [
			AdvancedSampleGrouper.self,
			SameTimeUnitSampleGrouper.self,
			SameValueSampleGrouper.self,
		]

		// when
		let numberOfRows = controller.pickerView(picker, numberOfRowsInComponent: 0)

		// then
		assertThat(numberOfRows, equalTo(controller.grouperTypes.count))
	}

	// MARK: - pickerViewTitleForRow()

	func test_pickerViewTitleForRow_returnsCapitalizedUserVisibleDescription() {
		// given
		let expectedType = AdvancedSampleGrouper.self
		controller.grouperTypes = [
			expectedType
		]

		// when
		let title = controller.pickerView(picker, titleForRow: 0, forComponent: 0)

		// then
		assertThat(title, equalTo(expectedType.userVisibleDescription.localizedCapitalized))
	}

	// MARK: - pickerViewDidSelectRow()

	func test_pickerViewDidSelectRow_setsSelectedGrouperType() {
		// given
		let expectedType = AdvancedSampleGrouper.self
		controller.grouperTypes = [
			expectedType,
		]
		controller.selectedGrouperType = nil

		// when
		controller.pickerView(picker, didSelectRow: 0, inComponent: 0)

		// then
		assertThat(controller.selectedGrouperType, equals(expectedType))
	}
}
