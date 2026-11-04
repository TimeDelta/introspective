import XCTest
import CoreData
import HealthKit

import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
@testable import Persistence
import Queries
@testable import Samples
@testable import Settings

private final class InspectionServiceTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	private let database: Database
	private let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<Value>(_ type: Value.Type) throws -> Value {
		if type == Database.self { return database as! Value }
		if type == Settings.self { return settings as! Value }
		throw GenericError("Unexpected inspection test dependency")
	}
}

private final class InspectionServiceHealthProbe: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	var started: XCTestExpectation?
	var stopped: XCTestExpectation?
	var automatic = false
	var samples: [HKSample]?
	var error: Error?
	private let lock = NSLock()
	private var callback: (([HKSample]?, Error?) -> Void)?
	private var requestCount = 0
	var requests: Int { lock.lock(); defer { lock.unlock() }; return requestCount }

	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? { .count() }
	func getAuthorization(callback: @escaping (Error?) -> Void) { callback(nil) }
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Inspection must use records rather than substituting Health statistics")
		callback(nil, GenericError("Unexpected Health calculation"))
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTAssertFalse(Thread.isMainThread, "Potentially expensive Health inspection belongs on the read queue")
		XCTAssertTrue(type == Steps.self)
		lock.lock(); requestCount += 1; self.callback = callback; lock.unlock()
		started?.fulfill()
		if automatic { deliver(samples, error: error) }
		return { [weak self] in self?.stopped?.fulfill() }
	}
	func deliver(_ samples: [HKSample]?, error: Error? = nil) {
		lock.lock(); let callback = callback; self.callback = nil; lock.unlock()
		XCTAssertNotNil(callback)
		callback?(samples, error)
	}
}

private final class InspectionCallbackLifetime {
	let released: XCTestExpectation
	init(_ released: XCTestExpectation) { self.released = released }
	func receive(_ result: Result<QueryInspectionReport, Error>) { XCTFail("Cancelled inspection must not publish") }
	deinit { released.fulfill() }
}

final class QueryInspectionServiceTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: QueryInspectionServiceTests.self)])!
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.125)
	private var directory: URL!
	private var container: NSPersistentContainer!

	override func setUpWithError() throws {
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "QueryInspectionTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("inspection.sqlite"))
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: context))
		let settings = SettingsImpl(entity: entity, insertInto: context)
		try context.save()
		context.automaticallyMergesChangesFromParent = true
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			InspectionServiceTestProvider(database: DatabaseImpl(container), settings: settings)])
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
		try FileManager.default.removeItem(at: directory)
	}

	@discardableResult private func mood(_ rating: Double, at date: Date? = nil, note: String? = nil) throws -> MoodImpl {
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context))
		let mood = MoodImpl(entity: entity, insertInto: context)
		mood.setValue(date ?? anchor, forKey: "timestamp")
		mood.setValue(TimeZone.current.identifier, forKey: "timestampTimeZoneId")
		mood.rating = rating; mood.minRating = 0; mood.maxRating = 10; mood.note = note
		mood.setSource(.introspective)
		return mood
	}

	private func above(_ value: Double) -> GreaterThanDoubleAttributeRestriction {
		GreaterThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: value)
	}
	private func below(_ value: Double) -> LessThanDoubleAttributeRestriction {
		LessThanDoubleAttributeRestriction(restrictedAttribute: MoodImpl.rating, value: value)
	}
	private func activity(directTags: [Tag] = [], definitionTags: [Tag] = []) throws -> Activity {
		let context = container.viewContext
		let definitionEntity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: ActivityDefinition.entityName, in: context))
		let definition = ActivityDefinition(entity: definitionEntity, insertInto: context)
		definition.setValue(UUID().uuidString, forKey: "name")
		definition.setValue(0, forKey: "recordScreenIndex")
		definition.setValue(NSSet(array: definitionTags), forKey: "tags")
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Activity.entityName, in: context))
		let activity = Activity(entity: entity, insertInto: context)
		activity.setValue(definition, forKey: "definition")
		activity.setValue(anchor, forKey: "startDate")
		activity.setValue(anchor.addingTimeInterval(10), forKey: "endDate")
		activity.setValue(NSSet(array: directTags), forKey: "tags")
		return activity
	}
	private func tag(_ name: String) throws -> Tag {
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: container.viewContext))
		let tag = Tag(entity: entity, insertInto: container.viewContext); tag.name = name
		return tag
	}
	private func step(_ date: Date, count: Double = 20) -> HKQuantitySample {
		HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: .count(), doubleValue: count),
			start: date, end: date.addingTimeInterval(10))
	}
	private func query(_ expression: BooleanExpression?) -> MoodQueryImpl {
		let query = MoodQueryImpl(); query.expression = expression; return query
	}

	@MainActor private func inspect(_ query: Query, selected: QueryInspectionRecordID? = nil,
		clock: (() -> Date)? = nil) throws -> QueryInspectionReport {
		let finished = expectation(description: "Inspection finished on main")
		let date = anchor
		let service = QueryInspectionService(context: container.viewContext, convertTimeZones: false, clock: clock ?? { date })
		var outcome: Result<QueryInspectionReport, Error>?
		let task = service.inspect(try QueryInspectionDefinition.capture(query), selectedRecord: selected) {
			XCTAssertTrue(Thread.isMainThread)
			outcome = $0; finished.fulfill()
		}
		wait(for: [finished], timeout: 5)
		withExtendedLifetime(task) {}
		return try XCTUnwrap(outcome).get()
	}

	/// Compare inspection to the actual engine, including SQL NULL handling.
	/// These comparison queries contain only synchronous Core Data nodes.
	private func actualIDs(_ query: Query) throws -> Set<NSManagedObjectID> {
		var ids: Set<NSManagedObjectID>?
		var failure: Error?
		QueryReadScope.with(date: anchor, convertTimeZones: false) {
			query.runQuery { (result: QueryResult?, error: Error?) in
				failure = error
				ids = Set((result?.samples ?? []).compactMap { ($0 as? NSManagedObject)?.objectID })
			}
		}
		if let failure = failure, !(failure is NoSamplesFoundQueryError) { throw failure }
		return try XCTUnwrap(ids)
	}

	@MainActor func testOverlappingORCountsEachGroupOnceAndExplainsSelectedMembership() throws {
		_ = try mood(1); let middle = try mood(5); _ = try mood(9)
		try container.viewContext.save()
		let query = query(OrExpression(above(3), below(7)))
		let report = try inspect(query, selected: .capture(middle))
		XCTAssertEqual(report.counts["q0/all"]?.matched, 3)
		XCTAssertEqual(report.counts["q0/expression/0"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression/1"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 3, "An overlapping OR is not the sum of its children")
		XCTAssertEqual(report.counts["q0/results"]?.matched, try actualIDs(query).count)
		for path in ["q0/all", "q0/expression", "q0/expression/0", "q0/expression/1", "q0/results"] {
			XCTAssertEqual(report.counts[path]?.selectedRecordMatches, true, path)
		}
		XCTAssertFalse(container.viewContext.hasChanges)
	}

	@MainActor func testNestedANDNOTAndExplicitGroupPreserveActualEngineResults() throws {
		_ = try mood(1, note: "other")
		_ = try mood(5, note: "needle")
		let selected = try mood(9, note: "other")
		try container.viewContext.save()
		let contains = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "needle")
		let query = query(AndExpression(BooleanExpressionGroup(OrExpression(below(3), above(7))), NotExpression(contains)))
		let report = try inspect(query, selected: .capture(selected))
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression/0"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression/0/0"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression/1/0"]?.matched, 1)
		XCTAssertEqual(report.counts["q0/results"]?.matched, try actualIDs(query).count)
		XCTAssertEqual(report.counts["q0/expression/1"]?.selectedRecordMatches, true)
		XCTAssertEqual(report.counts["q0/expression/1/0"]?.selectedRecordMatches, false)
	}

	@MainActor func testNullableNOTCountsAndRecordReasonsFollowSQLiteRatherThanAssumedComplements() throws {
		let missing = try mood(1)
		let needle = try mood(5, note: "needle")
		let other = try mood(9, note: "other")
		try container.viewContext.save()
		let contains = ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "needle")
		let query = query(NotExpression(contains))
		let expected = try actualIDs(query)
		for record in [missing, needle, other] {
			let report = try inspect(query, selected: .capture(record))
			XCTAssertEqual(report.counts["q0/results"]?.matched, expected.count)
			XCTAssertEqual(report.counts["q0/expression"]?.matched, expected.count)
			XCTAssertEqual(report.counts["q0/expression"]?.selectedRecordMatches, expected.contains(record.objectID))
			XCTAssertEqual(report.counts["q0/expression/0"]?.matched, 1)
		}
	}

	@MainActor func testMixedUnsupportedSQLConditionKeepsEvaluatorSemanticsForEveryChild() throws {
		let missing = try mood(1)
		let needle = try mood(5, note: "needle")
		let other = try mood(9, note: "other")
		try container.viewContext.save()
		let negated = NotExpression(ContainsStringAttributeRestriction(restrictedAttribute: MoodImpl.note, substring: "needle"))
		let neverBeforeMidnight = BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp,
			timeOfDay: TimeOfDay())
		let expression = OrExpression(negated, neverBeforeMidnight)
		XCTAssertNil(expression.predicate(), "This entire query must use its evaluator")
		let query = query(expression)
		let expected = try actualIDs(query)
		let childExpected = try QueryReadScope.with(date: anchor, convertTimeZones: false) {
			try [missing, needle, other].filter { try negated.evaluate([.sample: $0]) }
		}
		let report = try inspect(query, selected: .capture(missing))
		XCTAssertEqual(report.counts["q0/results"]?.matched, expected.count)
		XCTAssertEqual(report.counts["q0/expression/0"]?.matched, childExpected.count)
		XCTAssertEqual(report.counts["q0/expression/0"]?.selectedRecordMatches,
			childExpected.contains { $0.objectID == missing.objectID })
		XCTAssertEqual(report.counts["q0/expression/1"]?.matched, 0)
	}

	@MainActor func testEmptyStoreAndContradictoryConditionsProduceDifferentEvidenceWithoutChangingQuery() throws {
		let expression = AndExpression(above(7), below(3))
		let query = query(expression)
		let empty = try inspect(query)
		XCTAssertEqual(empty.counts["q0/all"]?.matched, 0)
		XCTAssertEqual(empty.counts["q0/results"]?.matched, 0)
		_ = try mood(1); _ = try mood(9); try container.viewContext.save()
		let contradiction = try inspect(query)
		XCTAssertEqual(contradiction.counts["q0/all"]?.matched, 2)
		XCTAssertEqual(contradiction.counts["q0/expression/0"]?.matched, 1)
		XCTAssertEqual(contradiction.counts["q0/expression/1"]?.matched, 1)
		XCTAssertEqual(contradiction.counts["q0/results"]?.matched, 0)
		XCTAssertNotEqual(empty.diagnostics, contradiction.diagnostics)
		XCTAssertTrue((query.expression as? AndExpression) === expression)
		XCTAssertNil(query.subQuery)
		XCTAssertEqual(try actualIDs(query).count, 0)
		XCTAssertEqual(try container.viewContext.count(for: MoodImpl.fetchRequest()), 2)
		XCTAssertFalse(container.viewContext.hasChanges)
	}

	@MainActor func testSingleActivityTagSQLInspectionIncludesBothDirectAndDefinitionTags() throws {
		let selectedTag = try tag("Quiet"), other = try tag("Other")
		let direct = try activity(directTags: [selectedTag])
		let inherited = try activity(definitionTags: [selectedTag])
		_ = try activity(directTags: [other])
		try container.viewContext.save()
		let query = ActivityQueryImpl()
		query.expression = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: selectedTag)
		let report = try inspect(query, selected: .capture(inherited))
		XCTAssertEqual(report.counts["q0/all"]?.matched, 3)
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/results"]?.selectedRecordMatches, true)
		XCTAssertEqual(try actualIDs(query), Set([direct.objectID, inherited.objectID]))
		XCTAssertFalse(container.viewContext.hasChanges)
	}

	@MainActor func testSingleActivityTagEvaluatorInspectionPreservesInheritedTagsInMixedTree() throws {
		let selectedTag = try tag("Quiet")
		let inherited = try activity(definitionTags: [selectedTag])
		_ = try activity()
		try container.viewContext.save()
		let query = ActivityQueryImpl()
		let tagCondition = ActivityHasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: selectedTag)
		query.expression = OrExpression(tagCondition,
			BeforeTimeOfDayAttributeRestriction(restrictedAttribute: CommonSampleAttributes.startDate, timeOfDay: TimeOfDay()))
		XCTAssertNil(query.expression?.predicate())
		let report = try inspect(query, selected: .capture(inherited))
		XCTAssertEqual(report.counts["q0/all"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/expression/0"]?.matched, 1)
		XCTAssertEqual(report.counts["q0/expression/1"]?.matched, 0)
		XCTAssertEqual(report.counts["q0/expression/0"]?.selectedRecordMatches, true)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 1)
		XCTAssertEqual(try actualIDs(query), Set([inherited.objectID]))
	}

	@MainActor func testStrictTimestampBoundaryExcludesTheExactInstantWithoutRoundingIt() throws {
		_ = try mood(1, at: anchor.addingTimeInterval(-0.125))
		let boundary = try mood(5, at: anchor)
		let after = try mood(9, at: anchor.addingTimeInterval(0.125))
		try container.viewContext.save()
		let query = query(AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor))
		let report = try inspect(query, selected: .capture(boundary))
		XCTAssertEqual(report.counts["q0/all"]?.matched, 3)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 1)
		XCTAssertEqual(report.counts["q0/results"]?.selectedRecordMatches, false)
		XCTAssertEqual(try actualIDs(query), Set([after.objectID]))
		XCTAssertEqual(boundary.originalTimestamp, anchor, "Inspection must not apply timestamp-editor rounding")
	}

	@MainActor func testRelativeWindowUsesOneCapturedClockAndIncludesBothEndpoints() throws {
		_ = try mood(1, at: anchor.addingTimeInterval(-300.125))
		_ = try mood(3, at: anchor.addingTimeInterval(-300))
		_ = try mood(5, at: anchor)
		_ = try mood(9, at: anchor.addingTimeInterval(0.125))
		try container.viewContext.save()
		let query = query(InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, 5, .minute))
		var clockReads = 0
		let date = anchor
		let report = try inspect(query, clock: { clockReads += 1; return date.addingTimeInterval(Double(clockReads - 1) * 3_600) })
		XCTAssertEqual(clockReads, 1)
		XCTAssertEqual(report.evaluatedAt, anchor)
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 2)
		XCTAssertEqual(try actualIDs(query).count, 2)
	}

	@MainActor func testSubqueryCountsKeepReferenceAndRootPopulationsSeparateAndUseTheActualNewestReference() throws {
		_ = try mood(1, at: anchor)
		_ = try mood(9, at: anchor)
		_ = try mood(2, at: anchor.addingTimeInterval(60))
		let latest = try mood(8, at: anchor.addingTimeInterval(60))
		try container.viewContext.save()
		let reference = query(below(3))
		let query = query(above(7))
		query.subQuery = (SameStartDatesSubQueryMatcher(mostRecentOnly: true), reference)
		let report = try inspect(query, selected: .capture(latest))
		XCTAssertEqual(report.counts["q0/all"]?.matched, 4)
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 1)
		XCTAssertEqual(report.counts["q1/all"]?.matched, 4)
		XCTAssertEqual(report.counts["q1/results"]?.matched, 2, "Matcher recency selects a reference; it does not rewrite the reference query")
		XCTAssertNil(report.counts["q1/results"]?.selectedRecordMatches)
		XCTAssertEqual(report.counts["q0/results"]?.selectedRecordMatches, true)
		XCTAssertEqual(try actualIDs(query), Set([latest.objectID]))
	}

	@MainActor func testEmptyReferenceQueryIsDiagnosedWithoutShowingUnrelatedRootRecordsAsMatches() throws {
		_ = try mood(9); try container.viewContext.save()
		let query = query(above(7))
		query.subQuery = (SameStartDatesSubQueryMatcher(), self.query(below(0)))
		let report = try inspect(query)
		XCTAssertEqual(report.counts["q0/expression"]?.matched, 1)
		XCTAssertEqual(report.counts["q1/results"]?.matched, 0)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 0)
		XCTAssertTrue(report.diagnostics.contains { $0.localizedCaseInsensitiveContains("subquery") })
		XCTAssertEqual(try actualIDs(query).count, 0)
	}

	@MainActor func testSelectedDeletedRecordIsReportedAsAbsentFromTheNewSnapshot() throws {
		let deleted = try mood(5); _ = try mood(9)
		try container.viewContext.save()
		let identity = try QueryInspectionRecordID.capture(deleted)
		container.viewContext.delete(deleted); try container.viewContext.save()
		let report = try inspect(query(nil), selected: identity)
		XCTAssertEqual(report.counts["q0/all"]?.matched, 1)
		XCTAssertEqual(report.counts["q0/all"]?.selectedRecordMatches, false)
		XCTAssertEqual(report.counts["q0/results"]?.selectedRecordMatches, false)
		XCTAssertTrue(report.diagnostics.contains { $0.localizedCaseInsensitiveContains("no longer visible") })
	}

	@MainActor func testConcurrentSaveWhileAwaitingHealthKeepsTheOriginalDatabaseGenerationForLaterReferenceCounts() throws {
		_ = try mood(2); try container.viewContext.save()
		let health = InspectionServiceHealthProbe()
		let started = expectation(description: "Health read awaits delivery after database generation is pinned")
		health.started = started; DependencyInjector.register([health])
		let query = StepsQueryImpl()
		query.subQuery = (SameStartDatesSubQueryMatcher(), self.query(nil))
		let finished = expectation(description: "Inspection remains on the original database generation")
		let date = anchor
		let service = QueryInspectionService(context: container.viewContext, convertTimeZones: false, clock: { date })
		var outcome: Result<QueryInspectionReport, Error>?
		let task = service.inspect(try QueryInspectionDefinition.capture(query), selectedRecord: nil) { outcome = $0; finished.fulfill() }
		wait(for: [started], timeout: 5)
		_ = try mood(8, at: anchor.addingTimeInterval(60)); try container.viewContext.save()
		health.deliver([step(anchor), step(anchor.addingTimeInterval(60))])
		wait(for: [finished], timeout: 5)
		let report = try XCTUnwrap(outcome).get()
		XCTAssertEqual(report.counts["q0/all"]?.matched, 2)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 1)
		XCTAssertEqual(report.counts["q1/all"]?.matched, 1, "Later condition reads must not advance to a post-save generation")
		XCTAssertEqual(report.counts["q1/results"]?.matched, 1)
		XCTAssertEqual(health.requests, 1, "All Health counts must share the captured read")
		health.started = nil; health.automatic = true
		health.samples = [step(anchor), step(anchor.addingTimeInterval(60))]
		let fresh = try inspect(query)
		XCTAssertEqual(fresh.counts["q1/all"]?.matched, 2)
		XCTAssertEqual(fresh.counts["q0/results"]?.matched, 2)
		XCTAssertEqual(health.requests, 2, "A separate inspection captures fresh Health data")
		withExtendedLifetime(task) {}
	}

	@MainActor func testMissingHealthReadRemainsVisibilityAmbiguousAndIsFetchedOnlyOnce() throws {
		let health = InspectionServiceHealthProbe(); health.automatic = true; health.samples = nil
		DependencyInjector.register([health])
		let query = StepsQueryImpl()
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: Steps.stepCount, value: 10)
		let report = try inspect(query)
		XCTAssertEqual(report.counts["q0/all"]?.matched, 0)
		XCTAssertEqual(report.counts["q0/results"]?.matched, 0)
		XCTAssertEqual(health.requests, 1)
		let explanation = (report.explanation.notes + report.diagnostics).joined(separator: " ").lowercased()
		XCTAssertTrue(explanation.contains("health"))
		XCTAssertTrue(explanation.contains("permission") || explanation.contains("access"),
			"An empty Health read must not be described as proof that the user has no data")
	}

	@MainActor func testSelectedHealthRecordUsesOriginalIdentityRatherThanExportUUIDOrEqualContent() throws {
		let original = step(anchor)
		let sameContentDifferentIdentity = step(anchor)
		XCTAssertNotEqual(original.uuid, sameContentDifferentIdentity.uuid)
		let health = InspectionServiceHealthProbe(); health.automatic = true
		health.samples = [sameContentDifferentIdentity]
		DependencyInjector.register([health])
		let selection = try QueryInspectionRecordID.capture(Steps(original))
		let query = StepsQueryImpl()
		query.expression = GreaterThanDoubleAttributeRestriction(restrictedAttribute: Steps.stepCount, value: 10)
		let absent = try inspect(query, selected: selection)
		XCTAssertEqual(absent.counts["q0/all"]?.matched, 1)
		XCTAssertEqual(absent.counts["q0/all"]?.selectedRecordMatches, false,
			"An identical Health record with a different UUID must not explain the selected record")
		health.samples = [original, sameContentDifferentIdentity]
		let present = try inspect(query, selected: selection)
		XCTAssertEqual(present.counts["q0/all"]?.matched, 2)
		XCTAssertEqual(present.counts["q0/all"]?.selectedRecordMatches, true)
		XCTAssertEqual(present.counts["q0/expression"]?.selectedRecordMatches, true)
		XCTAssertEqual(present.counts["q0/results"]?.selectedRecordMatches, true,
			"Mapped Health snapshots must preserve the original identity across independent count queries")
		XCTAssertEqual(health.requests, 2)
	}

	@MainActor func testHealthReadFailureRemainsAFailureInsteadOfPublishingZeroMatchEvidence() throws {
		let health = InspectionServiceHealthProbe(); health.automatic = true
		health.error = NSError(domain: "InspectionHealthReadFailure", code: 19)
		DependencyInjector.register([health])
		let finished = expectation(description: "Health failure is delivered")
		let date = anchor
		let service = QueryInspectionService(context: container.viewContext, convertTimeZones: false, clock: { date })
		let task = service.inspect(try QueryInspectionDefinition.capture(StepsQueryImpl()), selectedRecord: nil) { result in
			XCTAssertTrue(Thread.isMainThread)
			switch result {
			case .success: XCTFail("Read failures must not become empty diagnostic reports")
			case let .failure(error):
				XCTAssertEqual((error as NSError).domain, "InspectionHealthReadFailure")
				XCTAssertEqual((error as NSError).code, 19)
			}
			finished.fulfill()
		}
		wait(for: [finished], timeout: 5)
		XCTAssertEqual(health.requests, 1)
		withExtendedLifetime(task) {}
	}

	@MainActor func testDroppingTheTaskCancelsHealthAndReleasesItsCompletionWithoutPublishing() throws {
		let health = InspectionServiceHealthProbe()
		let started = expectation(description: "Health read started")
		let stopped = expectation(description: "Cancelling releases the underlying Health read")
		let released = expectation(description: "Cancelled worker releases its completion capture")
		health.started = started; health.stopped = stopped; DependencyInjector.register([health])
		var owner: InspectionCallbackLifetime? = InspectionCallbackLifetime(released)
		weak var weakOwner = owner
		let date = anchor
		let service = QueryInspectionService(context: container.viewContext, convertTimeZones: false, clock: { date })
		var task: QueryInspectionTask? = service.inspect(try QueryInspectionDefinition.capture(StepsQueryImpl()), selectedRecord: nil) { [owner] in owner?.receive($0) }
		owner = nil
		wait(for: [started], timeout: 5)
		XCTAssertNotNil(weakOwner)
		task = nil
		wait(for: [stopped, released], timeout: 5)
		XCTAssertNil(weakOwner)
		XCTAssertNil(task)
		// A platform callback may arrive after stop; it must remain harmless.
		health.deliver([step(anchor)])
	}
}
