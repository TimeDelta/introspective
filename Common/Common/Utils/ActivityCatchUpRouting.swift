import Foundation

private struct ActivityCatchUpRoutingError: LocalizedError {
	var errorDescription: String? { "Open Introspective to review this activity." }
}

public struct ActivityCatchUpRoute: Codable, Equatable {
	public let activityID: String
	public let openNote: Bool
	public let editEndTime: Bool
	public init(activityID: String, openNote: Bool = false, editEndTime: Bool = true) {
		self.activityID = activityID
		self.openNote = openNote
		self.editEndTime = editEndTime
	}
}

/// Retain a notification's destination until the foreground app has navigation ready.
public final class ActivityCatchUpRouting {
	public static let shared = ActivityCatchUpRouting()
	public static let notification = Notification.Name("openActivityCatchUp")
	private static let pendingKey = "activityCatchUp.pendingRoute"
	private let defaults: UserDefaults?

	public init(defaults: UserDefaults? = UserDefaults(suiteName: "group.Introspective")) {
		self.defaults = defaults
	}

	public func request(activityID: String, openNote: Bool = false, editEndTime: Bool = true) throws {
		guard !activityID.isEmpty, let defaults = defaults else {
			throw ActivityCatchUpRoutingError()
		}
		let route = ActivityCatchUpRoute(activityID: activityID, openNote: openNote, editEndTime: editEndTime)
		defaults.set(try JSONEncoder().encode(route), forKey: Self.pendingKey)
		NotificationCenter.default.post(name: Self.notification, object: self)
	}

	public func takePending() -> ActivityCatchUpRoute? {
		guard let defaults = defaults, let data = defaults.data(forKey: Self.pendingKey) else { return nil }
		defaults.removeObject(forKey: Self.pendingKey)
		guard let route = try? JSONDecoder().decode(ActivityCatchUpRoute.self, from: data),
			!route.activityID.isEmpty else { return nil }
		return route
	}
}
