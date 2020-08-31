//
//  GroupDefinitionTableViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/26/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective
@testable import AttributeRestrictions
@testable import BooleanAlgebra
@testable import Common
@testable import Samples
@testable import SampleGroupers

class GroupDefinitionTableViewControllerUnitTests: UnitTest {

	private final var addButton: UIBarButtonItem!
	private final var doneButton: UIBarButtonItem!

	private final var tableView: UITableView! {
		get { return controller.tableView }
	}
	private final let sampleType = HeartRate.self

	private final var groupDefinition: GroupDefinitionMock!

	private final var controller: GroupDefinitionTableViewController!

	override func setUp() {
		super.setUp()

		addButton = UIBarButtonItem()
		doneButton = UIBarButtonItem()

		let storyboard = UIStoryboard(name: "Util", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "groupDefinitionView") as! GroupDefinitionTableViewController)
		controller.addButton = addButton
		controller.doneButton = doneButton

		groupDefinition = GroupDefinitionMock()
		Given(groupDefinition, .name(getter: "f"))
		Given(groupDefinition, .sampleType(getter: sampleType))
		Given(groupDefinition, .expressionParts(getter: []))
		Given(groupDefinition, .isValid(willReturn: true))
		setGroupDefinition(groupDefinition)
	}

	// MARK: - viewDidLoad()

	func testGivenValidGroupDefinition_viewDidLoad_enablesDoneButton() {
		// given
		Given(groupDefinition, .isValid(willReturn: true))
		doneButton.isEnabled = false

		// when
		controller.viewDidLoad()

		// then
		assertThat(doneButton, isEnabled())
	}

	func testGivenInvalidGroupDefinition_viewDidLoad_disablesDoneButton() {
		// given
		Given(groupDefinition, .isValid(willReturn: false))
		doneButton.isEnabled = true

		// when
		controller.viewDidLoad()

		// then
		assertThat(doneButton, not(isEnabled()))
	}

	// MARK: - numberOfSections()

	func test_numberOfSections_returns2() {
		// when
		let numberOfSections = controller.numberOfSections(in: tableView)

		// then
		assertThat(numberOfSections, equalTo(2))
	}

	// MARK: - tableViewNumberOfRowsInSection()

	func testGivenSection0_tableViewNumberOfRowsInSection_returns1() {
		// given
		let sectionNumber = 0

		// when
		let numberOfRows = controller.tableView(tableView, numberOfRowsInSection: sectionNumber)

		// then
		assertThat(numberOfRows, equalTo(1))
	}

	func testGivenSection1_tableViewNumberOfRowsInSection_returnsNumberOfExpressionPartsInGroupDefinition() {
		// given
		let sectionNumber = 1
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .or, expression: nil),
			(type: .or, expression: nil),
			(type: .or, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let numberOfRows = controller.tableView(tableView, numberOfRowsInSection: sectionNumber)

		// then
		assertThat(numberOfRows, equalTo(groupDefinition.expressionParts.count))
	}

	// MARK: - tableViewTitleForHeaderInSection()

	func testGivenSection0_tableViewTitleForHeaderInSection_returnsNil() {
		// given
		let section = 0

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: section)

		// then
		assertThat(title, nilValue())
	}

	func testGivenSection1_tableViewTitleForHeaderInSection_returnsCondition() {
		// given
		let section = 1

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: section)

		// then
		assertThat(title, equalTo("Condition"))
	}

	// MARK: - tableViewCellForRowAt()

	func testGivenSection0_tableViewCellForRowAt_returnsGroupNameTableViewCellWithCorrectName() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		guard let castedCell = cell as? GroupNameTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(castedCell.groupName, equalTo(groupDefinition.name))
	}

	func testGivenIndexOfAndPart_tableViewCellForRowAt_returnsBasicCellWithAndAsText() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .and, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		assertThat(cell.textLabel, hasText(equalTo("and")))
	}

	func testGivenIndexOfOrPart_tableViewCellForRowAt_returnsBasicCellWithOrAsText() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		assertThat(cell.textLabel, hasText(equalTo("or")))
	}

	func testGivenIndexOfGroupStartPart_tableViewCellForRowAt_returnsBasicCellWithLeftParenthesisAsText() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .groupStart, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		assertThat(cell.textLabel, hasText(equalTo("(")))
	}

	func testGivenIndexOfGroupEndPart_tableViewCellForRowAt_returnsBasicCellWithRightParenthesisAsText() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .groupEnd, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		assertThat(cell.textLabel, hasText(equalTo(")")))
	}

	func testGivenIndexOfAttributeRestrictionPart_tableViewCellForRowAt_returnsAttributeRestrictionCellWithCorrectRestriction() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let attributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		let cell = controller.tableView(tableView, cellForRowAt: indexPath)

		// then
		guard let castedCell = cell as? AttributeRestrictionTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(castedCell.attributeRestriction, equals(attributeRestriction))
	}

	// MARK: - tableViewDidSelectRowAt()

	func testGivenSection0_tableViewDidSelectRowAt_deselectsSelectedRow() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)

		// when
		controller.tableView(tableView, didSelectRowAt: indexPath)

		// then
		assertThat(tableView.indexPathForSelectedRow, nilValue())
	}

	func testGivenNonExpressionPartAtSelectedRow_tableViewDidSelectRowAt_showsExpressionPartTypesActionSheet() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: alert))
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)

		// when
		controller.tableView(tableView, didSelectRowAt: indexPath)

		// then
		assertThat(alert.actions, hasItems(
			hasTitle("And"),
			hasTitle("Or"),
			hasTitle("Attribute Restriction"),
			hasTitle("Condition Group Start"),
			hasTitle("Condition Group End")))
		Verify(mockUiUtil, .present(.value(controller), .value(alert), animated: .any, completion: .any))
	}

	func testGivenPartTypeIsExpressionAtSelectedRow_tableViewDidSelectRowAt_setsCorrectSampleTypeOnPresentedController() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let attributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let presentedController = mockEditAttributeRestrictionViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: indexPath)

		// then
		assertThat(presentedController.sampleType, equals(sampleType))
	}

	func testGivenPartTypeIsExpressionAtSelectedRow_tableViewDidSelectRowAt_setsCorrectAttributeRestrictionOnPresentedController() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let attributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let presentedController = mockEditAttributeRestrictionViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: indexPath)

		// then
		assertThat(presentedController.attributeRestriction, equals(attributeRestriction))
	}

	// MARK: - tableViewMoveRowAt()

	func testGivenFromSection0_tableViewMoveRowAt_doesNotModifyExpressionParts() {
		// given
		let from = IndexPath(row: 0, section: 0)
		let to = IndexPath(row: 1, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .and, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let createdDefinition = GroupDefinitionMock()
		Given(createdDefinition, .isValid(willReturn: false))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))

		// when
		controller.tableView(tableView, moveRowAt: from, to: to)

		// then
		assertThat(controller.groupDefinition.expressionParts, contains(
			equals((type: .or, expression: nil)),
			equals((type: .and, expression: nil))
		))
	}

	func testGivenToSection0_tableViewMoveRowAt_doesNotModifyExpressionParts() {
		// given
		let from = IndexPath(row: 0, section: 1)
		let to = IndexPath(row: 1, section: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .and, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let createdDefinition = GroupDefinitionMock()
		Given(createdDefinition, .isValid(willReturn: false))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))

		// when
		controller.tableView(tableView, moveRowAt: from, to: to)

		// then
		assertThat(controller.groupDefinition.expressionParts, contains(
			equals((type: .or, expression: nil)),
			equals((type: .and, expression: nil))
		))
	}

	func testGivenValidFromAndToSections_tableViewMoveRowAt_swapsCorrectExpressionParts() {
		// given
		let from = IndexPath(row: 0, section: 1)
		let to = IndexPath(row: 1, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .and, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let createdDefinition = GroupDefinitionMock()
		Given(createdDefinition, .isValid(willReturn: false))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))

		// when
		controller.tableView(tableView, moveRowAt: from, to: to)

		// then
		assertThat(controller.groupDefinition.expressionParts, contains(
			equals((type: .and, expression: nil)),
			equals((type: .or, expression: nil))
		))
	}

	func testGivenSwappingMakesExpressionValid_tableViewMoveRowAt_enablesDoneButton() {
		// given
		let from = IndexPath(row: 2, section: 1)
		let to = IndexPath(row: 1, section: 1)
		let attributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
			(type: .expression, expression: attributeRestriction),
			(type: .or, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		Given(groupDefinition, .isValid(willReturn: true))
		setGroupDefinition(groupDefinition)
		doneButton.isEnabled = false

		// when
		controller.tableView(tableView, moveRowAt: from, to: to)

		// then
		assertThat(doneButton, isEnabled())
	}

	func testGivenSwappingMakesExpressionInvalid_tableViewMoveRowAt_disablesDoneButton() {
		// given
		let from = IndexPath(row: 2, section: 1)
		let to = IndexPath(row: 1, section: 1)
		let attributeRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: attributeRestriction),
			(type: .or, expression: nil),
			(type: .expression, expression: attributeRestriction),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		Given(groupDefinition, .isValid(willReturn: false))
		setGroupDefinition(groupDefinition)
		doneButton.isEnabled = true

		// when
		controller.tableView(tableView, moveRowAt: from, to: to)

		// then
		assertThat(doneButton, not(isEnabled()))
	}

	// MARK: - tableViewEditActionsForRowAt()

	func testGivenSection0_tableViewEditActionsForRowAt_returnsEmptyArray() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let editActions = controller.tableView(tableView, editActionsForRowAt: indexPath)

		// then
		guard let actions = editActions else {
			XCTFail("actions was nil")
			return
		}
		assertThat(actions, hasCount(0))
	}

	func testGivenSection1_tableViewEditActionsForRowAt_returnsActionThatRemovesCorrespondingExpressionPart() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .or, expression: nil),
			(type: .and, expression: nil),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		let createdDefinition = GroupDefinitionMock()
		Given(createdDefinition, .isValid(willReturn: false))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))
		Given(mockUiUtil, .tableViewRowAction(style: .any, title: .any, handler: .any, willReturn: UITableViewRowAction()))

		// when
		let actions = controller.tableView(tableView, editActionsForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<(UITableViewRowAction, IndexPath) -> Void>()
		Verify(mockUiUtil, .tableViewRowAction(style: .value(.destructive), title: .any, handler: .capturing(handlerCaptor)))
		guard let handler = handlerCaptor.value else {
			XCTFail("handler was nil")
			return
		}
		handler(actions![0], indexPath)

		// then
		guard let definition = controller.groupDefinition else {
			XCTFail("definition was nil")
			return
		}
		assertThat(definition.expressionParts, contains(equals((type: .and, expression: nil))))
	}

	// MARK: - tableViewCanMoveRowAt()

	func testGivenSection0_tableViewCanMoveRowAt_returnsFalse() {
		// given
		let indexPath = IndexPath(row: 0, section: 0)

		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: indexPath)

		// then
		XCTAssertFalse(canMove)
	}

	func testGivenSection1_tableViewCanMoveRowAt_returnsTrue() {
		// given
		let indexPath = IndexPath(row: 0, section: 1)

		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: indexPath)

		// then
		XCTAssert(canMove)
	}

	// MARK: - attributeRestrictionEdited()

	func test_attributeRestrictionEdited_overwritesCorrectExpressionPart() {
		// given
		let newRestriction = LessThanDoubleAttributeRestriction(restrictedAttribute: HeartRate.heartRate, value: 0)
		let expressionParts: [BooleanExpressionPart] = [
			(type: .expression, expression: AnyAttributeRestriction(restrictedAttribute: HeartRate.heartRate)),
			(type: .expression, expression: ExpressionStub("b")),
		]
		Given(groupDefinition, .expressionParts(getter: expressionParts))
		setGroupDefinition(groupDefinition)
		mockEditAttributeRestrictionViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		let createdDefinition = GroupDefinitionMock(sampleType)
		Given(createdDefinition, .isValid(willReturn: false))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))

		// when
		Given(
			mockUiUtil,
			.value(for: .value(.attributeRestriction), from: .any, keyIsOptional: .any, willReturn: newRestriction))
		NotificationCenter.default.post(
			name: NotificationName.attributeRestrictionEdited.toName(),
			object: nil,
			userInfo: [UserInfoKey.attributeRestriction : newRestriction])

		// then
		guard let definition = controller.groupDefinition else {
			XCTFail("definition was nil")
			return
		}
		assertThat(definition.expressionParts, contains(
			equals((type: .expression, expression: newRestriction)),
			equals(expressionParts[1])))
	}

	// MARK: - groupNameEdited()

	func test_groupNameEdited_setsNewNameForGroupDefinition() {
		// given
		let newName = groupDefinition.name + "other stuff"
		let createdDefinition = GroupDefinitionMock()
		Given(createdDefinition, .isValid(willReturn: false))
		Given(createdDefinition, .description(getter: ""))
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: createdDefinition))
		controller.viewDidLoad()

		// when
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: newName))
		NotificationCenter.default.post(
			name: NotificationName.groupNameEdited.toName(),
			object: nil,
			userInfo: [UserInfoKey.text : newName])

		// then
		assertThat(controller.groupDefinition, hasName(newName))
	}

	func testGivenDefinitionNoLongerValid_groupNameEdited_disablesDoneButton() {
		// given
		let newName = groupDefinition.name + "other stuff"
		Given(groupDefinition, .isValid(willReturn: false))
		doneButton.isEnabled = true
		controller.viewDidLoad()

		// when
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: newName))
		NotificationCenter.default.post(
			name: NotificationName.groupNameEdited.toName(),
			object: nil,
			userInfo: [UserInfoKey.text : newName])

		// then
		assertThat(doneButton, not(isEnabled()))
	}

	func testGivenDefinitionNowValid_groupNameEdited_enablesDoneButton() {
		// given
		let newName = groupDefinition.name + "other stuff"
		Given(groupDefinition, .isValid(willReturn: true))
		doneButton.isEnabled = false
		controller.viewDidLoad()

		// when
		Given(mockUiUtil, .value(for: .value(.text), from: .any, keyIsOptional: .any, willReturn: newName))
		NotificationCenter.default.post(
			name: NotificationName.groupNameEdited.toName(),
			object: nil,
			userInfo: [UserInfoKey.text : newName])

		// then
		assertThat(doneButton, isEnabled())
	}

	// MARK: - Helper Functions

	private final func setGroupDefinition(_ groupDefinition: GroupDefinition) {
		controller.groupDefinition = groupDefinition
		Given(mockSampleGrouperFactory, .groupDefinition(.any, willReturn: groupDefinition))
	}

	@discardableResult
	private final func mockEditAttributeRestrictionViewController() -> EditAttributeRestrictionViewControllerMock {
		let controller = EditAttributeRestrictionViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("editAttributeRestriction"),
			from: .value("Query"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
