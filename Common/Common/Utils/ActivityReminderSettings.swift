import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public struct ActivityReminderError: LocalizedError, Equatable {
	public let message: String
	public init(_ message: String) { self.message = message }
	public var errorDescription: String? { message }
}

public struct ActivityReminderSettings: Codable, Equatable {
	public static let allowedIntervals = [30, 60, 120, 240]
	public var enabled = false
	/// Elapsed minutes, rather than a wall-clock appointment or rounded activity time.
	public var intervalMinutes = 120
	public init() {}
	public func validate() throws {
		guard Self.allowedIntervals.contains(intervalMinutes) else {
			throw ActivityReminderError("Choose a reminder interval of 30, 60, 120 or 240 minutes.")
		}
	}
}

public struct ActivityReminderRunningActivity: Equatable {
	public let id: String
	public let start: Date
	public init(id: String, start: Date) { self.id = id; self.start = start }
}

public struct ActivityReminderPrompt: Equatable {
	public let activityID: String
	public let date: Date
	public init(activityID: String, date: Date) { self.activityID = activityID; self.date = date }
}

public enum ActivityReminderPlan {
	/// Mood and stress can use 56 of iOS's 64 pending notification slots.
	public static let maximumPending = 8
}

/// Only exact instance identities and reminder times are stored; names and notes are not copied.
public final class ActivityReminderPreferences {
	public static let groupIdentifier = "group.Introspective"
	public static let shared: ActivityReminderPreferences = {
		let suite = CommandLine.arguments.contains("--ui-testing")
			? "com.bnova.Introspective.activity-reminder-ui-tests" : groupIdentifier
		let defaults = UserDefaults(suiteName: suite)!
		#if canImport(Darwin)
		let lockURL = CommandLine.arguments.contains("--ui-testing") ? nil :
			FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)?
				.appendingPathComponent("activity-reminder-preferences.lock")
		#else
		let lockURL: URL? = nil
		#endif
		return ActivityReminderPreferences(defaults: defaults, lockURL: lockURL)
	}()

	private struct Instance: Codable {
		let startedAt: Date
		let due: Date
	}
	private struct Document: Codable {
		var settings = ActivityReminderSettings()
		var instances: [String: Instance] = [:]
	}
	private static let processLock = NSLock()
	private let defaults: UserDefaults
	private let lockURL: URL?
	private let key = "activityReminders.v1"
	public init(defaults: UserDefaults, lockURL: URL? = nil) {
		self.defaults = defaults; self.lockURL = lockURL
	}

	public func settings() throws -> ActivityReminderSettings { try locked { try read().settings } }

	public func save(settings: ActivityReminderSettings) throws {
		try settings.validate()
		try locked {
			// An explicit valid Save also lets the user repair damaged preferences.
			var document = (try? read()) ?? Document()
			if document.settings != settings || !settings.enabled { document.instances = [:] }
			document.settings = settings
			try write(document)
		}
	}

	/// Reconcile a fresh snapshot. An elapsed due date remains consumed until Continue;
	/// reopening the app must not turn an ignored prompt into a repeated reminder.
	public func plan(running: [ActivityReminderRunningActivity], now: Date,
		maximumPending: Int = ActivityReminderPlan.maximumPending) throws -> [ActivityReminderPrompt] {
		guard now.timeIntervalSinceReferenceDate.isFinite else { throw ActivityReminderError("Choose a valid reminder time.") }
		return try locked {
			var document = try read()
			guard document.settings.enabled else {
				document.instances = [:]; try write(document); return []
			}
			let activities = Dictionary(grouping: running.filter {
				!$0.id.isEmpty && $0.start.timeIntervalSinceReferenceDate.isFinite && $0.start <= now
			}, by: { $0.id }).compactMapValues { $0.max(by: { $0.start < $1.start }) }
			document.instances = document.instances.filter { id, state in
				activities[id]?.start == state.startedAt && state.due.timeIntervalSinceReferenceDate.isFinite
			}
			let interval = TimeInterval(document.settings.intervalMinutes * 60)
			var candidates: [ActivityReminderPrompt] = []
			for activity in activities.values {
				if let state = document.instances[activity.id] {
					if state.due > now { candidates.append(ActivityReminderPrompt(activityID: activity.id, date: state.due)) }
				} else {
					let originalDue = activity.start.addingTimeInterval(interval)
					let due = originalDue > now ? originalDue : now.addingTimeInterval(interval)
					candidates.append(ActivityReminderPrompt(activityID: activity.id, date: due))
				}
			}
			let count = min(ActivityReminderPlan.maximumPending, max(0, maximumPending))
			let selected = Array(candidates.sorted {
				$0.date == $1.date ? $0.activityID < $1.activityID : $0.date < $1.date
			}.prefix(count))
			for prompt in selected {
				if let activity = activities[prompt.activityID] {
					document.instances[prompt.activityID] = Instance(startedAt: activity.start, due: prompt.date)
				}
			}
			try write(document)
			return selected
		}
	}

	public func snooze(activityID: String, startedAt: Date, now: Date) throws {
		guard !activityID.isEmpty, now.timeIntervalSinceReferenceDate.isFinite,
			startedAt.timeIntervalSinceReferenceDate.isFinite, startedAt <= now else {
			throw ActivityReminderError("Choose a current running activity.")
		}
		try locked {
			var document = try read()
			guard document.settings.enabled else { throw ActivityReminderError("Activity reminders are turned off.") }
			document.instances[activityID] = Instance(startedAt: startedAt,
				due: now.addingTimeInterval(TimeInterval(document.settings.intervalMinutes * 60)))
			try write(document)
		}
	}

	private func read() throws -> Document {
		_ = defaults.synchronize()
		guard let data = defaults.data(forKey: key) else { return Document() }
		let document: Document
		do { document = try JSONDecoder().decode(Document.self, from: data) }
		catch { throw ActivityReminderError("Activity reminder preferences could not be read. Save the reminder settings again to reset them.") }
		try document.settings.validate()
		return document
	}
	private func write(_ document: Document) throws {
		defaults.set(try JSONEncoder().encode(document), forKey: key)
		_ = defaults.synchronize()
	}
	private func locked<T>(_ action: () throws -> T) throws -> T {
		Self.processLock.lock(); defer { Self.processLock.unlock() }
		var descriptor: Int32?
		if let lockURL = lockURL {
			let fd = open(lockURL.path, O_CREAT | O_RDWR | O_CLOEXEC, S_IRUSR | S_IWUSR)
			guard fd >= 0 else { throw ActivityReminderError("Activity reminder settings are unavailable. Unlock the device and try again.") }
			guard flock(fd, LOCK_EX) == 0 else {
				_ = close(fd); throw ActivityReminderError("Activity reminder settings are busy. Please try again.")
			}
			descriptor = fd
		}
		defer { if let descriptor = descriptor { _ = flock(descriptor, LOCK_UN); _ = close(descriptor) } }
		return try action()
	}
}
