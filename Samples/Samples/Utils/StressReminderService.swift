import Foundation
import CoreData
import Common
import DependencyInjection
import Persistence

public enum StressReminderService {
	/// Reminders use their own completed days; recording a mood does not complete a stress check-in.
	public static func refresh(now: Date = Date(), calendar: Calendar = .current,
		preferences: StressReminderPreferences = .shared, scheduler: StressReminderScheduler = .shared,
		completion: @escaping (Error?) -> Void = { _ in }) {
		guard Thread.isMainThread else {
			DispatchQueue.main.async { refresh(now: now, calendar: calendar, preferences: preferences, scheduler: scheduler, completion: completion) }
			return
		}
		do {
			let settings = try preferences.reminders()
			// Disabled prompts must be removable even if the database cannot be read.
			guard settings.enabled else { scheduler.replace(dates: [], completion: completion); return }
			guard now.timeIntervalSinceReferenceDate.isFinite else { throw MoodTrackingError("Choose a valid reminder date.") }
			var dates: [Date] = []
			if settings.skipRecordedDays {
				let request = StressCheckIn.fetchRequest()
				request.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp <= %@ AND overallRating >= 0 AND overallRating <= 4 AND measurementKind == %@ AND scaleVersion == 1",
					calendar.startOfDay(for: now) as NSDate, now as NSDate, "momentary")
				request.fetchLimit = 1
				dates = try injected(Database.self).query(request).map { $0.timestamp }
			}
			let plan = try StressReminderPlan.dates(settings: settings, now: now, recordedDates: dates, calendar: calendar)
			scheduler.replace(dates: plan, calendar: calendar, completion: completion)
		} catch { completion(error) }
	}
}
