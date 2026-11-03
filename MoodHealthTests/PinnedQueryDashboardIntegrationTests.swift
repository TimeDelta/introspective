import XCTest
import CoreData
import UIKit
import HealthKit
import AttributeRestrictions
import BooleanAlgebra
import Common
import DependencyInjection
@testable import Persistence
import Queries
@testable import Samples
@testable import Settings

private final class DashboardTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<Value>(_ type: Value.Type) throws -> Value {
		if type == Database.self { return database as! Value }
		if type == Settings.self { return settings as! Value }
		throw GenericError("Unexpected dashboard test dependency")
	}
}

private final class DashboardLoaderProbe: PinnedQueryDashboardLoading {
	struct Refresh {
		let pins: [PinnedQueryReference]
		let onCard: (PinnedQueryCard) -> Void
		let completion: () -> Void
		let task: PinnedQueryDashboardTask
	}
	struct Opening {
		let pin: PinnedQueryReference
		let completion: (Result<PinnedQueryDashboardRecords, Error>) -> Void
		let task: PinnedQueryDashboardTask
	}
	var refreshes: [Refresh] = []
	var openings: [Opening] = []
	func refresh(_ pins: [PinnedQueryReference], onCard: @escaping (PinnedQueryCard) -> Void,
		completion: @escaping () -> Void) -> PinnedQueryDashboardTask {
		let task = PinnedQueryDashboardTask()
		refreshes.append(Refresh(pins: pins, onCard: onCard, completion: completion, task: task))
		return task
	}
	func openResults(_ pin: PinnedQueryReference,
		completion: @escaping (Result<PinnedQueryDashboardRecords, Error>) -> Void) -> PinnedQueryDashboardTask {
		let task = PinnedQueryDashboardTask()
		openings.append(Opening(pin: pin, completion: completion, task: task))
		return task
	}
}

private final class DashboardHealthObserverProbe: DashboardHealthObserving {
	var observedTypes: [Set<HKSampleType>] = []
	var notifications: [() -> Void] = []
	var stopCount = 0
	func observe(_ types: Set<HKSampleType>, changed: @escaping () -> Void) -> (() -> Void) {
		XCTAssertTrue(Thread.isMainThread)
		observedTypes.append(types); notifications.append(changed)
		return { [weak self] in self?.stopCount += 1 }
	}
}

private final class DashboardControlledHealthQuery: HealthKitUtil, InjectionProvider {
	let types: [Any.Type] = [HealthKitUtil.self]
	let started: XCTestExpectation
	private let lock = NSLock()
	private var completion: (([HKSample]?, Error?) -> Void)?
	init(started: XCTestExpectation) { self.started = started }
	func get<Value>(_ type: Value.Type) throws -> Value { self as! Value }
	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		XCTFail("Dashboard sample queries must not substitute aggregate Health calculations")
		callback(nil, GenericError("Unexpected Health calculation"))
	}
	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		XCTAssertTrue(type == Steps.self)
		lock.lock(); completion = callback; lock.unlock()
		started.fulfill()
		return {}
	}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? { HKUnit.count() }
	func getAuthorization(callback: @escaping (Error?) -> Void) { callback(nil) }
	func deliver(_ samples: [HKSample]) {
		lock.lock(); let callback = completion; completion = nil; lock.unlock()
		XCTAssertNotNil(callback)
		callback?(samples, nil)
	}
}

final class PinnedQueryDashboardIntegrationTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: PinnedQueryDashboardIntegrationTests.self)])!
	private let anchor = Date(timeIntervalSince1970: 1_700_000_000.123456)
	private var directory: URL!
	private var container: NSPersistentContainer!
	private var defaults: UserDefaults!
	private var suite: String!
	private var preferences: PinnedQueryPreferences!
	private let dao = StoredQueriesDAOImpl()

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "DashboardTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("dashboard.sqlite"))
		description.shouldAddStoreAsynchronously = false
		container.persistentStoreDescriptions = [description]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let error = failure { throw error }
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: context))
		let settings = SettingsImpl(entity: entity, insertInto: context)
		try context.save()
		context.automaticallyMergesChangesFromParent = true
		DependencyInjector.register([CommonInjectionProvider(), BooleanAlgebraInjectionProvider(),
			SamplesInjectionProvider(), QueriesInjectionProvider(), AttributeRestrictionsInjectionProvider(),
			DashboardTestProvider(database: DatabaseImpl(container), settings: settings)])
		suite = "dashboard-test." + UUID().uuidString
		defaults = UserDefaults(suiteName: suite)!
		preferences = PinnedQueryPreferences(defaults: defaults)
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil
		defaults.removePersistentDomain(forName: suite)
		try FileManager.default.removeItem(at: directory)
	}

	@discardableResult private func mood(_ rating: Double, at date: Date? = nil,
		minimum: Double = 0, maximum: Double = 10, note: String? = nil) throws -> MoodImpl {
		let context = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: context))
		let mood = MoodImpl(entity: entity, insertInto: context)
		mood.setValue(date ?? anchor, forKey: "timestamp")
		mood.setValue(TimeZone.current.identifier, forKey: "timestampTimeZoneId")
		mood.rating = rating; mood.minRating = minimum; mood.maxRating = maximum; mood.note = note
		mood.setSource(.introspective)
		return mood
	}

	private func save(_ query: Query = MoodQueryImpl(), name: String) throws -> (StoredQuery, PinnedQueryReference) {
		try dao.save(query, name: name)
		let stored = try XCTUnwrap(dao.getQueryWith(name: name))
		return (stored, PinnedQueryReference(id: stored.objectID.uriRepresentation().absoluteString, lastKnownName: name))
	}

	@MainActor private func refresh(_ pins: [PinnedQueryReference], clock: (() -> Date)? = nil) -> [PinnedQueryCard] {
		let finished = expectation(description: "Dashboard refresh finished")
		var cards: [PinnedQueryCard] = []
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false,
			clock: clock ?? { self.anchor })
		let task = service.refresh(pins, onCard: { card in
			XCTAssertTrue(Thread.isMainThread); cards.append(card)
		}, completion: { XCTAssertTrue(Thread.isMainThread); finished.fulfill() })
		wait(for: [finished], timeout: 5)
		withExtendedLifetime(task) {}
		return cards
	}

	private func ready(_ card: PinnedQueryCard?, file: StaticString = #file, line: UInt = #line) throws -> PinnedQuerySummary {
		guard let card = card, case let .ready(summary) = card.state else {
			XCTFail("Expected a ready card", file: file, line: line)
			throw GenericError("Missing ready dashboard summary")
		}
		return summary
	}

	@MainActor private func controller(_ pins: [PinnedQueryReference], probe: DashboardLoaderProbe) throws -> PinnedQueryDashboardViewController {
		try preferences.save(pins: pins)
		let controller = PinnedQueryDashboardViewController(style: .grouped)
		controller.preferences = preferences; controller.loader = probe
		controller.loadViewIfNeeded(); controller.viewWillAppear(false)
		controller.tableView.layoutIfNeeded()
		return controller
	}

	private func card(_ pin: PinnedQueryReference, count: Int) -> PinnedQueryCard {
		let records = (0..<count).map { _ in PinnedQuerySummaryRecord(start: anchor) }
		return PinnedQueryCard(pin: pin, sampleTypeName: "Mood", queryDescription: "All records",
			state: .ready(PinnedQuerySummary(records: records, evaluatedAt: anchor, includeRatings: false)))
	}

	@MainActor func testRefreshUsesRealSavedQueryAndOriginalRatingScales() throws {
		let first = try mood(1, minimum: -1, maximum: 3, note: "First")
		let second = try mood(20, at: anchor.addingTimeInterval(60), minimum: 10, maximum: 30)
		try container.viewContext.save()
		let (_, pin) = try save(name: "Mixed scales")
		let before = [first.objectID, second.objectID]
		let cards = refresh([pin]), summary = try ready(cards.first)
		XCTAssertEqual(cards.count, 1); XCTAssertEqual(cards[0].pin.id, pin.id)
		XCTAssertEqual(cards[0].sampleTypeName, MoodImpl.name)
		XCTAssertEqual(summary.count, 2); XCTAssertEqual(summary.validRatingCount, 2)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.5, accuracy: 1e-12)
		XCTAssertEqual(summary.earliestDate, anchor); XCTAssertEqual(summary.latestDate, anchor.addingTimeInterval(60))
		XCTAssertEqual(summary.evaluatedAt, anchor)
		XCTAssertEqual([first.objectID, second.objectID], before)
		XCTAssertEqual(first.note, "First"); XCTAssertFalse(container.viewContext.hasChanges)
	}

	@MainActor func testRenamePreservesPinnedIdentityAndUsesCurrentSavedName() throws {
		let (stored, pin) = try save(name: "Before rename")
		try dao.rename(stored, to: "After rename")
		let cards = refresh([pin])
		XCTAssertEqual(cards.count, 1)
		XCTAssertEqual(cards.first?.pin.id, pin.id)
		XCTAssertEqual(cards.first?.pin.lastKnownName, "After rename")
		XCTAssertEqual(try ready(cards.first).count, 0)
	}

	@MainActor func testDeletedQueryIsUnavailableAndNeverReboundToAnIdenticallyNamedQuery() throws {
		let (stored, pin) = try save(name: "Shared name")
		try dao.delete(stored)
		let (replacement, _) = try save(name: "Shared name")
		XCTAssertNotEqual(replacement.objectID.uriRepresentation().absoluteString, pin.id)
		let cards = refresh([pin])
		XCTAssertEqual(cards.count, 1); XCTAssertEqual(cards[0].pin, pin)
		guard case .unavailable = cards[0].state else { return XCTFail("A missing identity must not become an unrestricted or same-name query") }
	}

	@MainActor func testUnsupportedTypeAndBrokenSubqueryRemainErrorsRatherThanZeroCounts() throws {
		let (unsupported, first) = try save(name: "Unsupported")
		unsupported.sampleTypeId = Int16.max
		let outer = MoodQueryImpl(), child = MoodQueryImpl()
		outer.subQuery = (SameDatesSubQueryMatcher(), child)
		let (broken, second) = try save(outer, name: "Broken subquery")
		broken.matcherData = nil
		try container.viewContext.save()
		let cards = refresh([first, second])
		XCTAssertEqual(cards.count, 2)
		for card in cards { guard case .unavailable = card.state else { return XCTFail("Invalid definitions must be unavailable") } }
	}

	@MainActor func testEmptyResultsAreReadyWithoutInventedDatesOrRatingStatistics() throws {
		let (_, pin) = try save(name: "Empty")
		let summary = try ready(refresh([pin]).first)
		XCTAssertEqual(summary.count, 0); XCTAssertEqual(summary.validRatingCount, 0)
		XCTAssertNil(summary.meanRatingPosition); XCTAssertNil(summary.earliestDate); XCTAssertNil(summary.latestDate)
	}

	@MainActor func testRelativeDatesAreReevaluatedAtEachRefreshWithoutChangingTheSavedQuery() throws {
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: anchor).addingTimeInterval(12 * 3600)
		let tomorrow = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: today))
		_ = try mood(1, at: today); _ = try mood(2, at: tomorrow); _ = try mood(3, at: tomorrow.addingTimeInterval(1))
		try container.viewContext.save()
		let query = MoodQueryImpl()
		query.expression = InCurrentTimeUnitDateAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, .day)
		let (stored, pin) = try save(query, name: "Current day")
		let original = try stored.convert()
		XCTAssertEqual(try ready(refresh([pin], clock: { today }).first).count, 1)
		XCTAssertEqual(try ready(refresh([pin], clock: { tomorrow }).first).count, 2)
		XCTAssertTrue(try stored.convert().equalTo(original), "Refresh must not persist resolved dates over a relative query")
	}

	@MainActor func testNestedSavedQueryUsesItsRealMatchingRecords() throws {
		_ = try mood(2, at: anchor); _ = try mood(4, at: anchor.addingTimeInterval(60))
		try container.viewContext.save()
		let inner = MoodQueryImpl()
		inner.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp,
			date: anchor.addingTimeInterval(30))
		let outer = MoodQueryImpl(); outer.subQuery = (SameDatesSubQueryMatcher(), inner)
		let (_, pin) = try save(outer, name: "Nested")
		let summary = try ready(refresh([pin]).first)
		XCTAssertEqual(summary.count, 1); XCTAssertEqual(summary.earliestDate, anchor)
	}

	@MainActor func testMultipleCardsRetainPinOrderAndShareOneCapturedEvaluationDate() throws {
		let (_, first) = try save(name: "Z first"), (_, second) = try save(name: "A second")
		var clockCalls = 0
		let cards = refresh([first, second], clock: { clockCalls += 1; return self.anchor.addingTimeInterval(Double(clockCalls)) })
		XCTAssertEqual(cards.map { $0.pin.id }, [first.id, second.id])
		XCTAssertEqual(clockCalls, 1)
		XCTAssertEqual(try cards.map { try self.ready($0).evaluatedAt }, [anchor.addingTimeInterval(1), anchor.addingTimeInterval(1)])
	}

	@MainActor func testRefreshDoesNotSaveOrDiscardPendingEditsInTheMainContext() throws {
		let mood = try self.mood(2, note: "Persisted")
		try container.viewContext.save()
		let (_, pin) = try save(name: "Saved only")
		mood.rating = 9; mood.note = "Pending draft"
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: container.viewContext))
		let pending = Tag(entity: entity, insertInto: container.viewContext); pending.name = "Not yet committed"
		let summary = try ready(refresh([pin]).first)
		XCTAssertEqual(try XCTUnwrap(summary.meanRatingPosition), 0.2, accuracy: 1e-12)
		XCTAssertEqual(mood.rating, 9); XCTAssertEqual(mood.note, "Pending draft")
		XCTAssertTrue(mood.isUpdated); XCTAssertTrue(pending.isInserted); XCTAssertTrue(container.viewContext.hasChanges)
	}

	@MainActor func testOpeningResultsResolvesOnlyMatchingObjectsOnTheMainContextAndKeepsARefreshableQuery() throws {
		let first = try mood(1, at: anchor), second = try mood(7, at: anchor.addingTimeInterval(60))
		try container.viewContext.save()
		let query = MoodQueryImpl()
		query.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor.addingTimeInterval(30))
		let (_, pin) = try save(query, name: "Drill down")
		let finished = expectation(description: "Opened matching records")
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false, clock: { self.anchor })
		let task = service.openResults(pin) { result in
			XCTAssertTrue(Thread.isMainThread)
			do {
				let records = try result.get()
				let objects = records.samples.compactMap { $0 as? NSManagedObject }
				XCTAssertEqual(records.name, "Drill down"); XCTAssertEqual(records.evaluatedAt, self.anchor)
				XCTAssertEqual(objects.map { $0.objectID }, [first.objectID]); XCTAssertFalse(objects.contains { $0.objectID == second.objectID })
				XCTAssertTrue(objects.allSatisfy { $0.managedObjectContext === self.container.viewContext })
				XCTAssertNil((records.query as? ReadContextQuery)?.readContext, "Navigation must not retain a worker context")
				XCTAssertTrue(records.query.equalTo(query))
			} catch { XCTFail("Could not open query results: \(error)") }
			finished.fulfill()
		}
		wait(for: [finished], timeout: 5)
		withExtendedLifetime(task) {}
	}

	@MainActor func testCancellationSuppressesQueuedPublicationAndCompletion() throws {
		let (_, pin) = try save(name: "Cancelled")
		let unwanted = expectation(description: "Cancelled refresh must not publish")
		unwanted.isInverted = true
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false)
		let task = service.refresh([pin], onCard: { _ in unwanted.fulfill() }, completion: { unwanted.fulfill() })
		task.cancel()
		wait(for: [unwanted], timeout: 0.1)
		XCTAssertTrue(task.isCancelled)
	}

	@MainActor func testDashboardRejectsOldRefreshCallbacksAndCancelsWorkWhenHidden() throws {
		let (_, pin) = try save(name: "Visible")
		let probe = DashboardLoaderProbe(), controller = try self.controller([pin], probe: probe)
		let old = try XCTUnwrap(probe.refreshes.first)
		controller.refreshDashboard()
		XCTAssertTrue(old.task.isCancelled); XCTAssertEqual(probe.refreshes.count, 2)
		old.onCard(card(pin, count: 99))
		guard case .loading = controller.cards[0].state else { return XCTFail("An old refresh must not replace a newer loading state") }
		let latest = probe.refreshes[1]
		latest.onCard(card(pin, count: 3)); XCTAssertEqual(try ready(controller.cards.first).count, 3)
		controller.viewWillDisappear(false)
		XCTAssertTrue(latest.task.isCancelled)
		latest.onCard(card(pin, count: 88)); XCTAssertEqual(try ready(controller.cards.first).count, 3)
	}

	@MainActor func testReorderingAndUnpinningNeverDeleteSavedQueriesOrRecords() throws {
		_ = try mood(3); try container.viewContext.save()
		let (_, first) = try save(name: "First"), (_, second) = try save(name: "Second")
		let probe = DashboardLoaderProbe(), controller = try self.controller([first, second], probe: probe)
		controller.setEditing(true, animated: false)
		controller.tableView(controller.tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0))
		XCTAssertEqual(try preferences.pins().map { $0.id }, [second.id, first.id])
		XCTAssertEqual(controller.cards.map { $0.pin.id }, [second.id, first.id])
		controller.tableView(controller.tableView, commit: .delete, forRowAt: IndexPath(row: 1, section: 0))
		XCTAssertEqual(try preferences.pins().map { $0.id }, [second.id])
		XCTAssertEqual(try dao.getAllQueries().count, 2)
		XCTAssertEqual(try container.viewContext.count(for: MoodImpl.fetchRequest()), 1)
		controller.viewWillDisappear(false)
	}

	@MainActor func testDashboardNavigationUsesTheSelectedPinAndTheExactOpenedRecords() throws {
		let mood = try self.mood(7); try container.viewContext.save()
		let (stored, pin) = try save(name: "Selected")
		let probe = DashboardLoaderProbe(), controller = try self.controller([pin], probe: probe)
		let row = IndexPath(row: 0, section: 0)
		XCTAssertNil(controller.tableView(controller.tableView, willSelectRowAt: row))
		probe.refreshes[0].onCard(card(pin, count: 1))
		XCTAssertEqual(controller.tableView(controller.tableView, willSelectRowAt: row), row)
		var opened: PinnedQueryDashboardRecords?
		controller.showRecords = { opened = $0 }
		controller.tableView(controller.tableView, didSelectRowAt: row)
		XCTAssertEqual(probe.openings.count, 1); XCTAssertEqual(probe.openings[0].pin.id, pin.id)
		let records = PinnedQueryDashboardRecords(name: stored.name, query: try stored.convert(), samples: [mood], evaluatedAt: anchor)
		probe.openings[0].completion(.success(records))
		XCTAssertEqual(opened?.samples.compactMap { ($0 as? NSManagedObject)?.objectID }, [mood.objectID])
		XCTAssertTrue(opened?.query === records.query)
		controller.viewWillDisappear(false)
	}

	@MainActor func testDashboardObserversAndOutstandingCallbacksDoNotRetainTheScreen() throws {
		let (_, pin) = try save(name: "Released")
		let probe = DashboardLoaderProbe()
		weak var released: PinnedQueryDashboardViewController?
		try autoreleasepool {
			let controller = try self.controller([pin], probe: probe)
			released = controller
			controller.viewWillDisappear(false)
		}
		XCTAssertNil(released)
		XCTAssertTrue(try XCTUnwrap(probe.refreshes.first).task.isCancelled)
		probe.refreshes[0].onCard(card(pin, count: 100)); probe.refreshes[0].completion()
		XCTAssertNil(released)
	}

	@MainActor func testDefinitionSnapshotAllowsRenameButDetectsEditsToExistingRootRestrictionNodes() throws {
		let query = MoodQueryImpl()
		query.expression = AndExpression(
			AfterDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor.addingTimeInterval(-60)),
			BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor.addingTimeInterval(60)))
		let (stored, pin) = try save(query, name: "Before")
		let original = try DashboardDefinitionSnapshot.capture(stored)
		try dao.rename(stored, to: "After")
		XCTAssertEqual(stored.objectID.uriRepresentation().absoluteString, pin.id)
		XCTAssertEqual(try DashboardDefinitionSnapshot.capture(stored), original, "A display-name edit must preserve the evaluated definition")
		let expression = try XCTUnwrap(stored.storedExpression)
		let restriction = try XCTUnwrap(expression.value(forKey: "storedExpression1") as? NSManagedObject)
		let restrictionID = restriction.objectID
		let originalDate = try XCTUnwrap(restriction.value(forKey: "value") as? Date)
		restriction.setValue(originalDate.addingTimeInterval(1), forKey: "value")
		try container.viewContext.save()
		XCTAssertEqual(restriction.objectID, restrictionID)
		XCTAssertNotEqual(try DashboardDefinitionSnapshot.capture(stored), original,
			"An in-place parameter edit must invalidate old matching records even when all node identities remain unchanged")
		restriction.setValue(originalDate, forKey: "value"); try container.viewContext.save()
		XCTAssertEqual(try DashboardDefinitionSnapshot.capture(stored), original)
	}

	@MainActor func testDefinitionSnapshotIncludesNestedQueryFlagsRestrictionValuesAndMatcherData() throws {
		let inner = MoodQueryImpl()
		inner.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.timestamp, date: anchor)
		let outer = MoodQueryImpl(); outer.subQuery = (WithinXCalendarUnitsSubQueryMatcher(numberOfTimeUnits: 5, timeUnit: .minute), inner)
		let (stored, _) = try save(outer, name: "Nested definition")
		let original = try DashboardDefinitionSnapshot.capture(stored)
		let child = try XCTUnwrap(stored.storedSubQuery)
		child.name = "Only a nested label"
		XCTAssertEqual(try DashboardDefinitionSnapshot.capture(stored), original)
		child.mostRecentEntryOnly = true
		XCTAssertNotEqual(try DashboardDefinitionSnapshot.capture(stored), original)
		child.mostRecentEntryOnly = false
		let restriction = try XCTUnwrap(child.storedExpression)
		restriction.setValue(anchor.addingTimeInterval(1), forKey: "value")
		XCTAssertNotEqual(try DashboardDefinitionSnapshot.capture(stored), original)
		restriction.setValue(anchor, forKey: "value")
		let matcher = try XCTUnwrap(stored.matcherData)
		stored.matcherData = matcher + Data([0])
		XCTAssertNotEqual(try DashboardDefinitionSnapshot.capture(stored), original)
		stored.matcherData = matcher
		XCTAssertEqual(try DashboardDefinitionSnapshot.capture(stored), original)
	}

	@MainActor func testDefinitionSnapshotRejectsCyclicStoredExpressionsBeforeConversion() throws {
		let (stored, _) = try save(name: "Cyclic expression")
		let group = NSEntityDescription.insertNewObject(forEntityName: "BooleanExpressionGroup", into: container.viewContext)
		let expression = try XCTUnwrap(group as? StoredBooleanExpression)
		stored.storedExpression = expression
		group.setValue(group, forKey: "storedSubExpression")
		XCTAssertThrowsError(try DashboardDefinitionSnapshot.capture(stored))
		// Break the malformed fixture's self-reference before releasing its context.
		group.setValue(nil, forKey: "storedSubExpression"); stored.storedExpression = nil
		container.viewContext.delete(group)
	}

	@MainActor func testHealthObservationDeduplicatesRootAndNestedTypesPublishesOnMainAndStopsOnCancellation() throws {
		let (_, corePin) = try save(name: "Core Data only")
		let observer = DashboardHealthObserverProbe()
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false, healthObserver: observer)
		let coreTask = service.observeHealthChanges([corePin]) { XCTFail("A Core Data-only dashboard must not subscribe to Health") }
		XCTAssertTrue(observer.observedTypes.isEmpty)
		coreTask.cancel(); XCTAssertEqual(observer.stopCount, 0)

		let (_, stepsPin) = try save(StepsQueryImpl(), name: "Steps")
		let nestedSteps = StepsQueryImpl(); nestedSteps.subQuery = (SameDatesSubQueryMatcher(), SleepQueryImpl())
		let outer = MoodQueryImpl(); outer.subQuery = (SameDatesSubQueryMatcher(), nestedSteps)
		let (_, nestedPin) = try save(outer, name: "Moods near steps and sleep")
		let changed = expectation(description: "Health event reaches main")
		let unwanted = expectation(description: "Cancelled Health events remain suppressed"); unwanted.isInverted = true
		var cancelled = false
		let task = service.observeHealthChanges([corePin, stepsPin, nestedPin]) {
			XCTAssertTrue(Thread.isMainThread)
			if cancelled { unwanted.fulfill() } else { changed.fulfill() }
		}
		XCTAssertEqual(observer.observedTypes, [Set([Steps.sampleType, Sleep.sampleType])])
		let notify = try XCTUnwrap(observer.notifications.first)
		DispatchQueue.global(qos: .userInitiated).async(execute: notify)
		wait(for: [changed], timeout: 5)
		cancelled = true; task.cancel()
		XCTAssertEqual(observer.stopCount, 1)
		DispatchQueue.global(qos: .userInitiated).async(execute: notify)
		wait(for: [unwanted], timeout: 0.1)
		task.cancel(); XCTAssertEqual(observer.stopCount, 1, "Repeated cancellation must not stop the same observation twice")
	}

	@MainActor func testOpeningResultsRejectsAQueryEditedWhileItsHealthReadWasInFlight() throws {
		let (stored, pin) = try save(StepsQueryImpl(), name: "Edited during read")
		let started = expectation(description: "Original saved query is waiting for Health results")
		let health = DashboardControlledHealthQuery(started: started)
		DependencyInjector.register([health])
		let finished = expectation(description: "Opening rejects mismatched query definition")
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false, clock: { self.anchor })
		let task = service.openResults(pin) { result in
			XCTAssertTrue(Thread.isMainThread)
			switch result {
			case .success: XCTFail("Rows from an old query definition must not open with a newly edited query")
			case let .failure(error): XCTAssertTrue(error.localizedDescription.localizedCaseInsensitiveContains("changed"))
			}
			finished.fulfill()
		}
		wait(for: [started], timeout: 5)
		let changed = StepsQueryImpl()
		changed.expression = BeforeDateAndTimeAttributeRestriction(restrictedAttribute: CommonSampleAttributes.healthKitStartDate,
			date: anchor.addingTimeInterval(-60))
		try dao.update(stored, with: changed)
		XCTAssertNotNil(try XCTUnwrap(dao.getQueryWith(name: stored.name)).storedExpression)
		let sample = HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: .count(), doubleValue: 12),
			start: anchor, end: anchor.addingTimeInterval(10))
		health.deliver([sample])
		wait(for: [finished], timeout: 5)
		withExtendedLifetime(task) {}
	}

	@MainActor func testSerializedCardsKeepOneStoreGenerationAcrossInterveningSavesAndContextResets() throws {
		_ = try mood(2); try container.viewContext.save()
		let (_, stepsPin) = try save(StepsQueryImpl(), name: "First: paused Health query")
		let (_, moodPin) = try save(name: "Second: persisted moods")
		let started = expectation(description: "First card has pinned its generation and is awaiting Health")
		let health = DashboardControlledHealthQuery(started: started)
		DependencyInjector.register([health])
		let finished = expectation(description: "Both cards evaluated against the original generation")
		var cards: [PinnedQueryCard] = []
		let service = PinnedQueryDashboardService(context: container.viewContext, convertTimeZones: false, clock: { self.anchor })
		let task = service.refresh([stepsPin, moodPin], onCard: { card in
			XCTAssertTrue(Thread.isMainThread); cards.append(card)
		}, completion: { finished.fulfill() })
		wait(for: [started], timeout: 5)
		_ = try mood(8, at: anchor.addingTimeInterval(60)); try container.viewContext.save()
		let sample = HKQuantitySample(type: Steps.quantityType, quantity: HKQuantity(unit: .count(), doubleValue: 12),
			start: anchor, end: anchor.addingTimeInterval(10))
		health.deliver([sample])
		wait(for: [finished], timeout: 5)
		XCTAssertEqual(cards.map { $0.pin.id }, [stepsPin.id, moodPin.id])
		let snapshot = try ready(cards.first { $0.pin.id == moodPin.id })
		XCTAssertEqual(snapshot.count, 1,
			"Resetting between serialized cards must not silently advance to a later database generation")
		XCTAssertEqual(try XCTUnwrap(snapshot.meanRatingPosition), 0.2, accuracy: 1e-12)
		let fresh = try ready(refresh([moodPin]).first)
		XCTAssertEqual(fresh.count, 2, "A subsequent refresh must include the newly saved record")
		XCTAssertEqual(try XCTUnwrap(fresh.meanRatingPosition), 0.5, accuracy: 1e-12)
		withExtendedLifetime(task) {}
	}
}
