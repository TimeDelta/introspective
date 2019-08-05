//
//  MultipleSampleTypeBasicXYGraphCustomizationViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 7/21/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import AAInfographics
@testable import Introspective

final class MultipleSampleTypeBasicXYGraphCustomizationViewControllerUnitTests: UnitTest {

	private final var chooseXAxisSampleTypeButton: UIButton!
	private final var clearXAxisQueryButton: UIButton!
	private final var chooseXAxisQueryButton: UIButton!
	private final var chooseXAxisInformationButton: UIButton!
	private final var chooseYAxisSampleTypeButton: UIButton!
	private final var clearYAxisQueryButton: UIButton!
	private final var chooseYAxisQueryButton: UIButton!
	private final var chooseYAxisInformationButton: UIButton!
	private final var clearSeriesGroupingButton: UIButton!
	private final var chooseSeriesGroupingButton: UIButton!
	private final var choosePointGroupingButton: UIButton!
	private final var showGraphButton: UIButton!

	private final var controller: MultipleSampleTypeBasicXYGraphCustomizationViewController!

	override func setUp() {
		super.setUp()

		chooseXAxisSampleTypeButton = UIButton()
		clearXAxisQueryButton = UIButton()
		chooseXAxisQueryButton = UIButton()
		chooseXAxisInformationButton = UIButton()
		chooseYAxisSampleTypeButton = UIButton()
		clearYAxisQueryButton = UIButton()
		chooseYAxisQueryButton = UIButton()
		chooseYAxisInformationButton = UIButton()
		clearSeriesGroupingButton = UIButton()
		chooseSeriesGroupingButton = UIButton()
		choosePointGroupingButton = UIButton()
		showGraphButton = UIButton()

		let storyboard = UIStoryboard(name: "BasicXYGraph", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "multipleSampleTypeSetup") as! MultipleSampleTypeBasicXYGraphCustomizationViewController)

		controller.chooseXAxisSampleTypeButton = chooseXAxisSampleTypeButton
		controller.clearXAxisQueryButton = clearXAxisQueryButton
		controller.chooseXAxisQueryButton = chooseXAxisQueryButton
		controller.chooseXAxisInformationButton = chooseXAxisInformationButton
		controller.chooseYAxisSampleTypeButton = chooseYAxisSampleTypeButton
		controller.clearYAxisQueryButton = clearYAxisQueryButton
		controller.chooseYAxisQueryButton = chooseYAxisQueryButton
		controller.chooseYAxisInformationButton = chooseYAxisInformationButton
		controller.clearSeriesGroupingButton = clearSeriesGroupingButton
		controller.chooseSeriesGroupingButton = chooseSeriesGroupingButton
		controller.choosePointGroupingButton = choosePointGroupingButton
		controller.showGraphButton = showGraphButton

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

	// MARK: - clearSeriesGroupingButtonPressed()

	func test_clearSeriesGroupingButtonPressed_clearsSeriesGroupers() {
		// given
		setSeriesGroupers(x: AdvancedSampleGrouper(), y: AdvancedSampleGrouper())

		// when
		controller.clearSeriesGroupingButtonPressed(self)

		// then
		let presentedController = mockChooseGroupersForXYGraphViewController()
		controller.chooseSeriesGroupingButtonPressed(self)
		Verify(presentedController, .xGrouper(set: .value(nil)))
		Verify(presentedController, .yGrouper(set: .value(nil)))
	}

	// MARK: - chooseSeriesGroupingButtonPressed()

	func test_chooseSeriesGroupingButtonPressed_setsXAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.xAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xSampleType, equals(expectedSampleType))
	}

	func test_chooseSeriesGroupingButtonPressed_setsYAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.yAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.ySampleType, equals(expectedSampleType))
	}

	func test_chooseSeriesGroupingButtonPressed_setsNavBarTitleOnPresentedControllerToSeriesGrouping() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.navBarTitle, equalTo("Series Grouping"))
	}

	func testGivenSeriesGroupersPreviouslySet_chooseSeriesGroupingButtonPressed_setsCopyOfXGrouperOnPresentedController() {
		// given
		let grouper = mockSampleGrouper(debugDescription: "initial")
		let expectedGrouper = mockSampleGrouper(debugDescription: "expected")
		Given(grouper, .copy(willReturn: expectedGrouper))
		setSeriesGroupers(x: grouper)
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xGrouper, sameObject(expectedGrouper))
	}

	func testGivenSeriesGroupersPreviouslySet_chooseSeriesGroupingButtonPressed_setsCopyOfYGrouperOnPresentedController() {
		// given
		let grouper = mockSampleGrouper(debugDescription: "initial")
		let expectedGrouper = mockSampleGrouper(debugDescription: "expected")
		Given(grouper, .copy(willReturn: expectedGrouper))
		setSeriesGroupers(y: grouper)
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.yGrouper, sameObject(expectedGrouper))
	}

	func test_chooseSeriesGroupingButtonPressed_setsCurrentAttributeTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedAttributeType = "fjdsio hfuioerw hqiup n"
		setSeriesGroupers(attributeType: expectedAttributeType)

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.currentAttributeType, equalTo(expectedAttributeType))
	}

	// MARK: - choosePointGroupingButtonPressed()

	func test_choosePointGroupingButtonPressed_setsXAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.xAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xSampleType, equals(expectedSampleType))
	}

	func test_choosePointGroupingButtonPressed_setsYAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.yAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.ySampleType, equals(expectedSampleType))
	}

	func test_choosePointGroupingButtonPressed_setsNavBarTitleOnPresentedControllerToAxisGrouping() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.navBarTitle, equalTo("Point Grouping"))
	}

	func testGivenPointGroupersPreviouslySet_choosePointGroupingButtonPressed_setsCopyOfXGrouperOnPresentedController() {
		// given
		let grouper = mockSampleGrouper(debugDescription: "initial")
		let expectedGrouper = mockSampleGrouper(debugDescription: "expected")
		Given(grouper, .copy(willReturn: expectedGrouper))
		setPointGroupers(x: grouper)
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xGrouper, sameObject(expectedGrouper))
	}

	func testGivenPointGroupersPreviouslySet_choosePointGroupingButtonPressed_setsCopyOfYGrouperOnPresentedController() {
		// given
		let grouper = mockSampleGrouper(debugDescription: "initial")
		let expectedGrouper = mockSampleGrouper(debugDescription: "expected")
		Given(grouper, .copy(willReturn: expectedGrouper))
		setPointGroupers(y: grouper)
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.yGrouper, sameObject(expectedGrouper))
	}

	func test_choosePointGroupingButtonPressed_setsCurrentAttributeTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedAttributeType = "fjdsio hfuioerw hqiup n"
		setPointGroupers(attributeType: expectedAttributeType)

		// when
		controller.choosePointGroupingButtonPressed(self)

		// then
		assertThat(presentedController.currentAttributeType, equalTo(expectedAttributeType))
	}

	// MARK: - chooseXAxisSampleTypeButtonPressed()

	func test_chooseXAxisSampleTypeButtonPressed_setsCurrentXAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseSampleTypeViewController()
		let expectedSampleType = BodyMassIndex.self
		setXSampleType(expectedSampleType)

		// when
		controller.chooseXAxisSampleTypeButtonPressed(self)

		// then
		assertThat(presentedController.selectedSampleType, equals(expectedSampleType))
	}

	// MARK: - clearXAxisQueryButtonPressed()

	func test_clearXAxisQueryButtonPressed_setsXAxisQueryToNil() {
		// given
		setXAxisQuery(HeartRateQueryMock())

		// when
		controller.clearXAxisQueryButtonPressed(self)

		// then
		let presentedController = mockQueryViewController()
		controller.chooseXAxisQueryButtonPressed(self)
		Verify(presentedController, .initialQuery(set: .value(nil)))
	}

	// MARK: - chooseXAxisQueryButtonPressed()

	func test_chooseXAxisQueryButtonPressed_setsFinishedButtonTitleToUseQueryOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()

		// when
		controller.chooseXAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.finishedButtonTitle, equalTo("Use Query"))
	}

	func test_chooseXAxisQueryButtonPressed_setsTopmostSampleTypeOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()
		let expectedSampleType = HeartRate.self
		setXSampleType(expectedSampleType)

		// when
		controller.chooseXAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.topmostSampleType, equals(expectedSampleType))
	}

	func test_chooseXAxisQueryButtonPressed_setsInitialQueryOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()
		let expectedQuery = NonRunningSampleQueryStub<HeartRate>()
		expectedQuery.subQuery = (
			matcher: SameDatesSubQueryMatcher(mostRecentOnly: false),
			query: NonRunningSampleQueryStub<BodyMassIndex>()
		)
		setXAxisQuery(expectedQuery)

		// when
		controller.chooseXAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.initialQuery, equals(expectedQuery))
	}

	// MARK: - chooseXAxisInformationButtonPressed()

	func test_chooseXAxisInformationButtonPressed_setsAttributesOnPresentedControllerToXSampleTypeAttributes() {
		// given
		let presentedController = mockXAxisSetupController()
		let expectedSampleType = HeartRate.self
		setXSampleType(expectedSampleType)

		// when
		controller.chooseXAxisInformationButtonPressed(self)

		// then
		assertThat(
			presentedController.attributes,
			arrayHasExactly(expectedSampleType.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_chooseXAxisInformationButtonPressed_setsSelectedAttributeOnPresentedController() {
		// given
		let presentedController = mockXAxisSetupController()
		setXSampleType(HeartRate.self)
		let expectedAttribute = HeartRate.heartRate
		let expectedInformation = AverageInformation(expectedAttribute)
		setXAxisInformation(expectedInformation)

		// when
		controller.chooseXAxisInformationButtonPressed(self)

		// then
		assertThat(presentedController.selectedAttribute, equals(expectedAttribute))
	}

	func test_chooseXAxisInformationButtonPressed_setsSelectedInformationOnPresentedController() {
		// given
		let presentedController = mockXAxisSetupController()
		setXSampleType(HeartRate.self)
		let expectedInformation = AverageInformation(HeartRate.heartRate)
		setXAxisInformation(expectedInformation)

		// when
		controller.chooseXAxisInformationButtonPressed(self)

		// then
		assertThat(presentedController.selectedInformation, equals(expectedInformation))
	}

	// MARK: - chooseYAxisSampleTypeButtonPressed()

	func test_chooseYAxisSampleTypeButtonPressed_setsCurrentXAxisSampleTypeOnPresentedController() {
		// given
		let presentedController = mockChooseSampleTypeViewController()
		let expectedSampleType = BodyMassIndex.self
		setYSampleType(expectedSampleType)

		// when
		controller.chooseYAxisSampleTypeButtonPressed(self)

		// then
		assertThat(presentedController.selectedSampleType, equals(expectedSampleType))
	}

	// MARK: - clearYAxisQueryButtonPressed()

	func test_clearYAxisQueryButtonPressed_setsXAxisQueryToNil() {
		// given
		setXAxisQuery(HeartRateQueryMock())

		// when
		controller.clearYAxisQueryButtonPressed(self)

		// then
		let presentedController = mockQueryViewController()
		controller.chooseYAxisQueryButtonPressed(self)
		Verify(presentedController, .initialQuery(set: .value(nil)))
	}

	// MARK: - chooseYAxisQueryButtonPressed()

	func test_chooseYAxisQueryButtonPressed_setsFinishedButtonTitleToUseQueryOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()

		// when
		controller.chooseYAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.finishedButtonTitle, equalTo("Use Query"))
	}

	func test_chooseYAxisQueryButtonPressed_setsTopmostSampleTypeOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()
		let expectedSampleType = HeartRate.self
		setYSampleType(expectedSampleType)

		// when
		controller.chooseYAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.topmostSampleType, equals(expectedSampleType))
	}

	func test_chooseYAxisQueryButtonPressed_setsInitialQueryOnPresentedController() {
		// given
		let presentedController = mockQueryViewController()
		let expectedQuery = NonRunningSampleQueryStub<HeartRate>()
		expectedQuery.subQuery = (
			matcher: SameDatesSubQueryMatcher(mostRecentOnly: false),
			query: NonRunningSampleQueryStub<BodyMassIndex>()
		)
		setYAxisQuery(expectedQuery)

		// when
		controller.chooseYAxisQueryButtonPressed(self)

		// then
		assertThat(presentedController.initialQuery, equals(expectedQuery))
	}

	// MARK: - chooseYAxisInformationButtonPressed()

	func test_chooseYAxisInformationButtonPressed_setsAttributesOnPresentedControllerToYSampleTypeAttributes() {
		// given
		let presentedController = mockChooseInformationToGraphViewController()
		let expectedSampleType = HeartRate.self
		setYSampleType(expectedSampleType)

		// when
		controller.chooseYAxisInformationButtonPressed(self)

		// then
		assertThat(
			presentedController.attributes,
			arrayHasExactly(expectedSampleType.attributes, areEqual: { $0.equalTo($1) }))
	}

	func test_chooseYAxisInformationButtonPressed_setsChosenInformationOnPresentedController() {
		// given
		let presentedController = mockChooseInformationToGraphViewController()
		setYSampleType(HeartRate.self)
		let expectedAttribute = HeartRate.heartRate
		let expectedInformation = [AverageInformation(expectedAttribute)]
		setYAxisInformation(expectedInformation)

		// when
		controller.chooseYAxisInformationButtonPressed(self)

		// then
		assertThat(
			presentedController.chosenInformation,
			arrayHasExactly(expectedInformation, areEqual: { $0.equalTo($1) }))
	}

	// MARK: - showMeTheGraphButtonPressed()

	func testGivenXAxisQueryNotSet_showMeTheGraphButtonPressed_usesUnconditionalQueryForXSampleType() {
		// given
		mockXYChartViewController()
		let xAxisSampleType = HeartRate.self
		let query = HeartRateQueryMock()
		Given(mockQueryFactory, .queryFor(.value(xAxisSampleType), willReturn: query))
		setXSampleType(xAxisSampleType)
		setYAxisQuery(HeartRateQueryMock())

		// when
		controller.showMeTheGraphButtonPressed(self)

		// then
		Verify(mockQueryFactory, .queryFor(.value(xAxisSampleType)))
	}

	func testGivenYAxisQueryNotSet_showMeTheGraphButtonPressed_usesUnconditionalQueryForYSampleType() {
		// given
		mockXYChartViewController()
		let yAxisSampleType = HeartRate.self
		let query = HeartRateQueryMock()
		Given(mockQueryFactory, .queryFor(.value(yAxisSampleType), willReturn: query))
		setYSampleType(yAxisSampleType)
		setXAxisQuery(HeartRateQueryMock())

		// when
		controller.showMeTheGraphButtonPressed(self)

		// then
		Verify(mockQueryFactory, .queryFor(.value(yAxisSampleType)))
	}

	func testGivenQueriesSet_showMeTheGraphButtonPressed_setsQueriesOnPresentedController() {
		// given
		let presentedController = mockXYChartViewController()
		let xQuery = NonRunningSampleQueryStub<HeartRate>()
		let yQuery = NonRunningSampleQueryStub<BodyMassIndex>()
		setXAxisQuery(xQuery)
		setYAxisQuery(yQuery)

		// when
		controller.showMeTheGraphButtonPressed(self)

		// then
		assertThat(presentedController.queries, arrayHasExactly([xQuery, yQuery], areEqual: { $0.equalTo($1) }))
	}

	func testGivenChartTypeSet_showMeTheGraphButtonPressed_setsChartTypeOnPresentedController() {
		// given
		let presentedController = mockXYChartViewController()
		let expectedChartType: AAChartType = .Spline
		controller.chartType = expectedChartType
		setXAxisQuery(HeartRateQueryMock())
		setYAxisQuery(HeartRateQueryMock())

		// when
		controller.showMeTheGraphButtonPressed(self)

		// then
		assertThat(presentedController.chartType, equalTo(expectedChartType))
	}

	// MARK: - updateShowGraphButtonState()

	func testGivenAllRequirementsSet_updateShowGraphButtonState_enablesShowGraphButton() {
		// given
		setPointGroupers()
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsExceptXSampleTypeSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		setPointGroupers()
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptYSampleTypeSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		setPointGroupers()
		setXSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptXAxisInformationSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		setPointGroupers()
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptYAxisInformationSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		setPointGroupers()
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptAxisGroupersSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	// MARK: - Helper Functions

	private final func setSeriesGroupers(
		x: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		y: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		attributeType: String = ""
	) {
		setGroupers(x: x, y: y, attributeType: attributeType, .seriesGrouperEdited)
	}

	private final func setPointGroupers(
		x: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		y: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		attributeType: String = ""
	) {
		setGroupers(x: x, y: y, attributeType: attributeType, .pointGrouperEdited)
	}

	private final func setGroupers(
		x: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		y: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		attributeType: String = "",
		_ notification: NotificationName
	) {
		Given(mockUiUtil, .value(for: .value(.x), from: .any, keyIsOptional: .any, willReturn: x))
		Given(mockUiUtil, .value(for: .value(.y), from: .any, keyIsOptional: .any, willReturn: y))
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: attributeType))
		NotificationCenter.default.post(
			name: notification.toName(),
			object: nil,
			userInfo: [
				UserInfoKey.x: x,
				UserInfoKey.y: y,
				UserInfoKey.attribute: attributeType
			])
	}

	private final func setXSampleType(_ sampleType: Sample.Type) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: sampleType))
		NotificationCenter.default.post(
			name: NotificationName.xAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: sampleType])
	}

	private final func setYSampleType(_ sampleType: Sample.Type) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: sampleType))
		NotificationCenter.default.post(
			name: NotificationName.yAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: sampleType])
	}

	private final func setXAxisQuery(_ query: Query) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.query), from: .any, keyIsOptional: .any, willReturn: query))
		NotificationCenter.default.post(
			name: NotificationName.xAxisQueryChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.query: query])
	}

	private final func setYAxisQuery(_ query: Query) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.query), from: .any, keyIsOptional: .any, willReturn: query))
		NotificationCenter.default.post(
			name: NotificationName.yAxisQueryChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.query: query])
	}

	private final func setXAxisInformation(_ information: ExtraInformation) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: information))
		NotificationCenter.default.post(
			name: NotificationName.xAxisInformationChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.information: information])
	}

	private final func setYAxisInformation(_ information: [ExtraInformation]) {
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: information))
		NotificationCenter.default.post(
			name: NotificationName.yAxisInformationChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.information: information])
	}

	private final func mockSampleGrouper(debugDescription: String = "sample grouper") -> SampleGrouperMock {
		let grouper = SampleGrouperMock(attributes: [])
		Given(grouper, .debugDescription(getter: debugDescription))
		return grouper
	}

	// MARK: Mock Controllers

	@discardableResult
	private final func mockChooseGroupersForXYGraphViewController() -> ChooseGroupersForXYGraphViewControllerMock {
		let controller = ChooseGroupersForXYGraphViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseXYGroupers"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockChooseSampleTypeViewController() -> ChooseSampleTypeViewControllerMock {
		let controller = ChooseSampleTypeViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("chooseSampleType"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockQueryViewController() -> QueryViewControllerMock {
		let controller = QueryViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("queryView"),
			from: .value("Query"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockSelectInformationViewController() -> SelectExtraInformationViewControllerMock {
		let controller = SelectExtraInformationViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("editExtraInformation"),
			from: .value("Util"),
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
