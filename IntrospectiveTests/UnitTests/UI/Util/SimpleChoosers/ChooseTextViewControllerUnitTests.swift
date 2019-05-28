//
//  ChooseTextViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/27/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import Hamcrest
@testable import Introspective

class ChooseTextViewControllerUnitTests: UnitTest {

	private final var picker: UIPickerView!

	private final var controller: ChooseTextViewControllerImpl!

	override func setUp() {
		super.setUp()

		picker = UIPickerView()

		let storyboard = UIStoryboard(name: "Util", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "chooseText") as! ChooseTextViewControllerImpl)

		controller.picker = picker
	}

	// MARK: - availableChoicesDidSet()

	func testGivenMoreThanOneOfSameChoice_availableChoicesDidSet_reducesAvailableChoicesToUniqueSet() {
		// given
		let originalChoices = [
			"a", "a", "a",
			"b", "b",
			"c",
		]

		// when
		controller.availableChoices = originalChoices

		// then
		assertThat(controller.availableChoices, hasCount(Set(originalChoices).count))
	}

	func testGivenAvailableChoicesIsNil_availableChoicesDidSet_doesNotThrowError() {
		// given
		let availableChoices: [String]? = nil

		// when
		controller.availableChoices = availableChoices

		// then - no error is thrown
	}

	// MARK: - viewDidLoad()

	func testGivenSelectedTextIsInAvailableChoices_viewDidLoad_selectedCorrectPickerIndex() {
		// given
		let expectedText = "hfuoerw"
		controller.availableChoices = [
			"jrwio",
			expectedText,
		]
		controller.selectedText = expectedText

		// when
		controller.viewDidLoad()

		// then
		assertThat(picker, hasSelected(row: 1))
	}

	func testGivenNoSelectedGrouperType_viewDidLoad_setsSelectedTypeToFirstPossible() {
		// given
		let expectedText = "hfuoerw"
		controller.availableChoices = [
			expectedText,
			"jrwio",
		]
		controller.selectedText = nil

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.selectedText, equalTo(expectedText))
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
		controller.availableChoices = [
			"fkdl",
			"jrwio",
			"",
		]

		// when
		let numberOfRows = controller.pickerView(picker, numberOfRowsInComponent: 0)

		// then
		assertThat(numberOfRows, equalTo(controller.availableChoices.count))
	}

	// MARK: - pickerViewTitleForRow()

	func test_pickerViewTitleForRow_returnsTextForThatIndex() {
		// given
		let expectedText = "hfuoerw"
		controller.availableChoices = [
			expectedText,
			"fer",
		]

		// when
		let title = controller.pickerView(picker, titleForRow: 0, forComponent: 0)

		// then
		assertThat(title, equalTo(expectedText))
	}

	// MARK: - pickerViewDidSelectRow()

	func test_pickerViewDidSelectRow_setsSelectedGrouperType() {
		// given
		let expectedText = "hfuoerw"
		controller.availableChoices = [
			expectedText,
		]
		controller.selectedText = nil

		// when
		controller.pickerView(picker, didSelectRow: 0, inComponent: 0)

		// then
		assertThat(controller.selectedText, equalTo(expectedText))
	}
}
