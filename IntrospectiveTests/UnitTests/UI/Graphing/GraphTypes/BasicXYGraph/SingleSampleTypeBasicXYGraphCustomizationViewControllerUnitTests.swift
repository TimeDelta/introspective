//
//  SingleSampleTypeBasicXYGraphCustomizationViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
@testable import Introspective

final class SingleSampleTypeBasicXYGraphCustomizationViewControllerUnitTests: UnitTest {

	private final let sampleTypes: [Sample.Type] = [Activity.self, HeartRate.self]

	private final var sampleTypePicker: UIPickerView!
	private final var clearSeriesGrouperButton: UIButton!
	private final var chooseSeriesGrouperButton: UIButton!
	private final var clearPointGrouperButton: UIButton!
	private final var choosePointGrouperButton: UIButton!
	private final var queryButton: UIButton!
	private final var xAxisButton: UIButton!
	private final var yAxisButton: UIButton!
	private final var showGraphButton: UIButton!
	private final var clearQueryButton: UIButton!

	private final var controller: SingleSampleTypeBasicXYGraphCustomizationViewController!

	override func setUp() {
		super.setUp()

		sampleTypePicker = UIPickerView()
		clearSeriesGrouperButton = UIButton()
		chooseSeriesGrouperButton = UIButton()
		clearPointGrouperButton = UIButton()
		choosePointGrouperButton = UIButton()
		queryButton = UIButton()
		xAxisButton = UIButton()
		yAxisButton = UIButton()
		showGraphButton = UIButton()
		clearQueryButton = UIButton()

		Given(mockSampleFactory, .allTypes(willReturn: sampleTypes))

		let storyboard = UIStoryboard(name: "BasicXYGraph", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "singleSampleTypeSetup") as! SingleSampleTypeBasicXYGraphCustomizationViewController)

		controller.sampleTypePicker = sampleTypePicker
		controller.clearSeriesGrouperButton = clearSeriesGrouperButton
		controller.chooseSeriesGrouperButton = chooseSeriesGrouperButton
		controller.clearPointGrouperButton = clearPointGrouperButton
		controller.choosePointGrouperButton = choosePointGrouperButton
		controller.queryButton = queryButton
		controller.xAxisButton = xAxisButton
		controller.yAxisButton = yAxisButton
		controller.showGraphButton = showGraphButton
		controller.clearQueryButton = clearQueryButton

		controller.viewDidLoad()
	}

	// MARK: - viewDidLoad()

	func test_viewDidLoad_setsInitialShowGraphButtonStateToDisabled() {
		// given
		showGraphButton.isEnabled = true

		// when
		controller.viewDidLoad()

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	// MARK: - chooseSeriesGroupingButtonPressed()

	func test_chooseSeriesGroupingButtonPressed_setsCorrectSampleTypeOnPresentedController() {
		// given
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.sampleType, equals(sampleTypes[0]))
	}

	func testGivenSeriesGrouperAndPointGrouperSelected_chooseSeriesGroupingButtonPressed_setsCopyOfCorrectGrouperOnPresentedController() {
		// given
		let seriesGrouper = mockSampleGrouper(debugDescription: "series")
		Given(seriesGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		let seriesGrouperCopy = mockSampleGrouper(debugDescription: "series copy")
		Given(seriesGrouper, .copy(willReturn: seriesGrouperCopy))
		setSeriesGrouper(seriesGrouper)

		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)

		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.currentGrouper, sameObject(seriesGrouperCopy))
	}

	func test_chooseSeriesGroupingButtonPressed_setsCorrectTitleForPresentedController() {
		// given
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.title, equalTo("Series Grouping"))
	}

	// MARK: - clearSeriesGroupingButtonPressed()

	func test_clearSeriesGroupingButtonPressed_setsSeriesGrouperToNil() {
		// given
		setSeriesGrouper(mockSampleGrouper())
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)
		assertThat(presentedController.currentGrouper, nilValue())
	}

	// MARK: - choosePointGroupingButtonPressed()

	func test_choosePointGroupingButtonPressed_setsCorrectSampleTypeOnPresentedController() {
		// given
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.choosePointGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.sampleType, equals(sampleTypes[0]))
	}

	func testGivenSeriesGrouperAndPointGrouperSelected_choosePointGroupingButtonPressed_setsCopyOfCorrectGrouperOnPresentedController() {
		// given
		let seriesGrouper = mockSampleGrouper()
		Given(seriesGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setSeriesGrouper(seriesGrouper)

		let pointGrouper = mockSampleGrouper()
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)
		let pointGrouperCopy = mockSampleGrouper()
		Given(pointGrouper, .copy(willReturn: pointGrouperCopy))

		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.choosePointGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.currentGrouper, sameObject(pointGrouperCopy))
	}

	func test_choosePointGroupingButtonPressed_setsCorrectTitleForPresentedController() {
		// given
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.choosePointGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.title, equalTo("Point Grouping"))
	}

	// MARK: - clearPointGroupingButtonPressed()

	func test_clearPointGroupingButtonPressed_setsPointGrouperToNil() {
		// given
		let presentedController = mockGroupingChooserTableViewController()
		setPointGrouper(mockSampleGrouper())

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		controller.choosePointGroupingButtonPressed(choosePointGrouperButton)
		assertThat(presentedController.currentGrouper, nilValue())
	}

	// MARK: - editXAxis()

	func testGivenXAxisSet_editXAxis_setsSelectedAttributeOnPresentedController() {
		// given
		let presentedController = mockXAxisSetupController()
		let expectedAttribute = TextAttribute(name: "f")
		setXAxis(expectedAttribute)

		// when
		controller.editXAxis(xAxisButton)

		// then
		assertThat(presentedController.selectedAttribute, equals(expectedAttribute))
	}

	func testGivenXAxisSet_editXAxis_setsSelectedInformationOnPresentedController() {
		// given
		let presentedController = mockXAxisSetupController()
		let expectedInformation = AverageInformation(TextAttribute(name: ""))
		setXAxis(expectedInformation)

		// when
		controller.editXAxis(xAxisButton)

		// then
		assertThat(presentedController.selectedInformation, equals(expectedInformation))
	}

	func testGivenPointGrouperNotNil_editXAxis_setsGroupedToTrueOnPresentedController() {
		// given
		setPointGrouper(mockSampleGrouper())
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssert(presentedController.grouped)
	}

	func testGivenPointGrouperIsNil_editXAxis_setsGroupedToFalseOnPresentedController() {
		// given
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssertFalse(presentedController.grouped)
	}

	func testGivenUsePointGroupValueForXAxis_editXAxis_setsUsePointGroupValueOnPresentedController() {
		// given
		setXAxis(usePointGroupValue: true)
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssert(presentedController.usePointGroupValue)
	}

	func test_editXAxis_setsNotificationToSendToXAxisInformationChanged() {
		// given
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.xAxisInformationChanged))
	}

	// MARK: - editYAxis()

	func testGivenPointGrouperNotSet_editYAxis_setsOnlyGraphableAttributesOnPresentedController() {
		// given
		let graphableAttributes = sampleTypes[0].attributes.filter{ $0 is GraphableAttribute }
		let presentedController = mockChooseAttributesToGraphController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(
			presentedController.allowedAttributes,
			arrayHasExactly(graphableAttributes, areEqual: { $0.equalTo($1) }))
	}

	func testGivenPointGrouperNotSetAndYAxisSet_editYAxis_setsSelectedAttributesOnPresentedController() {
		// given
		let attributes = [
			HeartRate.heartRate,
			Weight.weight,
		]
		setYAxis(attributes)
		let presentedController = mockChooseAttributesToGraphController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.selectedAttributes, arrayHasExactly(attributes, areEqual: { $0.equalTo($1) }))
	}

	func testGivenPointGrouperNotSet_editYAxis_setsNotificationToSendToYAxisInformationChangedOnPresentedController() {
		// given
		let presentedController = mockChooseAttributesToGraphController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.yAxisInformationChanged))
	}

	func testGivenPointGrouperSet_editYAxis_setsLimitToNumericInformationToTrue() {
		// given
		setPointGrouper(mockSampleGrouper())
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		XCTAssert(presentedController.limitToNumericInformation)
	}

	func testGivenPointGrouperSetAndYAxisSet_editYAxis_setsChosenInformationOnPresentedController() {
		// given
		setPointGrouper(mockSampleGrouper())
		let information: [ExtraInformation] = [
			AverageInformation(HeartRate.heartRate),
			SumInformation(Weight.weight),
		]
		setYAxis(information)
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.chosenInformation, arrayHasExactly(information, areEqual: { $0.equalTo($1) }))
	}

	func testGivenPointGrouperSet_editYAxis_setsNotificationToSendToYAxisInformationChangedOnPresentedController() {
		// given
		setPointGrouper(mockSampleGrouper())
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.yAxisInformationChanged))
	}

	// MARK: - xAxisSet()

	func testGivenXAxisSetToNilAndUsePointGroupValueTrue_xAxisSet_setsCorrectTitleForXAxisButton() {
		// when
		setXAxis(usePointGroupValue: true)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: Use point group value"))
	}

	func testGivenXAxisSetToNilAndUsePointGroupValueFalse_xAxisSet_setsCorrectTitleForXAxisButton() {
		// when
		setXAxis(usePointGroupValue: false)

		// then
		assertThat(xAxisButton, hasTitle("Choose x-axis information"))
	}

	func testGivenUseAttributeForXAxis_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		let attribute = TextAttribute(name: "fhjidso")

		// when
		setXAxis(attribute)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: " + attribute.name.localizedLowercase))
	}

	func testGivenUseInformationForXAxis_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		let information = AverageInformation(HeartRate.heartRate)

		// when
		setXAxis(information)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: " + information.description.localizedLowercase))
	}

	func test_xAxisSet_setsXAxisAccessibilityValueToTitle() {
		// when
		setXAxis(usePointGroupValue: true)

		// then
		assertThat(xAxisButton, hasAccessibilityValue(xAxisButton.currentTitle))
	}

	// MARK: - yAxisSet()

	func testGivenYAxisSetToNil_yAxisSet_setsCorrectTitleForYAxisButton() {
		// given
		setPointGrouper(mockSampleGrouper())

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(yAxisButton, hasTitle("Choose y-axis information"))
	}

	func testGivenMultipleAttributesForYAxis_yAxisSet_setsYAxisButtonTitleToIncludeAllAttributeNames() {
		// given
		let attributes: [Attribute] = [
			TextAttribute(name: "gjnreoq;"),
			DoubleAttribute(name: "fdsjkl"),
			DurationAttribute(name: "fggregeqmkp"),
		]

		// when
		setYAxis(attributes)

		// then
		for attribute in attributes {
			assertThat(yAxisButton, hasTitle(containsString(attribute.name.localizedLowercase)))
		}
	}

	func test_yAxisSet_setsXAxisAccessibilityValueToTitle() {
		// when
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(yAxisButton, hasAccessibilityValue(yAxisButton.currentTitle))
	}

	// MARK: - seriesGrouperSet()

	func testGivenSeriesGrouperSetToNonNilValue_seriesGrouperSet_enablesAndShowsClearSeriesGrouperButton() {
		// when
		setSeriesGrouper(mockSampleGrouper())

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenSeriesGrouperSetToNonNilValue_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// when
		setSeriesGrouper(mockSampleGrouper())

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Series grouping chosen"))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_disablesAndHidesClearSeriesGrouperButton() {
		// given
		setSeriesGrouper(mockSampleGrouper())
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(false), hidden: .value(true)))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// given
		setSeriesGrouper(mockSampleGrouper())
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Choose series grouping (optional)"))
	}

	// MARK: - pointGrouperSet()

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_enablesAndShowsClearPointGrouperButton() {
		// when
		setPointGrouper(mockSampleGrouper())

		// then
		Verify(mockUiUtil, .setButton(.value(clearPointGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_setsCorrectTitleForChoosePointGrouperButton() {
		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(choosePointGrouperButton, hasTitle("Point grouping chosen"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsXAxis() {
		// given
		setXAxis(TextAttribute(name: "a"))

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(xAxisButton, hasTitle("Choose x-axis information"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsYAxis() {
		// given
		setYAxis([TextAttribute(name: "a")])

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(yAxisButton, hasTitle("Choose y-axis information"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNonNilValue_pointGrouperSet_doesNotClearXAxis() {
		// given
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		Given(pointGrouper, .copy(willReturn: pointGrouper))
		setPointGrouper(pointGrouper)
		setXAxis(TextAttribute(name: "a"))

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(xAxisButton, not(hasTitle("Choose x-axis information")))
	}

	func testGivenPointGrouperSetToNonNilValueFromNonNilValue_pointGrouperSet_doesNotClearYAxis() {
		// given
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		Given(pointGrouper, .copy(willReturn: pointGrouper))
		setPointGrouper(pointGrouper)
		setYAxis([TextAttribute(name: "a")])

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(yAxisButton, not(hasTitle("Choose y-axis information")))
	}

	func testGivenPointGrouperSetToNil_pointGrouperSet_disablesAndHidesClearPointGrouperButton() {
		// given
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		Verify(mockUiUtil, .setButton(.value(clearPointGrouperButton), enabled: .value(false), hidden: .value(true)))
	}

	func testGivenPointGrouperSetToNil_pointGrouperSet_setsCorrectTitleForChoosePointGrouperButton() {
		// given
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(choosePointGrouperButton, hasTitle("Choose point grouping (optional)"))
	}

	func testGivenPointGrouperSetToNilFromNonNilValue_pointGrouperSet_clearsXAxis() {
		// given
		setXAxis(TextAttribute(name: "a"))
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(xAxisButton, hasTitle("Choose x-axis information"))
	}

	func testGivenPointGrouperSetToNilFromNonNilValue_pointGrouperSet_clearsYAxis() {
		// given
		setYAxis([TextAttribute(name: "a")])
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(yAxisButton, hasTitle("Choose y-axis information"))
	}

	func testGivenPointGrouperSetToNilFromNil_pointGrouperSet_doesNotClearXAxis() {
		// given
		setXAxis(TextAttribute(name: "a"))

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(xAxisButton, not(hasTitle("Choose x-axis information")))
	}

	func testGivenPointGrouperSetToNilFromNil_pointGrouperSet_doesNotClearYAxis() {
		// given
		setYAxis([TextAttribute(name: "a")])

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(yAxisButton, not(hasTitle("Choose y-axis information")))
	}

	// MARK: - updateShowGraphButtonState()

	func testGivenAllRequirementsSetWithUsePointGroupValue_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		setXAxis(usePointGroupValue: true)
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithXAxisAttribute_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		setXAxis(TextAttribute(name: ""))
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithXAxisInformation_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		setXAxis(AverageInformation(DoubleAttribute(name: "")))
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithYAxisInformation_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		setXAxis(TextAttribute(name: ""))
		setYAxis([AverageInformation(DoubleAttribute(name: ""))])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenXAxisNotSetAndUsePointGroupValueFalse_updateShowGraphButtonState_disablesGraphButton() {
		// given
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenYAxisNotSet_updateShowGraphButtonState_disablesGraphButton() {
		// given
		setXAxis(TextAttribute(name: ""))

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	// MARK: - Helper Functions

	private final func setSeriesGrouper(_ grouper: SampleGrouper) {
		mockGroupingChooserTableViewController()
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)
		sendGrouperEditedNotification(grouper)
	}

	private final func setPointGrouper(_ grouper: SampleGrouper) {
		mockGroupingChooserTableViewController()
		controller.choosePointGroupingButtonPressed(choosePointGrouperButton)
		sendGrouperEditedNotification(grouper)
	}

	private final func sendGrouperEditedNotification(_ grouper: SampleGrouper) {
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: grouper))
		NotificationCenter.default.post(
			name: NotificationName.grouperEdited.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.sampleGrouper: grouper,
			])
	}

	private final func setXAxis(_ attribute: Attribute) {
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: attribute))
		Given(
			mockUiUtil,
			.value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: nil as ExtraInformation?))
		Given(
			mockUiUtil,
			.value(for: .value(.usePointGroupValue), from: .any, keyIsOptional: .any, willReturn: nil as Bool?))
		NotificationCenter.default.post(
			name: NotificationName.xAxisInformationChanged.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.attribute: attribute,
			])
	}

	private final func setXAxis(_ information: ExtraInformation) {
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: information))
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: nil as Attribute?))
		Given(
			mockUiUtil,
			.value(for: .value(.usePointGroupValue), from: .any, keyIsOptional: .any, willReturn: nil as Bool?))
		NotificationCenter.default.post(
			name: NotificationName.xAxisInformationChanged.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.information: information,
			])
	}

	private final func setXAxis(usePointGroupValue: Bool) {
		Given(
			mockUiUtil,
			.value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: nil as ExtraInformation?))
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: nil as Attribute?))
		Given(
			mockUiUtil,
			.value(for: .value(.usePointGroupValue), from: .any, keyIsOptional: .any, willReturn: usePointGroupValue))
		NotificationCenter.default.post(
			name: NotificationName.xAxisInformationChanged.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.usePointGroupValue: usePointGroupValue,
			])
	}

	private final func setYAxis(_ attributes: [Attribute]) {
		Given(mockUiUtil, .value(for: .value(.attributes), from: .any, keyIsOptional: .any, willReturn: attributes))
		Given(
			mockUiUtil,
			.value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: nil as [ExtraInformation]?))
		NotificationCenter.default.post(
			name: NotificationName.yAxisInformationChanged.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.attributes: attributes,
			])
	}

	private final func setYAxis(_ information: [ExtraInformation]) {
		Given(
			mockUiUtil,
			.value(for: .value(.attributes), from: .any, keyIsOptional: .any, willReturn: nil as [Attribute]?))
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: information))
		NotificationCenter.default.post(
			name: NotificationName.yAxisInformationChanged.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.information: information,
			])
	}

	private final func mockSampleGrouper(debugDescription: String = "sample grouper") -> SampleGrouperMock {
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .debugDescription(getter: debugDescription))
		return grouper
	}

	// MARK: Mock Controllers

	@discardableResult
	private final func mockGroupingChooserTableViewController() -> GroupingChooserTableViewController {
		let controller = GroupingChooserTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseGrouper"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockXAxisSetupController() -> XAxisSetupViewController {
		let controller = XAxisSetupViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("xAxisSetup"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockChooseAttributesToGraphController() -> ChooseAttributesToGraphTableViewControllerMock {
		let controller = ChooseAttributesToGraphTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseAttributes"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockChooseInformationToGraphViewController() -> ChooseInformationToGraphTableViewControllerMock {
		let controller = ChooseInformationToGraphTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseInformation"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockXYChartViewController() -> BasicXYChartViewControllerMock {
		let controller = BasicXYChartViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("BasicXYChartViewController"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}
}
