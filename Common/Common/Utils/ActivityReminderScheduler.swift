import Foundation
import UserNotifications
import Darwin

public protocol ActivityReminderDelivery {
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void)
	func delivered(_ completion: @escaping ([UNNotificationRequest]) -> Void)
	func remove(_ identifiers: [String])
	func removeDelivered(_ identifiers: [String])
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void)
}

private final class SystemActivityReminderDelivery: ActivityReminderDelivery {
	private let center = UNUserNotificationCenter.current()
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) {
		center.getPendingNotificationRequests(completionHandler: completion)
	}
	func delivered(_ completion: @escaping ([UNNotificationRequest]) -> Void) {
		center.getDeliveredNotifications { completion($0.map { $0.request }) }
	}
	func remove(_ identifiers: [String]) { center.removePendingNotificationRequests(withIdentifiers: identifiers) }
	func removeDelivered(_ identifiers: [String]) { center.removeDeliveredNotifications(withIdentifiers: identifiers) }
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) {
		center.add(request, withCompletionHandler: completion)
	}
}

public struct ActivityReminderSchedule {
	public let enabled: Bool
	public let activeActivityIDs: Set<String>
	public let prompts: [ActivityReminderPrompt]
	public init(enabled: Bool, activeActivityIDs: Set<String>, prompts: [ActivityReminderPrompt]) {
		self.enabled = enabled; self.activeActivityIDs = activeActivityIDs; self.prompts = prompts
	}
}

/// Fetch the plan only after obtaining the shared scheduling lock. App, widget and
/// Siri updates therefore read the latest preferences/store rather than replaying
/// an old captured plan after a newer user's action has finished.
public final class ActivityReminderScheduler {
	public static let identifierPrefix = "activity-running."
	public static let categoryIdentifier = "activity-running-reminder"
	public static let activityIDUserInfoKey = "activityID"
	public static let shared = ActivityReminderScheduler(delivery: SystemActivityReminderDelivery(), lockURL:
		FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ActivityReminderPreferences.groupIdentifier)?
			.appendingPathComponent("activity-reminder-schedule.lock"))
	public typealias PlanProvider = (Int, @escaping (Result<ActivityReminderSchedule, Error>) -> Void) -> Void
	private struct Replacement {
		let now: Date?
		let provider: PlanProvider
		var completions: [(Error?) -> Void]
	}
	private let delivery: ActivityReminderDelivery
	private let lockURL: URL?
	private let queue = DispatchQueue(label: "Introspective.activity-reminder-scheduler")
	private var running = false
	private var pendingReplacement: Replacement?
	private var lockDescriptor: Int32?

	public init(delivery: ActivityReminderDelivery, lockURL: URL? = nil) {
		self.delivery = delivery; self.lockURL = lockURL
	}

	public func refresh(now: Date? = nil, plan: @escaping PlanProvider,
		completion: @escaping (Error?) -> Void = { _ in }) {
		queue.async {
			if let now = now, !now.timeIntervalSinceReferenceDate.isFinite {
				DispatchQueue.main.async { completion(ActivityReminderError("Choose a valid reminder time.")) }; return
			}
			let waiting = self.pendingReplacement?.completions ?? []
			self.pendingReplacement = Replacement(now: now, provider: plan, completions: waiting + [completion])
			self.drain()
		}
	}

	private func drain() {
		guard !running, let replacement = pendingReplacement else { return }
		pendingReplacement = nil; running = true
		do { try acquireLock() }
		catch { finish(replacement, error: error); return }
		delivery.pending { pending in
			self.delivery.delivered { delivered in
				self.queue.async {
					let otherCount = pending.filter { !$0.identifier.hasPrefix(Self.identifierPrefix) }.count
					let capacity = min(ActivityReminderPlan.maximumPending, max(0, 64 - otherCount))
					DispatchQueue.main.async {
						replacement.provider(capacity) { result in
							self.queue.async {
								// A newer in-process request should compute its own current plan.
								guard self.pendingReplacement == nil else { self.finish(replacement, error: nil); return }
								switch result {
								case let .failure(error): self.finish(replacement, error: error)
								case let .success(plan): self.apply(plan, pending: pending, delivered: delivered,
									capacity: capacity, replacement: replacement)
								}
							}
						}
					}
				}
			}
		}
	}

	private func apply(_ plan: ActivityReminderSchedule, pending: [UNNotificationRequest],
		delivered: [UNNotificationRequest], capacity: Int, replacement: Replacement) {
		// Lock acquisition and fetching the plan may take time. Use the actual
		// delivery time unless the caller supplied a deterministic reference time.
		let now = replacement.now ?? Date()
		guard plan.prompts.count <= capacity, Set(plan.prompts.map { $0.activityID }).count == plan.prompts.count,
			(plan.enabled || plan.prompts.isEmpty), plan.prompts.allSatisfy({
				!$0.activityID.isEmpty && plan.activeActivityIDs.contains($0.activityID) &&
					$0.date.timeIntervalSinceReferenceDate.isFinite && $0.date > now
			}) else {
			finish(replacement, error: ActivityReminderError("The activity reminder schedule is invalid.")); return
		}
		delivery.remove(pending.map { $0.identifier }.filter { $0.hasPrefix(Self.identifierPrefix) })
		let staleDelivered = delivered.filter { request in
			guard request.identifier.hasPrefix(Self.identifierPrefix) else { return false }
			guard plan.enabled, let id = request.content.userInfo[Self.activityIDUserInfoKey] as? String else { return true }
			return !plan.activeActivityIDs.contains(id)
		}
		delivery.removeDelivered(staleDelivered.map { $0.identifier })
		guard !plan.prompts.isEmpty else { finish(replacement, error: nil); return }
		var remaining = plan.prompts.count
		var firstError: Error?
		for prompt in plan.prompts {
			let content = UNMutableNotificationContent()
			content.title = "Still doing this?"
			content.body = "An activity is still running. Continue it or review when it ended."
			content.categoryIdentifier = Self.categoryIdentifier
			content.threadIdentifier = "activity-reminders"
			content.sound = .default
			content.userInfo = [Self.activityIDUserInfoKey: prompt.activityID]
			let request = UNNotificationRequest(identifier: Self.identifierPrefix + prompt.activityID, content: content,
				trigger: UNTimeIntervalNotificationTrigger(timeInterval: max(1, prompt.date.timeIntervalSince(now)), repeats: false))
			delivery.add(request) { error in
				self.queue.async {
					if firstError == nil { firstError = error }
					remaining -= 1
					if remaining == 0 { self.finish(replacement, error: firstError) }
				}
			}
		}
	}

	private func acquireLock() throws {
		guard let lockURL = lockURL else { return }
		let descriptor = open(lockURL.path, O_CREAT | O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR)
		guard descriptor >= 0 else { throw ActivityReminderError("Activity reminders are unavailable. Unlock the device and try again.") }
		// Only this scheduler's worker queue waits. Never block the main queue that
		// provides a fresh Core Data snapshot or a notification response callback.
		guard flock(descriptor, LOCK_EX) == 0 else {
			_ = close(descriptor); throw ActivityReminderError("Activity reminders could not be updated.")
		}
		lockDescriptor = descriptor
	}

	private func finish(_ replacement: Replacement, error: Error?) {
		if let descriptor = lockDescriptor { _ = flock(descriptor, LOCK_UN); _ = close(descriptor); lockDescriptor = nil }
		running = false
		if var newest = pendingReplacement {
			// An awaited caller keeps its app/extension alive until the newest
			// reconciliation is actually delivered, even when requests coalesce.
			newest.completions = replacement.completions + newest.completions
			pendingReplacement = newest
		} else {
			DispatchQueue.main.async { replacement.completions.forEach { $0(error) } }
		}
		drain()
	}
}
