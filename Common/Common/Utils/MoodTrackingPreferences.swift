import Foundation

public struct MoodTrackingError: LocalizedError {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
}

/// A rating retains its original scale even if the user's recording settings change.
public struct MoodCheckInPreset: Codable, Equatable {
	public let id: UUID
	public var name: String
	public var rating: Double
	public var minimum: Double
	public var maximum: Double
	public var note: String
	public var contexts: [String]

	public init(id: UUID = UUID(), name: String, rating: Double, minimum: Double, maximum: Double,
		note: String = "", contexts: [String] = []) {
		self.id = id; self.name = name; self.rating = rating; self.minimum = minimum; self.maximum = maximum
		self.note = note; self.contexts = contexts
	}
	public func validate() throws {
		guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, name.count <= 60 else {
			throw MoodTrackingError("Give the preset a name of up to 60 characters.")
		}
		guard rating.isFinite, minimum.isFinite, maximum.isFinite, maximum > minimum,
			(maximum - minimum).isFinite, rating >= minimum, rating <= maximum else {
			throw MoodTrackingError("Choose a finite rating within a valid minimum and maximum.")
		}
		guard note.count <= 4000, contexts.count <= 7, Set(contexts).count == contexts.count else {
			throw MoodTrackingError("Use a note of up to 4,000 characters and distinct context selections.")
		}
	}
}

public struct MoodReminderSettings: Codable, Equatable {
	public var enabled = false
	/// Local minutes after midnight. At most three daily times.
	public var times: [Int] = [18 * 60]
	public var quietHoursEnabled = true
	public var quietStart = 22 * 60
	public var quietEnd = 8 * 60
	public var skipRecordedDays = true
	public init() {}
	public func isQuiet(_ minute: Int) -> Bool {
		guard quietHoursEnabled else { return false }
		return quietStart < quietEnd ? (quietStart..<quietEnd).contains(minute) : minute >= quietStart || minute < quietEnd
	}
	public func validate() throws {
		guard !times.isEmpty, times.count <= 3, Set(times).count == times.count,
			times.allSatisfy({ (0..<1440).contains($0) }),
			(0..<1440).contains(quietStart), (0..<1440).contains(quietEnd) else {
			throw MoodTrackingError("Choose one to three distinct reminder times.")
		}
		guard !quietHoursEnabled || quietStart != quietEnd else {
			throw MoodTrackingError("Choose different start and end times for quiet hours.")
		}
		guard !enabled || !times.contains(where: isQuiet) else {
			throw MoodTrackingError("Move reminder times outside your quiet hours, or turn quiet hours off.")
		}
	}
}

public final class MoodTrackingPreferences {
	public static let groupIdentifier = "group.Introspective"
	public static let shared = MoodTrackingPreferences(defaults: UserDefaults(suiteName:
		CommandLine.arguments.contains("--ui-testing") ? "com.bnova.Introspective.mood-ui-tests" : groupIdentifier)!)
	private let defaults: UserDefaults
	private let presetsKey = "moodCheckInPresets.v1"
	private let remindersKey = "moodReminders.v1"
	public init(defaults: UserDefaults) { self.defaults = defaults }
	public func presets() throws -> [MoodCheckInPreset] {
		guard let data = defaults.data(forKey: presetsKey) else { return [] }
		let values = try JSONDecoder().decode([MoodCheckInPreset].self, from: data)
		try validate(values)
		return values
	}
	public func save(presets: [MoodCheckInPreset]) throws {
		try validate(presets)
		defaults.set(try JSONEncoder().encode(presets), forKey: presetsKey)
	}
	private func validate(_ presets: [MoodCheckInPreset]) throws {
		guard presets.count <= 20, Set(presets.map { $0.id }).count == presets.count else {
			throw MoodTrackingError("Keep up to 20 distinct check-in presets.")
		}
		for preset in presets { try preset.validate() }
	}
	public func reminders() throws -> MoodReminderSettings {
		guard let data = defaults.data(forKey: remindersKey) else { return MoodReminderSettings() }
		let settings = try JSONDecoder().decode(MoodReminderSettings.self, from: data)
		try settings.validate()
		return settings
	}
	public func save(reminders: MoodReminderSettings) throws {
		try reminders.validate()
		defaults.set(try JSONEncoder().encode(reminders), forKey: remindersKey)
	}
}

public enum MoodReminderPlan {
	/// One-shot requests allow a check-in to cancel today's reminders without cancelling future days.
	/// Fourteen days x three times stays below iOS's 64-request limit, leaving room for other notices.
	public static let horizonDays = 14
	public static func dates(settings: MoodReminderSettings, now: Date, recordedDates: [Date],
		calendar: Calendar = .current) throws -> [Date] {
		try settings.validate()
		guard settings.enabled else { return [] }
		let recordedDays = Set(recordedDates.filter { $0 <= now }.map { calendar.startOfDay(for: $0) })
		let today = calendar.startOfDay(for: now)
		var dates = Set<Date>()
		for offset in 0..<horizonDays {
			guard let day = calendar.date(byAdding: .day, value: offset, to: today),
				!settings.skipRecordedDays || !recordedDays.contains(calendar.startOfDay(for: day)) else { continue }
			for minute in settings.times {
				guard let date = calendar.date(bySettingHour: minute / 60, minute: minute % 60, second: 0, of: day,
					matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward),
					date > now, calendar.isDate(date, inSameDayAs: day) else { continue }
				let components = calendar.dateComponents([.hour, .minute], from: date)
				guard !settings.isQuiet((components.hour ?? 0) * 60 + (components.minute ?? 0)) else { continue }
				dates.insert(date)
			}
		}
		return dates.sorted()
	}
}
