//
//  ChooseActivityDefinitionViewControllerFunctionalTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective

final class ChooseActivityDefinitionViewControllerFunctionalTests: FunctionalTest {

	private final var picker: UIPickerView!

	private final var controller: ChooseActivityDefinitionViewControllerImpl!

	final override func setUp() {
		super.setUp()

		picker = UIPickerView()

		let storyboard = UIStoryboard(name: "Util", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "chooseActivityDefinition") as! ChooseActivityDefinitionViewControllerImpl)

		controller.picker = picker
	}

	// MARK: - viewDidLoad()

	func testGivenNoAvailableDefinitions_viewDidLoad_pullsFromDatabaseInAscendingRecordScreenIndexOrder() {
		// given
		let definition3 = ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 3)
		let definition1 = ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 1)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 2)

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.availableDefinitions, contains(definition1, definition2, definition3))
	}

	func testGivenSelectedDefinitionNotNil_viewDidLoad_setsPickerToCorrectIndex() {
		// given
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 2)
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 0)
		let definition2 = ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 1)
		controller.selectedDefinition = definition2

		// when
		controller.viewDidLoad()

		// then
		assertThat(controller.picker.selectedRow(inComponent: 0), equalTo(1))
	}

	// MARK: - numberOfComponentsInPickerView()

	func test_numberOfComponentsInPickerView_returns1() {
		// when
		let numComponents = controller.numberOfComponents(in: picker)

		// themn
		assertThat(numComponents, equalTo(1))
	}

	// MARK: - pickerViewNumberOfRowsInComponent()

	func testGivenThreeDefinitions_pickerViewNumberOfRowsInComponent_returns3() {
		// given
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 1)
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 2)
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 3)
		controller.viewDidLoad()

		// when
		let numRows = controller.pickerView(picker, numberOfRowsInComponent: 0)

		// then
		assertThat(numRows, equalTo(3))
	}

	// MARK: - pickerViewTitleForRow()

	func test_pickerViewTitleForRow_returnsNameOfDefinitionForGivenRow() {
		// given
		let expectedTitle = "fdsa"
		ActivityDataTestUtil.createActivityDefinition(name: "a", recordScreenIndex: 0)
		ActivityDataTestUtil.createActivityDefinition(name: "b", recordScreenIndex: 1)
		ActivityDataTestUtil.createActivityDefinition(name: expectedTitle, recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		let title = controller.pickerView(picker, titleForRow: 2, forComponent: 0)

		// then
		assertThat(title, equalTo(expectedTitle))
	}

	// MARK: - pickerViewDidSelectRow()

	func testGivenValidIndex_pickerViewDidSelectRow_correctlySetsSelectedDefinition() {
		// given
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 0)
		let expectedDefintion = ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 1)
		ActivityDataTestUtil.createActivityDefinition(recordScreenIndex: 2)
		controller.viewDidLoad()

		// when
		controller.pickerView(picker, didSelectRow: 1, inComponent: 0)

		// then
		assertThat(controller.selectedDefinition, equals(expectedDefintion))
	}
}
