//
//  ExportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit
import UserNotifications

import Common
import DataExport
import DependencyInjection
import Notifications
import Samples

public final class ExportDataTableViewController: UITableViewController {
	// MARK: - Static Variables

	private typealias Me = ExportDataTableViewController

	// MARK: Section Indexes

	private static let dataTypeSection = 0
	private static let activeExportsSection = 1

	// MARK: Exportable Sample Types

	/// All exportable sample types
	private static let sampleTypes: [CoreDataSample.Type] = [
		Activity.self,
		MedicationDose.self,
		MoodImpl.self,
		MetricContextEntry.self,
		LostItemEvent.self,
	]

	// MARK: Active Exports

	// keep these as static so that they persist if the user goes back to settings screen
	private static var backgroundExportOrder = [UIBackgroundTaskIdentifier]()
	private static let backgroundExportsAccessQueue = DispatchQueue(
		label: "backgroundExports access",
		attributes: .concurrent
	)
	private static var _backgroundExports = [UIBackgroundTaskIdentifier: Exporter]()
	public static func backgroundExports<Type>(_ code: ([UIBackgroundTaskIdentifier: Exporter]) -> Type) -> Type {
		var result: Type?
		// for synchronization to provide thread safety
		Me.backgroundExportsAccessQueue.sync(flags: .barrier) {
			result = code(_backgroundExports)
		}
		return result!
	}

	// Export IDs are stable UI/notification keys, independent of reusable UIKit IDs.
	private static var nextExportID = 1
	private static var executions = [UIBackgroundTaskIdentifier: ExportBackgroundExecution]()
	internal static var runningExportCount: Int {
		backgroundExportsAccessQueue.sync { executions.count }
	}

	// MARK: Logging

	private static let log = Log()

	// MARK: - Instance Variables

	/// Leave this as an instance variable because making it local will cause
	/// a bug with ARC that prevents the user from actually saving the file
	private final var documentInteractionController: UIDocumentInteractionController!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		observe(selector: #selector(extendTime), name: .extendBackgroundTaskTime)
		observe(selector: #selector(cancelBackgroundExport), name: .cancelBackgroundTask)
		observe(selector: #selector(shareExportFile), name: .shareExportFile)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in _: UITableView) -> Int {
		if Me.backgroundExports({ $0.count }) > 0 {
			return 2
		}
		return 1
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == Me.dataTypeSection {
			return "Data Types"
		}
		return "Active Exports"
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == Me.activeExportsSection {
			return Me.backgroundExports { $0.count }
		}
		return Me.sampleTypes.count
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath.section == Me.dataTypeSection {
			let cell = tableView.dequeueReusableCell(withIdentifier: "dataType", for: indexPath)
			let type = Me.sampleTypes[indexPath.row]
			cell.textLabel?.text = type == LostItemEvent.self ? "Lost Item Events" : type.name.localizedCapitalized
			return cell
		}
		let cell = tableView.dequeueReusableCell(
			withIdentifier: "activeExport",
			for: indexPath
		) as! ActiveExportTableViewCell
		let entry = Me.backgroundExportsAccessQueue.sync { () -> (UIBackgroundTaskIdentifier, Exporter?)? in
			guard Me.backgroundExportOrder.indices.contains(indexPath.row) else { return nil }
			let id = Me.backgroundExportOrder[indexPath.row]
			return (id, Me._backgroundExports[id])
		}
		cell.backgroundTaskId = entry?.0
		cell.exporter = entry?.1
		// need to do this or will double subscribe and receive event twice, causing app to crash
		injected(UiUtil.self).stopObserving(self, name: .presentView, object: cell.exporter)
		observe(selector: #selector(presentViewFrom), name: .presentView, object: cell.exporter)
		return cell
	}

	// MARK: - Table View Delegate

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == Me.dataTypeSection {
			return 44
		}
		return 75
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == Me.dataTypeSection else { // selecting an active export does nothing
			tableView.deselectRow(at: indexPath, animated: false)
			return
		}

		do {
			let exporter = try getExporterFor(indexPath)
			runExportInBackground(exporter)

			let taskDescription = "Exporting " + exporter.dataTypePluralName
			let alert = UIAlertController(
				title: taskDescription,
				message: "This may take a while. You can do something else and, if enabled, you will receive a notification when done.",
				preferredStyle: .alert
			)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			presentView(alert)
		} catch {
			Me.log.error("Failed to create data exporter while presenting directory picker: %@", errorInfo(error))
			showError(title: "Unable to export", message: "You found a bug. Please report this.")
		}
	}

	// MARK: - Received Notifications

	@objc private final func extendTime(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				Me.log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let exporter = Me.backgroundExports({ $0[backgroundTaskId] }) {
				runExportInBackground(exporter, resuming: backgroundTaskId)
			} else {
				Me.log.error("Unable to retrieve exporter for background task: %d", backgroundTaskId.rawValue)
			}
		}
	}

	@objc private final func cancelBackgroundExport(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				Me.log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let exporter = Me.backgroundExports({ $0[backgroundTaskId] }) {
				exporter.cancel()
			}
			removeExporterFor(backgroundTaskId)
		}
	}

	@objc private final func presentViewFrom(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			presentView(controller)
		}
	}

	@objc private final func shareExportFile(notification: Notification) {
		if let backgroundTaskId: UIBackgroundTaskIdentifier = value(for: .backgroundTaskId, from: notification) {
			guard let exporter = Me.backgroundExports({ $0[backgroundTaskId] }) else {
				Me.log.error("Did not find exporter associated with background task id")
				return
			}
			let controller = UIDocumentInteractionController(url: exporter.url)
			controller.presentOptionsMenu(from: view.frame, in: view, animated: true)
			documentInteractionController = controller
			removeExporterFor(backgroundTaskId)
		}
	}

	// MARK: - Helper Functions

	private final func runExportInBackground(_ exporter: Exporter, resuming existingID: UIBackgroundTaskIdentifier? = nil) {
		let execution = ExportBackgroundExecution { UIApplication.shared.endBackgroundTask($0) }
		let exportID: UIBackgroundTaskIdentifier? = Me.backgroundExportsAccessQueue.sync(flags: .barrier) {
			let id: UIBackgroundTaskIdentifier
			if let existingID = existingID {
				guard Me._backgroundExports[existingID] != nil, Me.executions[existingID] == nil else { return nil }
				id = existingID
			} else {
				id = UIBackgroundTaskIdentifier(rawValue: Me.nextExportID)
				Me.nextExportID += 1
				Me._backgroundExports[id] = exporter
				Me.backgroundExportOrder.append(id)
			}
			Me.executions[id] = execution
			return id
		}
		guard let id = exportID else { return }
		DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
		injected(AsyncUtil.self).run(qos: .utility) {
			defer {
				execution.finish()
				Me.backgroundExportsAccessQueue.sync(flags: .barrier) { Me.executions[id] = nil }
			}
			// Cancellation can remove a queued export before its worker begins.
			guard Me.backgroundExports({ $0[id] != nil }) else { return }
			let task = UIApplication.shared.beginBackgroundTask(withName: "Export " + exporter.dataTypePluralName) {
				guard execution.finish() else { return }
				exporter.pause()
				self.sendExtendTimeNotification(for: id)
			}
			execution.register(task)
			guard !execution.isFinished else { return }
			do {
				if existingID != nil {
					// Ignore stale Continue notifications after normal completion.
					guard exporter.isPaused else { return }
					try exporter.resume()
				} else {
					try exporter.exportData()
				}
				if exporter.isCancelled {
					self.removeExporterFor(id)
				} else if !exporter.isPaused && Me.backgroundExports({ $0[id] != nil }) {
					self.sendSuccessfulExportNotification(for: exporter)
					self.post(.backgroundExportFinished, object: exporter)
				}
			} catch {
				Me.log.error("Failed to export %@: %@", exporter.dataTypePluralName, errorInfo(error))
				self.sendBackgroundErrorNotification(for: exporter, error: error)
				self.removeExporterFor(id)
			}
		}
	}

	private final func removeExporterFor(_ exportID: UIBackgroundTaskIdentifier) {
		Me.backgroundExportsAccessQueue.sync(flags: .barrier) {
			Me._backgroundExports[exportID] = nil
			Me.backgroundExportOrder.removeAll { $0 == exportID }
		}
		// The worker owns its UIKit assertion until it exits (or expires).
		DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
	}

	internal final func getExporterFor(_ indexPath: IndexPath) throws -> Exporter {
		let type = Me.sampleTypes[indexPath.row]
		if type == Activity.self || type == ActivityDefinition.self {
			return injected(ActivityExporter.self)
		}
		if type == MedicationDose.self || type == Medication.self {
			return injected(MedicationExporter.self)
		}
		if type == MoodImpl.self {
			return injected(MoodExporter.self)
		}
		if type == MetricContextEntry.self { return injected(MetricContextExporter.self) }
		if type == LostItemEvent.self { return injected(LostItemExporter.self) }
		Me.log.error("Unknown index path: (section: %d, row: %d)", indexPath.section, indexPath.row)
		throw GenericError("Unknown index path")
	}


	// MARK: Send User Notification Functions

	private final func sendSuccessfulExportNotification(for exporter: Exporter) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: "Finished exporting", arguments: nil)
		content.body = NSString.localizedUserNotificationString(
			forKey: "Finished exporting %@",
			arguments: [exporter.dataTypePluralName.localizedLowercase]
		)
		content.sound = UNNotificationSound.default
		switch exporter {
		case is ActivityExporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedExportingActivities.identifier
			break
		case is MedicationExporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedExportingMedications.identifier
			break
		case is MoodExporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedExportingMoods.identifier
			break
		case is MetricContextExporter, is LostItemExporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedExportingRecords.identifier
		default:
			Me.log.error("Forgot a type of exporter for notifications: %@", String(describing: exporter))
		}
		sendUserNotification(withContent: content, id: "FinishedExport")
	}

	private final func sendExtendTimeNotification(for backgroundTaskId: UIBackgroundTaskIdentifier) {
		guard let exporter = Me.backgroundExports({ $0[backgroundTaskId] }) else {
			Me.log.error("Missing exporter for background task")
			// just let it go because won't be able to resume the export anyways
			return
		}
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Long running %@ export",
			arguments: [exporter.dataTypePluralName]
		)
		content.body = NSString.localizedUserNotificationString(
			forKey: "Would you like to continue the export?",
			arguments: nil
		)
		content.sound = UNNotificationSound.default
		content.categoryIdentifier = UserNotificationDelegate.timeExpired.identifier
		// can't use normal UserInfoKey : Any. Must be String : String
		// or errors will be thrown when notification is requested
		content.userInfo = [
			UserInfoKey.backgroundTaskId.description: String(backgroundTaskId.rawValue),
		]
		sendUserNotification(withContent: content, id: "ExtendExportTime")
	}

	private final func sendBackgroundErrorNotification(for exporter: Exporter, error: Error) {
		let dataType = exporter.dataTypePluralName.localizedLowercase
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Failed to export %@",
			arguments: [dataType]
		)
		var message = ""
		if let displayableError = error as? DisplayableError {
			message = displayableError.displayableTitle + "."
			if let errorDescription = displayableError.displayableDescription {
				message += " " + errorDescription + "."
			}
		}
		content.body = message
		content.sound = UNNotificationSound.default
		content.categoryIdentifier = UserNotificationDelegate.generalError.identifier
		sendUserNotification(withContent: content, id: "ExportErrorOccurred")
	}

	// MARK: - Testing

	/// This is for testing purposes only. All export workers must finish first.
	public static func resetExports() {
		let pending = backgroundExportsAccessQueue.sync(flags: .barrier) { () -> [ExportBackgroundExecution] in
			let pending = Array(executions.values)
			backgroundExportOrder = []
			_backgroundExports = [:]
			executions = [:]
			return pending
		}
		for execution in pending { execution.finish() }
	}
}

/// One execution owns one UIKit assertion. Expiration may race registration or
/// normal completion; all paths consume the assertion exactly once.
internal final class ExportBackgroundExecution {
	private let lock = NSLock()
	private let end: (UIBackgroundTaskIdentifier) -> Void
	private var task: UIBackgroundTaskIdentifier = .invalid
	private var finished = false

	init(end: @escaping (UIBackgroundTaskIdentifier) -> Void) { self.end = end }

	var isFinished: Bool {
		lock.lock()
		defer { lock.unlock() }
		return finished
	}

	func register(_ id: UIBackgroundTaskIdentifier) {
		lock.lock()
		let alreadyFinished = finished
		if !alreadyFinished { task = id }
		lock.unlock()
		if alreadyFinished && id != .invalid { end(id) }
	}

	@discardableResult func finish() -> Bool {
		lock.lock()
		guard !finished else { lock.unlock(); return false }
		finished = true
		let id = task
		task = .invalid
		lock.unlock()
		if id != .invalid { end(id) }
		return true
	}
}
