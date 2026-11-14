import CoreData
import SwiftUI
import WidgetKit

import Common
import DependencyInjection
import Persistence
import Samples
import Settings

@main
struct ActivityRecordingWidgets: WidgetBundle {
	var body: some Widget {
		ActivityQuickRecordWidget()
		ActivityQuickControl()
	}
}

/// Extensions can open a compatible shared store, but leave setup and migrations to the app.
@MainActor enum SharedWidgetDependencies {
	private static var prepared = false
	static func prepare() throws {
		guard !prepared else { return }
		guard FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Introspective") != nil else {
			throw ActivityRecordingError("Open Introspective to set up activity recording.")
		}
		let model = ObjectModelContainer.objectModel
		let probe = SharedPersistentContainer(name: "Introspective", managedObjectModel: model)
		guard let store = probe.persistentStoreDescriptions.first?.url, FileManager.default.fileExists(atPath: store.path) else {
			throw ActivityRecordingError("Open Introspective before recording from activity controls.")
		}
		let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: store, options: nil)
		guard model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
			throw ActivityRecordingError("Open Introspective once after updating, then try this activity control again.")
		}
		DependencyInjector.register([CommonInjectionProvider(), PersistenceInjectionProvider(model), SamplesInjectionProvider(), SettingsInjectionProvider()])
		prepared = true
	}
}
