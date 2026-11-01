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
import Presentr

@testable import Introspective
@testable import Attributes
@testable import Common
@testable import Persistence
@testable import Queries
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
		// Resolve the asynchronous setup before testing loaded rows and actions.
		// Keep production's loading guard; these tests exercise the ready state.
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in code() }))

		Given(mockUiUtil, .setBackButton(for: .any, title: .any, action: .any, willReturn: UIBarButtonItem()))

		let mockInformation = SampleGroupInformationMock()
		Given(mockInformation, .name(getter: ""))
		Given(mockInformation, .description(getter: "mock " + UUID().uuidString))
		Given(mockInformation, .compute(forSamples: .any, willReturn: ""))
		Given(mockSampleGroupInformationFactory, .initInformation(.any, .any, willReturn: mockInformation))
	}

	final override func tearDown() {
		if let controller = controller {
			controller.closeResults()
			NotificationCenter.default.removeObserver(controller)
			if let table = controller.viewIfLoaded as? UITableView {
				table.dataSource = nil
				table.delegate = nil
			}
		}
		// Invocation records retain callbacks and controller arguments. Release
		// them before replacing the dependencies used by this test's UI.
		mockAsyncUtil.resetMock()
		mockUiUtil.resetMock()
		controller = nil
		super.tearDown()
	}

	func testQueuedResultRefreshesDoNotRetainTheController() {
		weak var releasedController: ResultsViewControllerImpl?
		autoreleasepool {
			let subject = ResultsViewControllerImpl(style: .plain)
			subject.actionsButton = UIBarButtonItem()
			subject.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(
				withValues: [1], for: IntegerAttribute(id: 0, name: "value"))
			releasedController = subject
			mockAsyncUtil.resetMock()
			mockUiUtil.resetMock()
		}

		XCTAssertNil(releasedController)
	}

	func testQueuedInitialLoadingAfterBackDoesNotReadClearedSamples() {
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, _ in }))
		controller.samples = SampleCreatorTestUtil.createSamples(withDates: [Date()])
		let loadCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(loadCaptor)))
		guard let load = loadCaptor.value else { XCTFail("No initial loading callback"); return }
		controller.viewDidLoad()
		let backActionCaptor = ArgumentCaptor<Selector>()
		Verify(mockUiUtil, .setBackButton(for: .any, title: .any, action: .capturing(backActionCaptor)))
		guard let backAction = backActionCaptor.value else { XCTFail("No back-button action"); return }

		controller.perform(backAction)
		load()

		XCTAssertNil(controller.samples)
	}

	func testQueuedInitialLoadingIgnoresAnEmptyReplacement() {
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, _ in }))
		controller.samples = SampleCreatorTestUtil.createSamples(withDates: [Date()])
		let loadCaptor = ArgumentCaptor<() -> Void>()
		Verify(mockAsyncUtil, .run(qos: .any, code: .capturing(loadCaptor)))
		guard let load = loadCaptor.value else { XCTFail("No initial loading callback"); return }

		controller.samples = []
		load()

		XCTAssertTrue(controller.samples.isEmpty)
	}

	func testRecomputingInformationBeforeSamplesArriveKeepsTheLoadingState() {
		let information = SampleGroupInformationMock()
		controller.information = [information]
		controller.recomputeInformation()
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 0), 1)
		Verify(information, .never, .compute(forSamples: .any))
	}

	// MARK: - samplesDidSet()

	func testGivenSamplesWithoutDateAttributeInRandomOrder_samplesDidSet_doesNotChangeOrder() {
		// given
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(
			withValues: [0, 2, 1],
			for: IntegerAttribute(id: 0, name: "attribute"))

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
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), samples.count)
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

	func testViewOpenedAfterResultsFinishEnablesActions() {
		actionsButton.isEnabled = false // The storyboard's initial state.
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: IntegerAttribute(id: 0, name: "value"))
		controller.viewDidLoad()
		XCTAssertTrue(actionsButton.isEnabled)
	}

	func testViewOpenedBeforeResultsFinishKeepsActionsDisabledUntilPublication() throws {
		var job: (() -> Void)?
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in job = code }))
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: IntegerAttribute(id: 0, name: "value"))
		controller.viewDidLoad()
		XCTAssertFalse(actionsButton.isEnabled)
		try XCTUnwrap(job)()
		XCTAssertTrue(actionsButton.isEnabled)
	}

	func testSortChooserNotificationSortsTheDisplayedSamples() throws {
		let attribute: Attribute = IntegerAttribute(id: 0, name: "value")
		let order = ComparisonResult.orderedAscending
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [3, 1, 2], for: attribute)
		controller.viewDidLoad()
		Given(mockUiUtil, .value(for: .value(.attribute), from: .any, keyIsOptional: .any, willReturn: attribute))
		Given(mockUiUtil, .value(for: .value(.comparisonResult), from: .any, keyIsOptional: .any, willReturn: order))
		NotificationCenter.default.post(name: Notification.Name("sortSamplesBy"), object: controller)
		XCTAssertEqual(try controller.samples.map { try $0.value(of: attribute) as? Int }, [1, 2, 3])
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), 3)
	}

	func testSupersededSortCannotPublishAfterTheLatestSort() throws {
		let attribute = IntegerAttribute(id: 0, name: "value")
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [3, 1, 2], for: attribute)
		controller.samples = samples
		var jobs = [() -> Void]()
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
		controller.sortResults(by: attribute, order: .orderedAscending)
		controller.sortResults(by: attribute, order: .orderedDescending)
		XCTAssertEqual(jobs.count, 2)
		guard jobs.count == 2 else { return }
		jobs[1]()
		jobs[0]()
		XCTAssertEqual(try controller.samples.map { try $0.value(of: attribute) as? Int }, [3, 2, 1])
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), 3)
	}

	func testCancellingSortKeepsPreviouslyPublishedRows() throws {
		let attribute = IntegerAttribute(id: 0, name: "value")
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [3, 1, 2], for: attribute)
		var job: (() -> Void)?
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in job = code }))
		controller.sortResults(by: attribute, order: .orderedAscending)
		controller.cancelSorting()
		try XCTUnwrap(job)()
		XCTAssertEqual(try controller.samples.map { try $0.value(of: attribute) as? Int }, [3, 1, 2])
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), 3)
	}

	func testNewSamplesInvalidateAQueuedSortOfThePreviousSamples() throws {
		let attribute = IntegerAttribute(id: 0, name: "value")
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [3, 1, 2], for: attribute)
		var jobs = [() -> Void]()
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in jobs.append(code) }))
		controller.sortResults(by: attribute, order: .orderedAscending)
		controller.samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [8, 7], for: attribute)
		XCTAssertEqual(jobs.count, 2)
		guard jobs.count == 2 else { return }
		jobs[1](); jobs[0]()
		XCTAssertEqual(try controller.samples.map { try $0.value(of: attribute) as? Int }, [7, 8])
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), 2)
	}

	func testSearchTextChangedDuringSortIsAppliedToPublishedResults() throws {
		let hidden = searchableCoreDataSampleMock(matches: false)
		let visible = searchableCoreDataSampleMock(matches: true)
		let attribute = IntegerAttribute(id: 0, name: "value")
		let hiddenValue: Int = 1, visibleValue: Int = 2
		Given(hidden, .value(of: .any, willReturn: hiddenValue))
		Given(visible, .value(of: .any, willReturn: visibleValue))
		controller.samples = [hidden, visible]
		var job: (() -> Void)?
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in job = code }))
		controller.sortResults(by: attribute, order: .orderedDescending)
		controller.setSearchText("visible")
		controller.updateSearchResults(for: UISearchController())
		try XCTUnwrap(job)()
		XCTAssertEqual(controller.samples.count, 2)
		XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 1), 1)
		Verify(visible, .matchesSearchString(.value("visible")))
	}

	func testClosingResultsInvalidatesQueuedSortAndLateSampleAssignment() throws {
		let attribute = IntegerAttribute(id: 0, name: "value")
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [3, 1, 2], for: attribute)
		controller.samples = samples
		var job: (() -> Void)?
		Perform(mockAsyncUtil, .run(qos: .any, code: .any, perform: { _, code in job = code }))
		controller.sortResults(by: attribute, order: .orderedAscending)
		controller.closeResults()
		try XCTUnwrap(job)()
		controller.samples = samples
		XCTAssertNil(controller.samples)
	}

	private func configureRefreshes(_ queries: [QueryMock]) {
		controller.query = MoodQueryImpl()
		Given(mockQueryFactory, .sampleTypeFor(.any, willReturn: MoodImpl.self))
		Given(mockQueryFactory, .queryFor(.any, willProduce: { stub in
			for query in queries { stub.return(query) }
		}))
	}

	func testOutOfOrderRefreshesPublishOnlyTheLatestQueryResults() throws {
		let first = QueryMock(), second = QueryMock()
		configureRefreshes([first, second])
		var callbacks = [(QueryResult?, Error?) -> Void]()
		for query in [first, second] {
			Perform(query, .runQuery(callback: .any, perform: { callbacks.append($0) }))
		}
		controller.refreshQuery(); controller.refreshQuery()
		XCTAssertEqual(callbacks.count, 2)
		guard callbacks.count == 2 else { return }
		let attribute = IntegerAttribute(id: 0, name: "value")
		let old = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: attribute)
		let latest = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [2], for: attribute)
		callbacks[1](SampleQueryResult(latest), nil)
		callbacks[0](SampleQueryResult(old), nil)
		callbacks[0](nil, GenericError("Superseded refresh failed"))
		XCTAssertTrue((controller.samples.first as AnyObject?) === latest.first)
		Verify(first, .once, .stop())
		Verify(second, .once, .runQuery(callback: .any))
	}

	func testClosingResultsStopsRefreshAndIgnoresItsLateCallback() throws {
		let query = QueryMock()
		configureRefreshes([query])
		var callback: ((QueryResult?, Error?) -> Void)?
		Perform(query, .runQuery(callback: .any, perform: { callback = $0 }))
		controller.refreshQuery()
		controller.closeResults()
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: IntegerAttribute(id: 0, name: "value"))
		try XCTUnwrap(callback)(SampleQueryResult(samples), nil)
		XCTAssertNil(controller.samples)
		Verify(query, .once, .stop())
	}

	func testExternalSampleReplacementInvalidatesPendingRefresh() throws {
		let query = QueryMock()
		configureRefreshes([query])
		var callback: ((QueryResult?, Error?) -> Void)?
		Perform(query, .runQuery(callback: .any, perform: { callback = $0 }))
		controller.refreshQuery()
		let attribute = IntegerAttribute(id: 0, name: "value")
		let old = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: attribute)
		let latest = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [2], for: attribute)
		controller.samples = latest
		try XCTUnwrap(callback)(SampleQueryResult(old), nil)
		XCTAssertTrue((controller.samples.first as AnyObject?) === latest.first)
		Verify(query, .once, .stop())
	}

	func testBackgroundRefreshPublishesInformationOnMain() throws {
		let query = QueryMock()
		configureRefreshes([query])
		var callback: ((QueryResult?, Error?) -> Void)?
		Perform(query, .runQuery(callback: .any, perform: { callback = $0 }))
		controller.refreshQuery()
		let completion = try XCTUnwrap(callback)
		let information = mockInformation(count: 1)[0]
		Given(information, .name(getter: "Main queue probe"))
		Perform(information, .compute(forSamples: .any, perform: { _ in XCTAssertTrue(Thread.isMainThread) }))
		controller.information = [information]
		let samples = SampleCreatorTestUtil.createSamplesWithoutDateAttribute(withValues: [1], for: IntegerAttribute(id: 0, name: "value"))
		let published = expectation(description: "Main queue published background completion")
		DispatchQueue.global().async {
			completion(SampleQueryResult(samples), nil)
			DispatchQueue.main.async { published.fulfill() }
		}
		wait(for: [published], timeout: 2)
		XCTAssertTrue((controller.samples.first as AnyObject?) === samples.first)
		Verify(information, .compute(forSamples: .any))
	}

	func testQueuedRefreshDoesNotRetainClosedResultsController() throws {
		let query = QueryMock()
		configureRefreshes([query])
		controller.refreshQuery()
		let captured = ArgumentCaptor<(QueryResult?, Error?) -> Void>()
		Verify(query, .runQuery(callback: .capturing(captured)))
		let callback = try XCTUnwrap(captured.value)
		weak var released = controller
		controller.closeResults()
		mockUiUtil.resetMock(); mockAsyncUtil.resetMock()
		controller = nil
		XCTAssertNil(released)
		callback(nil, GenericError("Late error"))
	}

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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: expectedRows, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
			Given(sample, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(id: 0, name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()
		let loadedOrder = controller.samples!.map { ObjectIdentifier($0 as AnyObject) }
		XCTAssertEqual(Set(loadedOrder), Set(samples.map { ObjectIdentifier($0) }))

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 1))

		// then
		XCTAssertEqual(controller.samples!.map { ObjectIdentifier($0 as AnyObject) }, loadedOrder)
	}

	func testGivenMoveFromSection0ToSection1_tableViewMoveRowAt_doesNotChangeSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(id: 0, name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()
		let loadedOrder = controller.samples!.map { ObjectIdentifier($0 as AnyObject) }
		XCTAssertEqual(Set(loadedOrder), Set(samples.map { ObjectIdentifier($0) }))

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 1))

		// then
		XCTAssertEqual(controller.samples!.map { ObjectIdentifier($0 as AnyObject) }, loadedOrder)
	}

	func testGivenMoveFromSection1ToSection0_tableViewMoveRowAt_doesNotChangeSamples() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 2, withAttributes: [TextAttribute(id: 0, name: "")])
		Given(mockSampleUtil, .getOnly(samples: .any([Sample].self), from: .any, to: .any, willReturn: samples))
		controller.samples = copyArray(samples)
		controller.viewDidLoad()
		let loadedOrder = controller.samples!.map { ObjectIdentifier($0 as AnyObject) }
		XCTAssertEqual(Set(loadedOrder), Set(samples.map { ObjectIdentifier($0) }))

		// when
		controller.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 0))

		// then
		XCTAssertEqual(controller.samples!.map { ObjectIdentifier($0 as AnyObject) }, loadedOrder)
	}

	func testGivenMoveFromSection0ToSection0_tableViewMoveRowAt_swapsCorrectInformation() {
		// given
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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

	func testEditingFilteredMoodWithEqualValuesUpdatesItsOriginalSampleSlot() {
		let hidden = moodMock()
		let visible = moodMock()
		let replacement = moodMock()
		for mood in [hidden, visible, replacement] {
			Given(mood, .equalTo(.any(Sample.self), willReturn: true))
			Given(mood, .matchesSearchString(.any, willReturn: mood !== hidden))
		}
		controller.setSearchText("visible")
		controller.samples = [hidden, visible]
		controller.viewDidLoad()
		mockMoodTableViewCell()
		mockEditMoodViewController()
		controller.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
		Given(mockUiUtil, .value(for: .value(.sample), from: .any, keyIsOptional: .any, willReturn: replacement))

		NotificationCenter.default.post(name: ResultsViewControllerImpl.editedSample,
			object: controller, userInfo: [UserInfoKey.sample: replacement])

		XCTAssertEqual(controller.samples.count, 2)
		XCTAssertTrue((controller.samples[0] as AnyObject) === hidden)
		XCTAssertTrue((controller.samples[1] as AnyObject) === replacement)
	}

	func testNearbyActionUsesTheVisibleFilteredSamplesDates() {
		let hidden = searchableCoreDataSampleMock(matches: false)
		let visible = searchableCoreDataSampleMock(matches: true)
		Given(hidden, .dates(willReturn: [:]))
		Given(visible, .dates(willReturn: [.start: Date(timeIntervalSince1970: 1_700_000_000)]))
		controller.setSearchText("visible")
		controller.samples = [hidden, visible]
		controller.viewDidLoad()
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))

		let configuration = controller.tableView(tableView,
			trailingSwipeActionsConfigurationForRowAt: IndexPath(row: 0, section: 1))

		XCTAssertEqual(configuration?.actions.count, 2)
		Verify(mockUiUtil, .contextualAction(style: .value(.normal), title: .value("🔍 Nearby"), handler: .any))
		Verify(hidden, .never, .dates())
		Verify(visible, .once, .dates())
	}

	private func openNearbyChooser() throws -> (SelectDurationViewControllerImpl, QueryMock, Date, Date) {
		let earlier = Date(timeIntervalSince1970: 1_700_000_000)
		let later = earlier.addingTimeInterval(10_000)
		controller.samples = SampleCreatorTestUtil.createSamples(withDates: [earlier, later])
		let chooser = SelectDurationViewControllerImpl()
		let query = QueryMock()
		let destination = ResultsViewControllerMock()
		Given(mockSampleFactory, .allTypes(willReturn: [MoodImpl.self]))
		Given(mockQueryFactory, .queryFor(.any, willReturn: query))
		Given(mockUiUtil, .controller(named: .value("durationChooser"), from: .value("Util"), as: .value(UIViewController.self), willReturn: chooser))
		Given(mockUiUtil, .controller(named: .value("results"), from: .any, as: .value(UIViewController.self), willReturn: destination))
		Given(mockUiUtil, .customPresenter(width: .any, height: .any, center: .any, willReturn: Presentr(presentationType: .alert)))
		Given(mockUiUtil, .alert(title: .any, message: .any, preferredStyle: .any, willReturn: UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)))
		Given(mockUiUtil, .alertAction(title: .any, style: .any, handler: .any, willReturn: UIAlertAction(title: "Mood", style: .default), UIAlertAction(title: "Cancel", style: .cancel)))
		Given(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, willReturn: UIContextualAction()))
		Given(mockUiUtil, .value(for: .value(.duration), from: .any, keyIsOptional: .any, willReturn: TimeDuration(60)))
		var handlers = [UIContextualAction.Handler]()
		var chooseType: ((UIAlertAction) -> Void)?
		Perform(mockUiUtil, .contextualAction(style: .any, title: .any, handler: .any, perform: { _, _, handler in handlers.append(handler) }))
		Perform(mockUiUtil, .alertAction(title: .value(MoodImpl.name), style: .value(.default), handler: .any, perform: { _, _, handler in chooseType = handler }))
		// Building another row's actions must not change the first action's source.
		for row in 0..<2 {
			_ = controller.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: IndexPath(row: row, section: 1))
		}
		try XCTUnwrap(handlers.first)(UIContextualAction(), UIView(), { _ in })
		try XCTUnwrap(chooseType)(UIAlertAction())
		return (chooser, query, later, earlier)
	}

	func testNearbyDurationNotificationIsScopedToTheOpenedChooserAndConsumedOnce() throws {
		let (chooser, query, _, _) = try openNearbyChooser()
		let name = ResultsViewControllerImpl.choseSearchNearbyDuration
		NotificationCenter.default.post(name: name, object: SelectDurationViewControllerImpl())
		Verify(query, .never, .runQuery(callback: .any))
		NotificationCenter.default.post(name: name, object: chooser)
		NotificationCenter.default.post(name: name, object: chooser)
		Verify(query, .once, .runQuery(callback: .any))
	}

	func testNearbyActionRetainsItsOwnDatesWhenOtherRowActionsAreBuilt() throws {
		let (chooser, query, selected, other) = try openNearbyChooser()
		NotificationCenter.default.post(name: ResultsViewControllerImpl.choseSearchNearbyDuration, object: chooser)
		let expression = try XCTUnwrap(query.expression)
		let sample = AnySample(attributes: [CommonSampleAttributes.timestamp])
		sample.set(dates: [.start: selected])
		XCTAssertTrue(try expression.evaluate([.sample: sample]))
		sample.set(dates: [.start: other])
		XCTAssertFalse(try expression.evaluate([.sample: sample]))
	}

	func testGivenSampleEditedNotification_editedSample_editsCorrectSample() {
		// given
		let samples = [moodMock(), moodMock()]
		let newSample = moodMock()
		for sample in samples {
			Given(sample, .equalTo(.any(Sample.self), willReturn: true))
			Given(sample, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
			Given(sample, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
		Given(mood, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
		let samples = SampleCreatorTestUtil.createSamples(count: 1, withAttributes: [TextAttribute(id: 0, name: "")])
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
		Given(mock, .equalTo(Parameter<Sample>.matching { [weak mock] in ($0 as AnyObject) === mock }, willReturn: true))
		Given(mock, .equalTo(Parameter<Sample>.matching { [weak mock] in ($0 as AnyObject) !== mock }, willReturn: false))
		Given(mock, .attributedName(getter: ""))
		Given(mock, .debugDescription(getter: "mock " + UUID().uuidString))
		// Equal timestamps preserve fixture order; sorting is covered separately.
		Given(mock, .dates(willReturn: [.start: Date(timeIntervalSince1970: 1_700_000_000)]))
		Given(mock, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
		Given(mock, .attributes(getter: [TextAttribute(id: 0, name: "")]))
		Given(SearchableCoreDataSampleMock.self, .name(getter: "searchable sample"))
		return mock
	}

	private final func moodMock() -> MoodMock {
		let mock = MoodMock()
		Given(mock, .attributedName(getter: ""))
		Given(mock, .attributes(getter: []))
		Given(mock, .attributes(getter: [TextAttribute(id: 0, name: "")]))
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
