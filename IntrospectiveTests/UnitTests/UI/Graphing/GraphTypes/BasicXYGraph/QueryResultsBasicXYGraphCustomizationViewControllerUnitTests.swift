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
@testable import Attributes
@testable import Common
@testable import SampleGroupers
@testable import SampleGroupInformation
@testable import Samples

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
		controller.viewDidLoad()

		setRandomSamples()

		let seriesGrouper = mockSampleGrouper(debugDescription: "series")
		let seriesGrouperCopy = mockSampleGrouper(debugDescription: "series copy")
		Given(seriesGrouper, .copy(willReturn: seriesGrouperCopy))
		setSeriesGrouper(seriesGrouper)

		let pointGrouper = mockSampleGrouper(debugDescription: "point")
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
		setSeriesGrouper(mockSampleGrouper())

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		let presentedController = mockGroupingChooserTableViewController()
		controller.chooseSeriesGroupingButtonPressed(chooseSeriesGrouperButton)
		Verify(presentedController, .currentGrouper(set: .value(nil)))
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
		controller.viewDidLoad()

		setRandomSamples()

		let seriesGrouper = mockSampleGrouper()
		setSeriesGrouper(seriesGrouper)

		let pointGrouper = mockSampleGrouper()
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
		controller.viewDidLoad()
		setRandomSamples()
		setPointGrouper(mockSampleGrouper())

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		let presentedController = mockGroupingChooserTableViewController()
		controller.choosePointGroupingButtonPressed(choosePointGrouperButton)
		Verify(presentedController, .currentGrouper(set: .value(nil)))
	}

	// MARK: - editXAxis()

	func testGivenXAxisSet_editXAxis_setsSelectedAttributeOnPresentedController() {
		// given
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
		setRandomSamples()
		let pointGrouper = mockSampleGrouper()
		setPointGrouper(pointGrouper)
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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
		controller.viewDidLoad()
		setRandomSamples()
		setPointGrouper(mockSampleGrouper())
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		XCTAssert(presentedController.limitToNumericInformation)
	}

	func testGivenPointGrouperSetAndYAxisSet_editYAxis_setsChosenInformationOnPresentedController() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
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
		controller.viewDidLoad()
		setRandomSamples()
		setPointGrouper(mockSampleGrouper())
		let presentedController = mockChooseInformationToGraphViewController()

		// when
		controller.editYAxis(yAxisButton)

		// then
		assertThat(presentedController.notificationToSendWhenFinished, equalTo(.yAxisInformationChanged))
	}

	// MARK: - xAxisSet()

	func testGivenXAxisSetToNilAndUsePointGroupValueTrue_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		controller.viewDidLoad()

		// when
		setXAxis(usePointGroupValue: true)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: Use point group value"))
	}

	func testGivenXAxisSetToNilAndUsePointGroupValueFalse_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		controller.viewDidLoad()

		// when
		setXAxis(usePointGroupValue: false)

		// then
		assertThat(xAxisButton, hasTitle("Choose x-axis information"))
	}

	func testGivenUseAttributeForXAxis_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		let attribute = TextAttribute(name: "fhjidso")
		controller.viewDidLoad()

		// when
		setXAxis(attribute)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: " + attribute.name.localizedLowercase))
	}

	func testGivenUseInformationForXAxis_xAxisSet_setsCorrectTitleForXAxisButton() {
		// given
		let information = AverageInformation(HeartRate.heartRate)
		controller.viewDidLoad()

		// when
		setXAxis(information)

		// then
		assertThat(xAxisButton, hasTitle("X-Axis: " + information.description.localizedLowercase))
	}

	func test_xAxisSet_setsXAxisAccessibilityValueToTitle() {
		// given
		controller.viewDidLoad()

		// when
		setXAxis(usePointGroupValue: true)

		// then
		assertThat(xAxisButton, hasAccessibilityValue(xAxisButton.currentTitle))
	}

	// MARK: - yAxisSet()

	func testGivenYAxisSetToNil_yAxisSet_setsCorrectTitleForYAxisButton() {
		// given
		controller.viewDidLoad()
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
		controller.viewDidLoad()

		// when
		setYAxis(attributes)

		// then
		for attribute in attributes {
			assertThat(yAxisButton, hasTitle(containsString(attribute.name.localizedLowercase)))
		}
	}

	func test_yAxisSet_setsXAxisAccessibilityValueToTitle() {
		// given
		controller.viewDidLoad()

		// when
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(yAxisButton, hasAccessibilityValue(yAxisButton.currentTitle))
	}

	// MARK: - seriesGrouperSet()

	func testGivenSeriesGrouperSetToNonNilValue_seriesGrouperSet_enablesAndShowsClearSeriesGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()

		// when
		setSeriesGrouper(mockSampleGrouper())

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenSeriesGrouperSetToNonNilValue_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()

		// when
		setSeriesGrouper(mockSampleGrouper())

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Series grouping chosen"))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_disablesAndHidesClearSeriesGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setSeriesGrouper(mockSampleGrouper())
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		Verify(mockUiUtil, .setButton(.value(clearSeriesGrouperButton), enabled: .value(false), hidden: .value(true)))
	}

	func testGivenSeriesGrouperSetToNil_seriesGrouperSet_setsCorrectTitleForChooseSeriesGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setSeriesGrouper(mockSampleGrouper())
		mockGroupingChooserTableViewController()

		// when
		controller.clearSeriesGroupingButtonPressed(clearSeriesGrouperButton)

		// then
		assertThat(chooseSeriesGrouperButton, hasTitle("Choose series grouping (optional)"))
	}

	// MARK: - pointGrouperSet()

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_enablesAndShowsClearPointGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		Verify(mockUiUtil, .setButton(.value(clearPointGrouperButton), enabled: .value(true), hidden: .value(false)))
	}

	func testGivenPointGrouperSetToNonNilValue_pointGrouperSet_setsCorrectTitleForChoosePointGrouperButton() {
		// given
		controller.viewDidLoad()
		setRandomSamples()

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		assertThat(choosePointGrouperButton, hasTitle("Point grouping chosen"))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsXAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setXAxis(TextAttribute(name: "a"))

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		let presentedController = mockXAxisSetupController()
		controller.editXAxis(xAxisButton)
		Verify(presentedController, .selectedAttribute(set: .value(nil)))
		Verify(presentedController, .selectedInformation(set: .value(nil)))
	}

	func testGivenPointGrouperSetToNonNilValueFromNil_pointGrouperSet_clearsYAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setYAxis([TextAttribute(name: "a")])

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		let presentedController = mockChooseInformationToGraphViewController()
		controller.editYAxis(yAxisButton)
		Verify(presentedController, .never, .chosenInformation(set: .any))
	}

	func testGivenPointGrouperSetToNonNilValueFromNonNilValue_pointGrouperSet_doesNotClearXAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .copy(willReturn: pointGrouper))
		setPointGrouper(pointGrouper)
		setXAxis(TextAttribute(name: "a"))

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		let presentedController = mockXAxisSetupController()
		controller.editXAxis(xAxisButton)
		Verify(presentedController, .selectedAttribute(set: .notNil))
	}

	func testGivenPointGrouperSetToNonNilValueFromNonNilValue_pointGrouperSet_doesNotClearYAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		Given(pointGrouper, .copy(willReturn: pointGrouper))
		setPointGrouper(pointGrouper)
		let yAxis = [AverageInformation(TextAttribute(name: "a"))]
		setYAxis(yAxis)

		// when
		setPointGrouper(mockSampleGrouper())

		// then
		let presentedController = mockChooseInformationToGraphViewController()
		controller.editYAxis(yAxisButton)
		Verify(presentedController, .chosenInformation(set: .value(yAxis)))
	}

	func testGivenPointGrouperSetToNil_pointGrouperSet_disablesAndHidesClearPointGrouperButton() {
		// given
		controller.viewDidLoad()
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		setRandomSamples()
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		Verify(mockUiUtil, .setButton(.value(clearPointGrouperButton), enabled: .value(false), hidden: .value(true)))
	}

	func testGivenPointGrouperSetToNil_pointGrouperSet_setsCorrectTitleForChoosePointGrouperButton() {
		// given
		controller.viewDidLoad()
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		setRandomSamples()
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		assertThat(choosePointGrouperButton, hasTitle("Choose point grouping (optional)"))
	}

	func testGivenPointGrouperSetToNilFromNonNilValue_pointGrouperSet_clearsXAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setXAxis(TextAttribute(name: "a"))
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		let presentedController = mockXAxisSetupController()
		controller.editXAxis(xAxisButton)
		Verify(presentedController, .selectedAttribute(set: .value(nil)))
		Verify(presentedController, .selectedInformation(set: .value(nil)))
	}

	func testGivenPointGrouperSetToNilFromNonNilValue_pointGrouperSet_clearsYAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setYAxis([TextAttribute(name: "a")])
		let pointGrouper = mockSampleGrouper(debugDescription: "point")
		setPointGrouper(pointGrouper)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		let presentedController = mockChooseAttributesToGraphController()
		controller.editYAxis(yAxisButton)
		Verify(presentedController, .selectedAttributes(set: .value(nil)))
	}

	func testGivenPointGrouperSetToNilFromNil_pointGrouperSet_doesNotClearXAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		setXAxis(TextAttribute(name: "a"))

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		let presentedController = mockXAxisSetupController()
		controller.editXAxis(xAxisButton)
		Verify(presentedController, .selectedAttribute(set: .notNil))
	}

	func testGivenPointGrouperSetToNilFromNil_pointGrouperSet_doesNotClearYAxis() {
		// given
		controller.viewDidLoad()
		setRandomSamples()
		let yAxis = [TextAttribute(name: "a")]
		setYAxis(yAxis)

		// when
		controller.clearPointGroupingButtonPressed(clearPointGrouperButton)

		// then
		let presentedController = mockChooseAttributesToGraphController()
		controller.editYAxis(yAxisButton)
		Verify(presentedController, .selectedAttributes(set: .value(yAxis)))
	}

	// MARK: - updateShowGraphButtonState()

	func testGivenAllRequirementsSetWithUsePointGroupValue_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		controller.viewDidLoad()
		setXAxis(usePointGroupValue: true)
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithXAxisAttribute_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		controller.viewDidLoad()
		setXAxis(TextAttribute(name: ""))
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithXAxisInformation_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		controller.viewDidLoad()
		setXAxis(AverageInformation(DoubleAttribute(name: "")))
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsSetWithYAxisInformation_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		controller.viewDidLoad()
		setXAxis(TextAttribute(name: ""))
		setYAxis([AverageInformation(DoubleAttribute(name: ""))])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenXAxisNotSetAndUsePointGroupValueFalse_updateShowGraphButtonState_disablesGraphButton() {
		// given
		controller.viewDidLoad()
		setYAxis([TextAttribute(name: "")])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenYAxisNotSet_updateShowGraphButtonState_disablesGraphButton() {
		// given
		controller.viewDidLoad()
		setXAxis(TextAttribute(name: ""))

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	// MARK: - Helper Functions

	private final func setSeriesGrouper(_ grouper: SampleGrouper) {
		sendGrouperEditedNotification(.seriesGrouperEdited, grouper)
	}

	private final func setPointGrouper(_ grouper: SampleGrouper) {
		sendGrouperEditedNotification(.pointGrouperEdited, grouper)
	}

	private final func sendGrouperEditedNotification(_ notificationType: NotificationName, _ grouper: SampleGrouper) {
		Given(mockUiUtil, .value(for: .value(.sampleGrouper), from: .any, keyIsOptional: .any, willReturn: grouper))
		NotificationCenter.default.post(
			name: notificationType.toName(),
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

	private final func setRandomSamples() {
		let samples = SampleCreatorTestUtil.createSamples(count: 1)
		controller.samples = samples
	}

	private final func mockSampleGrouper(debugDescription: String = "sample grouper") -> SampleGrouperMock {
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .debugDescription(getter: debugDescription))
		Given(grouper, .equalTo(.any(SampleGrouper.self), willReturn: false))
		return grouper
	}

	// MARK: Mock Controllers

	@discardableResult
	private final func mockGroupingChooserTableViewController() -> GroupingChooserTableViewControllerMock {
		let controller = GroupingChooserTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseGrouper"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockXAxisSetupController() -> XAxisSetupViewControllerMock {
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
