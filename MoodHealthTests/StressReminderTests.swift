import XCTest
import CoreData
import UserNotifications
import UIKit
import Common
import DependencyInjection
@testable import Notifications
@testable import Persistence
@testable import Samples

private final class StressReminderDeliveryProbe: MoodReminderDelivery {
	private let lock = NSLock()
	private var requests: [String: UNNotificationRequest] = [:]
	var beforeAdd: ((UNNotificationRequest, @escaping (Error?) -> Void) -> Void)?
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) { completion(snapshot()) }
	func remove(_ identifiers: [String]) { lock.lock(); defer { lock.unlock() }; for identifier in identifiers { requests.removeValue(forKey: identifier) } }
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) {
		let finish: (Error?) -> Void = { [self] error in
			if error == nil { lock.lock(); requests[request.identifier] = request; lock.unlock() }
			completion(error)
		}
		if let beforeAdd = beforeAdd { beforeAdd(request, finish) } else { finish(nil) }
	}
	func snapshot() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(requests.values) }
}

final class StressReminderSchedulerTests: XCTestCase {
	func testReplacementsPreserveMoodAndOtherNotificationsAndUseGenericContent() throws {
		let delivery = StressReminderDeliveryProbe()
		for identifier in [MoodReminderScheduler.identifierPrefix + "existing", "finished-import"] {
			delivery.add(UNNotificationRequest(identifier: identifier, content: UNMutableNotificationContent(), trigger: nil)) { _ in }
		}
		let subject = StressReminderScheduler(delivery: delivery), first = expectation(description: "First plan"), disabled = expectation(description: "Disabled")
		subject.replace(dates: [Date().addingTimeInterval(3600)]) { error in XCTAssertNil(error); first.fulfill() }
		wait(for: [first], timeout: 5)
		let request = try XCTUnwrap(delivery.snapshot().first { $0.identifier.hasPrefix(StressReminderScheduler.identifierPrefix) })
		XCTAssertEqual(request.content.title, "Check-in reminder"); XCTAssertEqual(request.content.body, "Take a moment to check in.")
		XCTAssertTrue(request.content.userInfo.isEmpty)
		XCTAssertEqual(request.content.categoryIdentifier, StressReminderScheduler.categoryIdentifier)
		XCTAssertFalse(try XCTUnwrap(request.trigger as? UNCalendarNotificationTrigger).repeats)
		subject.replace(dates: []) { error in XCTAssertNil(error); disabled.fulfill() }
		wait(for: [disabled], timeout: 5)
		XCTAssertEqual(Set(delivery.snapshot().map { $0.identifier }), Set([MoodReminderScheduler.identifierPrefix + "existing", "finished-import"]))
	}
	func testNewPlanWaitsForInFlightOldDeliveryThenRemovesOldRequest() {
		let delivery = StressReminderDeliveryProbe()
		let started = expectation(description: "Old delivery started"), completed = expectation(description: "Newest plan completed")
		let lock = NSLock(); var finish: ((Error?) -> Void)?
		delivery.beforeAdd = { _, completion in lock.lock(); finish = completion; lock.unlock(); started.fulfill() }
		let scheduler = StressReminderScheduler(delivery: delivery)
		scheduler.replace(dates: [Date().addingTimeInterval(3600)])
		wait(for: [started], timeout: 5)
		scheduler.replace(dates: []) { error in XCTAssertNil(error); completed.fulfill() }
		lock.lock(); let callback = finish; lock.unlock(); callback?(nil)
		wait(for: [completed], timeout: 5)
		XCTAssertTrue(delivery.snapshot().isEmpty)
	}
	func testDeliveryFailureIsReportedAndDoesNotBlockLaterReplacement() {
		let delivery = StressReminderDeliveryProbe(), failed = expectation(description: "Delivery failed"), recovered = expectation(description: "Later replacement")
		delivery.beforeAdd = { _, completion in completion(NSError(domain: "StressReminderTests", code: 1)) }
		let subject = StressReminderScheduler(delivery: delivery)
		subject.replace(dates: [Date().addingTimeInterval(3600)]) { error in XCTAssertNotNil(error); failed.fulfill() }
		wait(for: [failed], timeout: 5)
		subject.replace(dates: []) { error in XCTAssertNil(error); recovered.fulfill() }
		wait(for: [recovered], timeout: 5)
		XCTAssertTrue(delivery.snapshot().isEmpty)
	}
	func testNonfinitePlanIsRejectedWithoutRemovingExistingNotifications() {
		let delivery = StressReminderDeliveryProbe()
		let identifier = StressReminderScheduler.identifierPrefix + "existing"
		delivery.add(UNNotificationRequest(identifier: identifier, content: UNMutableNotificationContent(), trigger: nil)) { _ in }
		let completed = expectation(description: "Rejected invalid plan")
		StressReminderScheduler(delivery: delivery).replace(dates: [Date(timeIntervalSinceReferenceDate: .infinity)]) { error in
			XCTAssertNotNil(error); completed.fulfill()
		}
		wait(for: [completed], timeout: 5)
		XCTAssertEqual(delivery.snapshot().map { $0.identifier }, [identifier])
	}
	func testStressAndMoodRoutesAndCategoriesStayDistinctAndRegistered() {
		XCTAssertNotEqual(StressReminderScheduler.openCheckInNotification, MoodReminderScheduler.openCheckInNotification)
		XCTAssertNotEqual(StressReminderScheduler.identifierPrefix, MoodReminderScheduler.identifierPrefix)
		XCTAssertTrue(UserNotificationDelegate.categories.contains { $0.identifier == StressReminderScheduler.categoryIdentifier })
		XCTAssertTrue(UserNotificationDelegate.categories.contains { $0.identifier == MoodReminderScheduler.categoryIdentifier })
	}
	@MainActor func testStressReminderRouteSelectsRecordAndDeliversNavigationOnMainFromWorker() {
		let tabs = UITabBarController()
		tabs.viewControllers = [UIViewController(), UIViewController()]
		tabs.selectedIndex = 1
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = tabs
		let subject = UserNotificationDelegate(window)
		let routed = expectation(description: "Stress reminder routed on main")
		routed.assertForOverFulfill = true
		let observer = NotificationCenter.default.addObserver(forName: StressReminderScheduler.openCheckInNotification,
			object: nil, queue: nil) { _ in
				let wasMain = Thread.isMainThread
				let selectedAtDelivery = wasMain ? MainActor.assumeIsolated { tabs.selectedIndex } : nil
				DispatchQueue.main.async {
					XCTAssertTrue(wasMain, "UIKit navigation notifications must be delivered on main")
					XCTAssertEqual(selectedAtDelivery, 0, "Select Record before delivering the navigation notification")
					routed.fulfill()
				}
			}
		defer { NotificationCenter.default.removeObserver(observer) }
		DispatchQueue.global(qos: .userInitiated).async { subject.openStressCheckIn() }
		wait(for: [routed], timeout: 5)
		withExtendedLifetime(subject) {}
	}
}

private final class StressReminderDatabaseProvider: InjectionProvider {
	let types: [Any.Type] = [Database.self]
	let database: Database
	init(_ database: Database) { self.database = database }
	func get<T>(_ type: T.Type) throws -> T { database as! T }
}

final class StressReminderIntegrationTests: XCTestCase {
	private static let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: StressReminderIntegrationTests.self)])!
	private var container: NSPersistentContainer!
	private var directory: URL!
	private var defaults: UserDefaults!
	private var suite: String!
	private var preferences: StressReminderPreferences!
	private var delivery: StressReminderDeliveryProbe!
	private var scheduler: StressReminderScheduler!
	private var calendar: Calendar!
	private var now: Date!
	override func setUpWithError() throws {
		directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		container = NSPersistentContainer(name: "StressReminderTests", managedObjectModel: Self.model)
		let description = NSPersistentStoreDescription(url: directory.appendingPathComponent("stress.sqlite"))
		description.shouldAddStoreAsynchronously = false; container.persistentStoreDescriptions = [description]
		var failure: Error?; container.loadPersistentStores { _, error in failure = error }; if let failure = failure { throw failure }
		DependencyInjector.register([CommonInjectionProvider(), SamplesInjectionProvider(), StressReminderDatabaseProvider(DatabaseImpl(container))])
		suite = UUID().uuidString; defaults = UserDefaults(suiteName: suite)!
		preferences = StressReminderPreferences(defaults: defaults)
		delivery = StressReminderDeliveryProbe(); scheduler = StressReminderScheduler(delivery: delivery)
		calendar = Calendar(identifier: .gregorian); calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		now = ISO8601DateFormatter().date(from: "2024-07-15T12:00:00Z")!
		var value = StressReminderSettings(); value.enabled = true; try preferences.save(reminders: value)
	}
	override func tearDownWithError() throws {
		container.viewContext.reset()
		for store in container.persistentStoreCoordinator.persistentStores { try container.persistentStoreCoordinator.remove(store) }
		container = nil; defaults.removePersistentDomain(forName: suite)
		try FileManager.default.removeItem(at: directory)
	}
	private func refresh(expecting count: Int, file: StaticString = #file, line: UInt = #line) {
		let completed = expectation(description: "Stress plan with \(count) prompts")
		StressReminderService.refresh(now: now, calendar: calendar, preferences: preferences, scheduler: scheduler) { error in
			XCTAssertNil(error, file: file, line: line); completed.fulfill()
		}
		wait(for: [completed], timeout: 5)
		XCTAssertEqual(delivery.snapshot().filter { $0.identifier.hasPrefix(StressReminderScheduler.identifierPrefix) }.count, count, file: file, line: line)
	}
	@discardableResult private func stress(at date: Date, rating: Int16 = 2, kind: String = "momentary", version: Int16 = 1) throws -> StressCheckIn {
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: StressCheckIn.entityName, in: container.viewContext))
		let entry = StressCheckIn(entity: entity, insertInto: container.viewContext)
		entry.id = UUID(); entry.timestamp = date; entry.overallRating = rating; entry.measurementKind = kind; entry.scaleVersion = version
		try container.viewContext.save(); return entry
	}
	func testOnlyCompletedStressCheckInSuppressesTodayAndDeletionRestoresPrompt() throws {
		refresh(expecting: 14)
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: MoodImpl.entityName, in: container.viewContext))
		let mood = MoodImpl(entity: entity, insertInto: container.viewContext)
		mood.setSource(.introspective); mood.date = now; mood.rating = 1; mood.minRating = 0; mood.maxRating = 1
		try container.viewContext.save()
		refresh(expecting: 14)
		let entry = try stress(at: now)
		refresh(expecting: 13)
		container.viewContext.delete(entry); try container.viewContext.save()
		refresh(expecting: 14)
	}
	func testBackdatedFutureAndUnsupportedStressRecordsDoNotCompleteToday() throws {
		try stress(at: now.addingTimeInterval(-86400))
		try stress(at: now.addingTimeInterval(1))
		// The model rejects out-of-range ratings before they can complete a day.
		XCTAssertThrowsError(try stress(at: now, rating: 9))
		container.viewContext.rollback()
		try stress(at: now, kind: "daily")
		try stress(at: now, version: 2)
		refresh(expecting: 14)
		try stress(at: now, rating: 0)
		refresh(expecting: 13)
	}
	func testSkipDisabledAlwaysKeepsTodayAndDisabledPlanPreservesMoodPrompts() throws {
		try stress(at: now)
		var value = try preferences.reminders(); value.skipRecordedDays = false
		try preferences.save(reminders: value); refresh(expecting: 14)
		let identifier = MoodReminderScheduler.identifierPrefix + "keep"
		delivery.add(UNNotificationRequest(identifier: identifier, content: UNMutableNotificationContent(), trigger: nil)) { _ in }
		value.enabled = false; try preferences.save(reminders: value)
		refresh(expecting: 0)
		XCTAssertEqual(delivery.snapshot().map { $0.identifier }, [identifier])
	}
	@MainActor func testReminderScreenStartsOptionalAndHasOneDailyTimeAndStressSpecificCompletionCopy() throws {
		let controller = StressRemindersViewController(style: .grouped)
		let isolated = StressReminderPreferences(defaults: UserDefaults(suiteName: suite + ".screen")!)
		defer { UserDefaults(suiteName: suite + ".screen")?.removePersistentDomain(forName: suite + ".screen") }
		controller.preferences = isolated; controller.scheduler = scheduler
		controller.requestAuthorization = { completion in
			XCTFail("Opening optional reminder settings must not request notification authorization")
			completion(false, nil)
		}
		controller.loadViewIfNeeded()
		XCTAssertTrue(controller.scheduler === scheduler, "The screen must retain its injected delivery scheduler")
		XCTAssertTrue(delivery.snapshot().isEmpty, "Opening reminder settings must not schedule notifications")
		XCTAssertEqual(controller.tableView.accessibilityIdentifier, "stressReminders")
		XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 1), 1)
		let cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		XCTAssertFalse(try XCTUnwrap(cell.accessoryView as? UISwitch).isOn)
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 3)?.contains("Recording a mood does not suppress") == true)
		XCTAssertTrue(controller.tableView(controller.tableView, titleForFooterInSection: 1)?.contains("14 days") == true)
	}
}
