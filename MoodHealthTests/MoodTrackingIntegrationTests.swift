import XCTest
import CoreData
import UIKit
import UserNotifications
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class TrackingTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	init(_ database: Database, _ settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { return database as! T }
		return settings as! T
	}
}

private final class TrackingDisplayShift: CoreDataSampleUtil, InjectionProvider {
	let types: [Any.Type] = [CoreDataSampleUtil.self]
	func get<T>(_ type: T.Type) throws -> T { self as! T }
	func convertTimeZoneIfApplicable(for date: Date, timeZoneId: String?) -> Date { date.addingTimeInterval(2 * 86400) }
}

private final class TrackingFailingWriteContext: NSManagedObjectContext {
	private(set) var saveAttempts = 0
	override func save() throws {
		saveAttempts += 1
		throw NSError(domain: "PresetWriteProbe", code: 1)
	}
}

private final class ReminderDeliveryProbe: MoodReminderDelivery {
	private let lock = NSLock()
	private var requests: [String: UNNotificationRequest] = [:]
	var beforeAdd: ((UNNotificationRequest, @escaping (Error?) -> Void) -> Void)?
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) { lock.lock(); let value = Array(requests.values); lock.unlock(); completion(value) }
	func remove(_ identifiers: [String]) { lock.lock(); for id in identifiers { requests.removeValue(forKey: id) }; lock.unlock() }
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) {
		let finish: (Error?) -> Void = { error in
			if error == nil { self.lock.lock(); self.requests[request.identifier] = request; self.lock.unlock() }
			completion(error)
		}
		if let beforeAdd = beforeAdd { beforeAdd(request, finish) } else { finish(nil) }
	}
	func snapshot() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(requests.values) }
}

final class MoodTrackingIntegrationTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: MoodTrackingIntegrationTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var defaults: UserDefaults!
	private var suite: String!
	private var preferences: MoodTrackingPreferences!
	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = try open()
		suite = UUID().uuidString; defaults = UserDefaults(suiteName: suite)!
		preferences = MoodTrackingPreferences(defaults: defaults)
		try register()
	}
	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil; defaults.removePersistentDomain(forName: suite)
		try FileManager.default.removeItem(at: directory)
	}
	private func open() throws -> NSPersistentContainer {
		let value = NSPersistentContainer(name: "MoodTrackingTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("tracking.sqlite")); description.shouldAddStoreAsynchronously = false
		value.persistentStoreDescriptions = [description]
		var error: Error?; value.loadPersistentStores { _, failure in error = failure }; if let error = error { throw error }
		value.viewContext.automaticallyMergesChangesFromParent = true
		return value
	}
	private func register() throws {
		let settings: SettingsImpl
		if let existing = try container.viewContext.fetch(SettingsImpl.fetchRequest()).first { settings = existing }
		else {
			let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: SettingsImpl.entityName, in: container.viewContext))
			settings = SettingsImpl(entity: entity, insertInto: container.viewContext); try container.viewContext.save()
		}
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider(), TrackingTestProvider(DatabaseImpl(container), settings)])
	}
	private func storedCount(_ entityName: String) throws -> Int {
		let reader = try open()
		defer { for store in reader.persistentStoreCoordinator.persistentStores { try? reader.persistentStoreCoordinator.remove(store) } }
		return try reader.viewContext.count(for: NSFetchRequest<NSFetchRequestResult>(entityName: entityName))
	}
	private func storedTagNames() throws -> [String] {
		let reader = try open()
		defer { for store in reader.persistentStoreCoordinator.persistentStores { try? reader.persistentStoreCoordinator.remove(store) } }
		return try reader.viewContext.fetch(Tag.fetchRequest()).map { $0.name }.sorted()
	}
	private func tag(_ name: String) throws -> Tag {
		let root = container.viewContext
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Tag.entityName, in: root))
		let tag = Tag(entity: entity, insertInto: root); tag.name = name
		return tag
	}
	func testPresetRecordsSavedScaleFullTimestampAndContextsAcrossSQLiteReopen() throws {
		let at = Date(timeIntervalSince1970: 1_700_000_000.123456)
		let preset = MoodCheckInPreset(name: "Travel", rating: -0.25, minimum: -1, maximum: 1, note: "At the airport", contexts: [ContextCategory.travel.rawValue, ContextCategory.routine.rawValue])
		let created = try MoodPresetRecorder.record(preset, at: at)
		XCTAssertEqual(created.rating, -0.25); XCTAssertEqual(MoodWeeklyReview.timestamp(for: created), at)
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = try open(); try register()
		let moods = try container.viewContext.fetch(MoodImpl.fetchRequest()), contexts = try container.viewContext.fetch(MetricContextEntry.fetchRequest())
		XCTAssertEqual(moods.count, 1); XCTAssertEqual(moods[0].originalTimestamp, at)
		XCTAssertEqual(moods[0].minRating, -1); XCTAssertEqual(moods[0].maxRating, 1); XCTAssertEqual(moods[0].note, preset.note)
		XCTAssertEqual(moods[0].getSource(), .introspective)
		XCTAssertEqual(Set(contexts.map { $0.category }), Set(preset.contexts))
		XCTAssertTrue(contexts.allSatisfy { $0.timestamp == at && $0.metric == .mood && $0.endDate == nil })
	}
	func testUnsupportedContextCannotLeaveAPartialMood() throws {
		let preset = MoodCheckInPreset(name: "Invalid", rating: 0.5, minimum: 0, maximum: 1, contexts: ["Unknown future category"])
		XCTAssertThrowsError(try MoodPresetRecorder.record(preset))
		XCTAssertEqual(try container.viewContext.count(for: MoodImpl.fetchRequest()), 0)
		XCTAssertEqual(try container.viewContext.count(for: MetricContextEntry.fetchRequest()), 0)
	}
	func testFailedPresetWriterCannotPersistAfterALaterUnrelatedParentSave() throws {
		let root = container.viewContext
		let unrelated = try tag("Original tag"); try root.save()
		unrelated.name = "Pending tag edit"
		let writer = TrackingFailingWriteContext(concurrencyType: .mainQueueConcurrencyType)
		let preset = MoodCheckInPreset(name: "Failed", rating: 0.5, minimum: 0, maximum: 1,
			note: "Must not persist", contexts: [ContextCategory.travel.rawValue])
		XCTAssertThrowsError(try MoodPresetRecorder.record(preset, at: Date(), contextFactory: { writer })) { error in
			XCTAssertEqual((error as NSError).domain, "PresetWriteProbe")
		}
		XCTAssertEqual(writer.saveAttempts, 1); XCTAssertFalse(writer.hasChanges)
		XCTAssertTrue(unrelated.isUpdated); XCTAssertEqual(unrelated.name, "Pending tag edit")
		XCTAssertEqual(try storedTagNames(), ["Original tag"], "A failed preset must not save unrelated pending edits")
		XCTAssertEqual(try storedCount(MoodImpl.entityName), 0)
		XCTAssertEqual(try storedCount(MetricContextEntry.entityName), 0)
		try root.save()
		XCTAssertEqual(try storedTagNames(), ["Pending tag edit"])
		XCTAssertEqual(try storedCount(MoodImpl.entityName), 0, "A later root save must not resurrect a failed preset")
		XCTAssertEqual(try storedCount(MetricContextEntry.entityName), 0)
	}
	func testSuccessfulPresetDoesNotCommitUnrelatedPendingParentEdits() throws {
		let root = container.viewContext
		let unrelated = try tag("Not yet saved")
		let at = Date(timeIntervalSince1970: 1_700_000_000.123456)
		let preset = MoodCheckInPreset(name: "Independent", rating: -0.25, minimum: -1, maximum: 1,
			note: "Saved separately", contexts: [ContextCategory.travel.rawValue, ContextCategory.routine.rawValue])
		let saved = try MoodPresetRecorder.record(preset, at: at)
		let object = try XCTUnwrap(saved as? MoodImpl)
		XCTAssertTrue(object.managedObjectContext === root)
		XCTAssertFalse(object.objectID.isTemporaryID)
		XCTAssertEqual(object.originalTimestamp, at); XCTAssertEqual(object.note, preset.note)
		XCTAssertEqual(object.rating, -0.25); XCTAssertEqual(object.minRating, -1); XCTAssertEqual(object.maxRating, 1)
		XCTAssertTrue(unrelated.isInserted); XCTAssertTrue(root.hasChanges)
		XCTAssertEqual(try storedTagNames(), [], "A successful preset must not commit an unrelated pending insertion")
		XCTAssertEqual(try storedCount(MoodImpl.entityName), 1)
		XCTAssertEqual(try storedCount(MetricContextEntry.entityName), 2)
		try root.save()
		XCTAssertEqual(try storedTagNames(), ["Not yet saved"])
		XCTAssertEqual(try storedCount(MoodImpl.entityName), 1, "Saving unrelated edits must not duplicate the preset")
	}
	func testWeeklyAnalyticsAreAnImmutableSnapshotOfRealPersistedMoods() throws {
		let now = Date(), date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
		let mood = try MoodPresetRecorder.record(MoodCheckInPreset(name: "Scale", rating: 5, minimum: 0, maximum: 10), at: date)
		let summary = MoodWeeklyReview(moods: [mood], endingOn: now)
		if let object = mood as? MoodImpl { object.rating = 10; try container.viewContext.save() }
		XCTAssertEqual(summary.current.averagePosition, 0.5)
		XCTAssertEqual(MoodWeeklyReview(moods: [mood], endingOn: now).current.averagePosition, 1)
	}
	func testWeeklyBoundariesUseStoredInstantsEvenWhenLegacyDisplayTimeIsShifted() throws {
		let now = Date(), date = Calendar.current.startOfDay(for: now).addingTimeInterval(-1)
		let mood = try MoodPresetRecorder.record(MoodCheckInPreset(name: "Boundary", rating: 0.8, minimum: 0, maximum: 1), at: date)
		DependencyInjector.register([TrackingDisplayShift()])
		XCTAssertGreaterThan(mood.date, now)
		let result = MoodWeeklyReview(moods: [mood], endingOn: now)
		XCTAssertEqual(result.current.checkInCount, 1); XCTAssertEqual(result.current.averagePosition, 0.8)
		XCTAssertEqual(MoodWeeklyReview.timestamp(for: mood), date)
	}
	func testMoodContextOverlayIncludesSpanningAndAllMetricEntriesButExcludesOtherMetricsAndEndBoundary() throws {
		let end = Date(), start = end.addingTimeInterval(-3600), interval = DateInterval(start: start, end: end)
		let spanning = try MetricContextEntry.record(category: .illness, metric: .mood, at: start.addingTimeInterval(-3600), until: start.addingTimeInterval(1))
		let all = try MetricContextEntry.record(category: .travel, metric: .all, at: start)
		_ = try MetricContextEntry.record(category: .exercise, metric: .steps, at: start)
		_ = try MetricContextEntry.record(category: .other, metric: .mood, at: end)
		_ = try MetricContextEntry.record(category: .device, metric: .mood, at: start.addingTimeInterval(-3600), until: start)
		let loaded = try container.viewContext.fetch(MetricContextEntry.request(metric: .mood, interval: interval))
		XCTAssertEqual(Set(loaded.map { $0.objectID }), Set([spanning.objectID, all.objectID]))
	}
	func testReminderReplacementPreservesOtherNotificationsAndUsesGenericContent() throws {
		let delivery = ReminderDeliveryProbe()
		let unrelated = UNNotificationRequest(identifier: "finished-import", content: UNMutableNotificationContent(), trigger: nil)
		delivery.add(unrelated) { _ in }
		let subject = MoodReminderScheduler(delivery: delivery), first = expectation(description: "First plan"), disabled = expectation(description: "Disabled plan")
		subject.replace(dates: [Date().addingTimeInterval(3600)]) { error in XCTAssertNil(error); first.fulfill() }
		wait(for: [first], timeout: 5)
		let request = try XCTUnwrap(delivery.snapshot().first { $0.identifier.hasPrefix(MoodReminderScheduler.identifierPrefix) })
		XCTAssertEqual(request.content.title, "Check-in reminder"); XCTAssertEqual(request.content.body, "Take a moment to check in.")
		XCTAssertTrue(request.content.userInfo.isEmpty); XCTAssertFalse(try XCTUnwrap(request.trigger as? UNCalendarNotificationTrigger).repeats)
		subject.replace(dates: []) { error in XCTAssertNil(error); disabled.fulfill() }
		wait(for: [disabled], timeout: 5)
		XCTAssertEqual(delivery.snapshot().map { $0.identifier }, [unrelated.identifier])
	}
	func testNewReminderPlanWaitsForOldDeliveryThenReplacesIt() throws {
		let delivery = ReminderDeliveryProbe()
		let started = expectation(description: "Old request in flight"), completed = expectation(description: "Newest plan complete")
		let lock = NSLock(); var finish: ((Error?) -> Void)?
		delivery.beforeAdd = { _, completion in lock.lock(); finish = completion; lock.unlock(); started.fulfill() }
		let subject = MoodReminderScheduler(delivery: delivery)
		subject.replace(dates: [Date().addingTimeInterval(3600)])
		wait(for: [started], timeout: 5)
		subject.replace(dates: []) { error in XCTAssertNil(error); completed.fulfill() }
		lock.lock(); let callback = finish; lock.unlock(); callback?(nil)
		wait(for: [completed], timeout: 5)
		XCTAssertTrue(delivery.snapshot().isEmpty)
	}
	func testActualPresetSaveSuppressesTodayAndDeletionRestoresItsReminder() throws {
		let calendar = Calendar.current
		let now = try XCTUnwrap(calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date()))
		var settings = MoodReminderSettings(); settings.enabled = true; settings.times = [18 * 60]
		try preferences.save(reminders: settings)
		let delivery = ReminderDeliveryProbe(), scheduler = MoodReminderScheduler(delivery: delivery)
		func refresh(_ count: Int) {
			let done = expectation(description: "Plan with \(count) reminders")
			MoodReminderService.refresh(now: now, preferences: preferences, scheduler: scheduler) { error in XCTAssertNil(error); done.fulfill() }
			wait(for: [done], timeout: 5); XCTAssertEqual(delivery.snapshot().count, count)
		}
		refresh(14)
		let saved = try MoodPresetRecorder.record(MoodCheckInPreset(name: "Today", rating: 1, minimum: 0, maximum: 2), at: now)
		refresh(13)
		container.viewContext.delete(try XCTUnwrap(saved as? MoodImpl)); try container.viewContext.save()
		refresh(14)
	}
	func testNotificationDeliveryFailureIsReportedAndDoesNotBlockLaterReplacement() {
		let delivery = ReminderDeliveryProbe(), scheduler = MoodReminderScheduler(delivery: delivery)
		delivery.beforeAdd = { _, completion in completion(NSError(domain: "ReminderProbe", code: 1)) }
		let failed = expectation(description: "Delivery failure"), recovered = expectation(description: "Later replacement")
		scheduler.replace(dates: [Date().addingTimeInterval(3600)]) { error in XCTAssertEqual((error as NSError?)?.domain, "ReminderProbe"); failed.fulfill() }
		wait(for: [failed], timeout: 5)
		scheduler.replace(dates: []) { error in XCTAssertNil(error); recovered.fulfill() }
		wait(for: [recovered], timeout: 5)
		XCTAssertTrue(delivery.snapshot().isEmpty)
	}
	@MainActor func testWeeklyReviewScreenExposesCoverageDistributionsDailyBreakdownAndContext() {
		let controller = MoodWeeklyReviewViewController(style: .grouped)
		controller.loadViewIfNeeded(); controller.viewWillAppear(false)
		XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 6)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 5)
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 3), 7)
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 0)?.contains("equal weight") == true)
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 2)?.contains("not zero") == true)
		XCTAssertEqual(controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 1, section: 5)).textLabel?.text, "Review or add mood context")
	}
	@MainActor func testPresetListRecordsAndDeletesTheVisiblePreset() throws {
		let preset = MoodCheckInPreset(name: "A", rating: 0.5, minimum: 0, maximum: 1)
		try preferences.save(presets: [preset])
		let controller = MoodPresetsViewController(style: .grouped); controller.preferences = preferences
		controller.reminderScheduler = MoodReminderScheduler(delivery: ReminderDeliveryProbe())
		controller.loadViewIfNeeded(); controller.viewWillAppear(false)
		controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		XCTAssertEqual(try container.viewContext.fetch(MoodImpl.fetchRequest()).map { $0.rating }, [0.5])
		controller.tableView(controller.tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
		XCTAssertTrue(try preferences.presets().isEmpty)
		XCTAssertEqual(try container.viewContext.count(for: MoodImpl.fetchRequest()), 1, "Deleting a preset retains recorded data")
	}
	@MainActor func testWeeklyReviewNotificationsAndInFlightCalculationDoNotRetainTheScreen() {
		weak var released: MoodWeeklyReviewViewController?
		let started = expectation(description: "Review calculation started"), finished = expectation(description: "Detached calculation finished")
		let release = DispatchSemaphore(value: 0)
		autoreleasepool {
			let controller = MoodWeeklyReviewViewController(style: .grouped)
			controller.analyticsCalculation = { entries, now, includingToday, calendar in
				started.fulfill(); XCTAssertEqual(release.wait(timeout: .now() + 5), .success)
				defer { finished.fulfill() }
				return MoodWeekComparison(observations: entries, endingOn: now, includingToday: includingToday, calendar: calendar)
			}
			controller.loadViewIfNeeded(); controller.viewWillAppear(false)
			wait(for: [started], timeout: 5); controller.viewWillDisappear(false); released = controller
		}
		XCTAssertNil(released)
		release.signal(); wait(for: [finished], timeout: 5)
	}
}
