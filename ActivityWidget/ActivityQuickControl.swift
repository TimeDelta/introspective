import AppIntents
import Samples
import SwiftUI
import WidgetKit

struct ActivityControlConfigurationIntent: ControlConfigurationIntent {
	static var title: LocalizedStringResource = "Choose activity"
	@Parameter(title: "Activity") var activity: RecordableActivityEntity
}

private struct ActivityControlValue {
	let activity: RecordableActivityEntity
	let runningActivityID: String?
	var isRunning: Bool { runningActivityID != nil }
}

private struct ActivityControlProvider: AppIntentControlValueProvider {
	func previewValue(configuration: ActivityControlConfigurationIntent) -> ActivityControlValue {
		ActivityControlValue(activity: configuration.activity, runningActivityID: nil)
	}

	func currentValue(configuration: ActivityControlConfigurationIntent) async throws -> ActivityControlValue {
		try await read(configuration: configuration)
	}

	@MainActor private func read(configuration: ActivityControlConfigurationIntent) throws -> ActivityControlValue {
		let snapshot = try ActivityWidgetStore.snapshot()
		guard let definition = snapshot.definitions.first(where: { $0.id == configuration.activity.id }) else {
			throw ActivityControlError("This activity is no longer available. Edit the control to choose another activity.")
		}
		return ActivityControlValue(activity: RecordableActivityEntity(id: definition.id, name: definition.name),
			runningActivityID: snapshot.running.first(where: { $0.definitionID == definition.id })?.id)
	}
}

private struct ActivityControlError: LocalizedError {
	let message: String
	init(_ message: String) { self.message = message }
	var errorDescription: String? { message }
}

struct SetActivityRunningIntent: SetValueIntent {
	static var title: LocalizedStringResource = "Start or stop activity"
	static var openAppWhenRun = false
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Activity identifier") var definitionID: String
	@Parameter(title: "Running activity identifier") var runningActivityID: String?
	@Parameter(title: "Activity is running") var value: Bool
	init() {}
	init(definitionID: String, runningActivityID: String?) {
		self.definitionID = definitionID
		self.runningActivityID = runningActivityID
	}
	@MainActor func perform() async throws -> some IntentResult & OpensIntent {
		try SharedWidgetDependencies.prepare()
		let now = Date()
		var result = ActivityRecordingResult()
		if value {
			result = try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now)
		} else if let expectedActivityID = runningActivityID {
			// Capture the instance shown by the control, not whichever timer is newest now.
			result = try ActivityQuickRecorder.stop(activityID: expectedActivityID, at: now, recordedAt: now)
		}
		ActivityWidgetStore.didRecord()
		return ActivityWidgetStore.actionResult(noteActivityID: result.autoNoteActivityIDs.first)
	}
}

struct ActivityQuickControl: ControlWidget {
	var body: some ControlWidgetConfiguration {
		AppIntentControlConfiguration(kind: "ActivityQuickControl", provider: ActivityControlProvider()) { state in
			ControlWidgetToggle(state.activity.name, isOn: state.isRunning,
				action: SetActivityRunningIntent(definitionID: state.activity.id, runningActivityID: state.runningActivityID)) { isOn in
				Label(isOn ? "Running" : "Stopped", systemImage: isOn ? "stop.circle.fill" : "play.circle.fill")
			}
			.privacySensitive()
		}
		.displayName("Activity")
		.description("Start or stop a chosen activity from Control Center or the Lock Screen.")
		.promptsForUserConfiguration()
	}
}
