//
//  QueryResultsBasicXYGraphCustomizationViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/31/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import AAInfographics
@testable import Introspective

final class QueryResultsBasicXYGraphCustomizationViewControllerUnitTests: UnitTest {

	private final var clearSeriesGrouperButton: UIButton!
	private final var chooseSeriesGrouperButton: UIButton!
	private final var clearPointGrouperButton: UIButton!
	private final var choosePointGrouperButton: UIButton!
	private final var xAxisButton: UIButton!
	private final var yAxisButton: UIButton!
	private final var showGraphButton: UIButton!

	private final var controller: QueryResultsBasicXYGraphCustomizationViewController!

	override func setUp() {
		super.setUp()

		clearSeriesGrouperButton = UIButton()
		chooseSeriesGrouperButton = UIButton()
		clearPointGrouperButton = UIButton()
		choosePointGrouperButton = UIButton()
		xAxisButton = UIButton()
		yAxisButton = UIButton()
		showGraphButton = UIButton()

		let storyboard = UIStoryboard(name: "BasicXYGraph", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "queryResultsGraphSetup") as! QueryResultsBasicXYGraphCustomizationViewController)
		controller.clearSeriesGrouperButton = clearSeriesGrouperButton
		controller.chooseSeriesGrouperButton = chooseSeriesGrouperButton
		controller.clearPointGrouperButton = clearPointGrouperButton
		controller.choosePointGrouperButton = choosePointGrouperButton
		controller.xAxisButton = xAxisButton
		controller.yAxisButton = yAxisButton
		controller.showGraphButton = showGraphButton
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
		let samples = [HeartRate(0, Date())]
		controller.samples = samples
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.sampleType, equals(HeartRate.self))
	}

	func testGivenSeriesGrouperAndPointGrouperSelected_chooseSeriesGroupingButtonPressed_setsCopyOfCorrectGrouperOnPresentedController() {
		// given
		setRandomSamples()

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
		let samples = [HeartRate(0, Date())]
		controller.samples = samples
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.title, equalTo("Series Grouping"))
	}

	// MARK: - clearSeriesGroupingButtonPressed()

	func test_clearSeriesGroupingButtonPressed_setsSeriesGrouperToNil() {
		// given
		setRandomSamples()
		setSeriesGrouper(SampleGrouperMock(attributes: []))
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
		let samples = [HeartRate(0, Date())]
		controller.samples = samples
		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.choosePointGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.sampleType, equals(HeartRate.self))
	}

	func testGivenSeriesGrouperAndPointGrouperSelected_choosePointGroupingButtonPressed_setsCopyOfCorrectGrouperOnPresentedController() {
		// given
		setRandomSamples()

		let seriesGrouper = SampleGrouperMock(attributes: [])
		Given(seriesGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setSeriesGrouper(seriesGrouper)

		let pointGrouper = SampleGrouperMock(attributes: [])
		Given(pointGrouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		setPointGrouper(pointGrouper)
		let pointGrouperCopy = SampleGrouperMock(attributes: [])
		Given(pointGrouper, .copy(willReturn: pointGrouperCopy))

		let presentedController = mockGroupingChooserTableViewController()

		// when
		controller.choosePointGroupingButtonPressed(chooseSeriesGrouperButton)

		// then
		assertThat(presentedController.currentGrouper, sameObject(pointGrouperCopy))
	}

	func test_choosePointGroupingButtonPressed_setsCorrectTitleForPresentedController() {
		// given
		let samples = [HeartRate(0, Date())]
		controller.samples = samples
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
		setRandomSamples()
		setPointGrouper(SampleGrouperMock(attributes: []))

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		controller.choosePointGroupingButtonPressed(choosePointGrouperButton)
		assertThat(presentedController.currentGrouper, nilValue())
	}

	// MARK: - editXAxis()

	func testGivenXAxisSet_editXAxis_setsSelectedAttributeOnPresentedController() {
		// given
		setRandomSamples()
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
		setRandomSamples()
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
		setRandomSamples()
		setPointGrouper(SampleGrouperMock(attributes: []))
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssert(presentedController.grouped)
	}

	func testGivenPointGrouperIsNil_editXAxis_setsGroupedToFalseOnPresentedController() {
		// given
		setRandomSamples()
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssertFalse(presentedController.grouped)
	}

	func testGivenUsePointGroupValueForXAxis_editXAxis_setsUsePointGroupValueOnPresentedController() {
		// given
		setRandomSamples()
		setXAxis(usePointGroupValue: true)
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		XCTAssert(presentedController.usePointGroupValue)
	}

	func test_editXAxis_setsNotificationToSendToXAxisInformationChanged() {
		// given
		setRandomSamples()
		let presentedController = mockXAxisSetupController()

		// when
		controller.editXAxis(xAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.xAxisInformationChanged))
	}

	// MARK: - editYAxis()

	func testGivenPointGrouperNotSet_editYAxis_setsOnlyGraphableAttributesOnPresentedController() {
		// given
		let graphableAttributes: [Attribute] = [
			HeartRate.heartRate,
			IntegerAttribute(name: "int"),
			DurationAttribute(name: "duration"),
		]
		var attributes: [Attribute] = [
			TextAttribute(name: "text"),
			DosageAttribute(name: "dosage"),
		]
		attributes.append(contentsOf: graphableAttributes)
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: attributes)
		controller.samples = samples
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
		setRandomSamples()
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
		setRandomSamples()
		let presentedController = mockChooseAttributesToGraphController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.yAxisInformationChanged))
	}

	func testGivenPointGrouperSet_editYAxis_setsLimitToNumericInformationToTrue() {
		// given
		setRandomSamples()
		setPointGrouper(SampleGrouperMock(attributes: []))
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		XCTAssert(presentedController.limitToNumericInformation)
	}

	func testGivenPointGrouperSetAndYAxisSet_editYAxis_setsChosenInformationOnPresentedController() {
		// given
		setRandomSamples()
		setPointGrouper(SampleGrouperMock(attributes: []))
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
		setRandomSamples()
		setPointGrouper(SampleGrouperMock(attributes: []))
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
		setRandomSamples()
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
		// given
		setRandomSamples()

		// when
		setSeriesGrouper(SampleGrouperMock(attributes: []))

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenSeriesGrouperSetToNonNilValue_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// given
		setRandomSamples()

		// when
		setSeriesGrouper(SampleGrouperMock(attributes: []))

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Series grouping chosen"))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_disablesAndHidesClearSeriesGrouperButton() {
		// given
		setRandomSamples()
		setSeriesGrouper(SampleGrouperMock(attributes: []))
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(false), hidden: .value(true)))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// given
		setRandomSamples()
		setSeriesGrouper(SampleGrouperMock(attributes: []))
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Choose series grouping (optional)"))
	}

	// MARK: - pointGrouperSet()

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_enablesAndShowsClearPointGrouperButton() {
		// given
		setRandomSamples()

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		Verify(mockUiUtil, .setButton(.value(clearPointGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_setsCorrectTitleForChoosePointGrouperButton() {
		// given
		setRandomSamples()

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(choosePointGrouperButton, hasTitle("Point grouping chosen"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsXAxis() {
		// given
		setRandomSamples()
		setXAxis(TextAttribute(name: "a"))

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(xAxisButton, hasTitle("Choose x-axis information"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsYAxis() {
		// given
		setRandomSamples()
		setYAxis([TextAttribute(name: "a")])

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(yAxisButton, hasTitle("Choose y-axis information"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNonNilValue_pointGrouperSet_doesNotClearXAxis() {
		// given
		setRandomSamples()
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
		setRandomSamples()
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
		setRandomSamples()
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
		setRandomSamples()
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(choosePointGrouperButton, hasTitle("Choose point grouping (optional)"))
	}

	func testGivenPointGrouperSetToNilFromNonNilValue_pointGrouperSet_clearsXAxis() {
		// given
		setRandomSamples()
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
		setRandomSamples()
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
		setRandomSamples()
		setXAxis(TextAttribute(name: "a"))

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(xAxisButton, not(hasTitle("Choose x-axis information")))
	}

	func testGivenPointGrouperSetToNilFromNil_pointGrouperSet_doesNotClearYAxis() {
		// given
		setRandomSamples()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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

	private final func setRandomSamples() {
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		controller.samples = samples
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
