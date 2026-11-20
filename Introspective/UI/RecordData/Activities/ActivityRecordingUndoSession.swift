import Foundation
import UIKit

import Samples
import UIExtensions

/// One successful in-app recording can be undone during this app session.
/// The recorder validates the token against current saved and pending data.
final class ActivityRecordingUndoSession {
	static let shared = ActivityRecordingUndoSession()
	static let changed = Notification.Name("activityRecordingUndoSessionChanged")
	private var token: ActivityRecordingUndoToken?
	private(set) var title = ""
	var canUndo: Bool { token != nil }

	func record(_ result: ActivityUndoableRecordingResult, title: String) {
		guard result.recording.didChange else { return }
		self.token = result.undoToken
		self.title = result.undoToken == nil ? "" : title
		NotificationCenter.default.post(name: Self.changed, object: self)
	}

	func clear() {
		guard token != nil else { return }
		token = nil; title = ""
		NotificationCenter.default.post(name: Self.changed, object: self)
	}

	@discardableResult func undo() throws -> ActivityRecordingResult {
		guard let token = token else { return ActivityRecordingResult() }
		let result = try ActivityQuickRecorder.undo(token)
		clear()
		// The activity write has succeeded even if notification delivery fails.
		ActivityReminderService.refresh()
		return result
	}
}

/// Share the same last action between the activity recorder and day review.
final class ActivityRecordingUndoToolbar: NSObject {
	private weak var owner: UIViewController?
	private var observer: NSObjectProtocol?
	private var active = false
	private var undoing = false

	init(owner: UIViewController) {
		self.owner = owner
		super.init()
		observer = NotificationCenter.default.addObserver(forName: ActivityRecordingUndoSession.changed,
			object: nil, queue: .main) { [weak self] _ in self?.update() }
	}
	deinit { if let observer = observer { NotificationCenter.default.removeObserver(observer) } }

	func show() { active = true; update() }
	func hide() {
		active = false
		owner?.navigationController?.setToolbarHidden(true, animated: false)
	}

	private func update() {
		guard active, let owner = owner, let navigation = owner.navigationController,
			navigation.topViewController === owner else { return }
		let session = ActivityRecordingUndoSession.shared
		guard session.canUndo else {
			owner.setToolbarItems(nil, animated: false)
			navigation.setToolbarHidden(true, animated: false)
			return
		}
		let status = UIBarButtonItem(title: session.title, style: .plain, target: nil, action: nil)
		status.isEnabled = false
		status.accessibilityIdentifier = "activityRecordingUndoStatus"
		let undo = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(undoRecording))
		undo.accessibilityIdentifier = "undoActivityRecording"
		undo.accessibilityLabel = "Undo activity recording"
		owner.setToolbarItems([status, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), undo], animated: false)
		navigation.setToolbarHidden(false, animated: false)
	}

	@objc private func undoRecording() {
		guard !undoing, ActivityRecordingUndoSession.shared.canUndo else { return }
		undoing = true
		defer { undoing = false }
		do {
			try ActivityRecordingUndoSession.shared.undo()
			UINotificationFeedbackGenerator().notificationOccurred(.success)
		} catch {
			owner?.showError(title: "Could not undo activity", message: error.localizedDescription)
		}
	}
}
