import AppIntents
import Foundation
import Samples

/// Included in both the app and activity extension so the foreground intent runs in the app.
/// Persist before notifying to cover an app launch whose activity screen is not ready yet.
@MainActor enum ActivityNoteRouting {
	static let suiteName = "group.Introspective"
	static let pendingActivityIDKey = "activityRecording.pendingAutoNoteActivityID"
	static let notification = Notification.Name("openActivityNoteRequested")

	static func request(_ activityID: String) throws {
		guard let defaults = UserDefaults(suiteName: suiteName) else {
			throw ActivityRecordingError("Open Introspective to add a note to this activity.")
		}
		defaults.set(activityID, forKey: pendingActivityIDKey)
		NotificationCenter.default.post(name: notification, object: nil)
	}

	static func takePending() -> String? {
		guard let defaults = UserDefaults(suiteName: suiteName),
			let activityID = defaults.string(forKey: pendingActivityIDKey) else { return nil }
		defaults.removeObject(forKey: pendingActivityIDKey)
		return activityID
	}
}

struct OpenActivityNoteIntent: AppIntent {
	static var title: LocalizedStringResource = "Add activity note"
	static var description = IntentDescription("Open the stopped activity's note editor.")
	static var openAppWhenRun = true
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Activity identifier") var activityID: String
	init() {}
	init(activityID: String) { self.activityID = activityID }
	@MainActor func perform() async throws -> some IntentResult {
		try ActivityNoteRouting.request(activityID)
		return .result()
	}
}
