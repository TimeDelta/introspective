//
//  ResultsViewControllerUnitTests.swift
//  IntrospectiveTests
//
//  Created by Bryan Nova on 8/15/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import XCTest
import SwiftyMocky
import Hamcrest
import SwiftDate

@testable import Introspective
@testable import Attributes
@testable import Common
@testable import Persistence
@testable import SampleGroupInformation
@testable import Samples

final class ResultsViewControllerUnitTests: UnitTest {

	private final var tableView: UITableView {
		return controller.tableView
	}

	private final var actionsButton: UIBarButtonItem!

	private final var controller: ResultsViewControllerImpl!

	final override func setUp() {
		super.setUp()

		actionsButton = UIBarButtonItem()

		let storyboard = UIStoryboard(name: "Results", bundle: nil)
		controller = (storyboard.instantiateViewController(withIdentifier: "results") as! ResultsViewControllerImpl)

		controller.actionsButton = actionsButton

		Given(mockUiUtil, .setBackButton(for: .any, title: .any, action: .any, willReturn: UIBarButtonItem()))

		let mockInformation = SampleGroupInformationMock()
		Given(mockInformation, .name(getter: ""))
		Given(mockInformation, .description(getter: "mock " + UUID().uuidString))
		Given(mockInformation, .compute(forSamples: .any, willReturn: ""))
		Given(mockSampleGroupInformationFactory, .initInformation(.any, .any, willReturn: mockInformation))
	}

	// MARK: - samplesDidSet()

	func testGivenSamplesWithoutDateAttributeInRandomOrder_samplesDidSet_doesNotChangeOrder() {
		// given
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(
			withValues: [0, 2, 1],
			for: IntegerAttribute(name: "attribute"))

		// when
		controller.samples = copyArray(samples)
		let didSetCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(didSetCaptor)))
		guard let didSet = didSetCaptor.value else {
			XCTFail("No async code for didSet")
			return
		}
		didSet()

		// then
		assertThat(controller.samples, contains(equals(samples[0]), equals(samples[1]), equals(samples[2])))
	}

	func testGivenSamplesWithDateAttributeInRandomOrder_samplesDidSet_sortsInDescendingOrderOfDate() {
		// given
		let date2 = Date()
		let date3 = date2 - 1.days
		let date1 = date2 + 1.days
		let samples = SampleCreatorTestUtil.createSamples(withDates: [
			date2,
			date3,
			date1,
		])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))

		// when
		controller.samples = copyArray(samples)
		let didSetCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(didSetCaptor)))
		guard let didSet = didSetCaptor.value else {
			XCTFail("No async code for didSet")
			return
		}
		didSet()

		// then
		assertThat(controller.samples, contains(equals(samples[2]), equals(samples[0]), equals(samples[1])))
	}

	// MARK: - viewDidLoad()

	func testGivenNoBackButtonTitle_viewDidLoad_setsBackButtonTitleToQuery() {
		// given
		controller.backButtonTitle = nil

		// when
		controller.viewDidLoad()

		// then
		Verify(mockUiUtil, .setBackButton(for: .any, title: .value("Query"), action: .any))
	}

	func testGivenBackButtonTitle_viewDidLoad_setsBackButtonTitleToProvidedValue() {
		// given
		let expectedTitle = "gnreiuqp"
		controller.backButtonTitle = expectedTitle

		// when
		controller.viewDidLoad()

		// then
		Verify(mockUiUtil, .setBackButton(for: .any, title: .value(expectedTitle), action: .any))
	}

	// MARK: - numberOfSections()

	func test_numberOfSections_returns2() {
		// when
		let sections = controller.numberOfSections(in: tableView)

		// then
		assertThat(sections, equalTo(2))
	}

	// MARK: - titleForHeaderInSection()

	func testGivenSection0_titleForHeaderInSection_returnsInformation() {
		// given
		let section = 0

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: section)

		// then
		assertThat(title, equalTo("Information"))
	}

	func testGivenSection1_titleForHeaderInSection_returnsSampleTypeName() {
		// given
		let section = 1
		let samples = [HeartRate(1, Date())]
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: section)

		// then
		assertThat(title, equalTo("Heart Rate"))
	}

	func testGivenSection2_titleForHeaderInSection_returnsNil() {
		// given
		let section = 2

		// when
		let title = controller.tableView(tableView, titleForHeaderInSection: section)

		// then
		assertThat(title, nilValue())
	}

	// MARK: - tableViewNumberOfRowsInSection()

	func testGivenFailed_tableViewNumberOfRowsInSection_returns0() {
		// given
		setFailedTrue()

		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		assertThat(numRows, equalTo(0))
	}

	func testGivenWaiting_tableViewNumberOfRowsInSection_returns1() {
		// given
		controller.samples = nil

		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		assertThat(numRows, equalTo(1))
	}

	func testGivenSection0AndInformationAdded_tableViewNumberOfRowsInSection_returnsNumberOfInformationsAdded() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let expectedRows = 3
		setInformation(count: expectedRows)

		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 0)

		// then
		assertThat(numRows, equalTo(expectedRows))
	}

	func testGivenSection1WithSamplesProvided_tableViewNumberOfRowsInSection_returnsNumberOfSamples() {
		// given
		let expectedRows = 3
		let samples = SampleCreatorTestUtil.createSamples(count: expectedRows, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()

		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 1)

		// then
		assertThat(numRows, equalTo(expectedRows))
	}

	func testGivenSection2_tableViewNumberOfRowsInSection_returns0() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()

		// when
		let numRows = controller.tableView(tableView, numberOfRowsInSection: 2)

		// then
		assertThat(numRows, equalTo(0))
	}

	// MARK: - tableViewCellForRowAt()

	func testGivenSection0_tableViewCellForRowAt_returnsSampleGroupInformationTableViewCellWithCorrectInformation() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let information = setInformation(count: 2)[0]

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		// then
		guard let informationCell = cell as? SampleGroupInformationTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(informationCell.sampleGroupInformation, sameObject(information))
	}

	func testGivenSection0_tableViewCellForRowAt_returnsSampleGroupInformationTableViewCellWithCorrectValue() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let expectedValue = "fheiruwqhnbi"
		setInformation(withValues: [expectedValue, "mkoerjmqu3"])

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		// then
		guard let informationCell = cell as? SampleGroupInformationTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(informationCell.value, equalTo(expectedValue))
	}

	func testGivenSection1WithMood_tableViewCellForRowAt_returnsMoodTableViewCellWithCorrectMood() {
		// given
		let expectedMood = moodMock()
		let samples = [moodMock(), expectedMood]
		for sample in samples {
			Given(sample, .attributes(getter: [TextAttribute(name: "")]))
		}
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		mockMoodTableViewCell()

		// when
		let cell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 1))

		// then
		guard let moodCell = cell as? MoodTableViewCell else {
			XCTFail("Wrong cell type")
			return
		}
		assertThat(moodCell.mood, sameObject(expectedMood))
	}

	// MARK: - tableViewDidSelectRowAt()

	func testGivenSection0_tableViewDidSelectRowAt_setsCorrectSelectedInformationOnPresentedController() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let informationIndex = 1
		let information = setInformation(count: informationIndex + 1)
		let attribute = HeartRate.heartRate
		Given(information[informationIndex], .attribute(getter: attribute))
		let presentedController = mockSelectSampleGroupInformationViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: informationIndex, section: 0))

		// then
		assertThat(presentedController.selectedInformation, sameObject(information[informationIndex]))
	}

	func testGivenSection0_tableViewDidSelectRowAt_setsCorrectSelectedAttributeOnPresentedController() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let informationIndex = 1
		let information = setInformation(count: informationIndex + 1)
		let attribute = HeartRate.heartRate
		Given(information[informationIndex], .attribute(getter: attribute))
		let presentedController = mockSelectSampleGroupInformationViewController()

		// when
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: informationIndex, section: 0))

		// then
		assertThat(presentedController.selectedAttribute, equals(attribute))
	}

	// MARK: - tableViewCanEditRowAt()

	func testGivenSection0_tableViewCanEditRowAt_returnsTrue() {
		// when
		let canEdit = controller.tableView(tableView, canEditRowAt: IndexPath(row: 0, section: 0))

		// then
		XCTAssert(canEdit)
	}

	func testGivenSection1WithNonDeletableSampleAtSpecifiedRow_tableViewCanEditRowAt_returnsFalse() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		samples[0].attributedName = ""
		controller.samples = samples

		// when
		let canEdit = controller.tableView(tableView, canEditRowAt: IndexPath(row: 0, section: 1))

		// then
		XCTAssertFalse(canEdit)
	}

	func testGivenSection1WithDeletableSampleAtSpecifiedRow_tableViewCanEditRowAt_returnsTrue() {
		// given
		let sample = coreDataSampleMock()
		Given(CoreDataSampleMock.self, .attributes(getter: [HeartRate.heartRate]))
		Given(sample, .attributes(getter: [HeartRate.heartRate]))
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: [sample]))
		Given(sample, .attributedName(getter: ""))
		controller.samples = [sample]
		controller.viewDidLoad()

		// when
		let canEdit = controller.tableView(tableView, canEditRowAt: IndexPath(row: 0, section: 1))

		// then
		XCTAssert(canEdit)
	}

	// MARK: - tableViewCanMoveRowAt()

	func testGivenSection0_tableViewCanMoveRowAt_returnsTrue() {
		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: IndexPath(row: 0, section: 0))

		// then
		XCTAssert(canMove)
	}

	func testGivenSection1_tableViewCanMoveRowAt_returnsFalse() {
		// when
		let canMove = controller.tableView(tableView, canMoveRowAt: IndexPath(row: 0, section: 1))

		// then
		XCTAssertFalse(canMove)
	}

	// MARK: - tableViewMoveRowAt()

	func testGivenMoveFromSection1ToSection1_tableViewMoveRowAt_doesNotChangeSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.samples, contains(equals(samples[0]), equals(samples[1])))
	}

	func testGivenMoveFromSection0ToSection1_tableViewMoveRowAt_doesNotChangeSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		assertThat(controller.samples, contains(equals(samples[0]), equals(samples[1])))
	}

	func testGivenMoveFromSection1ToSection0_tableViewMoveRowAt_doesNotChangeSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.samples, contains(equals(samples[0]), equals(samples[1])))
	}

	func testGivenMoveFromSection0ToSection0_tableViewMoveRowAt_swapsCorrectInformation() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		Given(mockNumericSampleUtil, .average(for: .any, over: .any, willReturn: 0.0))
		Given(mockNumericSampleUtil, .max(for: .any, over: .any, as: .any, willReturn: 0.0))
		let information = [AverageInformation(HeartRate.heartRate), MaximumInformation<Double>(HeartRate.heartRate)]
		setInformation(copyArray(information))

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0))

		// then
		assertThat(controller.information, contains(equals(information[1]), equals(information[0])))
	}

	// MARK: - trailingSwipeActionsConfigurationForRowAt()

	func testGivenSection0_trailingSwipeActionsConfigurationForRowAt_returnsActionThatUsingDeletesInformationAtSpecifiedIndex() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		Given(mockNumericSampleUtil, .average(for: .any, over: .any, willReturn: 0.0))
		Given(mockNumericSampleUtil, .max(for: .any, over: .any, as: .any, willReturn: 0.0))
		let information = [AverageInformation(HeartRate.heartRate), MaximumInformation<Double>(HeartRate.heartRate)]
		setInformation(copyArray(information))
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))
		let indexPath = IndexPath(row: 1, section: 0)
		tableView.reloadData()

		// when
		let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<UIContextualAction.Handler>()
		Verify(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .capturing(handlerCaptor)))
		guard let handler = handlerCaptor.value else {
			XCTFail("no handler")
			return
		}
		handler(config?.actions[0] ?? UIContextualAction(), UIView(), {_ in} )

		// then
		assertThat(
			controller.information,
			allOf(contains(equals(information[0])), not(contains(equals(information[1])))))
	}

	func testGivenSection1WithNonDeletableSampleAtGivenIndex_trailingSwipeActionsConfigurationForRowAt_returnsArrayWithoutDeleteAction() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()

		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))

		// when
		let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 1))

		// then
		guard let actions = config?.actions else {
			XCTFail("was nil")
			return
		}
		assertThat(actions, not(hasItem(hasTitle("🗑️"))))
	}

	func testGivenSection1WithDeletableSampleAtGivenIndex_trailingSwipeActionsConfigurationForRowAt_returnsArrayWithCorrectNumberOfActions() {
		// given
		let samples = [coreDataSampleMock()]
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))

		// when
		let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 1))

		// then
		guard let actions = config?.actions else {
			XCTFail("was nil")
			return
		}
		assertThat(actions, hasCount(2))
	}

	func testGivenSection1WithDeletableSampleAtGivenIndex_trailingSwipeActionsConfigurationForRowAt_returnsActionThatDeletesCorrectSample() {
		// given
		let transaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: transaction))
		let samples = [coreDataSampleMock(), coreDataSampleMock()]
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()
		let indexToDelete = 0
		let indexPath = IndexPath(row: indexToDelete, section: 1)
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))
		tableView.reloadData()

		// when
		guard let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath) else {
			XCTFail("nil return value")
			return
		}
		let handlerCaptor = ArgumentCaptor<UIContextualAction.Handler>()
		Verify(mockUiUtil, .contextualAction(style: .any, title: .value("🗑️"), handler: .capturing(handlerCaptor)))
		guard let handler = handlerCaptor.value else {
			XCTFail("no handler")
			return
		}
		handler(config.actions[0], UIView(), {_ in})
		let yesHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: .value("Yes"), style: .any, handler: .capturing(yesHandlerCaptor)))
		guard let yesHandler = yesHandlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("no yes handler")
			return
		}
		yesHandler(UIAlertAction())

		// then
		let deletedObjectCaptor = ArgumentCaptor<CoreDataObject>()
		Verify(transaction, .delete(.capturing(deletedObjectCaptor)))
		assertThat(deletedObjectCaptor.allValues, hasItem(sameObject(samples[indexToDelete])))
		assertThat(deletedObjectCaptor.allValues, not(hasItem(sameObject(samples[abs(indexToDelete - 1)]))))
	}

	func testGivenSection1WithDeletableSampleAtGivenIndex_trailingSwipeActionsConfigurationForRowAt_returnsActionThatRecomputesInformationOnDelete() {
		// given
		let transaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: transaction))
		let samples = [coreDataSampleMock(), coreDataSampleMock()]
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()
		let indexToDelete = 0
		let indexPath = IndexPath(row: indexToDelete, section: 1)
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))
		let information = setInformation(count: 2)
		tableView.reloadData()

		// when
		let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<UIContextualAction.Handler>()
		Verify(mockUiUtil, .contextualAction(style: .any, title: .value("🗑️"), handler: .capturing(handlerCaptor)))
		guard let handler = handlerCaptor.value else {
			XCTFail("no handler")
			return
		}
		handler(config?.actions[0] ?? UIContextualAction(), UIView(), {_ in})
		let yesHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: .value("Yes"), style: .any, handler: .capturing(yesHandlerCaptor)))
		guard let yesHandler = yesHandlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("no yes handler")
			return
		}
		yesHandler(UIAlertAction())

		// then
		for info in information {
			Verify(info, .compute(forSamples: .any))
		}
	}

	func testGivenSection1WithDeletableSampleAtGivenIndexWhileSearching_trailingSwipeActionsConfigurationForRowAt_returnsActionThatDeletesCorrectSample() {
		// given
		let transaction = TransactionMock()
		Given(mockDatabase, .transaction(willReturn: transaction))

		let searchText = "fhiewopq nhfuiopew q"
		let sampleToDelete = searchableCoreDataSampleMock()
		Given(sampleToDelete, .matchesSearchString(.value(searchText), willReturn: true))
		let otherSample1 = searchableCoreDataSampleMock(matches: false)
		let otherSample2 = searchableCoreDataSampleMock(matches: false)
		let samples = [
			otherSample1,
			sampleToDelete,
			otherSample2,
		]
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.setSearchText(searchText)
		controller.samples = samples
		controller.viewDidLoad()

		let indexPath = IndexPath(row: 0, section: 1)
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))
		tableView.reloadData()

		// when
		let config = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
		let handlerCaptor = ArgumentCaptor<UIContextualAction.Handler>()
		Verify(mockUiUtil, .contextualAction(style: .any, title: .value("🗑️"), handler: .capturing(handlerCaptor)))
		guard let handler = handlerCaptor.value else {
			XCTFail("no handler")
			return
		}
		handler(config?.actions[0] ?? UIContextualAction(), UIView(), {_ in})
		let yesHandlerCaptor = ArgumentCaptor<((UIAlertAction) -> Void)?>()
		Verify(mockUiUtil, .alertAction(title: .value("Yes"), style: .any, handler: .capturing(yesHandlerCaptor)))
		guard let yesHandler = yesHandlerCaptor.value as? (UIAlertAction) -> Void else {
			XCTFail("no yes handler")
			return
		}
		yesHandler(UIAlertAction())

		// thens
		let deletedObjectCaptor = ArgumentCaptor<CoreDataObject>()
		Verify(transaction, .delete(.capturing(deletedObjectCaptor)))
		assertThat(deletedObjectCaptor.allValues, not(hasItem(sameObject(otherSample1))))
		assertThat(deletedObjectCaptor.allValues, hasItem(sameObject(sampleToDelete)))
		assertThat(deletedObjectCaptor.allValues, not(hasItem(sameObject(otherSample2))))
	}

	// MARK: - saveEditedSampleGroupInformation()

	func testGivenInformationEditedNotification_saveEditedSampleGroupInformation_editsCorrectInformation() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let originalInformation = setInformation(count: 2)
		let newInformation = mockInformation(count: 1)[0]
		let expectedInformation = [originalInformation[0], newInformation]
		mockSelectSampleGroupInformationViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: newInformation))
		tableView.reloadData()

		// when
		NotificationCenter.default.post(
			name: NotificationName.editedInformation.toName(),
			object: controller,
			userInfo: [
				UserInfoKey.information: newInformation
			])

		// then
		assertThat(controller.information, contains(sameObject(expectedInformation[0]), sameObject(expectedInformation[1])))
	}

	func testGivenInformationEditedNotification_saveEditedSampleGroupInformation_computesValueForNewInformation() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		setInformation(count: 2)
		let newInformation = mockInformation(count: 1)[0]
		mockSelectSampleGroupInformationViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 0))
		Given(mockUiUtil, .value(for: .value(.information), from: .any, keyIsOptional: .any, willReturn: newInformation))
		tableView.reloadData()

		// when
		NotificationCenter.default.post(
			name: NotificationName.editedInformation.toName(),
			object: controller,
			userInfo: [
				UserInfoKey.information: newInformation
			])

		// then
		let codeCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(codeCaptor)))
		guard let code = codeCaptor.value else {
			XCTFail("no async code ran")
			return
		}
		code()
		Verify(newInformation, .compute(forSamples: .any))
	}

	// MARK: - editedSample()

	func testGivenSampleEditedNotification_editedSample_editsCorrectSample() {
		// given
		let samples = [moodMock(), moodMock()]
		let newSample = moodMock()
		for sample in samples {
			Given(sample, .equalTo(.any(Sample.self), willReturn: true))
			Given(sample, .attributes(getter: [TextAttribute(name: "")]))
		}
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		mockMoodTableViewCell()
		mockEditMoodViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 1))
		Given(mockUiUtil, .value(for: .value(.sample), from: .any, keyIsOptional: .any, willReturn: newSample))
		tableView.reloadData()

		// when
		NotificationCenter.default.post(
			name: ResultsViewControllerImpl.editedSample,
			object: controller,
			userInfo: [UserInfoKey.sample: newSample])

		// then
		assertThat(controller.samples, contains(sameObject(samples[0]), sameObject(newSample)))
	}

	func testGivenSampleEditedNotification_editedSample_recomputesSampleGroupInformationValues() {
		// given
		let samples = [moodMock(), moodMock()]
		let newSample = moodMock()
		for sample in samples {
			Given(sample, .equalTo(.any(Sample.self), willReturn: true))
			Given(sample, .attributes(getter: [TextAttribute(name: "")]))
		}
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		let information = setInformation(count: 2)
		mockMoodTableViewCell()
		mockEditMoodViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 1, section: 1))
		Given(mockUiUtil, .value(for: .value(.sample), from: .any, keyIsOptional: .any, willReturn: newSample))
		tableView.reloadData()

		// when
		NotificationCenter.default.post(
			name: ResultsViewControllerImpl.editedSample,
			object: controller,
			userInfo: [UserInfoKey.sample: newSample])
		let codeCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(codeCaptor)))
		guard let code = codeCaptor.value else {
			XCTFail("no async code ran")
			return
		}
		code()

		// then
		for info in information {
			Verify(info, .compute(forSamples: .any))
		}
	}

	// MARK: - presentActions()

	func testGivenSamplesAreDeletable_presentActions_includesActionToDeleteSamples() {
		// given
		let mood = moodMock()
		Given(mood, .attributes(getter: [TextAttribute(name: "")]))
		Given(mockSampleUtil, .getOnly(samples: .any, from: .any, to: .any, willReturn: [mood]))
		controller.samples = [mood]
		controller.viewDidLoad()
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))

		// when
		controller.perform(controller.actionsButton.action)

		// then
		Verify(mockUiUtil, .alertAction(title: .matching({ $0?.starts(with: "Delete") ?? false }), style: .any, handler: .any))
	}

	func testGivenSamplesAreNotDeletable_presentActions_doesNotIncludeActionToDeleteSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = samples
		controller.viewDidLoad()
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction()))

		// when
		controller.perform(controller.actionsButton.action)

		// then
		Verify(mockUiUtil, .never, .alertAction(title: .matching({ $0?.starts(with: "Delete") ?? false }), style: .any, handler: .any))
	}

	// MARK: - Helper Functions

	private final func setFailedTrue() {
		controller.samples = nil
		controller.showError(title: "")
	}

	@discardableResult
	private final func setInformation(count: Int) -> [SampleGroupInformationMock] {
		let information = mockInformation(count: count)
		setInformation(information)
		return information
	}

	@discardableResult
	private final func setInformation(withValues values: [String]) -> [SampleGroupInformationMock] {
		let information = mockInformation(computedValues: values)
		setInformation(information)
		return information
	}

	private final func setInformation(_ information: [SampleGroupInformation]) {
		controller.information = information
		controller.recomputeInformation()
	}

	private final func mockInformation(count: Int = 1) -> [SampleGroupInformationMock] {
		var computedValues = [String]()
		for _ in 0 ..< count {
			computedValues.append("")
		}
		return mockInformation(computedValues: computedValues)
	}

	private final func mockInformation(computedValues: [String]) -> [SampleGroupInformationMock] {
		let applicableTypes = [SampleGroupInformationMock.self]
		Given(mockSampleGroupInformationFactory, .getApplicableInformationTypes(forAttribute: .any, willReturn: applicableTypes))
		var information = [SampleGroupInformationMock]()
		for value in computedValues {
			let mock = SampleGroupInformationMock()
			Given(mock, .compute(forSamples: .any, willReturn: value))
			Given(mock, .description(getter: value))
			Given(mock, .attribute(getter: AttributeMock()))
			information.append(mock)
		}
		return information
	}

	private final func coreDataSampleMock() -> CoreDataSampleMock {
		let mock = CoreDataSampleMock()
		Given(mock, .attributedName(getter: ""))
		Given(mock, .debugDescription(getter: "mock " + UUID().uuidString))
		Given(mock, .dates(willReturn: [.start: Date()]))
		Given(mock, .attributes(getter: [TextAttribute(name: "")]))
		return mock
	}

	private final func searchableCoreDataSampleMock(matches: Bool? = nil) -> SearchableCoreDataSampleMock {
		let mock = SearchableCoreDataSampleMock()
		Given(mock, .attributedName(getter: ""))
		let uuid = UUID()
		mock.description = "mock " + uuid.uuidString
		Given(mock, .debugDescription(getter: "mock " + uuid.uuidString))
		Given(mock, .dates(willReturn: [.start: Date()]))
		if let matches = matches {
			Given(mock, .matchesSearchString(.any, willReturn: matches))
		}
		Given(mock, .attributes(getter: [TextAttribute(name: "")]))
		Given(SearchableCoreDataSampleMock.self, .name(getter: "searchable sample"))
		return mock
	}

	private final func moodMock() -> MoodMock {
		let mock = MoodMock()
		Given(mock, .attributedName(getter: ""))
		Given(mock, .attributes(getter: []))
		Given(mock, .attributes(getter: [TextAttribute(name: "")]))
		Given(mock, .rating(getter: 0))
		Given(mock, .minRating(getter: 0))
		Given(mock, .maxRating(getter: 0))
		Given(mock, .date(getter: Date()))
		let uuid = UUID()
		mock.description = "mock " + uuid.uuidString
		Given(mock, .debugDescription(getter: "mock " + uuid.uuidString))
		Given(MoodMock.self, .name(getter: "mood"))
		return mock
	}

	@discardableResult
	private final func mockSelectSampleGroupInformationViewController() -> SelectSampleGroupInformationViewControllerMock {
		let controller = SelectSampleGroupInformationViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("editSampleGroupInformation"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller))
		return controller
	}

	@discardableResult
	private final func mockEditMoodViewController() -> EditMoodTableViewControllerMock {
		let controller = EditMoodTableViewControllerMock()
		Given(mockUiUtil, .controller(
			named: .value("editMood"),
			from: .value("Util"),
			as: .value(UIViewController.self),
			willReturn: controller
		))
		return controller
	}

	@discardableResult
	private final func mockMoodTableViewCell() -> MoodTableViewCellMock {
		let cell = MoodTableViewCellMock()
		Given(mockUiUtil, .tableViewCell(
			from: .any,
			withIdentifier: .value("moodSampleCell"),
			for: .any,
			as: .value(UITableViewCell.self),
			willReturn: cell))
		return cell
	}
}
