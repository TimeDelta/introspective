import AppIntents
import DependencyInjection
import Persistence
import Samples
import SwiftUI
import WidgetKit

/// Stable identities avoid binding a widget to another activity after a rename.
struct RecordableActivityEntity: AppEntity {
	static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Activity")
	static var defaultQuery = RecordableActivityQuery()
	let id: String
	let name: String
	var displayRepresentation: DisplayRepresentation { DisplayRepresentation(title: "\(name)") }
}

struct RecordableActivityQuery: EntityQuery {
	func entities(for identifiers: [String]) async throws -> [RecordableActivityEntity] {
		let entities = try await allEntities()
		return identifiers.compactMap { id in entities.first { $0.id == id } }
	}

	func suggestedEntities() async throws -> [RecordableActivityEntity] { try await allEntities() }

	@MainActor private func allEntities() throws -> [RecordableActivityEntity] {
		try ActivityWidgetStore.snapshot().definitions.map { RecordableActivityEntity(id: $0.id, name: $0.name) }
	}
}

struct ActivityWidgetConfigurationIntent: WidgetConfigurationIntent {
	static var title: LocalizedStringResource = "Choose activity"
	static var description = IntentDescription("Choose the activity to start, stop, or switch to from this widget.")
	@Parameter(title: "Activity") var activity: RecordableActivityEntity?
}

typealias ActivityWidgetActionResult = IntentResultContainer<Never, OpenActivityNoteIntent, Never, Never>

@MainActor enum ActivityWidgetStore {
	static let setupURL = URL(string: "introspective://activities")!
	static let widgetKind = "ActivityQuickRecordWidget"
	static let controlKind = "ActivityQuickControl"

	static func snapshot() throws -> ActivityRecordingSnapshot {
		try SharedWidgetDependencies.prepare()
		return try ActivityQuickRecorder.snapshot()
	}

	static func didRecord() {
		injected(Database.self).setModifiedExternally(true)
		WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
		ControlCenter.shared.reloadControls(ofKind: controlKind)
	}

	static func actionResult(noteActivityID: String?) -> ActivityWidgetActionResult {
		// The explicit generic container uses the iOS 16+ overload. The erased
		// opensIntent result is newer than this extension's iOS 18.0 minimum.
		var result: ActivityWidgetActionResult = .result(
			opensIntent: OpenActivityNoteIntent(activityID: noteActivityID ?? ""))
		result.opensIntent = noteActivityID.map { OpenActivityNoteIntent(activityID: $0) }
		return result
	}
}

struct StartRecordedActivityIntent: AppIntent {
	static var title: LocalizedStringResource = "Start activity"
	static var description = IntentDescription("Start the chosen activity, keeping other activities running.")
	static var openAppWhenRun = false
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Activity identifier") var definitionID: String
	init() {}
	init(definitionID: String) { self.definitionID = definitionID }
	@MainActor func perform() async throws -> some IntentResult {
		try SharedWidgetDependencies.prepare()
		let now = Date()
		try ActivityQuickRecorder.start(definitionID: definitionID, at: now, recordedAt: now)
		ActivityWidgetStore.didRecord()
		return .result()
	}
}

struct StopRecordedActivityIntent: AppIntent {
	static var title: LocalizedStringResource = "Stop activity"
	static var description = IntentDescription("Stop the running activity shown in the widget.")
	static var openAppWhenRun = false
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Running activity identifier") var activityID: String
	init() {}
	init(activityID: String) { self.activityID = activityID }
	@MainActor func perform() async throws -> some IntentResult & OpensIntent {
		try SharedWidgetDependencies.prepare()
		let now = Date()
		// An old Stop button must never stop a later instance of this definition.
		let result = try ActivityQuickRecorder.stop(activityID: activityID, at: now, recordedAt: now)
		ActivityWidgetStore.didRecord()
		return ActivityWidgetStore.actionResult(noteActivityID: result.autoNoteActivityIDs.first)
	}
}

struct SwitchRecordedActivityIntent: AppIntent {
	static var title: LocalizedStringResource = "Switch activity"
	static var description = IntentDescription("End the selected running activity and start another at the same instant.")
	static var openAppWhenRun = false
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Running activity identifier") var activityID: String
	@Parameter(title: "Next activity identifier") var definitionID: String
	init() {}
	init(activityID: String, definitionID: String) {
		self.activityID = activityID
		self.definitionID = definitionID
	}
	@MainActor func perform() async throws -> some IntentResult & OpensIntent {
		try SharedWidgetDependencies.prepare()
		let now = Date()
		let result = try ActivityQuickRecorder.switchActivity(from: activityID, to: definitionID, at: now, recordedAt: now)
		ActivityWidgetStore.didRecord()
		return ActivityWidgetStore.actionResult(noteActivityID: result.autoNoteActivityIDs.first)
	}
}

private struct ActivityWidgetItem: Identifiable {
	let id: String
	let definitionID: String
	let name: String
	let start: Date
}

private struct ActivityWidgetEntry: TimelineEntry {
	let date: Date
	let activity: RecordableActivityEntity?
	let running: [ActivityWidgetItem]
	let unavailable: Bool
	let isPreview: Bool
	var selectedRunning: ActivityWidgetItem? { running.first { $0.definitionID == activity?.id } }
	var otherRunning: [ActivityWidgetItem] { running.filter { $0.definitionID != activity?.id } }
}

private struct ActivityWidgetProvider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> ActivityWidgetEntry {
		ActivityWidgetEntry(date: Date(), activity: nil, running: [], unavailable: false, isPreview: true)
	}
	func snapshot(for configuration: ActivityWidgetConfigurationIntent, in context: Context) async -> ActivityWidgetEntry {
		if context.isPreview { return placeholder(in: context) }
		return await entry(for: configuration)
	}
	func timeline(for configuration: ActivityWidgetConfigurationIntent, in context: Context) async -> Timeline<ActivityWidgetEntry> {
		let value = await entry(for: configuration)
		return Timeline(entries: [value], policy: .after(value.date.addingTimeInterval(900)))
	}
	@MainActor private func entry(for configuration: ActivityWidgetConfigurationIntent) -> ActivityWidgetEntry {
		guard let selected = configuration.activity else {
			return ActivityWidgetEntry(date: Date(), activity: nil, running: [], unavailable: false, isPreview: false)
		}
		do {
			let snapshot = try ActivityWidgetStore.snapshot()
			guard let definition = snapshot.definitions.first(where: { $0.id == selected.id }) else {
				return ActivityWidgetEntry(date: Date(), activity: nil, running: [], unavailable: false, isPreview: false)
			}
			return ActivityWidgetEntry(date: Date(),
				activity: RecordableActivityEntity(id: definition.id, name: definition.name),
				running: snapshot.running.map { ActivityWidgetItem(id: $0.id, definitionID: $0.definitionID, name: $0.name, start: $0.start) },
				unavailable: false, isPreview: false)
		} catch {
			// Never display a Start action when the current running state could not be read.
			return ActivityWidgetEntry(date: Date(), activity: nil, running: [], unavailable: true, isPreview: false)
		}
	}
}

private struct ActivityWidgetView: View {
	let entry: ActivityWidgetEntry
	@Environment(\.widgetFamily) private var family
	private let setupURL = URL(string: "introspective://activities")!

	var body: some View {
		Group {
			if let activity = entry.activity {
				if family == .accessoryCircular {
					primaryAction(for: activity, compact: true)
				} else {
					VStack(alignment: .leading, spacing: family == .accessoryRectangular ? 3 : 8) {
						Text(activity.name).font(.headline).lineLimit(1)
						HStack {
							if let running = entry.selectedRunning {
								elapsed(since: running.start)
							} else {
								Text("Not running").font(.caption).foregroundStyle(.secondary)
							}
							Spacer(minLength: 4)
							primaryAction(for: activity, compact: false)
						}
						if family == .systemMedium {
							ForEach(Array(entry.otherRunning.prefix(2))) { running in
								if entry.selectedRunning == nil {
									Button(intent: SwitchRecordedActivityIntent(activityID: running.id, definitionID: activity.id)) {
										Label("Switch from \(running.name)", systemImage: "arrow.triangle.swap").lineLimit(1)
									}.buttonStyle(.plain).font(.caption)
										.accessibilityLabel("Stop \(running.name) and start \(activity.name)")
								} else {
									Button(intent: StopRecordedActivityIntent(activityID: running.id)) {
										Label("Stop \(running.name)", systemImage: "stop.circle").lineLimit(1)
									}.buttonStyle(.plain).font(.caption)
								}
							}
							Link("Open activities", destination: setupURL).font(.caption2)
						}
					}
				}
			} else {
				Link(destination: setupURL) {
					if family == .accessoryCircular {
						Image(systemName: "figure.walk").accessibilityLabel("Open activities")
					} else {
						VStack(alignment: .leading, spacing: 4) {
							Label("Activities", systemImage: "figure.walk").font(.headline)
							Text(entry.unavailable ? "Open Introspective to refresh" : "Edit widget to choose an activity")
								.font(.caption)
						}
					}
				}
			}
		}
		.privacySensitive()
		.widgetURL(setupURL)
		.containerBackground(for: .widget) { Color.clear }
	}

	@ViewBuilder private func primaryAction(for activity: RecordableActivityEntity, compact: Bool) -> some View {
		if let running = entry.selectedRunning {
			Button(intent: StopRecordedActivityIntent(activityID: running.id)) {
				actionLabel("Stop", name: activity.name, systemImage: "stop.circle.fill", compact: compact)
			}.buttonStyle(.plain).accessibilityLabel("Stop \(activity.name)")
		} else {
			Button(intent: StartRecordedActivityIntent(definitionID: activity.id)) {
				actionLabel("Start", name: activity.name, systemImage: "play.circle.fill", compact: compact)
			}.buttonStyle(.plain).accessibilityLabel("Start \(activity.name)")
		}
	}

	@ViewBuilder private func actionLabel(_ title: String, name: String, systemImage: String, compact: Bool) -> some View {
		if compact {
			VStack(spacing: 2) {
				Image(systemName: systemImage).font(.title2)
				Text(name).font(.caption2).lineLimit(1).minimumScaleFactor(0.7)
			}
		} else {
			Label(title, systemImage: systemImage).font(.body)
		}
	}

	@ViewBuilder private func elapsed(since start: Date) -> some View {
		if start <= entry.date {
			Text(start, style: .timer).font(.caption.monospacedDigit())
				.accessibilityLabel("Elapsed time")
		} else {
			Text("Starts later").font(.caption)
		}
	}
}

struct ActivityQuickRecordWidget: Widget {
	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: "ActivityQuickRecordWidget", intent: ActivityWidgetConfigurationIntent.self,
			provider: ActivityWidgetProvider()) { entry in ActivityWidgetView(entry: entry) }
			.configurationDisplayName("Activity")
			.description("Start or stop a chosen activity. The medium widget can switch from another running activity.")
			.supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryCircular])
	}
}
