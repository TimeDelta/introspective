import Foundation
import UserNotifications

private final class SystemStressReminderDelivery: MoodReminderDelivery {
	let center = UNUserNotificationCenter.current()
	func pending(_ completion: @escaping ([UNNotificationRequest]) -> Void) { center.getPendingNotificationRequests(completionHandler: completion) }
	func remove(_ identifiers: [String]) { center.removePendingNotificationRequests(withIdentifiers: identifiers) }
	func add(_ request: UNNotificationRequest, completion: @escaping (Error?) -> Void) { center.add(request, withCompletionHandler: completion) }
}

/// Replacements are serialized through delivery callbacks; the newest waiting plan wins.
public final class StressReminderScheduler {
	public static let shared = StressReminderScheduler(delivery: SystemStressReminderDelivery())
	public static let identifierPrefix = "stress-check-in."
	public static let categoryIdentifier = "stress-check-in-reminder"
	public static let openCheckInNotification = Notification.Name("openStressCheckIn")
	private let delivery: MoodReminderDelivery
	private let queue = DispatchQueue(label: "Introspective.stress-reminder-scheduler")
	private var running = false
	private var pending: (dates: [Date], calendar: Calendar, completion: (Error?) -> Void)?
	public init(delivery: MoodReminderDelivery) { self.delivery = delivery }

	public func replace(dates: [Date], calendar: Calendar = .current, completion: @escaping (Error?) -> Void = { _ in }) {
		queue.async {
			guard dates.allSatisfy({ $0.timeIntervalSinceReferenceDate.isFinite }) else {
				completion(MoodTrackingError("Choose valid reminder dates.")); return
			}
			self.pending?.completion(nil)
			self.pending = (Array(Set(dates)).sorted(), calendar, completion)
			self.drain()
		}
	}

	private func drain() {
		guard !running, let plan = pending else { return }
		pending = nil; running = true
		delivery.pending { requests in
			self.queue.async {
				self.delivery.remove(requests.map { $0.identifier }.filter { $0.hasPrefix(Self.identifierPrefix) })
				guard !plan.dates.isEmpty else { self.finish(plan.completion, error: nil); return }
				var remaining = plan.dates.count
				var firstError: Error?
				for date in plan.dates {
					let content = UNMutableNotificationContent()
					content.title = "Check-in reminder"; content.body = "Take a moment to check in."
					content.categoryIdentifier = Self.categoryIdentifier; content.threadIdentifier = "stress-check-ins"
					var components = plan.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
					components.calendar = plan.calendar; components.timeZone = plan.calendar.timeZone
					let request = UNNotificationRequest(identifier: Self.identifierPrefix + String(date.timeIntervalSince1970),
						content: content, trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false))
					self.delivery.add(request) { error in
						self.queue.async {
							if firstError == nil { firstError = error }
							remaining -= 1
							if remaining == 0 { self.finish(plan.completion, error: firstError) }
						}
					}
				}
			}
		}
	}

	private func finish(_ completion: (Error?) -> Void, error: Error?) {
		running = false; completion(error); drain()
	}
}
