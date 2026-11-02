import Foundation
import Common
import DependencyInjection

public enum MoodReminderService {
	/// Extension entry points keep their work alive until notification replacement finishes.
	/// Notification failure never invalidates a successfully saved check-in.
	public static func refreshIfEnabled(completion: @escaping () -> Void = {}) {
		guard !CommandLine.arguments.contains("--testing"), !CommandLine.arguments.contains("--ui-testing"),
			(try? MoodTrackingPreferences.shared.reminders().enabled) == true else { completion(); return }
		refresh { _ in completion() }
	}
	public static func refresh(now: Date = Date(), preferences: MoodTrackingPreferences = .shared,
		scheduler: MoodReminderScheduler = .shared, completion: @escaping (Error?) -> Void = { _ in }) {
		guard Thread.isMainThread else {
			DispatchQueue.main.async { refresh(now: now, preferences: preferences, scheduler: scheduler, completion: completion) }
			return
		}
		do {
			let settings = try preferences.reminders()
			// Disabled reminders must still be removed if the database is unavailable.
			guard settings.enabled else { scheduler.replace(dates: [], completion: completion); return }
			let calendar = Calendar.current
			let dates = try injected(MoodDAO.self).getMoods(from: calendar.startOfDay(for: now), to: now).map { MoodWeeklyReview.timestamp(for: $0) }
			let plan = try MoodReminderPlan.dates(settings: settings, now: now, recordedDates: dates, calendar: calendar)
			scheduler.replace(dates: plan, calendar: calendar, completion: completion)
		} catch { completion(error) }
	}
}
