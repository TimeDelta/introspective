import XCTest
import UIKit
import CoreData
import HealthKit
import CalendarKit
import SwiftyMocky
@testable import Introspective
@testable import Common
@testable import DependencyInjection
@testable import Persistence
@testable import Samples

final class UnifiedDayHealthAuthorizationTests: UnitTest {
	private var health: UnifiedDayHealthReadProbe!
	private var activityContext: NSManagedObjectContext!
	private var window: UIWindow?
	private let base = Date(timeIntervalSince1970: 1_700_000_000)

	override func setUp() {
		super.setUp()
		health = UnifiedDayHealthReadProbe()
		Given(injectionProvider, .get(.value(HealthKitUtil.self), willReturn: health as HealthKitUtil))
		Given(injectionProvider, .get(.value(CalendarUtil.self), willReturn: CalendarUtilImpl()))
		Given(injectionProvider, .get(.value(CoreDataSampleUtil.self), willReturn: CoreDataSampleUtilImpl()))
		Given(mockSettings, .convertTimeZones(getter: false))
		Given(mockDatabase, .query(.any(NSFetchRequest<Activity>.self), willReturn: []))
		activityContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		activityContext.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: ObjectModelContainer.objectModel)
	}

	override func tearDown() {
		window?.isHidden = true
		window?.rootViewController = nil
		window = nil
		activityContext = nil
		health = nil
		super.tearDown()
	}

	private func activity() throws -> Activity {
		let entity = try XCTUnwrap(NSEntityDescription.entity(forEntityName: Activity.entityName, in: activityContext))
		let activity = Activity(entity: entity, insertInto: activityContext)
		activity.setValue(base, forKey: "startDate")
		activity.setValue(base.addingTimeInterval(600), forKey: "endDate")
		Given(mockDatabase, .query(.any(NSFetchRequest<Activity>.self), willReturn: [activity]))
		return activity
	}

	private func open() -> UnifiedDayViewController {
		let controller = UnifiedDayViewController()
		controller.loadViewIfNeeded()
		return controller
	}

	private func finishMainQueueCallbacks() {
		let finished = expectation(description: "Authorization completion and calendar reload finished")
		DispatchQueue.main.async { finished.fulfill() }
		wait(for: [finished], timeout: 5)
	}

	private func show(_ controller: UnifiedDayViewController) -> UINavigationController {
		let navigation = UINavigationController(rootViewController: UIViewController())
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = navigation
		window.isHidden = false
		self.window = window
		navigation.pushViewController(controller, animated: false)
		return navigation
	}

	func testOpeningRequestsOnlySleepAndKeepsActivitiesVisibleWhileAuthorizationIsPending() throws {
		let activity = try activity()
		let controller = open()
		let events = controller.eventsForDate(base)

		XCTAssertEqual(health.requests.count, 1)
		XCTAssertEqual(health.requests.first?.types, Sleep.readPermissions)
		XCTAssertNil(health.requests.first?.predicate)
		XCTAssertEqual(health.legacyAuthorizationCount, 0)
		XCTAssertTrue(health.reads.isEmpty)
		XCTAssertEqual(health.calculationCount, 0, "Heart rate is requested only after the person selects that calculation")
		XCTAssertEqual(events.count, 1)
		XCTAssertTrue(events.first?.text.hasPrefix("Activity\n") == true)
		XCTAssertEqual(events.first?.dateInterval, DateInterval(start: activity.start, end: activity.end!))
		controller.viewWillAppear(false)
		XCTAssertEqual(health.requests.count, 1, "Repeated appearance must not duplicate an outstanding permission request")
	}

	func testSuccessfulAuthorizationReloadsTheCalendarAndDoesNotPromptAgainOrAcceptDuplicateCompletions() throws {
		let controller = open()
		health.samples = [HKCategorySample(type: Sleep.categoryType,
			value: HKCategoryValueSleepAnalysis.asleepCore.rawValue,
			start: base, end: base.addingTimeInterval(600))]

		health.completeRequest(0)
		finishMainQueueCallbacks()
		XCTAssertFalse(health.reads.isEmpty, "Authorization success must reload existing CalendarKit pages")
		XCTAssertTrue(health.reads.allSatisfy { $0.type == Sleep.self && $0.wasMainThread })
		let events = controller.eventsForDate(base)
		XCTAssertTrue(events.contains { $0.text.hasPrefix("Sleeping\n") })
		XCTAssertTrue(events.allSatisfy { $0.dateInterval == DateInterval(start: base, end: base.addingTimeInterval(600)) })

		let readsAfterSuccess = health.reads.count
		health.completeRequest(0)
		finishMainQueueCallbacks()
		XCTAssertEqual(health.reads.count, readsAfterSuccess, "A duplicate completion must not trigger another reload")
		controller.viewWillAppear(false)
		XCTAssertEqual(health.requests.count, 1)
		XCTAssertEqual(health.legacyAuthorizationCount, 0)
		XCTAssertEqual(health.calculationCount, 0)
	}

	func testAuthorizationFailurePreservesActivitiesWithoutReadingSleepOrRepeatingTheRequest() throws {
		_ = try activity()
		let controller = open()
		health.completeRequest(0, error: GenericError("Sleep authorization unavailable"))
		finishMainQueueCallbacks()

		let events = controller.eventsForDate(base)
		XCTAssertEqual(events.count, 1)
		XCTAssertTrue(events.first?.text.hasPrefix("Activity\n") == true)
		XCTAssertTrue(health.reads.isEmpty)
		controller.viewWillAppear(false)
		XCTAssertEqual(health.requests.count, 1)
		XCTAssertEqual(health.calculationCount, 0)
	}

	func testBackgroundAuthorizationCompletionReloadsOnTheMainQueue() {
		let controller = open()
		let callbackReturned = expectation(description: "Background authorization callback returned")
		let probe = health!
		DispatchQueue.global(qos: .userInitiated).async {
			probe.completeRequest(0)
			callbackReturned.fulfill()
		}
		wait(for: [callbackReturned], timeout: 5)
		finishMainQueueCallbacks()

		XCTAssertFalse(health.reads.isEmpty)
		XCTAssertTrue(health.reads.allSatisfy { $0.wasMainThread })
		XCTAssertEqual(health.requests.count, 1)
		withExtendedLifetime(controller) {}
	}

	func testInitialActivityEventsReturnBeforeAuthorizationQueuedOnMainCompletes() throws {
		_ = try activity()
		let controller = open()
		let finished = expectation(description: "Main-queue authorization and reload finish without blocking the initial read")
		let probe = health!
		DispatchQueue.main.async {
			probe.completeRequest(0)
			DispatchQueue.main.async { finished.fulfill() }
		}

		let events = controller.eventsForDate(base)
		XCTAssertEqual(events.count, 1)
		XCTAssertTrue(events.first?.text.hasPrefix("Activity\n") == true)
		XCTAssertTrue(health.reads.isEmpty, "The synchronous calendar read must not wait for the permission callback")
		wait(for: [finished], timeout: 5)
		XCTAssertFalse(health.reads.isEmpty, "Sleep reads can begin after main processes the permission callback")
	}

	func testPoppingTheControllerInvalidatesItsPendingAuthorizationCompletion() {
		let controller = open()
		let navigation = show(controller)
		XCTAssertTrue(navigation.popViewController(animated: false) === controller)
		XCTAssertNil(controller.navigationController)

		health.completeRequest(0)
		finishMainQueueCallbacks()
		XCTAssertTrue(health.reads.isEmpty, "An authorization callback must not reload a closed calendar")
		XCTAssertEqual(health.requests.count, 1)
	}

	func testReturningAfterAPopStartsAFreshRequestAndRejectsThePreviousCompletion() {
		let controller = open()
		let navigation = show(controller)
		XCTAssertTrue(navigation.popViewController(animated: false) === controller)
		navigation.pushViewController(controller, animated: false)
		XCTAssertEqual(health.requests.count, 2)

		health.completeRequest(0)
		finishMainQueueCallbacks()
		XCTAssertTrue(health.reads.isEmpty)
		health.completeRequest(1)
		finishMainQueueCallbacks()
		XCTAssertFalse(health.reads.isEmpty)
		XCTAssertEqual(health.requests.count, 2)
	}

	func testPendingAuthorizationDoesNotRetainAnAbandonedController() {
		weak var released: UnifiedDayViewController?
		autoreleasepool {
			let controller = open()
			released = controller
		}
		XCTAssertNil(released)
		XCTAssertEqual(health.requests.count, 1)

		health.completeRequest(0)
		finishMainQueueCallbacks()
		XCTAssertTrue(health.reads.isEmpty)
	}
}

private final class UnifiedDayHealthReadProbe: HealthKitUtil, HealthReadAuthorizationProviding {
	struct Request {
		let types: Set<HKObjectType>
		let predicate: NSPredicate?
		let callback: (Error?) -> Void
	}
	struct Read {
		let type: HealthKitSample.Type
		let wasMainThread: Bool
	}
	private(set) var requests: [Request] = []
	private(set) var reads: [Read] = []
	private(set) var legacyAuthorizationCount = 0
	private(set) var calculationCount = 0
	var samples: [HKSample] = []

	func requestReadAuthorization(for types: Set<HKObjectType>, predicate: NSPredicate?, callback: @escaping (Error?) -> Void) {
		requests.append(Request(types: types, predicate: predicate, callback: callback))
	}

	func completeRequest(_ index: Int, error: Error? = nil) { requests[index].callback(error) }

	func getAuthorization(callback: @escaping (Error?) -> Void) {
		legacyAuthorizationCount += 1
		XCTFail("The unified calendar must request selected Sleep permissions")
		callback(nil)
	}

	func getSamples(for type: HealthKitSample.Type, from startDate: Date?, to endDate: Date?,
		predicate: NSPredicate?, callback: @escaping ([HKSample]?, Error?) -> Void) -> (() -> Void) {
		reads.append(Read(type: type, wasMainThread: Thread.isMainThread))
		// Synchronous fixtures keep the existing synchronous CalendarKit bridge
		// deterministic without requiring HealthKit callbacks or a real store.
		callback(samples, nil)
		return {}
	}

	func calculate(_ calculation: HKStatisticsOptions, _ type: HealthKitQuantitySample.Type,
		from startDate: Date, to endDate: Date, callback: @escaping (Double?, Error?) -> Void) {
		calculationCount += 1
		XCTFail("Opening the unified calendar must not query heart rate statistics")
		callback(nil, GenericError("Unexpected statistics read"))
	}

	func setTimeZoneIfApplicable(for date: inout Date, from sample: HKSample) {}
	func preferredUnitFor(_ typeId: HKQuantityTypeIdentifier) -> HKUnit? { nil }
}
