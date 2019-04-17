//
//  ExportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 4/17/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit
import UserNotifications

public final class ExportDataTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = ExportDataTableViewController
	private static let dataTypeSection = 0
	private static let activeExportsSection = 1
	private static let sampleTypes: [CoreDataSample.Type] = [
		Activity.self,
		MedicationDose.self,
		MoodImpl.self,
	]

	// MARK: - Instance Variables

	private final var backgroundExportOrder = [UIBackgroundTaskIdentifier]()
	private final let backgroundExportsAccessQueue = DispatchQueue(
		label: "backgroundExports access",
		attributes: .concurrent)
	private final var _backgroundExports = [UIBackgroundTaskIdentifier: Exporter]()
	public final func backgroundExports<Type>(_ code: ([UIBackgroundTaskIdentifier: Exporter]) -> Type) -> Type {
		var result: Type?
		// for synchronization to provide thread safety
		backgroundExportsAccessQueue.sync(flags: .barrier) {
			result = code(_backgroundExports)
		}
		return result!
	}
	/// This is necessary because can't reference the local variable with
	/// the returned id from its expiration handler otherwise compiler will
	/// complain about referencing a variable in its definition.
	private final var taskIds = [UUID: UIBackgroundTaskIdentifier]()
	/// Leave this as an instance variable because making it local will cause
	/// a bug with ARC that prevents the user from actually saving the file
	private final var documentInteractionController: UIDocumentInteractionController!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		observe(selector: #selector(extendTime), name: .extendBackgroundTaskTime)
		observe(selector: #selector(cancelBackgroundExport), name: .cancelBackgroundTask)
		observe(selector: #selector(shareExportFile), name: .shareExportFile)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in tableView: UITableView) -> Int {
		if backgroundExports({ $0.count }) > 0 {
			return 2
		}
		return 1
	}

	public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == Me.dataTypeSection {
			return "Data Types"
		}
		return "Active Exports"
	}

	public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == Me.activeExportsSection {
			return backgroundExports({ $0.count })
		}
		return Me.sampleTypes.count
	}

	public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == Me.dataTypeSection {
			let cell = tableView.dequeueReusableCell(withIdentifier: "dataType", for: indexPath)
			cell.textLabel?.text = Me.sampleTypes[indexPath.row].name.localizedCapitalized
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "activeExport", for: indexPath) as! ActiveExportTableViewCell
		cell.backgroundTaskId = backgroundExportOrder[indexPath.row]
		cell.exporter = backgroundExports({ $0[cell.backgroundTaskId] })
		// need to do this or will double subscribe and receive event twice, causing app to crash
		DependencyInjector.util.ui.stopObserving(self, name: .presentView, object: cell.exporter)
		observe(selector: #selector(presentViewFrom), name: .presentView, object: cell.exporter)
		return cell
	}

	// MARK: - Table View Delegate

	public final override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
			let alert = UIAlertController(title: taskDescription, message: "This may take a while. You can do something else and, if enabled, you will receive a notification when done.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			presentView(alert)
		} catch {
			log.error("Failed to create data exporter while presenting directory picker: %@", errorInfo(error))
			showError(title: "Unable to export", message: "You found a bug. Please report this.")
		}
	}

	// MARK: - Received Notifications

	@objc private final func extendTime(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let exporter = backgroundExports({ $0[backgroundTaskId] }) {
				runExportInBackground(exporter)
				backgroundExportsAccessQueue.sync(flags: .barrier) {
					_backgroundExports[backgroundTaskId] = nil
				}
				backgroundExportOrder.removeAll(where: { $0 == backgroundTaskId })
			} else {
				log.error("Unable to retrieve exporter for background task: %d", backgroundTaskId.rawValue)
			}
		}
	}

	@objc private final func cancelBackgroundExport(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let exporter = backgroundExports({ $0[backgroundTaskId] }) {
				exporter.cancel()
			}
			backgroundExportsAccessQueue.sync(flags: .barrier) {
				_backgroundExports[backgroundTaskId] = nil
			}
			backgroundExportOrder.removeAll(where: { $0 == backgroundTaskId })
			tableView.reloadData()
		}
	}

	@objc private final func presentViewFrom(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			presentView(controller)
		}
	}

	@objc private final func shareExportFile(notification: Notification) {
		if let backgroundTaskId: UIBackgroundTaskIdentifier = value(for: .backgroundTaskId, from: notification) {
			guard let exporter = backgroundExports({ $0[backgroundTaskId] }) else {
				log.error("Did not find exporter associated with background task id")
				return
			}
			let controller = UIDocumentInteractionController(url: exporter.url)
			controller.presentOptionsMenu(from: view.frame, in: view, animated: true)
			documentInteractionController = controller
			removeExporterFor(backgroundTaskId)
		}
	}

	// MARK: - Helper Functions

	private final func runExportInBackground(_ exporter: Exporter) {
		let dataType = exporter.dataTypePluralName
		let taskDescription = "Export " + dataType
		DispatchQueue.global(qos: .utility).async {
			let uuid = UUID()
			let backgroundTask = UIApplication.shared.beginBackgroundTask(withName: taskDescription) { [weak self] in
				self?.log.info("Background task to export %@ expired", dataType)
				exporter.pause()
				guard let taskId = self?.taskIds[uuid] else {
					self?.log.error("Missing background task id. App might be killed by iOS due to inability to end background task.")
					return
				}
				self?.sendExtendTimeNotification(for: taskId)
				self?.endBackgroundTask(id: taskId)
			}

			do {
				if !self.backgroundExportOrder.contains(backgroundTask) {
					self.backgroundExportOrder.append(backgroundTask)
					DispatchQueue.main.async { self.tableView.reloadData() }
				}
				self.backgroundExportsAccessQueue.sync(flags: .barrier) {
					self._backgroundExports[backgroundTask] = exporter
				}
				self.taskIds[uuid] = backgroundTask
				if exporter.isPaused {
					self.log.info("Continuing background export of %@", dataType)
					try exporter.resume()
				} else {
					self.log.info("Starting background export of %@", dataType)
					try exporter.exportData()
				}
				if !exporter.isPaused && !exporter.isCancelled {
					self.sendSuccessfulExportNotification(for: exporter)
					self.post(.backgroundExportFinished, object: exporter)
				}
			} catch {
				self.log.error("Failed to export %@: %@", dataType, errorInfo(error))
				self.sendBackgroundErrorNotification(for: exporter, error: error)
			}
			if exporter.isCancelled {
				self.log.info("Finished background export of %@", dataType)
				self.removeExporterFor(backgroundTask)
			}
		}
	}

	private final func removeExporterFor(_ backgroundTask: UIBackgroundTaskIdentifier) {
		self.backgroundExportsAccessQueue.sync(flags: .barrier) {
			self._backgroundExports[backgroundTask] = nil
		}
		self.backgroundExportOrder.removeAll(where: { $0 == backgroundTask })
		self.endBackgroundTask(id: backgroundTask)
		DispatchQueue.main.async { self.tableView.reloadData() }
	}

	private final func getExporterFor(_ indexPath: IndexPath) throws -> Exporter {
		let type = Me.sampleTypes[indexPath.row]
		if type == Activity.self || type == ActivityDefinition.self {
			return try DependencyInjector.exporter.activityExporter()
		}
		if type == MedicationDose.self || type == Medication.self {
			return try DependencyInjector.exporter.medicationExporter()
		}
		if type == Mood.self {
			return try DependencyInjector.exporter.moodExporter()
		}
		log.error("Unknown index path: (section: %d, row: %d)", indexPath.section, indexPath.row)
		throw GenericError("Unknown index path")
	}

	private final func endBackgroundTask(id: UIBackgroundTaskIdentifier) {
		guard id != .invalid else { return }
		UIApplication.shared.endBackgroundTask(id)
	}

	// MARK: Send User Notification Functions

	private final func sendSuccessfulExportNotification(for exporter: Exporter) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: "Finished exporting", arguments: nil)
		content.body = NSString.localizedUserNotificationString(
			forKey: "Finished exporting %@",
			arguments: [ exporter.dataTypePluralName.localizedLowercase ])
		content.sound = UNNotificationSound.default
		switch(exporter) {
			case is ActivityExporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedExportingActivities.identifier
				break
			case is MedicationExporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedExportingMedications.identifier
				break
			case is MoodExporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedExportingMoods.identifier
				break
			default:
				log.error("Forgot a type of exporter for notifications: %@", String(describing: exporter))
		}
		sendUserNotification(withContent: content, id: "FinishedExport")
	}

	private final func sendExtendTimeNotification(for backgroundTaskId: UIBackgroundTaskIdentifier) {
		guard let exporter = backgroundExports({ $0[backgroundTaskId] }) else {
			log.error("Missing exporter for background task")
			// just let it go because won't be able to resume the export anyways
			return
		}
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Long running %@ export",
			arguments: [exporter.dataTypePluralName])
		content.body = NSString.localizedUserNotificationString(forKey: "Would you like to continue the export?", arguments: nil)
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
			arguments: [ dataType ])
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
}
