import XCTest
import CoreData
import UIKit

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
import Queries
@testable import Samples

private final class QueryInspectionLoaderProbe: QueryInspectionLoading {
	struct Request {
		let definition: QueryInspectionDefinition
		let selectedRecord: QueryInspectionRecordID?
		let completion: (Result<QueryInspectionReport, Error>) -> Void
		let task: QueryInspectionTask
	}
	var requests: [Request] = []
	var synchronousReport: QueryInspectionReport?
	func inspect(_ definition: QueryInspectionDefinition, selectedRecord: QueryInspectionRecordID?,
		completion: @escaping (Result<QueryInspectionReport, Error>) -> Void) -> QueryInspectionTask {
		let task = QueryInspectionTask()
		requests.append(Request(definition: definition, selectedRecord: selectedRecord, completion: completion, task: task))
		if let report = synchronousReport { completion(.success(report)) }
		return task
	}
}

final class QueryInspectionViewControllerTests: XCTestCase {
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private var context: NSManagedObjectContext?

	override func setUpWithError() throws {
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider()])
	}

	override func tearDownWithError() throws {
		context?.reset(); context = nil
	}

	@MainActor private func controller(_ query: Query = MoodQueryImpl(), probe: QueryInspectionLoaderProbe) -> QueryInspectionViewController {
		let controller = QueryInspectionViewController(style: .grouped)
		controller.loader = probe; controller.query = query
		controller.convertTimeZones = false; controller.clock = { self.anchor }
		controller.loadViewIfNeeded(); controller.viewWillAppear(false)
		return controller
	}

	private func report(_ query: Query = MoodQueryImpl(), count: Int = 2,
		selected: Bool? = nil, diagnostics: [String] = []) throws -> QueryInspectionReport {
		QueryInspectionReport(explanation: try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false),
			evaluatedAt: anchor, counts: [
				"q0/all": QueryInspectionCount(matched: count, selectedRecordMatches: selected),
				"q0/results": QueryInspectionCount(matched: count, selectedRecordMatches: selected),
				"q0/expression": QueryInspectionCount(matched: count, selectedRecordMatches: selected),
			], diagnostics: diagnostics)
	}

	@MainActor private func text(_ controller: QueryInspectionViewController, row: Int, section: Int = 1) -> String {
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: row, section: section))
		return [cell.textLabel?.text, cell.detailTextLabel?.text].compactMap { $0 }.joined(separator: " ")
	}

	@MainActor func testOpeningPreviewExplainsActualTreeWithoutReadingAnyRecords() throws {
		let query = MoodQueryImpl()
		query.expression = NotExpression(BooleanExpressionGroup(OrExpression(
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 4),
			LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 2))))
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		XCTAssertTrue(probe.requests.isEmpty)
		XCTAssertNil(controller.report)
		XCTAssertTrue(controller.statusText.contains("No records have been read"))
		XCTAssertEqual(controller.tableView.accessibilityIdentifier, "queryInspection")
		XCTAssertTrue(controller.navigationItem.rightBarButtonItem?.isEnabled == true)
		XCTAssertGreaterThan(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 5)
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 2, section: 1))
		XCTAssertEqual(cell.accessibilityIdentifier, "queryExplanation.q0/expression")
		XCTAssertTrue(cell.isAccessibilityElement)
		XCTAssertTrue(cell.detailTextLabel?.text?.contains("Count not inspected") == true)
		controller.viewWillDisappear(false)
	}

	@MainActor func testCountsStartOnlyOnExplicitRequestAndOverlappingORRemainsOneGroupCount() throws {
		let query = MoodQueryImpl()
		query.expression = OrExpression(
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 1),
			GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 2))
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		controller.inspectConditionCounts()
		XCTAssertEqual(probe.requests.count, 1)
		XCTAssertEqual(probe.requests[0].definition, try QueryInspectionDefinition.capture(query))
		XCTAssertNil(probe.requests[0].selectedRecord)
		let explanation = try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false)
		probe.requests[0].completion(.success(QueryInspectionReport(explanation: explanation, evaluatedAt: anchor, counts: [
			"q0/all": QueryInspectionCount(matched: 3, selectedRecordMatches: nil),
			"q0/results": QueryInspectionCount(matched: 2, selectedRecordMatches: nil),
			"q0/expression": QueryInspectionCount(matched: 2, selectedRecordMatches: nil),
			"q0/expression/0": QueryInspectionCount(matched: 2, selectedRecordMatches: nil),
			"q0/expression/1": QueryInspectionCount(matched: 2, selectedRecordMatches: nil),
		], diagnostics: [])))
		XCTAssertEqual(controller.report?.counts["q0/results"]?.matched, 2)
		XCTAssertTrue(text(controller, row: 2).contains("2 matching records"))
		XCTAssertFalse(text(controller, row: 2).contains("4 matching records"))
		XCTAssertTrue(controller.statusText.contains("never added"))
		controller.viewWillDisappear(false)
	}

	@MainActor func testCancelButtonCancelsWorkerAndRejectsLateCompletion() throws {
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(probe: probe)
		controller.inspectConditionCounts()
		let request = try XCTUnwrap(probe.requests.first)
		XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Cancel")
		controller.inspectConditionCounts()
		XCTAssertTrue(request.task.isCancelled)
		request.completion(.success(try report(count: 999)))
		XCTAssertNil(controller.report)
		XCTAssertTrue(controller.statusText.contains("cancelled"))
		XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Inspect Counts")
		controller.viewWillDisappear(false)
	}

	@MainActor func testReplacingQueryCancelsOldRequestAndOldResultCannotReplaceNewResult() throws {
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(probe: probe)
		controller.inspectConditionCounts()
		let first = probe.requests[0]
		let replacement = MoodQueryImpl()
		replacement.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 5)
		controller.query = replacement
		XCTAssertTrue(first.task.isCancelled)
		XCTAssertNil(controller.report)
		controller.inspectConditionCounts()
		probe.requests[1].completion(.success(try report(replacement, count: 3)))
		first.completion(.success(try report(count: 500)))
		XCTAssertEqual(controller.report?.counts["q0/results"]?.matched, 3)
		controller.viewWillDisappear(false)
	}

	@MainActor func testEditingMutableConditionWhileInspectionRunsDiscardsSnapshot() throws {
		let query = MoodQueryImpl()
		let restriction = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 2)
		query.expression = restriction
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		controller.inspectConditionCounts()
		let oldReport = try report(query, count: 2)
		restriction.value = 9
		probe.requests[0].completion(.success(oldReport))
		XCTAssertNil(controller.report)
		XCTAssertTrue(controller.statusText.contains("query changed"))
		XCTAssertTrue(text(controller, row: 2).contains("9"))
		controller.viewWillDisappear(false)
	}

	@MainActor func testDisappearingCancelsAndNeverPublishesLateCounts() throws {
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(probe: probe)
		controller.inspectConditionCounts()
		controller.viewWillDisappear(false)
		XCTAssertTrue(probe.requests[0].task.isCancelled)
		probe.requests[0].completion(.success(try report()))
		XCTAssertNil(controller.report)
		XCTAssertTrue(controller.statusText.contains("cancelled"))
	}

	@MainActor func testControllerCanDeallocateWhileLoaderRetainsCompletion() throws {
		let probe = QueryInspectionLoaderProbe()
		weak var released: QueryInspectionViewController?
		autoreleasepool {
			let controller = self.controller(probe: probe)
			released = controller
			controller.inspectConditionCounts()
		}
		XCTAssertNil(released)
		XCTAssertTrue(probe.requests[0].task.isCancelled)
		probe.requests[0].completion(.success(try report()))
	}

	@MainActor func testFailureDoesNotMasqueradeAsZeroCountsAndLeavesRetryAvailable() throws {
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(probe: probe)
		controller.inspectConditionCounts()
		probe.requests[0].completion(.failure(GenericError("Unavailable test data")))
		XCTAssertNil(controller.report)
		XCTAssertTrue(controller.statusText.contains("Could not inspect"))
		XCTAssertTrue(text(controller, row: 1).contains("Count not inspected"))
		XCTAssertTrue(controller.navigationItem.rightBarButtonItem?.isEnabled == true)
		controller.inspectConditionCounts()
		XCTAssertEqual(probe.requests.count, 2)
		controller.viewWillDisappear(false)
	}

	@MainActor func testSelectedRecordIsPassedAsPermanentIdentityAndMatchingStatusIsShown() throws {
		let model = try XCTUnwrap(NSManagedObjectModel.mergedModel(from: [Bundle(for: Self.self)]))
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = coordinator; self.context = context
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context))
		let sample = MoodImpl(entity: entity, insertInto: context)
		sample.setValue(anchor, forKey: "timestamp")
		sample.setValue(TimeZone.current.identifier, forKey: "timestampTimeZoneId")
		sample.rating = 4; sample.minRating = 0; sample.maxRating = 10; sample.setSource(.introspective)
		try context.save()
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(probe: probe)
		try controller.selectRecord(sample)
		XCTAssertTrue(probe.requests.isEmpty)
		controller.inspectConditionCounts()
		XCTAssertEqual(probe.requests[0].selectedRecord, .stored(sample.objectID))
		probe.requests[0].completion(.success(try report(count: 1, selected: true)))
		XCTAssertTrue(text(controller, row: 1).contains("Selected record: matches"))
		XCTAssertEqual(sample.rating, 4)
		XCTAssertFalse(context.hasChanges)
		controller.viewWillDisappear(false)
	}

	@MainActor func testSynchronousLoaderCompletionIsPublishedWithoutLeavingCancelState() throws {
		let probe = QueryInspectionLoaderProbe()
		probe.synchronousReport = try report(count: 7)
		let controller = self.controller(probe: probe)
		controller.inspectConditionCounts()
		XCTAssertEqual(controller.report?.counts["q0/results"]?.matched, 7)
		XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Inspect Counts")
		controller.viewWillDisappear(false)
	}

	@MainActor func testReferenceQueryCountsDoNotClaimSelectedRecordFailedAConditionOnAnotherType() throws {
		let query = MoodQueryImpl(), reference = PainQueryImpl()
		query.subQuery = (SameDatesSubQueryMatcher(), reference)
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		controller.inspectConditionCounts()
		probe.requests[0].completion(.success(QueryInspectionReport(
			explanation: try QueryExplanationBuilder.explain(query: query, evaluatedAt: anchor, convertTimeZones: false),
			evaluatedAt: anchor, counts: [
				"q0/results": QueryInspectionCount(matched: 0, selectedRecordMatches: false),
				"q1/all": QueryInspectionCount(matched: 5, selectedRecordMatches: nil),
				"q1/results": QueryInspectionCount(matched: 1, selectedRecordMatches: nil),
			], diagnostics: [])))
		XCTAssertTrue(controller.tableView(controller.tableView, titleForHeaderInSection: 2)?.contains("Reference query") == true)
		XCTAssertTrue(text(controller, row: 1, section: 2).contains("1 matching record"))
		XCTAssertFalse(text(controller, row: 1, section: 2).contains("Selected record"))
		controller.viewWillDisappear(false)
	}

	@MainActor func testZeroResultsPresentDiagnosticsWithoutChangingOrRerunningTheQuery() throws {
		let query = MoodQueryImpl()
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: 8)
		let before = try QueryInspectionDefinition.capture(query)
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		controller.inspectConditionCounts()
		probe.requests[0].completion(.success(try report(query, count: 0,
			diagnostics: ["No available records match this condition. Review its rating boundary."])))
		XCTAssertEqual(probe.requests.count, 1)
		XCTAssertEqual(try QueryInspectionDefinition.capture(query), before)
		XCTAssertTrue(text(controller, row: 1).contains("0 matching records"))
		XCTAssertEqual(controller.tableView(controller.tableView, titleForHeaderInSection: 2), "Diagnostics")
		XCTAssertTrue(text(controller, row: 0, section: 2).contains("rating boundary"))
		controller.viewWillDisappear(false)
	}

	@MainActor func testIncompleteExpressionNeverRunsInspectionOrPresentsGuessedPreview() {
		let query = MoodQueryImpl(); query.expression = AndExpression()
		let probe = QueryInspectionLoaderProbe(), controller = self.controller(query, probe: probe)
		XCTAssertFalse(controller.navigationItem.rightBarButtonItem?.isEnabled ?? true)
		XCTAssertTrue(controller.statusText.contains("cannot be explained safely"))
		controller.inspectConditionCounts()
		XCTAssertTrue(probe.requests.isEmpty)
		XCTAssertNil(controller.report)
		controller.viewWillDisappear(false)
	}
}
