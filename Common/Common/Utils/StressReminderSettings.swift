import Foundation

/// One optional daily prompt leaves room for the existing mood reminder schedule.
public struct StressReminderSettings: Codable, Equatable {
	public var enabled = false
	/// Wall-clock minutes after midnight, independent of daylight-saving day length.
	public var minute = 18 * 60
	public var quietHoursEnabled = true
	public var quietStart = 22 * 60
	public var quietEnd = 8 * 60
	public var skipRecordedDays = true
	public init() {}

	internal var planningSettings: MoodReminderSettings {
		var value = MoodReminderSettings()
		value.enabled = enabled; value.times = [minute]
		value.quietHoursEnabled = quietHoursEnabled; value.quietStart = quietStart; value.quietEnd = quietEnd
		value.skipRecordedDays = skipRecordedDays
		return value
	}

	public func validate() throws { try planningSettings.validate() }
}

public final class StressReminderPreferences {
	public static let shared = StressReminderPreferences(defaults: UserDefaults(suiteName:
		CommandLine.arguments.contains("--ui-testing") ? "com.bnova.Introspective.stress-ui-tests" : MoodTrackingPreferences.groupIdentifier)!)
	private let defaults: UserDefaults
	private let key = "stressReminders.v1"
	public init(defaults: UserDefaults) { self.defaults = defaults }
	public func reminders() throws -> StressReminderSettings {
		guard let data = defaults.data(forKey: key) else { return StressReminderSettings() }
		let settings = try JSONDecoder().decode(StressReminderSettings.self, from: data)
		try settings.validate()
		return settings
	}
	public func save(reminders: StressReminderSettings) throws {
		try reminders.validate()
		defaults.set(try JSONEncoder().encode(reminders), forKey: key)
	}
}

public enum StressReminderPlan {
	public static let horizonDays = MoodReminderPlan.horizonDays
	public static func dates(settings: StressReminderSettings, now: Date, recordedDates: [Date],
		calendar: Calendar = .current) throws -> [Date] {
		guard now.timeIntervalSinceReferenceDate.isFinite else { throw MoodTrackingError("Choose a valid reminder date.") }
		return try MoodReminderPlan.dates(settings: settings.planningSettings, now: now,
			recordedDates: recordedDates.filter { $0.timeIntervalSinceReferenceDate.isFinite }, calendar: calendar)
	}
}
