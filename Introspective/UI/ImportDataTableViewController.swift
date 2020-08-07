//
//  ImportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import NotificationBannerSwift
import SwiftDate
import UIKit
import UserNotifications

import Common
import DataImport
import DependencyInjection
import Notifications

public final class ImportDataTableViewController: UITableViewController {
	private enum Errors: Error {
		case unknownIndexPath
	}

	// MARK: - Static Variables

	private typealias Me = ImportDataTableViewController

	public static let sectionRows = [
		(
			section: "Activity",
			rows: [
				"ATracker",
				"Introspective",
			]
		),
		(
			section: "Medication",
			rows: [
				"EasyPill Medications",
				"EasyPill Doses",
				"Introspective",
			]
		),
		(
			section: "Mood",
			rows: [
				"Wellness",
				"Introspective",
			]
		),
	]

	private static let log = Log()

	// MARK: activities

	private static let activitiesSection = 0
	private static let aTrackerActivityIndex = IndexPath(row: 0, section: activitiesSection)
	private static let introspectiveActivityIndex = IndexPath(row: 1, section: activitiesSection)

	// MARK: medications

	private static let medicationSection = 1
	private static let easyPillMedicationIndex = IndexPath(row: 0, section: medicationSection)
	private static let easyPillDoseIndex = IndexPath(row: 1, section: medicationSection)
	private static let introspectiveMedicationIndex = IndexPath(row: 2, section: medicationSection)

	// MARK: moods

	private static let moodSection = 2
	private static let wellnessMoodIndex = IndexPath(row: 0, section: moodSection)
	private static let introspectiveMoodIndex = IndexPath(row: 1, section: moodSection)

	// MARK: - Instance Variables

	private final var importer: Importer!
	private final var backgroundImportOrder = [UIBackgroundTaskIdentifier]()
	private final let backgroundImportsAccessQueue = DispatchQueue(
		label: "backgroundImports access",
		attributes: .concurrent
	)
	private final var _backgroundImports = [UIBackgroundTaskIdentifier: Importer]()
	public final func backgroundImports<Type>(_ code: ([UIBackgroundTaskIdentifier: Importer]) -> Type) -> Type {
		var result: Type?
		// for synchronization to provide thread safety
		backgroundImportsAccessQueue.sync(flags: .barrier) {
			result = code(_backgroundImports)
		}
		return result!
	}

	/// This is necessary because can't reference the local variable with
	/// the returned id from its expiration handler otherwise compiler will
	/// complain about referencing a variable in its definition.
	private final var taskIds = [UUID: UIBackgroundTaskIdentifier]()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		observe(selector: #selector(extendTime), name: .extendBackgroundTaskTime)
		observe(selector: #selector(cancelBackgroundImport), name: .cancelBackgroundTask)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table View Data Source

	public final override func numberOfSections(in _: UITableView) -> Int {
		if backgroundImports({ $0.count }) > 0 {
			return 4
		}
		return 3
	}

	public final override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section >= Me.sectionRows.count {
			return "Active Imports"
		}
		return Me.sectionRows[section].section
	}

	public final override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section >= Me.sectionRows.count {
			return backgroundImports { $0.count }
		}
		return Me.sectionRows[section].rows.count
	}

	public final override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath.section >= Me.sectionRows.count {
			let cell = tableView.dequeueReusableCell(
				withIdentifier: "activeImport",
				for: indexPath
			) as! ActiveImportTableViewCell
			cell.backgroundTaskId = backgroundImportOrder[indexPath.row]
			cell.importer = backgroundImports { $0[cell.backgroundTaskId] }
			// need to do this or will double subscribe and receive event twice, causing app to crash
			DependencyInjector.get(UiUtil.self).stopObserving(self, name: .presentView, object: cell.importer)
			observe(selector: #selector(presentViewFrom), name: .presentView, object: cell.importer)
			return cell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "dataSource", for: indexPath)
		cell.textLabel?.text = Me.sectionRows[indexPath.section].rows[indexPath.row]
		return cell
	}

	// MARK: - Table View Delegate

	public final override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section < Me.sectionRows.count {
			return 44
		}
		return 75
	}

	public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section < Me.sectionRows.count else {
			tableView.deselectRow(at: indexPath, animated: false)
			return
		}
		do {
			importer = try getImporterFor(indexPath)
			var lastImportedText: String
			if let importDate = importer.lastImport {
				let dateText = DependencyInjector.get(CalendarUtil.self)
					.string(for: importDate, dateStyle: .medium, timeStyle: .medium)
				lastImportedText = "Last import date: \(dateText)"
			} else {
				lastImportedText = "Never imported"
			}
			let actionSheet = UIAlertController(title: lastImportedText, message: nil, preferredStyle: .actionSheet)
			actionSheet.addAction(UIAlertAction(title: "Import", style: .default) { _ in
				self.promptForDataImport(indexPath)
			})
			actionSheet.addAction(UIAlertAction(title: "Reset Last Import Date", style: .default) { _ in
				do {
					try self.importer.resetLastImportDate()
				} catch {
					Me.log.error("Failed to reset last import date: %@", errorInfo(error))
					self.showError(title: "Failed to reset last import date", error: error)
				}
			})
			actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
				self.tableView.deselectRow(at: indexPath, animated: false)
			})
			presentView(actionSheet)
		} catch {
			Me.log.error("Failed to create data importer while presenting menu: %@", errorInfo(error))
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
			if let importer = backgroundImports({ $0[backgroundTaskId] }) {
				runImportInBackground(importer)
				backgroundImportsAccessQueue.sync(flags: .barrier) {
					_backgroundImports[backgroundTaskId] = nil
				}
				backgroundImportOrder.removeAll(where: { $0 == backgroundTaskId })
			} else {
				Me.log.error("Unable to retrieve importer for background task: %d", backgroundTaskId.rawValue)
			}
		}
	}

	@objc private final func cancelBackgroundImport(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				Me.log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let importer = backgroundImports({ $0[backgroundTaskId] }) {
				importer.cancel()
			}
			backgroundImportsAccessQueue.sync(flags: .barrier) {
				_backgroundImports[backgroundTaskId] = nil
			}
			backgroundImportOrder.removeAll(where: { $0 == backgroundTaskId })
			tableView.reloadData()
		}
	}

	@objc private final func presentViewFrom(notification: Notification) {
		if let controller: UIViewController = value(for: .controller, from: notification) {
			presentView(controller)
		}
	}

	// MARK: - Helper Functions

	private final func promptForDataImport(_: IndexPath) {
		let message = importer.customImportMessage ??
			"This will only import data that was recorded after the imported record with the most recent date and time."
		let prompt = UIAlertController(title: "Import new data only?", message: message, preferredStyle: .alert)
		prompt.addAction(UIAlertAction(title: "No", style: .destructive) { _ in
			self.importData(newDataOnly: false)
		})
		prompt.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
			self.importData(newDataOnly: true)
		})
		presentView(prompt)
	}

	private final func importData(newDataOnly: Bool) {
		let documentPickerController = DependencyInjector.get(UiUtil.self)
			.documentPicker(docTypes: ["public.data"], in: .import)
		documentPickerController.allowsMultipleSelection = false
		documentPickerController.delegate = self
		importer.importOnlyNewData = newDataOnly
		presentView(documentPickerController)
	}

	private final func runImportInBackground(_ importer: Importer, _ url: URL? = nil) {
		let dataType = importer.dataTypePluralName
		let source = importer.sourceName
		let taskDescription = "Import " + dataType + " from " + source
		DispatchQueue.global(qos: .utility).async {
			let uuid = UUID()
			let backgroundTask = UIApplication.shared.beginBackgroundTask(withName: taskDescription) { [weak self] in
				Me.log.info("Background task to import %@ from %@ expired", dataType, source)
				importer.pause()
				guard let taskId = self?.taskIds[uuid] else {
					Me.log.error(
						"Missing background task id. App might be killed by iOS due to inability to end background task."
					)
					return
				}
				self?.sendExtendTimeNotification(for: taskId)
				self?.endBackgroundTask(id: taskId)
			}

			do {
				if !self.backgroundImportOrder.contains(backgroundTask) {
					self.backgroundImportOrder.append(backgroundTask)
					DispatchQueue.main.async { self.tableView.reloadData() }
				}
				self.backgroundImportsAccessQueue.sync(flags: .barrier) {
					self._backgroundImports[backgroundTask] = importer
				}
				self.taskIds[uuid] = backgroundTask
				if let url = url {
					Me.log.info("Starting background import for %@ from %@", dataType, source)
					try importer.importData(from: url)
				} else {
					Me.log.info("Continuing background import for %@ from %@", dataType, source)
					try importer.resume()
				}
				if !importer.isPaused && !importer.isCancelled {
					self.sendSuccessfulImportNotification(for: importer)
				}
			} catch {
				Me.log.error("Failed to import %@ from %@: %@", dataType, source, errorInfo(error))
				self.sendBackgroundErrorNotification(for: importer, error: error)
			}
			if !importer.isPaused {
				Me.log.info("Finished background import for %@ from %@", dataType, source)
				self.backgroundImportsAccessQueue.sync(flags: .barrier) {
					self._backgroundImports[backgroundTask] = nil
				}
				self.backgroundImportOrder.removeAll(where: { $0 == backgroundTask })
				self.endBackgroundTask(id: backgroundTask)
				DispatchQueue.main.async { self.tableView.reloadData() }
			}
		}
	}

	private final func getImporterFor(_ indexPath: IndexPath) throws -> Importer {
		if indexPath == Me.aTrackerActivityIndex {
			return try DependencyInjector.get(ImporterFactory.self).aTrackerActivityImporter()
		} else if indexPath == Me.introspectiveActivityIndex {
			return try DependencyInjector.get(ImporterFactory.self).introspectiveActivityImporter()
		} else if indexPath == Me.wellnessMoodIndex {
			return try DependencyInjector.get(ImporterFactory.self).wellnessMoodImporter()
		} else if indexPath == Me.introspectiveMoodIndex {
			return try DependencyInjector.get(ImporterFactory.self).introspectiveMoodImporter()
		} else if indexPath == Me.easyPillMedicationIndex {
			return try DependencyInjector.get(ImporterFactory.self).easyPillMedicationImporter()
		} else if indexPath == Me.easyPillDoseIndex {
			return try DependencyInjector.get(ImporterFactory.self).easyPillMedicationDoseImporter()
		} else if indexPath == Me.introspectiveMedicationIndex {
			return try DependencyInjector.get(ImporterFactory.self).introspectiveMedicationImporter()
		} else {
			Me.log.error("Unknown index path: (section: %d, row: %d)", indexPath.section, indexPath.row)
			throw Errors.unknownIndexPath
		}
	}

	private final func endBackgroundTask(id: UIBackgroundTaskIdentifier) {
		guard id != .invalid else { return }
		UIApplication.shared.endBackgroundTask(id)
	}

	// MARK: Send User Notification Functions

	private final func sendSuccessfulImportNotification(for importer: Importer) {
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(forKey: "Finished importing", arguments: nil)
		content.body = NSString.localizedUserNotificationString(
			forKey: "Finished importing %@ from %@",
			arguments: [
				importer.dataTypePluralName.localizedLowercase,
				importer.sourceName,
			]
		)
		content.sound = UNNotificationSound.default
		switch importer {
		case is ActivityImporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedImportingActivities.identifier
			break
		case is MedicationImporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedImportingMedications.identifier
			break
		case is MoodImporter:
			content.categoryIdentifier = UserNotificationDelegate.finishedImportingMoods.identifier
			break
		default:
			Me.log.error("Forgot a type of importer for notifications: %@", String(describing: importer))
		}
		sendUserNotification(withContent: content, id: "FinishedImport")
	}

	private final func sendExtendTimeNotification(for backgroundTaskId: UIBackgroundTaskIdentifier) {
		guard let importer = backgroundImports({ $0[backgroundTaskId] }) else {
			Me.log.error("Missing importer for background task")
			// just let it go because won't be able to resume the import anyways
			return
		}
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Long running %@ import",
			arguments: [importer.dataTypePluralName]
		)
		content.body = NSString.localizedUserNotificationString(
			forKey: "Would you like to continue the import from %@?",
			arguments: [importer.sourceName]
		)
		content.sound = UNNotificationSound.default
		content.categoryIdentifier = UserNotificationDelegate.timeExpired.identifier
		// can't use normal UserInfoKey : Any. Must be String : String
		// or errors will be thrown when notification is requested
		content.userInfo = [
			UserInfoKey.backgroundTaskId.description: String(backgroundTaskId.rawValue),
		]
		sendUserNotification(withContent: content, id: "ExtendImportTime")
	}

	private final func sendBackgroundErrorNotification(for importer: Importer, error: Error) {
		let dataType = importer.dataTypePluralName.localizedLowercase
		let source = importer.sourceName
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Failed to import %@ from %@",
			arguments: [
				dataType,
				source,
			]
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
		sendUserNotification(withContent: content, id: "ImportErrorOccurred")
	}
}

// MARK: - UIDocumentPickerDelegate

extension ImportDataTableViewController: UIDocumentPickerDelegate {
	public final func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		if urls.count != 1 {
			Me.log.error("Wrong number of urls for document picker: received %d", urls.count)
			return
		}
		let url = urls[0]
		runImportInBackground(importer, url)

		let taskDescription = "Importing " + importer.dataTypePluralName + " from " + importer.sourceName
		let alert = UIAlertController(
			title: taskDescription,
			message: "This may take a while. You can do something else and, if enabled, you will receive a notification when done.",
			preferredStyle: .alert
		)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		presentView(alert)

		// do this in order to make sure no importer type initialization from tableView(didSelectRowAt:) was forgotten
		importer = nil
	}
}
