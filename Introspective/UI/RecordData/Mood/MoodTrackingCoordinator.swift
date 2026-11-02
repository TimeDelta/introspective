import Foundation
import CoreData
import UIKit
import WidgetKit
import Common
import Samples

/// App lifecycle integration; widgets also refresh the same reminder plan after saving.
final class MoodTrackingCoordinator {
	private var observers: [NSObjectProtocol] = []
	private var refreshQueued = false
	deinit { for observer in observers { NotificationCenter.default.removeObserver(observer) } }
	func start() {
		guard observers.isEmpty else { return }
		let center = NotificationCenter.default
		observers.append(center.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: nil) { [weak self] notification in
			// Inspect the entity names on the saving context's queue; never pass managed objects to the UI queue.
			let affectsMoods = [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey].contains { key in
				(notification.userInfo?[key] as? Set<NSManagedObject>)?.contains { $0.entity.name == "Mood" } == true
			}
			if affectsMoods { DispatchQueue.main.async { self?.queueRefresh() } }
		})
		for name in [UIApplication.didBecomeActiveNotification, .NSCalendarDayChanged, .NSSystemTimeZoneDidChange] {
			observers.append(center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in self?.queueRefresh() })
		}
		queueRefresh()
	}
	private func queueRefresh() {
		guard !refreshQueued else { return }; refreshQueued = true
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }; self.refreshQueued = false
			MoodReminderService.refresh()
		}
	}
}
