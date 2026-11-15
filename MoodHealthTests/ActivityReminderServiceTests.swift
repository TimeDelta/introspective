import XCTest
import CoreData
import UserNotifications
import Darwin
import Common
import DependencyInjection
@testable import Persistence
@testable import Samples
import Settings

private final class ActivityReminderServiceTestProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self, Settings.self]
	let database: Database
	let settings: Settings
	private(set) var databaseReads = 0
	init(database: Database, settings: Settings) { self.database = database; self.settings = settings }
	func get<T>(_ type: T.Type) throws -> T {
		if type == Database.self { databaseReads += 1; return database as! T }
		if type == Settings.self { return settings as! T }
		throw GenericError("Unexpected activity reminder dependency")
	}
}

private final class ActivityReminderServiceDelivery: ActivityReminderDelivery {
	private let lock = NSLock()
	private var requests: [String: UNNotificationRequest] = [:]
	private var notifications: [String: UNNotificationRequest] = [:]
	var failAdd = false
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) { completion(pendingRequests()) }
	func delivered(_ completion: @escaping ([UNNotificationRequest]) -> Void) { completion(deliveredRequests()) }
	func remove(_ identifiers: [String]) {
		lock.lock(); defer { lock.unlock() }; for id in identifiers { requests.removeValue(forKey: id) }
	}
	func removeDelivered(_ identifiers: [String]) {
		lock.lock(); defer { lock.unlock() }; for id in identifiers { notifications.removeValue(forKey: id) }
	}
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) {
		if failAdd { completion(NSError(domain: "ActivityReminderServiceTests", code: 1)); return }
		lock.lock(); requests[request.identifier] = request; lock.unlock(); completion(nil)
	}
	func pendingRequests() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(requests.values) }
	func deliveredRequests() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(notifications.values) }
	func seed(_ request: UNNotificationRequest, delivered: Bool = false) {
		lock.lock(); defer { lock.unlock() }
		if delivered { notifications[request.identifier] = request } else { requests[request.identifier] = request }
	}
}

final class ActivityReminderServiceTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: ActivityReminderServiceTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var settings: SettingsImpl!
	private var provider: ActivityReminderServiceTestProvider!
	private var preferences: ActivityReminderPreferences!
	private var suite: String!
	private var delivery: ActivityReminderServiceDelivery!
	private var scheduler: ActivityReminderScheduler!
	private let now = Date(timeIntervalSince1970: 1_720_915_223.875)
	private struct StoredActivity {
		let id: String
		let start: Date
		let end: Date?
		let endSetAt: Date?
		let note: String?
	}

	override func setUpWithError() throws {
		_ = CommonInjectionProvider()
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "ActivityReminderServiceTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("reminders.sqlite"))
		description.shouldAddStoreAsynchronously = false; container.persistentStoreDescriptions = [description]
		var failure: Error?
		container.loadPersistentStores { _, error in failure = error }
		if let failure = failure { throw failure }
		container.viewContext.automaticallyMergesChangesFromParent = true
		settings = SettingsImpl(entity: try entity(SettingsImpl.entityName), insertInto: container.viewContext)
		try container.viewContext.save(); settings.setAutoIgnoreEnabled(false)
		provider = ActivityReminderServiceTestProvider(database: DatabaseImpl(container), settings: settings)
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider(), provider])
		suite = "ActivityReminderServiceTests.\(UUID().uuidString)"
		preferences = ActivityReminderPreferences(defaults: UserDefaults(suiteName: suite)!)
		var enabled = ActivityReminderSettings(); enabled.enabled = true
		try preferences.save(settings: enabled)
		delivery = ActivityReminderServiceDelivery(); scheduler = ActivityReminderScheduler(delivery: delivery)
	}

	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil; settings = nil; provider = nil
		try FileManager.default.removeItem(at: directory)
		UserDefaults(suiteName: suite)?.removePersistentDomain(forName: suite)
		preferences = nil; delivery = nil; scheduler = nil
	}

	private func entity(_ name: String) throws -> NSEntityDescription {
		try XCTUnwrap(NSEntityDescription.entity(forEntityName: name, in: container.viewContext))
	}
	private func id(_ object: NSManagedObject) -> String { object.objectID.uriRepresentation().absoluteString }
	private func definition(_ name: String, autoNote: Bool = false) throws -> ActivityDefinition {
		let value = ActivityDefinition(entity: try entity(ActivityDefinition.entityName), insertInto: container.viewContext)
		value.name = name; value.autoNote = autoNote; value.setSource(.introspective)
		try container.viewContext.save(); return value
	}
	private func activity(_ definition: ActivityDefinition, start: Date, end: Date? = nil, note: String? = nil) throws -> Activity {
		let value = Activity(entity: try entity(Activity.entityName), insertInto: container.viewContext)
		value.definition = definition; value.setSource(.introspective); value.start = start; value.startSetAt = start
		value.end = end; value.endSetAt = end; value.note = note
		try container.viewContext.save(); return value
	}
	private func stored() throws -> [StoredActivity] {
		let reader = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		reader.persistentStoreCoordinator = container.persistentStoreCoordinator
		defer { reader.reset() }
		return try reader.fetch(Activity.fetchRequest()).map {
			StoredActivity(id: id($0), start: $0.value(forKey: "startDate") as! Date,
				end: $0.value(forKey: "endDate") as? Date,
				endSetAt: $0.value(forKey: "endDateSetAt") as? Date, note: $0.note)
		}
	}
	private func refresh(at date: Date? = nil, fromWorker: Bool = false) throws {
		let completed = expectation(description: "Reminder reconciliation")
		var failure: Error?
		let work = {
			ActivityReminderService.refresh(now: date ?? self.now, preferences: self.preferences, scheduler: self.scheduler) {
				XCTAssertTrue(Thread.isMainThread); failure = $0; completed.fulfill()
			}
		}
		if fromWorker { DispatchQueue.global().async(execute: work) } else { work() }
		wait(for: [completed], timeout: 5)
		if let failure = failure { throw failure }
	}
	private func action(_ action: String, id: String?, at date: Date? = nil, fromWorker: Bool = false) throws -> ActivityReminderActionResult {
		let completed = expectation(description: "Reminder action")
		var response: Result<ActivityReminderActionResult, Error>?
		let work = {
			ActivityReminderService.handleResponse(actionIdentifier: action,
				userInfo: id.map { [ActivityReminderService.activityIDUserInfoKey: $0] } ?? [:],
				now: date ?? self.now, preferences: self.preferences, scheduler: self.scheduler) {
					XCTAssertTrue(Thread.isMainThread); response = $0; completed.fulfill()
				}
		}
		if fromWorker { DispatchQueue.global().async(execute: work) } else { work() }
		wait(for: [completed], timeout: 5)
		return try XCTUnwrap(response).get()
	}
	private func reminderID(_ request: UNNotificationRequest) -> String? {
		request.content.userInfo[ActivityReminderService.activityIDUserInfoKey] as? String
	}
	private func request(_ activityID: String) throws -> UNNotificationRequest {
		try XCTUnwrap(delivery.pendingRequests().first { reminderID($0) == activityID })
	}

	func testRefreshUsesActualRunningInstancesIncludingOvernightAndExcludesFutureAndEndedRecords() throws {
		let work = try definition("Private activity"), music = try definition("Private music")
		let overnight = try activity(work, start: now.addingTimeInterval(-86400), note: "Private note")
		let recent = try activity(music, start: now.addingTimeInterval(-300))
		_ = try activity(work, start: now.addingTimeInterval(-7200), end: now.addingTimeInterval(-3600))
		_ = try activity(music, start: now.addingTimeInterval(300))
		try refresh(fromWorker: true)
		XCTAssertEqual(Set(delivery.pendingRequests().compactMap(reminderID)), Set([id(overnight), id(recent)]))
		for request in delivery.pendingRequests() {
			XCTAssertEqual(request.content.title, "Still doing this?")
			XCTAssertFalse(request.content.body.contains("Private"))
			XCTAssertEqual(Set(request.content.userInfo.keys.compactMap { $0 as? String }), Set(["activityID"]))
		}
		XCTAssertEqual(try stored().filter { $0.end == nil }.count, 3)
	}

	func testContinueSchedulesFromActionTimeWithoutChangingRecordedTimesAndCompletesOnMain() throws {
		let value = try activity(definition("Work"), start: now.addingTimeInterval(-300))
		let activityID = id(value), continuedAt = now.addingTimeInterval(83.5)
		try refresh()
		let result = try action(ActivityReminderService.continueActionIdentifier, id: activityID, at: continuedAt, fromWorker: true)
		XCTAssertEqual(result, ActivityReminderActionResult(activityID: activityID))
		let trigger = try XCTUnwrap(request(activityID).trigger as? UNTimeIntervalNotificationTrigger)
		XCTAssertEqual(trigger.timeInterval, 120 * 60, accuracy: 0.001); XCTAssertFalse(trigger.repeats)
		let saved = try XCTUnwrap(stored().first)
		XCTAssertEqual(saved.start, now.addingTimeInterval(-300)); XCTAssertNil(saved.end)
	}

	func testStaleContinueAndStopNeverChangeOrSnoozeRestartedInstance() throws {
		let work = try definition("Work")
		let old = try activity(work, start: now.addingTimeInterval(-3600), end: now.addingTimeInterval(-600))
		let restarted = try activity(work, start: now.addingTimeInterval(-300)), restartedID = id(restarted)
		let continued = try action(ActivityReminderService.continueActionIdentifier, id: id(old))
		XCTAssertEqual(continued, ActivityReminderActionResult())
		let stopped = try action(ActivityReminderService.stopActionIdentifier, id: id(old))
		XCTAssertFalse(stopped.didChange)
		let values = try stored()
		XCTAssertEqual(values.filter { $0.end == nil }.map { $0.id }, [restartedID])
		XCTAssertEqual(try XCTUnwrap(values.first { $0.id == id(old) }).end, now.addingTimeInterval(-600))
		XCTAssertEqual(try XCTUnwrap(request(restartedID).trigger as? UNTimeIntervalNotificationTrigger).timeInterval,
			120 * 60 - 300, accuracy: 0.001)
	}

	func testStopCommitsExactInstanceAndAutoNoteWhileConcurrentActivityRemainsRunning() throws {
		let work = try activity(definition("Work", autoNote: true), start: now.addingTimeInterval(-900), note: "Keep me")
		let music = try activity(definition("Music"), start: now.addingTimeInterval(-300))
		let workID = id(work), musicID = id(music)
		try refresh(); delivery.seed(try request(workID), delivered: true)
		let result = try action(ActivityReminderService.stopActionIdentifier, id: workID)
		XCTAssertTrue(result.didChange); XCTAssertEqual(result.autoNoteActivityID, workID); XCTAssertFalse(result.shouldOpenReview)
		let values = try stored(), saved = try XCTUnwrap(values.first { $0.id == workID })
		XCTAssertEqual(saved.end, now); XCTAssertEqual(saved.endSetAt, now); XCTAssertEqual(saved.note, "Keep me")
		XCTAssertEqual(values.filter { $0.end == nil }.map { $0.id }, [musicID])
		XCTAssertEqual(delivery.pendingRequests().compactMap(reminderID), [musicID])
		XCTAssertTrue(delivery.deliveredRequests().isEmpty)
	}

	func testStopHonorsAutoIgnoreAndDoesNotRouteDeletedShortActivityToAutoNote() throws {
		settings.setAutoIgnoreEnabled(true); settings.setAutoIgnoreSeconds(60)
		let value = try activity(definition("Work", autoNote: true), start: now.addingTimeInterval(-5)), activityID = id(value)
		let result = try action(ActivityReminderService.stopActionIdentifier, id: activityID)
		XCTAssertTrue(result.didChange); XCTAssertNil(result.autoNoteActivityID)
		XCTAssertTrue(try stored().isEmpty); XCTAssertTrue(delivery.pendingRequests().isEmpty)
	}

	func testReviewAndDefaultRouteExactSavedRecordWithoutChangingItsEnd() throws {
		let value = try activity(definition("Work"), start: now.addingTimeInterval(-900), end: now.addingTimeInterval(-300))
		for actionID in [ActivityReminderService.reviewActionIdentifier, UNNotificationDefaultActionIdentifier] {
			let result = try action(actionID, id: id(value))
			XCTAssertEqual(result, ActivityReminderActionResult(activityID: id(value), shouldOpenReview: true))
		}
		XCTAssertEqual(try stored().first?.end, now.addingTimeInterval(-300))
	}

	func testMalformedWrongEntityAndDeletedReviewIDsFailWithoutChangingOtherActivity() throws {
		let work = try definition("Work"), live = try activity(work, start: now.addingTimeInterval(-900))
		let deleted = try activity(work, start: now.addingTimeInterval(-1800), end: now.addingTimeInterval(-1200))
		let deletedID = id(deleted); container.viewContext.delete(deleted); try container.viewContext.save()
		for identifier in [nil, "not-an-object-id", id(work), deletedID] {
			XCTAssertThrowsError(try action(ActivityReminderService.reviewActionIdentifier, id: identifier))
		}
		XCTAssertEqual(try stored().map { $0.id }, [id(live)]); XCTAssertNil(try stored().first?.end)
	}

	func testDisabledRefreshCleansOnlyOwnNotificationsWithoutResolvingDatabase() throws {
		try preferences.save(settings: ActivityReminderSettings())
		let own = UNNotificationRequest(identifier: ActivityReminderScheduler.identifierPrefix + "old", content: UNMutableNotificationContent(), trigger: nil)
		let other = UNNotificationRequest(identifier: "mood-reminder.keep", content: UNMutableNotificationContent(), trigger: nil)
		for request in [own, other] { delivery.seed(request); delivery.seed(request, delivered: true) }
		let previousReads = provider.databaseReads
		try refresh()
		XCTAssertEqual(provider.databaseReads, previousReads)
		XCTAssertEqual(delivery.pendingRequests().map { $0.identifier }, [other.identifier])
		XCTAssertEqual(delivery.deliveredRequests().map { $0.identifier }, [other.identifier])
	}

	func testDismissedPromptStaysConsumedAcrossRefreshUntilExplicitContinue() throws {
		let value = try activity(definition("Work"), start: now.addingTimeInterval(-300)), activityID = id(value)
		try refresh()
		let delivered = try request(activityID), due = now.addingTimeInterval(120 * 60 - 300)
		delivery.remove([delivered.identifier]); delivery.seed(delivered, delivered: true)
		XCTAssertEqual(try action(UNNotificationDismissActionIdentifier, id: activityID, at: due.addingTimeInterval(1)), ActivityReminderActionResult())
		try refresh(at: due.addingTimeInterval(2))
		XCTAssertTrue(delivery.pendingRequests().isEmpty)
		_ = try action(ActivityReminderService.continueActionIdentifier, id: activityID, at: due.addingTimeInterval(3))
		XCTAssertEqual(try XCTUnwrap(request(activityID).trigger as? UNTimeIntervalNotificationTrigger).timeInterval, 120 * 60, accuracy: 0.001)
	}

	func testContinueReportsDeliveryFailureButSuccessfulStopRemainsCommitted() throws {
		let work = try activity(definition("Work"), start: now.addingTimeInterval(-900)), workID = id(work)
		let music = try activity(definition("Music"), start: now.addingTimeInterval(-300))
		delivery.failAdd = true
		XCTAssertThrowsError(try action(ActivityReminderService.continueActionIdentifier, id: workID))
		let stopped = try action(ActivityReminderService.stopActionIdentifier, id: workID)
		XCTAssertTrue(stopped.didChange)
		let values = try stored()
		XCTAssertEqual(try XCTUnwrap(values.first { $0.id == workID }).end, now)
		XCTAssertEqual(values.filter { $0.end == nil }.map { $0.id }, [id(music)])
	}

	func testDefaultRefreshIncludesTimerStartedWhileWaitingForAnotherProcess() throws {
		let lockURL = directory.appendingPathComponent("shared-reminder-schedule.lock")
		let descriptor = open(lockURL.path, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR)
		XCTAssertGreaterThanOrEqual(descriptor, 0)
		guard descriptor >= 0 else { return }
		defer { _ = flock(descriptor, LOCK_UN); _ = close(descriptor) }
		XCTAssertEqual(flock(descriptor, LOCK_EX | LOCK_NB), 0)
		let subject = ActivityReminderScheduler(delivery: delivery, lockURL: lockURL)
		let early = expectation(description: "Wait for the other process"); early.isInverted = true
		let done = expectation(description: "Reconcile the latest running instances")
		var unlocked = false
		ActivityReminderService.refresh(preferences: preferences, scheduler: subject) { error in
			XCTAssertTrue(Thread.isMainThread); XCTAssertNil(error)
			if !unlocked { early.fulfill() }
			done.fulfill()
		}
		XCTAssertEqual(XCTWaiter.wait(for: [early], timeout: 0.05), .completed)
		// Simulate a widget starting another activity while this app waits for the lock.
		let running = try activity(definition("Started elsewhere"), start: Date())
		unlocked = true
		XCTAssertEqual(flock(descriptor, LOCK_UN), 0)
		wait(for: [done], timeout: 5)
		XCTAssertEqual(delivery.pendingRequests().compactMap(reminderID), [id(running)])
	}
}
