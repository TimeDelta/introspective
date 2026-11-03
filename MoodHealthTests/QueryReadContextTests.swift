import XCTest
import Foundation
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

private final class ReadContextUnsupportedQuery: Query {
	var expression: BooleanExpression?
	var mostRecentEntryOnly = false
	var subQuery: (matcher: SubQueryMatcher, query: Query)?
	required init(parts: [BooleanExpressionPart]) throws {}
	func runQuery(callback: @escaping (QueryResult?, Error?) -> Void) { callback(nil, nil) }
	func stop() {}
	func resetStoppedState() {}
	func stored(withName name: String, using transaction: Transaction?) throws -> StoredQuery {
		throw GenericError("Unsupported test query")
	}
}

private final class ReadContextTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<Value>(_ type: Value.Type) throws -> Value {
		if type == Database.self { return database as! Value }
		if type == Settings.self { return settings as! Value }
		throw GenericError("Unexpected read-context test dependency")
	}
}

private final class ReadContextHealthProbe: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	private let lock = NSLock()
	private var authorization: ((Error?) -> Void)?
	private(set) var requests = 0
	private(set) var authorizationRequests = 0
	let anchor: Date
	var authorizationStarted: (() -> Void)?
	var unitFailure: Error?
	init(anchor: Date) { self.anchor = anchor }
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func getAuthorization(callback: @escaping (Error?) -> Void) {
		lock.lock(); authorizationRequests += 1; authorization = callback; lock.unlock()
		authorizationStarted?()
	}
	func deliverAuthorization(completion: @escaping () -> Void = {}) {
		lock.lock(); let callback = authorization; authorization = nil; lock.unlock()
		DispatchQueue.global().async { callback?(nil); completion() }
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? {
		XCTAssertFalse(Thread.isMainThread)
		XCTAssertEqual(QueryReadScope.date, anchor)
		if let unitFailure = unitFailure { QueryReadScope.recordFailure(unitFailure); return nil }
		return HKUnit.count()
	}
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {
		XCTAssertFalse(Thread.isMainThread)
		XCTAssertEqual(QueryReadScope.date, anchor)
		XCTAssertEqual(QueryReadScope.convertTimeZones, false)
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		lock.lock(); requests += 1; lock.unlock()
		XCTAssertFalse(Thread.isMainThread); XCTAssertEqual(QueryReadScope.date, anchor)
		let date = anchor.addingTimeInterval(-1)
		let sample = HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: .count(), doubleValue: 25), start: date, end: date)
		DispatchQueue.global().async { callback([sample], nil) }
		return {}
	}
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Unexpected statistics request in raw-query test")
		callback(nil, GenericError("Unexpected statistics request"))
	}
}

final class QueryReadContextTests: XCTestCase {
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: QueryReadContextTests.self)])!

	override func setUp() {
		super.setUp()
		DependencyInjector.register([CommonInjectionProvider()])
	}

	func testReadScopeRestoresNestedValuesAfterSuccessAndThrowingWork() {
		enum ProbeError: Error { case expected }
		XCTAssertNil(QueryReadScope.date); XCTAssertNil(QueryReadScope.convertTimeZones)
		QueryReadScope.with(date: anchor, convertTimeZones: false) {
			XCTAssertEqual(QueryReadScope.date, anchor)
			XCTAssertEqual(QueryReadScope.convertTimeZones, false)
			let later = anchor.addingTimeInterval(60)
			let result = QueryReadScope.with(date: later, convertTimeZones: true) {
				XCTAssertEqual(QueryReadScope.date, later)
				XCTAssertEqual(QueryReadScope.convertTimeZones, true)
				return 17
			}
			XCTAssertEqual(result, 17)
			XCTAssertThrowsError(try QueryReadScope.with(date: later, convertTimeZones: true) { () throws -> Void in
				throw ProbeError.expected
			})
			XCTAssertEqual(QueryReadScope.date, anchor)
			XCTAssertEqual(QueryReadScope.convertTimeZones, false)
		}
		XCTAssertNil(QueryReadScope.date); XCTAssertNil(QueryReadScope.convertTimeZones)
	}

	func testReadScopesOnConcurrentThreadsCannotChangeEachOtherOrTheCaller() {
		let entered = DispatchGroup(), release = DispatchSemaphore(value: 0)
		let done = expectation(description: "Independent scoped threads")
		done.expectedFulfillmentCount = 2
		for index in 0..<2 {
			entered.enter()
			let date = anchor.addingTimeInterval(Double(index)), conversion = index == 0
			DispatchQueue.global(qos: .userInitiated).async {
				XCTAssertNil(QueryReadScope.date)
				QueryReadScope.with(date: date, convertTimeZones: conversion) {
					entered.leave()
					XCTAssertEqual(release.wait(timeout: .now() + 5), .success)
					XCTAssertEqual(QueryReadScope.date, date)
					XCTAssertEqual(QueryReadScope.convertTimeZones, conversion)
				}
				XCTAssertNil(QueryReadScope.date); XCTAssertNil(QueryReadScope.convertTimeZones)
				done.fulfill()
			}
		}
		XCTAssertEqual(entered.wait(timeout: .now() + 5), .success)
		XCTAssertNil(QueryReadScope.date); XCTAssertNil(QueryReadScope.convertTimeZones)
		release.signal(); release.signal()
		wait(for: [done], timeout: 5)
	}

	func testReadFailuresRestoreNestedErrorsAndStayIndependentOnAnotherThread() {
		enum ProbeError: Error { case expected }
		let outer = NSError(domain: "ReadScopeProbe", code: 1)
		let inner = NSError(domain: "ReadScopeProbe", code: 2)
		let other = NSError(domain: "ReadScopeProbe", code: 3)
		let entered = DispatchSemaphore(value: 0), release = DispatchSemaphore(value: 0)
		let done = expectation(description: "Independent scoped failure")
		QueryReadScope.recordFailure(outer)
		XCTAssertNil(QueryReadScope.readFailure, "Failures outside a read scope must not leak into later reads")
		QueryReadScope.with(date: anchor, convertTimeZones: false) {
			QueryReadScope.recordFailure(outer)
			QueryReadScope.recordFailure(inner)
			XCTAssertEqual(QueryReadScope.readFailure as NSError?, outer, "Preserve the first read failure")
			XCTAssertThrowsError(try QueryReadScope.with(date: anchor, convertTimeZones: true) { () throws -> Void in
				XCTAssertNil(QueryReadScope.readFailure)
				QueryReadScope.recordFailure(inner)
				XCTAssertEqual(QueryReadScope.readFailure as NSError?, inner)
				throw ProbeError.expected
			})
			XCTAssertEqual(QueryReadScope.readFailure as NSError?, outer)
			DispatchQueue.global().async {
				XCTAssertNil(QueryReadScope.readFailure)
				QueryReadScope.with(date: self.anchor, convertTimeZones: true) {
					QueryReadScope.recordFailure(other)
					entered.signal()
					XCTAssertEqual(release.wait(timeout: .now() + 5), .success)
					XCTAssertEqual(QueryReadScope.readFailure as NSError?, other)
				}
				XCTAssertNil(QueryReadScope.readFailure); done.fulfill()
			}
			XCTAssertEqual(entered.wait(timeout: .now() + 5), .success)
			XCTAssertEqual(QueryReadScope.readFailure as NSError?, outer)
			release.signal()
		}
		XCTAssertNil(QueryReadScope.readFailure)
		wait(for: [done], timeout: 5)
	}

	func testPrivateContextPerformsWithCapturedValuesAndRestoresItsQueueAfterward() {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: true)
		let scoped = expectation(description: "Read context work"), restored = expectation(description: "Scope removed")
		environment.perform {
			XCTAssertFalse(Thread.isMainThread)
			XCTAssertEqual(QueryReadScope.date, self.anchor)
			XCTAssertEqual(QueryReadScope.convertTimeZones, true)
			XCTAssertFalse(environment.isCancelled)
			scoped.fulfill()
		}
		context.perform {
			XCTAssertNil(QueryReadScope.date); XCTAssertNil(QueryReadScope.convertTimeZones)
			restored.fulfill()
		}
		wait(for: [scoped, restored], timeout: 5)
		XCTAssertNil(QueryReadScope.date)
	}

	func testReadContextCancellationChecksCurrentStateAndStillAllowsScopedCleanup() {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let lock = NSLock(); var cancelled = false
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false,
			isCancelled: { lock.lock(); defer { lock.unlock() }; return cancelled })
		XCTAssertFalse(environment.isCancelled)
		lock.lock(); cancelled = true; lock.unlock()
		let cleaned = expectation(description: "Cancelled read cleanup still runs")
		environment.perform {
			XCTAssertTrue(environment.isCancelled)
			XCTAssertEqual(QueryReadScope.date, self.anchor)
			context.reset()
			cleaned.fulfill()
		}
		wait(for: [cleaned], timeout: 5)
	}

	func testAlreadyCancelledQueriesNeverFetchOrRequestHealthAuthorization() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false, isCancelled: { true })
		let probe = ReadContextHealthProbe(anchor: anchor)
		DependencyInjector.register([probe])
		let queries: [Query] = [MoodQueryImpl(), StepsQueryImpl()]
		for query in queries { try configureReadContext(query, context: environment) }
		let finished = expectation(description: "Cancelled starts rejected")
		environment.perform {
			var callbacks = 0
			for query in queries { query.runQuery { (result: QueryResult?, error: Error?) in callbacks += 1 } }
			XCTAssertEqual(callbacks, 0)
			XCTAssertEqual(probe.authorizationRequests, 0); XCTAssertEqual(probe.requests, 0)
			finished.fulfill()
		}
		wait(for: [finished], timeout: 5)
	}

	func testHealthCallbacksReturnToThePrivateContextBeforeMappingAndFiltering() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let probe = ReadContextHealthProbe(anchor: anchor)
		let authorization = expectation(description: "Authorization requested"), finished = expectation(description: "Scoped Health result")
		probe.authorizationStarted = { authorization.fulfill() }
		DependencyInjector.register([probe])
		let query = StepsQueryImpl()
		query.expression = InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate, 5, .minute)
		try configureReadContext(query, context: environment)
		environment.perform {
			query.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertFalse(Thread.isMainThread); XCTAssertEqual(QueryReadScope.date, self.anchor)
				XCTAssertNil(error); XCTAssertEqual(result?.samples.count, 1)
				XCTAssertEqual((result?.samples.first as? Steps)?.steps, 25)
				XCTAssertEqual(probe.requests, 1)
				finished.fulfill()
			}
		}
		wait(for: [authorization], timeout: 5)
		probe.deliverAuthorization()
		wait(for: [finished], timeout: 5)
	}

	func testPreferredUnitFailureRejectsHealthQueryBeforeFetchingOrUsingFallbackUnits() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let failure = NSError(domain: "PreferredUnitProbe", code: 7)
		let probe = ReadContextHealthProbe(anchor: anchor); probe.unitFailure = failure
		let authorization = expectation(description: "Unit failure authorization"), finished = expectation(description: "Unit failure reported")
		probe.authorizationStarted = { authorization.fulfill() }; DependencyInjector.register([probe])
		let query = StepsQueryImpl(); try configureReadContext(query, context: environment)
		environment.perform {
			query.runQuery { (result: QueryResult?, error: Error?) in
				XCTAssertFalse(Thread.isMainThread)
				XCTAssertNil(result); XCTAssertEqual(error as NSError?, failure)
				XCTAssertEqual(probe.requests, 0, "No samples may be converted using fallback units after a unit-read failure")
				finished.fulfill()
			}
		}
		wait(for: [authorization], timeout: 5)
		probe.deliverAuthorization()
		wait(for: [finished], timeout: 5)
		XCTAssertNil(QueryReadScope.readFailure)
	}

	func testCancellationBeforeHealthAuthorizationCompletionPreventsFetchingAndPublication() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let lock = NSLock(); var cancelled = false
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false,
			isCancelled: { lock.lock(); defer { lock.unlock() }; return cancelled })
		let probe = ReadContextHealthProbe(anchor: anchor)
		let authorization = expectation(description: "Pending authorization"), delivered = expectation(description: "Authorization callback scheduled"), stopped = expectation(description: "Cancelled callback drained")
		probe.authorizationStarted = { authorization.fulfill() }; DependencyInjector.register([probe])
		let query = StepsQueryImpl(); try configureReadContext(query, context: environment)
		var callbacks = 0
		environment.perform { query.runQuery { (result: QueryResult?, error: Error?) in callbacks += 1 } }
		wait(for: [authorization], timeout: 5)
		lock.lock(); cancelled = true; lock.unlock()
		probe.deliverAuthorization { delivered.fulfill() }
		wait(for: [delivered], timeout: 5)
		environment.perform {
			XCTAssertEqual(probe.requests, 0); XCTAssertEqual(callbacks, 0)
			query.stop(); stopped.fulfill()
		}
		wait(for: [stopped], timeout: 5)
	}

	func testReadContextIsAssignedToEveryNodeIncludingHealthSubqueries() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let root = MoodQueryImpl(), child = ActivityQueryImpl(), health = StepsQueryImpl()
		root.subQuery = (SameStartDatesSubQueryMatcher(), child)
		child.subQuery = (SameDatesSubQueryMatcher(), health)
		try configureReadContext(root, context: environment)
		XCTAssertTrue(root.readContext === environment)
		XCTAssertTrue(child.readContext === environment)
		XCTAssertTrue(health.readContext === environment)
	}

	func testUnsupportedNodeDoesNotPartiallyReplaceAnExistingReadContext() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let original = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let replacement = QueryReadContext(context: context, date: anchor.addingTimeInterval(10), convertTimeZones: true)
		let root = MoodQueryImpl(), child = ActivityQueryImpl()
		root.readContext = original; child.readContext = original
		root.subQuery = (SameDatesSubQueryMatcher(), child)
		child.subQuery = (SameDatesSubQueryMatcher(), try ReadContextUnsupportedQuery(parts: []))
		XCTAssertThrowsError(try configureReadContext(root, context: replacement))
		XCTAssertTrue(root.readContext === original); XCTAssertTrue(child.readContext === original)
	}

	func testCyclicReadTreeIsRejectedWithoutMutatingAnyNode() {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let first = MoodQueryImpl(), second = MoodQueryImpl()
		first.subQuery = (SameDatesSubQueryMatcher(), second)
		second.subQuery = (SameDatesSubQueryMatcher(), first)
		defer { first.subQuery = nil; second.subQuery = nil }
		XCTAssertThrowsError(try configureReadContext(first, context: environment))
		XCTAssertNil(first.readContext); XCTAssertNil(second.readContext)
	}

	func testReadTreeDepthLimitAcceptsThirtyTwoAndRejectsThirtyThreeAtomically() throws {
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let queries = (0..<33).map { _ in MoodQueryImpl() }
		for index in 0..<31 { queries[index].subQuery = (SameDatesSubQueryMatcher(), queries[index + 1]) }
		try configureReadContext(queries[0], context: environment)
		XCTAssertTrue(queries.prefix(32).allSatisfy { $0.readContext === environment })
		queries[31].subQuery = (SameDatesSubQueryMatcher(), queries[32])
		let other = QueryReadContext(context: context, date: anchor, convertTimeZones: true)
		XCTAssertThrowsError(try configureReadContext(queries[0], context: other))
		XCTAssertTrue(queries.prefix(32).allSatisfy { $0.readContext === environment })
		XCTAssertNil(queries[32].readContext)
	}

	func testCurrentCalendarUnitEvaluationAndPredicateUseTheCapturedRefreshDate() throws {
		let attribute = CommonSampleAttributes.timestamp
		let restriction = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: attribute, .day)
		let sample = AnySample(attributes: [attribute], attributeValues: [attribute.name: anchor])
		try QueryReadScope.with(date: anchor, convertTimeZones: false) {
			XCTAssertTrue(try restriction.samplePasses(sample))
			let predicate = try XCTUnwrap(restriction.predicate())
			XCTAssertTrue(predicate.evaluate(with: ["timestamp": anchor]))
		}
		let nextDay = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: 1, to: anchor))
		try QueryReadScope.with(date: nextDay, convertTimeZones: false) {
			XCTAssertFalse(try restriction.samplePasses(sample))
			XCTAssertFalse(try XCTUnwrap(restriction.predicate()).evaluate(with: ["timestamp": anchor]))
		}
	}

	func testPastWindowUsesCapturedInclusiveBoundariesAndExcludesFutureRecords() throws {
		let refreshDate = Date(timeIntervalSince1970: 1_700_000_000)
		let attribute = CommonSampleAttributes.timestamp
		let restriction = InThePastXTimeUnitsDateAttributeRestriction(restrictedAttribute: attribute, 5, .minute)
		try QueryReadScope.with(date: refreshDate, convertTimeZones: false) {
			let predicate = try XCTUnwrap(restriction.predicate())
			for (offset, expected) in [(-301.0, false), (-300, true), (-1, true), (0, true), (0.001, false)] {
				let date = refreshDate.addingTimeInterval(offset)
				let sample = AnySample(attributes: [attribute], attributeValues: [attribute.name: date])
				XCTAssertEqual(try restriction.samplePasses(sample), expected, "Offset \(offset)")
				XCTAssertEqual(predicate.evaluate(with: ["timestamp": date]), expected, "Offset \(offset)")
			}
		}
		QueryReadScope.with(date: refreshDate, convertTimeZones: true) {
			XCTAssertNil(restriction.predicate(), "Converted display dates must retain evaluator semantics")
		}
	}

	func testSavedTagReferencesConvertAndEvaluateWithinThePrivateSQLiteContext() throws {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		let container = NSPersistentContainer(name: "ReadContextTagTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("tags.sqlite"))
		description.shouldAddStoreAsynchronously = false; container.persistentStoreDescriptions = [description]
		var loadError: Error?; container.loadPersistentStores { _, error in loadError = error }
		if let loadError = loadError { throw loadError }
		defer {
			container.viewContext.reset()
			for store in container.persistentStoreCoordinator.persistentStores { try? container.persistentStoreCoordinator.remove(store) }
			try? FileManager.default.removeItem(at: directory)
		}
		let root = container.viewContext
		func entity(_ name: String) throws -> NSEntityDescription {
			try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: root))
		}
		let settings = SettingsImpl(entity: try entity(SettingsImpl.entityName), insertInto: root)
		let tag = Tag(entity: try entity(Tag.entityName), insertInto: root); tag.name = "Restful"
		let definition = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: root)
		definition.name = "Tagged activity"; definition.recordScreenIndex = 0
		let activity = Activity(entity: try entity(Activity.entityName), insertInto: root)
		activity.definition = definition; activity.tags = NSSet(array: [tag]); activity.setValue(anchor, forKey: "startDate")
		let other = Activity(entity: try entity(Activity.entityName), insertInto: root)
		other.definition = definition; other.setValue(anchor.addingTimeInterval(10), forKey: "startDate")
		try root.save()
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(), SamplesInjectionProvider(),
			QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			ReadContextTestProvider(database: DatabaseImpl(container), settings: settings)])
		let single = ActivityQueryImpl(), multiple = ActivityQueryImpl()
		single.expression = HasTagAttributeRestriction(restrictedAttribute: Activity.tagsAttribute, tag: tag)
		multiple.expression = HasOneOfTagAttributeRestriction(tags: [tag], restrictedAttribute: Activity.tagsAttribute)
		let dao = StoredQueriesDAOImpl()
		try dao.save(single, name: "Single tag"); try dao.save(multiple, name: "Multiple tags")
		let queryIDs = try ["Single tag", "Multiple tags"].map { try XCTUnwrap(dao.getQueryWith(name: $0)).objectID }
		let expectedID = activity.objectID
		let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		context.persistentStoreCoordinator = container.persistentStoreCoordinator
		let environment = QueryReadContext(context: context, date: anchor, convertTimeZones: false)
		let finished = expectation(description: "Private tag conversion and actual query")
		environment.perform {
			defer { context.reset(); finished.fulfill() }
			do {
				for queryID in queryIDs {
					let saved = try XCTUnwrap(context.existingObject(with: queryID) as? StoredQuery)
						for legacy in [false, true] {
							if legacy { saved.storedExpression?.setValue(nil, forKey: "tagReferencesData") }
							let query = try saved.convert()
							if let restriction = query.expression as? HasTagAttributeRestriction {
								XCTAssertTrue(restriction.tag.managedObjectContext === context)
							} else if let restriction = query.expression as? HasOneOfTagAttributeRestriction {
								XCTAssertTrue(restriction.tags.allSatisfy { $0.managedObjectContext === context })
							} else { XCTFail("Saved tag restriction did not retain its type") }
							try configureReadContext(query, context: environment)
							var callbackCount = 0
							query.runQuery { (result: QueryResult?, error: Error?) in
								callbackCount += 1; XCTAssertNil(error)
								XCTAssertEqual(result?.samples.compactMap { ($0 as? NSManagedObject)?.objectID }, [expectedID])
							}
							XCTAssertEqual(callbackCount, 1)
					}
				}
			} catch { XCTFail("Private saved-tag query failed: \(error)") }
		}
		wait(for: [finished], timeout: 5)
	}
}
