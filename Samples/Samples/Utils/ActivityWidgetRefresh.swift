import CoreData
import Foundation
import WidgetKit

/// Covers existing app editors and Siri actions as well as the new recording controls.
public enum ActivityWidgetRefresh {
	private static let lock = NSLock()
	private static var observer: NSObjectProtocol?

	public static func startObserving() {
		lock.lock()
		defer { lock.unlock() }
		guard observer == nil else { return }
		observer = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave,
			object: nil, queue: nil) { notification in
			// Inspect managed objects only on the queue that saved them.
			let changedActivity = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey].contains { key in
				(notification.userInfo?[key] as? Set<NSManagedObject>)?.contains {
					$0.entity.name == Activity.entityName || $0.entity.name == ActivityDefinition.entityName
				} == true
			}
			if changedActivity { reload() }
		}
	}

	public static func reload() {
		WidgetCenter.shared.reloadTimelines(ofKind: "ActivityQuickRecordWidget")
		if #available(iOS 18.0, *) {
			ControlCenter.shared.reloadControls(ofKind: "ActivityQuickControl")
		}
	}
}
