import SwiftUI
import WidgetKit
import AppIntents
import CoreData
import Common
import DependencyInjection
import Persistence
import Samples
import Settings

private struct MoodWidgetEntry: TimelineEntry {
	let date: Date
	let presets: [MoodCheckInPreset]
}

private struct MoodWidgetProvider: TimelineProvider {
	func placeholder(in context: Context) -> MoodWidgetEntry {
		MoodWidgetEntry(date: Date(), presets: [MoodCheckInPreset(name: "Check-in", rating: 5, minimum: 0, maximum: 10)])
	}
	func getSnapshot(in context: Context, completion: @escaping (MoodWidgetEntry) -> Void) {
		completion(context.isPreview ? placeholder(in: context) : entry())
	}
	func getTimeline(in context: Context, completion: @escaping (Timeline<MoodWidgetEntry>) -> Void) {
		let value = entry()
		completion(Timeline(entries: [value], policy: .after(value.date.addingTimeInterval(3600))))
	}
	private func entry() -> MoodWidgetEntry {
		MoodWidgetEntry(date: Date(), presets: Array(((try? MoodTrackingPreferences.shared.presets()) ?? []).prefix(3)))
	}
}

struct RecordMoodPresetIntent: AppIntent {
	static var title: LocalizedStringResource = "Record mood check-in"
	static var description = IntentDescription("Record one of your saved check-in presets.")
	static var openAppWhenRun = false
	static var authenticationPolicy: IntentAuthenticationPolicy = .requiresAuthentication
	static var isDiscoverable = false
	@Parameter(title: "Preset identifier") var presetID: String
	init() {}
	init(presetID: String) { self.presetID = presetID }
	@MainActor func perform() async throws -> some IntentResult {
		guard let preset = try MoodTrackingPreferences.shared.presets().first(where: { $0.id.uuidString == presetID }) else {
			throw MoodTrackingError("This preset is no longer available. Open Introspective to choose another.")
		}
		try MoodWidgetDependencies.prepare()
		try MoodPresetRecorder.record(preset)
		injected(Database.self).setModifiedExternally(true)
		// A reminder error must not turn an already-saved mood into an apparent failed check-in.
		await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
			MoodReminderService.refresh { _ in continuation.resume() }
		}
		WidgetCenter.shared.reloadTimelines(ofKind: "MoodCheckInWidget")
		return .result()
	}
}

@MainActor private enum MoodWidgetDependencies {
	private static var prepared = false
	static func prepare() throws {
		guard !prepared else { return }
		guard let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: MoodTrackingPreferences.groupIdentifier) else {
			throw MoodTrackingError("Open Introspective to set up check-ins.")
		}
		// Match SharedPersistentContainer's existing directory and default store name.
		let store = group.appendingPathComponent("Introspective.sqlite").appendingPathComponent("Introspective.sqlite")
		guard FileManager.default.fileExists(atPath: store.path) else { throw MoodTrackingError("Open Introspective before recording from the widget.") }
		let model = ObjectModelContainer.objectModel
		let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: store, options: nil)
		guard model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
			throw MoodTrackingError("Open Introspective once after updating, then try this check-in again.")
		}
		DependencyInjector.register([CommonInjectionProvider(), PersistenceInjectionProvider(model), SamplesInjectionProvider(), SettingsInjectionProvider()])
		prepared = true
	}
}

private struct MoodWidgetView: View {
	let entry: MoodWidgetEntry
	@Environment(\.widgetFamily) private var family
	private let setupURL = URL(string: "introspective://mood-check-in")!
	var body: some View {
		Group {
			if let first = entry.presets.first {
				if family == .accessoryCircular {
					Button(intent: RecordMoodPresetIntent(presetID: first.id.uuidString)) { Image(systemName: "plus.circle.fill") }
						.buttonStyle(.plain).accessibilityLabel("Record " + first.name)
				} else {
					VStack(alignment: .leading, spacing: 8) {
						if family != .accessoryRectangular { Text("Mood check-in").font(.headline) }
						ForEach(Array(entry.presets.prefix(family == .accessoryRectangular ? 1 : family == .systemSmall ? 2 : 3))) { preset in
							Button(intent: RecordMoodPresetIntent(presetID: preset.id.uuidString)) {
								Label(preset.name, systemImage: "plus.circle").lineLimit(1)
							}.buttonStyle(.plain).accessibilityLabel("Record " + preset.name)
						}
						if family == .systemMedium { Link("Edit presets in Introspective", destination: setupURL).font(.caption) }
					}
				}
			} else {
				Link(destination: setupURL) {
					Label(family == .accessoryCircular ? "Check-in" : "Set up check-in presets", systemImage: "plus.circle")
				}
			}
		}
		.privacySensitive()
		.widgetURL(setupURL)
		.containerBackground(for: .widget) { Color.clear }
	}
}

@main
struct MoodCheckInWidget: Widget {
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: "MoodCheckInWidget", provider: MoodWidgetProvider()) { entry in MoodWidgetView(entry: entry) }
			.configurationDisplayName("Mood Check-in")
			.description("Record a saved preset without opening the app. Presets keep their original mood scales.")
			.supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryCircular])
	}
}
