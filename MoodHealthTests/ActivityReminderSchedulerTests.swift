import XCTest
import Foundation
import UserNotifications
import Darwin
import Common

private final class ActivityScheduleDeliveryProbe: ActivityReminderDelivery {
	private let lock = NSLock()
	private var requests: [String: UNNotificationRequest] = [:]
	private var notifications: [String: UNNotificationRequest] = [:]
	private var additions: [String] = []
	var beforeAdd: ((UNNotificationRequest, @escaping (Error?) -> Void) -> Void)?

	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) { completion(pendingSnapshot()) }
	func delivered(_ completion: @escaping ([UNNotificationRequest]) -> Void) { completion(deliveredSnapshot()) }
	func remove(_ identifiers: [String]) {
		lock.lock(); defer { lock.unlock() }
		for id in identifiers { requests.removeValue(forKey: id) }
	}
	func removeDelivered(_ identifiers: [String]) {
		lock.lock(); defer { lock.unlock() }
		for id in identifiers { notifications.removeValue(forKey: id) }
	}
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) {
		let finish: (Error?) -> Void = { [self] error in
			if error == nil {
				lock.lock(); requests[request.identifier] = request; additions.append(request.identifier); lock.unlock()
			}
			completion(error)
		}
		if let beforeAdd = beforeAdd { beforeAdd(request, finish) } else { finish(nil) }
	}
	func seedPending(_ request: UNNotificationRequest) { lock.lock(); requests[request.identifier] = request; lock.unlock() }
	func seedDelivered(_ request: UNNotificationRequest) { lock.lock(); notifications[request.identifier] = request; lock.unlock() }
	func pendingSnapshot() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(requests.values) }
	func deliveredSnapshot() -> [UNNotificationRequest] { lock.lock(); defer { lock.unlock() }; return Array(notifications.values) }
	func addedIdentifiers() -> [String] { lock.lock(); defer { lock.unlock() }; return additions }
}

final class ActivityReminderSchedulerTests: XCTestCase {
	private let now = Date(timeIntervalSince1970: 1_700_000_000.875)
	private let prefix = ActivityReminderScheduler.identifierPrefix

	private func request(_ identifier: String, activityID: String? = nil) -> UNNotificationRequest {
		let content = UNMutableNotificationContent()
		if let activityID = activityID { content.userInfo = [ActivityReminderScheduler.activityIDUserInfoKey: activityID] }
		return UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
	}
	private func schedule(_ ids: [String], delay: TimeInterval = 1800) -> ActivityReminderSchedule {
		ActivityReminderSchedule(enabled: true, activeActivityIDs: Set(ids), prompts: ids.map {
			ActivityReminderPrompt(activityID: $0, date: now.addingTimeInterval(delay))
		})
	}

	func testDeliveredRequestUsesGenericContentAndExactInstanceIdentityWithoutRepeating() throws {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let done = expectation(description: "Recorded activity request")
		let id = "x-coredata://store/Activity/p42"
		subject.refresh(now: now, plan: { capacity, completion in
			XCTAssertTrue(Thread.isMainThread); XCTAssertEqual(capacity, 8)
			completion(.success(self.schedule([id])))
		}) { error in XCTAssertTrue(Thread.isMainThread); XCTAssertNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		let pending = delivery.pendingSnapshot()
		XCTAssertEqual(pending.count, 1)
		let value = try XCTUnwrap(pending.first)
		XCTAssertEqual(value.identifier, prefix + id)
		XCTAssertEqual(value.content.title, "Still doing this?")
		XCTAssertEqual(value.content.body, "An activity is still running. Continue it or review when it ended.")
		XCTAssertEqual(value.content.categoryIdentifier, ActivityReminderScheduler.categoryIdentifier)
		XCTAssertEqual(Set(value.content.userInfo.keys.compactMap { $0 as? String }), Set(["activityID"]))
		XCTAssertEqual(value.content.userInfo["activityID"] as? String, id)
		let trigger = try XCTUnwrap(value.trigger as? UNTimeIntervalNotificationTrigger)
		XCTAssertEqual(trigger.timeInterval, 1800); XCTAssertFalse(trigger.repeats)
	}

	func testCapacityReservesExistingMoodStressAndOtherPendingNotifications() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		for index in 0..<61 { delivery.seedPending(request("other.\(index)")) }
		delivery.seedPending(request(prefix + "old", activityID: "old"))
		let done = expectation(description: "Remaining notification capacity")
		subject.refresh(now: now, plan: { capacity, completion in
			XCTAssertEqual(capacity, 3)
			completion(.success(self.schedule(["first", "second", "third"])))
		}) { error in XCTAssertNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		let pending = delivery.pendingSnapshot()
		XCTAssertEqual(pending.count, 64)
		XCTAssertEqual(pending.filter { !$0.identifier.hasPrefix(self.prefix) }.count, 61)
		XCTAssertEqual(Set(pending.filter { $0.identifier.hasPrefix(self.prefix) }.map { $0.identifier }),
			Set(["first", "second", "third"].map { prefix + $0 }))
	}

	func testDisabledPlanRemovesOnlyOwnPendingAndDeliveredRequests() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let unrelated = [MoodReminderScheduler.identifierPrefix + "keep", StressReminderScheduler.identifierPrefix + "keep", "import-result"]
		for id in unrelated { delivery.seedPending(request(id)); delivery.seedDelivered(request(id)) }
		delivery.seedPending(request(prefix + "running", activityID: "running"))
		delivery.seedDelivered(request(prefix + "running", activityID: "running"))
		let done = expectation(description: "Disabled prompt cleanup")
		subject.refresh(now: now, plan: { _, completion in
			completion(.success(ActivityReminderSchedule(enabled: false, activeActivityIDs: [], prompts: [])))
		}) { error in XCTAssertNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		XCTAssertEqual(Set(delivery.pendingSnapshot().map { $0.identifier }), Set(unrelated))
		XCTAssertEqual(Set(delivery.deliveredSnapshot().map { $0.identifier }), Set(unrelated))
	}

	func testEnabledPlanKeepsDeliveredCurrentInstanceAndRemovesStoppedOrInvalidInstances() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		delivery.seedDelivered(request(prefix + "current", activityID: "current"))
		delivery.seedDelivered(request(prefix + "stopped", activityID: "stopped"))
		delivery.seedDelivered(request(prefix + "missing-payload"))
		delivery.seedDelivered(request("other.keep"))
		let done = expectation(description: "Stale delivered cleanup")
		subject.refresh(now: now, plan: { _, completion in
			completion(.success(ActivityReminderSchedule(enabled: true, activeActivityIDs: ["current"], prompts: [])))
		}) { error in XCTAssertNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		XCTAssertEqual(Set(delivery.deliveredSnapshot().map { $0.identifier }), Set([prefix + "current", "other.keep"]))
		XCTAssertTrue(delivery.pendingSnapshot().isEmpty)
	}

	func testMalformedPlansCannotRemoveAnAlreadyScheduledNotification() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let original = prefix + "original"
		delivery.seedPending(request(original, activityID: "original"))
		let future = now.addingTimeInterval(60)
		let invalid: [ActivityReminderSchedule] = [
			schedule((0..<9).map { "excess.\($0)" }),
			ActivityReminderSchedule(enabled: true, activeActivityIDs: ["same"], prompts: [
				ActivityReminderPrompt(activityID: "same", date: future), ActivityReminderPrompt(activityID: "same", date: future)]),
			ActivityReminderSchedule(enabled: false, activeActivityIDs: ["disabled"], prompts: [ActivityReminderPrompt(activityID: "disabled", date: future)]),
			ActivityReminderSchedule(enabled: true, activeActivityIDs: [], prompts: [ActivityReminderPrompt(activityID: "stopped", date: future)]),
			ActivityReminderSchedule(enabled: true, activeActivityIDs: ["invalid"], prompts: [ActivityReminderPrompt(activityID: "invalid", date: Date(timeIntervalSinceReferenceDate: .nan))]),
			ActivityReminderSchedule(enabled: true, activeActivityIDs: ["past"], prompts: [ActivityReminderPrompt(activityID: "past", date: now)])
		]
		for plan in invalid {
			let done = expectation(description: "Rejected invalid plan")
			subject.refresh(now: now, plan: { _, completion in completion(.success(plan)) }) { error in
				XCTAssertNotNil(error); XCTAssertTrue(Thread.isMainThread); done.fulfill()
			}
			wait(for: [done], timeout: 5)
			XCTAssertEqual(delivery.pendingSnapshot().map { $0.identifier }, [original])
		}
	}

	func testNonfiniteReferenceTimeDoesNotReadOrModifyDelivery() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let original = prefix + "keep"
		delivery.seedPending(request(original, activityID: "keep"))
		let done = expectation(description: "Rejected invalid time")
		subject.refresh(now: Date(timeIntervalSinceReferenceDate: .infinity), plan: { _, _ in
			XCTFail("An invalid reference time must not request a plan")
		}) { error in XCTAssertNotNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		XCTAssertEqual(delivery.pendingSnapshot().map { $0.identifier }, [original])
	}

	func testDefaultRefreshAccountsForProviderWaitWhenComputingTrigger() throws {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let done = expectation(description: "Default time follows delayed plan")
		let due = Date().addingTimeInterval(60)
		var released: Date?
		subject.refresh(plan: { _, completion in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				released = Date()
				completion(.success(ActivityReminderSchedule(enabled: true, activeActivityIDs: ["current"],
					prompts: [ActivityReminderPrompt(activityID: "current", date: due)])))
			}
		}) { error in XCTAssertNil(error); done.fulfill() }
		wait(for: [done], timeout: 5)
		let request = try XCTUnwrap(delivery.pendingSnapshot().first)
		let trigger = try XCTUnwrap(request.trigger as? UNTimeIntervalNotificationTrigger)
		let releaseTime = try XCTUnwrap(released)
		XCTAssertLessThanOrEqual(trigger.timeInterval, due.timeIntervalSince(releaseTime) + 0.02)
		XCTAssertGreaterThan(trigger.timeInterval, 1)
	}

	func testDefaultRefreshRejectsPromptThatExpiredWhileProviderWasWaiting() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let original = prefix + "keep"
		delivery.seedPending(request(original, activityID: "keep"))
		let done = expectation(description: "Expired delayed plan is rejected")
		subject.refresh(plan: { _, completion in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				completion(.success(ActivityReminderSchedule(enabled: true, activeActivityIDs: ["expired"],
					prompts: [ActivityReminderPrompt(activityID: "expired", date: Date().addingTimeInterval(-0.05))])))
			}
		}) { error in XCTAssertNotNil(error); XCTAssertTrue(Thread.isMainThread); done.fulfill() }
		wait(for: [done], timeout: 5)
		XCTAssertEqual(delivery.pendingSnapshot().map { $0.identifier }, [original])
		XCTAssertTrue(delivery.addedIdentifiers().isEmpty)
	}

	func testCoalescedCallersCompleteOnlyAfterNewestPlanIsActuallyDelivered() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let firstStarted = expectation(description: "First plan requested")
		let allDone = expectation(description: "All callers receive applied newest plan")
		allDone.expectedFulfillmentCount = 3; allDone.assertForOverFulfill = true
		var releaseFirst: ((Result<ActivityReminderSchedule, Error>) -> Void)?
		var middleProviderCalled = false
		let completed: (Error?) -> Void = { error in
			XCTAssertTrue(Thread.isMainThread); XCTAssertNil(error)
			XCTAssertEqual(delivery.pendingSnapshot().map { $0.identifier }, [self.prefix + "latest"])
			allDone.fulfill()
		}
		subject.refresh(now: now, plan: { _, completion in releaseFirst = completion; firstStarted.fulfill() }, completion: completed)
		wait(for: [firstStarted], timeout: 5)
		subject.refresh(now: now, plan: { _, completion in middleProviderCalled = true; completion(.success(self.schedule(["middle"]))) }, completion: completed)
		subject.refresh(now: now, plan: { _, completion in completion(.success(self.schedule(["latest"]))) }, completion: completed)
		releaseFirst?(.success(schedule(["old"])))
		wait(for: [allDone], timeout: 5)
		XCTAssertFalse(middleProviderCalled)
		XCTAssertEqual(delivery.addedIdentifiers(), [prefix + "latest"])
	}

	func testCallersOfInFlightDeliveryWaitForNewerCleanupBeforeCompleting() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let adding = expectation(description: "Old delivery in progress")
		let allDone = expectation(description: "Both callers observe newest cleanup")
		allDone.expectedFulfillmentCount = 2; allDone.assertForOverFulfill = true
		let callbackLock = NSLock()
		var release: ((Error?) -> Void)?
		delivery.beforeAdd = { _, completion in callbackLock.lock(); release = completion; callbackLock.unlock(); adding.fulfill() }
		let completed: (Error?) -> Void = { error in
			XCTAssertNil(error); XCTAssertTrue(Thread.isMainThread)
			XCTAssertTrue(delivery.pendingSnapshot().isEmpty); allDone.fulfill()
		}
		subject.refresh(now: now, plan: { _, completion in completion(.success(self.schedule(["old"]))) }, completion: completed)
		wait(for: [adding], timeout: 5)
		subject.refresh(now: now, plan: { _, completion in
			completion(.success(ActivityReminderSchedule(enabled: false, activeActivityIDs: [], prompts: [])))
		}, completion: completed)
		callbackLock.lock(); let callback = release; callbackLock.unlock(); callback?(nil)
		wait(for: [allDone], timeout: 5)
	}

	func testNewestPlanFailureReachesEveryCoalescedCaller() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		let firstStarted = expectation(description: "Old provider requested")
		let allDone = expectation(description: "Newest failure reaches both callers")
		allDone.expectedFulfillmentCount = 2; allDone.assertForOverFulfill = true
		var releaseFirst: ((Result<ActivityReminderSchedule, Error>) -> Void)?
		let completed: (Error?) -> Void = { error in
			XCTAssertTrue(Thread.isMainThread)
			XCTAssertEqual((error as NSError?)?.domain, "ActivityReminderLatestPlanTest")
			allDone.fulfill()
		}
		subject.refresh(now: now, plan: { _, completion in releaseFirst = completion; firstStarted.fulfill() }, completion: completed)
		wait(for: [firstStarted], timeout: 5)
		subject.refresh(now: now, plan: { _, completion in
			completion(.failure(NSError(domain: "ActivityReminderLatestPlanTest", code: 1)))
		}, completion: completed)
		releaseFirst?(.success(schedule(["superseded"])))
		wait(for: [allDone], timeout: 5)
		XCTAssertTrue(delivery.pendingSnapshot().isEmpty)
		XCTAssertTrue(delivery.addedIdentifiers().isEmpty)
	}

	func testDeliveryErrorsReachMainAndDoNotBlockAFollowingPlan() {
		let delivery = ActivityScheduleDeliveryProbe(), subject = ActivityReminderScheduler(delivery: delivery)
		delivery.beforeAdd = { _, completion in completion(NSError(domain: "ActivityReminderDeliveryTest", code: 1)) }
		let failed = expectation(description: "Delivery error")
		subject.refresh(now: now, plan: { _, completion in completion(.success(self.schedule(["failed"]))) }) { error in
			XCTAssertTrue(Thread.isMainThread)
			XCTAssertEqual((error as NSError?)?.domain, "ActivityReminderDeliveryTest"); failed.fulfill()
		}
		wait(for: [failed], timeout: 5)
		delivery.beforeAdd = nil
		let recovered = expectation(description: "Later delivery succeeds")
		subject.refresh(now: now, plan: { _, completion in completion(.success(self.schedule(["recovered"]))) }) { error in
			XCTAssertNil(error); recovered.fulfill()
		}
		wait(for: [recovered], timeout: 5)
		XCTAssertEqual(delivery.pendingSnapshot().map { $0.identifier }, [prefix + "recovered"])
	}

	func testSharedSchedulingLockDefersProviderWithoutBlockingMainThread() throws {
		let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		defer { try? FileManager.default.removeItem(at: directory) }
		let lockURL = directory.appendingPathComponent("schedule.lock")
		let fd = open(lockURL.path, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR)
		XCTAssertGreaterThanOrEqual(fd, 0)
		guard fd >= 0 else { return }
		defer { _ = flock(fd, LOCK_UN); _ = close(fd) }
		XCTAssertEqual(flock(fd, LOCK_EX | LOCK_NB), 0)
		let subject = ActivityReminderScheduler(delivery: ActivityScheduleDeliveryProbe(), lockURL: lockURL)
		let earlyProvider = expectation(description: "Provider must wait for independent descriptor")
		earlyProvider.isInverted = true
		let done = expectation(description: "Provider resumes after unlock")
		var released = false
		subject.refresh(now: now, plan: { _, completion in
			XCTAssertTrue(Thread.isMainThread)
			if !released { earlyProvider.fulfill() }
			completion(.success(ActivityReminderSchedule(enabled: false, activeActivityIDs: [], prompts: [])))
		}) { error in XCTAssertNil(error); done.fulfill() }
		XCTAssertEqual(XCTWaiter.wait(for: [earlyProvider], timeout: 0.1), .completed)
		released = true
		XCTAssertEqual(flock(fd, LOCK_UN), 0)
		wait(for: [done], timeout: 5)
	}
}
