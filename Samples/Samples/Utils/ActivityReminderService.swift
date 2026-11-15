import CoreData
import Foundation
import UserNotifications

import Common

public struct ActivityReminderActionResult: Equatable {
	public let activityID: String?
	public let didChange: Bool
	public let autoNoteActivityID: String?
	public let shouldOpenReview: Bool
	public init(activityID: String? = nil, didChange: Bool = false,
		autoNoteActivityID: String? = nil, shouldOpenReview: Bool = false) {
		self.activityID = activityID; self.didChange = didChange
		self.autoNoteActivityID = autoNoteActivityID; self.shouldOpenReview = shouldOpenReview
	}
}

/// Reconcile only exact running-instance identities. Notification actions never
/// infer that the newest instance of an activity is the one the user selected.
public enum ActivityReminderService {
	public static let categoryIdentifier = ActivityReminderScheduler.categoryIdentifier
	public static let continueActionIdentifier = "activity-reminder.continue"
	public static let stopActionIdentifier = "activity-reminder.stop"
	public static let reviewActionIdentifier = "activity-reminder.review"
	public static let activityIDUserInfoKey = ActivityReminderScheduler.activityIDUserInfoKey
	public static let openReviewNotification = Notification.Name("openActivityCatchUp")
	public static let openAutoNoteNotification = Notification.Name("openActivityAutoNote")
	private static let observerLock = NSLock()
	private static var observer: NSObjectProtocol?
	/// Accessed only on the main queue; bulk imports need one fresh reconciliation.
	private static var pendingRefresh: DispatchWorkItem?

	public static func refresh(now: Date? = nil, preferences: ActivityReminderPreferences = .shared,
		scheduler: ActivityReminderScheduler = .shared,
		completion: @escaping (Error?) -> Void = { _ in }) {
		guard Thread.isMainThread else {
			DispatchQueue.main.async { refresh(now: now, preferences: preferences, scheduler: scheduler, completion: completion) }
			return
		}
		// The provider executes after the scheduler obtains its cross-process lock.
		// A delayed widget update therefore reads today's settings and store state.
		scheduler.refresh(now: now, plan: { capacity, finish in
			do {
				let settings = try preferences.settings()
				guard settings.enabled else {
					// Disabling must work even if the protected store cannot be opened.
					finish(.success(ActivityReminderSchedule(enabled: false, activeActivityIDs: [], prompts: [])))
					return
				}
				// The default time must be sampled after waiting for another process.
				// Otherwise a timer started while waiting could disappear from this plan.
				let snapshot = try ActivityQuickRecorder.snapshot()
				let planningTime = now ?? Date()
				let running = snapshot.running.filter { $0.start <= planningTime }
				let prompts = try preferences.plan(running: running.map {
					ActivityReminderRunningActivity(id: $0.id, start: $0.start)
				}, now: planningTime, maximumPending: capacity)
				finish(.success(ActivityReminderSchedule(enabled: true,
					activeActivityIDs: Set(running.map { $0.id }), prompts: prompts)))
			} catch { finish(.failure(error)) }
		}, completion: completion)
	}

	public static func handleResponse(actionIdentifier: String, userInfo: [AnyHashable: Any],
		now: Date? = nil, preferences: ActivityReminderPreferences = .shared,
		scheduler: ActivityReminderScheduler = .shared,
		completion: @escaping (Result<ActivityReminderActionResult, Error>) -> Void) {
		guard Thread.isMainThread else {
			DispatchQueue.main.async {
				handleResponse(actionIdentifier: actionIdentifier, userInfo: userInfo, now: now,
					preferences: preferences, scheduler: scheduler, completion: completion)
			}
			return
		}
		guard actionIdentifier != UNNotificationDismissActionIdentifier else {
			// The saved due date remains consumed; dismissal does not create a new prompt.
			completion(.success(ActivityReminderActionResult())); return
		}
		do {
			let actionTime = now ?? Date()
			guard actionTime.timeIntervalSinceReferenceDate.isFinite,
				let id = userInfo[activityIDUserInfoKey] as? String, !id.isEmpty else {
				throw ActivityReminderError("This activity reminder is no longer available.")
			}
			let result: ActivityReminderActionResult
			switch actionIdentifier {
			case continueActionIdentifier:
				if let activity = try ActivityQuickRecorder.snapshot().running.first(where: { $0.id == id && $0.start <= actionTime }) {
					try preferences.snooze(activityID: id, startedAt: activity.start, now: actionTime)
					result = ActivityReminderActionResult(activityID: id)
				} else {
					// An old Continue action must not apply to a restarted instance.
					result = ActivityReminderActionResult()
				}
			case stopActionIdentifier:
				let stopped = try ActivityQuickRecorder.stop(activityID: id, at: actionTime, recordedAt: actionTime)
				result = ActivityReminderActionResult(activityID: id, didChange: stopped.didChange,
					autoNoteActivityID: stopped.autoNoteActivityIDs.first)
			case reviewActionIdentifier, UNNotificationDefaultActionIdentifier:
				// End earlier opens this saved record, including one stopped meanwhile.
				_ = try ActivityCatchUpService.activity(id: id)
				result = ActivityReminderActionResult(activityID: id, shouldOpenReview: true)
			default:
				throw ActivityReminderError("This activity reminder action is not supported.")
			}
			refresh(now: now, preferences: preferences, scheduler: scheduler) { error in
				// A successfully saved Stop remains successful if reminder cleanup fails.
				// Continue must report a scheduling failure rather than claim another prompt.
				if let error = error, actionIdentifier == continueActionIdentifier, result.activityID != nil {
					completion(.failure(error))
				} else { completion(.success(result)) }
			}
		} catch { completion(.failure(error)) }
	}

	public static func startObserving() {
		observerLock.lock(); defer { observerLock.unlock() }
		guard observer == nil else { return }
		observer = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
			object: nil, queue: nil) { notification in
			// Managed objects are inspected on the queue that sent the save notification.
			let relevant = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey].contains { key in
				(notification.userInfo?[key] as? Set<NSManagedObject>)?.contains {
					$0.entity.name == Activity.entityName || $0.entity.name == ActivityDefinition.entityName
				} == true
			}
			guard relevant else { return }
			DispatchQueue.main.async {
				pendingRefresh?.cancel()
				let work = DispatchWorkItem {
					// With reminders off, ordinary saves do not touch DI or notification delivery.
					guard (try? ActivityReminderPreferences.shared.settings().enabled) == true else { return }
					refresh()
				}
				pendingRefresh = work
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
			}
		}
	}
}
