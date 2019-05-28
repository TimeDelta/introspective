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
	private final var chooseAxisGroupingButton: UIButton!
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
		chooseAxisGroupingButton = UIButton()
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
		controller.chooseAxisGroupingButton = chooseAxisGroupingButton
		controller.showGraphButton = showGraphButton
	}

	// MARK: - viewDidLoad()

	func test_viewDidLoad_setsInitialShowGraphButtonStateToDisabled() {
		// when
		controller.viewDidLoad()

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	// MARK: - clearSeriesGroupingButtonPressed()

	func test_clearSeriesGroupingButtonPressed_clearsSeriesGroupers() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		controller.chooseSeriesGroupingButtonPressed(self)
		setGroupers(x: AdvancedSampleGrouper(), y: AdvancedSampleGrouper())

		// when
		controller.clearSeriesGroupingButtonPressed(self)

		// then
		controller.chooseSeriesGroupingButtonPressed(self)
		assertThat(presentedController.xGrouper, nilValue())
		assertThat(presentedController.yGrouper, nilValue())
	}

	// MARK: - chooseSeriesGroupingButtonPressed()

	func test_chooseSeriesGroupingButtonPressed_setsXAxisSampleTypeOnPresentedController() {
		// given
		controller.viewDidLoad()
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
		controller.viewDidLoad()
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

	func testGivenSeriesGroupersPreviouslySet_chooseSeriesGroupingButtonPressed_setsXGrouperOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedGrouper = AdvancedSampleGrouper()
		expectedGrouper.groupDefinitions.append(GroupDefinitionMock())
		controller.chooseSeriesGroupingButtonPressed(self)
		setGroupers(x: expectedGrouper)

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xGrouper, sameObject(expectedGrouper))
	}

	func testGivenSeriesGroupersPreviouslySet_chooseSeriesGroupingButtonPressed_setsYGrouperOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedGrouper = AdvancedSampleGrouper()
		expectedGrouper.groupDefinitions.append(GroupDefinitionMock())
		controller.chooseSeriesGroupingButtonPressed(self)
		setGroupers(y: expectedGrouper)

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.yGrouper, sameObject(expectedGrouper))
	}

	func test_chooseSeriesGroupingButtonPressed_setsCurrentAttributeTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedAttributeType = "fjdsio hfuioerw hqiup n"
		controller.chooseSeriesGroupingButtonPressed(self)
		setGroupers(attributeType: expectedAttributeType)

		// when
		controller.chooseSeriesGroupingButtonPressed(self)

		// then
		assertThat(presentedController.currentAttributeType, equalTo(expectedAttributeType))
	}

	// MARK: - chooseAxisGroupingButtonPressed()

	func test_chooseAxisGroupingButtonPressed_setsXAxisSampleTypeOnPresentedController() {
		// given
		controller.viewDidLoad()
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.xAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.chooseAxisGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xSampleType, equals(expectedSampleType))
	}

	func test_chooseAxisGroupingButtonPressed_setsYAxisSampleTypeOnPresentedController() {
		// given
		controller.viewDidLoad()
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedSampleType = HeartRate.self
		Given(mockUiUtil, .value(for: .value(.sampleType), from: .any, keyIsOptional: .any, willReturn: expectedSampleType))
		NotificationCenter.default.post(
			name: NotificationName.yAxisSampleTypeChanged.toName(),
			object: nil,
			userInfo: [UserInfoKey.sampleType: expectedSampleType])

		// when
		controller.chooseAxisGroupingButtonPressed(self)

		// then
		assertThat(presentedController.ySampleType, equals(expectedSampleType))
	}

	func test_chooseAxisGroupingButtonPressed_setsNavBarTitleOnPresentedControllerToAxisGrouping() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()

		// when
		controller.chooseAxisGroupingButtonPressed(self)

		// then
		assertThat(presentedController.navBarTitle, equalTo("Axis Grouping"))
	}

	func testGivenSeriesGroupersPreviouslySet_chooseAxisGroupingButtonPressed_setsXGrouperOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedGrouper = AdvancedSampleGrouper()
		expectedGrouper.groupDefinitions.append(GroupDefinitionMock())
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers(x: expectedGrouper)

		// when
		controller.chooseAxisGroupingButtonPressed(self)

		// then
		assertThat(presentedController.xGrouper, sameObject(expectedGrouper))
	}

	func testGivenSeriesGroupersPreviouslySet_chooseAxisGroupingButtonPressed_setsYGrouperOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedGrouper = AdvancedSampleGrouper()
		expectedGrouper.groupDefinitions.append(GroupDefinitionMock())
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers(y: expectedGrouper)

		// when
		controller.chooseAxisGroupingButtonPressed(self)

		// then
		assertThat(presentedController.yGrouper, sameObject(expectedGrouper))
	}

	func test_chooseAxisGroupingButtonPressed_setsCurrentAttributeTypeOnPresentedController() {
		// given
		let presentedController = mockChooseGroupersForXYGraphViewController()
		let expectedAttributeType = "fjdsio hfuioerw hqiup n"
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers(attributeType: expectedAttributeType)

		// when
		controller.chooseAxisGroupingButtonPressed(self)

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
		assertThat(presentedController.initialQuery, nilValue())
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
		let presentedController = mockSelectInformationViewController()
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
		let presentedController = mockSelectInformationViewController()
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
		let presentedController = mockSelectInformationViewController()
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
		assertThat(presentedController.initialQuery, nilValue())
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
		mockChooseGroupersForXYGraphViewController()
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers()
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, isEnabled())
	}

	func testGivenAllRequirementsExceptXSampleTypeSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		mockChooseGroupersForXYGraphViewController()
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers()
		setYSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptYSampleTypeSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		mockChooseGroupersForXYGraphViewController()
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers()
		setXSampleType(HeartRate.self)
		setXAxisInformation(AverageInformation(HeartRate.heartRate))
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptXAxisInformationSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		mockChooseGroupersForXYGraphViewController()
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers()
		setXSampleType(HeartRate.self)
		setYSampleType(HeartRate.self)
		setYAxisInformation([AverageInformation(HeartRate.heartRate)])

		// then
		assertThat(showGraphButton, not(isEnabled()))
	}

	func testGivenAllRequirementsExceptYAxisInformationSet_updateShowGraphButtonState_disablesShowGraphButton() {
		// given
		mockChooseGroupersForXYGraphViewController()
		controller.chooseAxisGroupingButtonPressed(self)
		setGroupers()
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
	private final func mockXYChartViewController() -> BasicXYChartViewControllerMock {
		let controller = BasicXYChartViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("BasicXYChartViewController"),
			from: .any(UIStoryboard.self),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	private final func setGroupers(
		x: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		y: SampleGrouper = SameValueSampleGrouper(sampleType: HeartRate.self),
		attributeType: String = ""
	) {
		Given(mockUiUtil, .value(for: .value(.x), from: .any, keyIsOptional: .any, willReturn: x))
		Given(mockUiUtil, .value(for: .value(.y), from: .any, keyIsOptional: .any, willReturn: y))
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: attributeType))
		NotificationCenter.default.post(
			name: NotificationName.groupersEdited.toName(),
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
}
