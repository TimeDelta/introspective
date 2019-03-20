//
//  ImportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate
import UserNotifications
import NotificationBannerSwift

final class ImportDataTableViewController: UITableViewController {

	// MARK: - Static Variables

	private typealias Me = ImportDataTableViewController
	private enum Errors: Error {
		case unknownIndexPath
	}

	// MARK: activities
	private static let activitiesSection = 0
	private static let aTrackerActivityIndex = IndexPath(row: 0, section: activitiesSection)

	// MARK: medications
	private static let medicationSection = 1
	private static let easyPillMedicationIndex = IndexPath(row: 0, section: medicationSection)
	private static let easyPillDoseIndex = IndexPath(row: 1, section: medicationSection)

	// MARK: moods
	private static let moodSection = 2
	private static let wellnessMoodIndex = IndexPath(row: 0, section: moodSection)

	// MARK: - Instance Variables

	private final var importer: Importer!
	private final var backgroundImports = [UIBackgroundTaskIdentifier: Importer]()
	/// This is necessary because can't reference the local variable with
	/// the returned id from its expiration handler otherwise compiler will
	/// complain about referencing a variable in its definition.
	private final var taskIds = [UUID: UIBackgroundTaskIdentifier]()

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		observe(selector: #selector(extendTime), name: .extendBackgroundTaskTime)
		observe(selector: #selector(cancelBackgroundImport), name: .cancelBackgroundTask)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Table View Delegate

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		do {
			importer = try getImporterFor(indexPath)
			var lastImportedText: String
			if let importDate = importer.lastImport {
				let dateText = DependencyInjector.util.calendar.string(for: importDate, dateStyle: .medium, timeStyle: .medium)
				lastImportedText = "Last import date: \(dateText)"
			} else {
				lastImportedText = "Never imported"
			}
			let actionSheet = UIAlertController(title: lastImportedText, message: nil, preferredStyle: .actionSheet)
			actionSheet.addAction(UIAlertAction(title: "Import", style: .default){ _ in
				self.promptForDataImport(indexPath)
			})
			actionSheet.addAction(UIAlertAction(title: "Reset Last Import Date", style: .default){ _ in
				do {
					try self.importer.resetLastImportDate()
				} catch {
					self.log.error("Failed to reset last import date: %@", errorInfo(error))
					self.showError(title: "Failed to reset last import date", error: error)
				}
			})
			actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
				self.tableView.deselectRow(at: indexPath, animated: false)
			})
			present(actionSheet, animated: false, completion: nil)
		} catch {
			log.error("Failed to create data importer while presenting menu: %@", errorInfo(error))
		}
	}

	// MARK: - Received Notifiations

	@objc private final func extendTime(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let importer = backgroundImports[backgroundTaskId] {
				runImportInBackground(importer)
				backgroundImports[backgroundTaskId] = nil
			} else {
				log.error("Unable to retrieve importer for background task: %d", backgroundTaskId.rawValue)
			}
		}
	}

	@objc private final func cancelBackgroundImport(notification: Notification) {
		if let taskId: String = value(for: .backgroundTaskId, from: notification) {
			guard let taskIdRawValue = Int(taskId) else {
				log.error("Failed to convert %@ to raw value for background task id", taskId)
				return
			}
			let backgroundTaskId = UIBackgroundTaskIdentifier(rawValue: taskIdRawValue)
			if let importer = backgroundImports[backgroundTaskId] {
				importer.pause()
			}
			backgroundImports[backgroundTaskId] = nil
		}
	}

	// MARK: - Helper Functions

	private final func promptForDataImport(_ indexPath: IndexPath) {
		let message = importer.customImportMessage ??
			"This will only import data that was recorded after the imported record with the most recent date and time."
		let prompt = UIAlertController(title: "Import new data only?", message: message, preferredStyle: .alert)
		prompt.addAction(UIAlertAction(title: "No", style: .destructive) { _ in
			self.importData(newDataOnly: false, indexPath: indexPath)
		})
		prompt.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
			self.importData(newDataOnly: true, indexPath: indexPath)
		})
		present(prompt, animated: false, completion: nil)
	}

	private final func importData(newDataOnly: Bool, indexPath: IndexPath) {
		let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
		documentPickerController.allowsMultipleSelection = false
		documentPickerController.delegate = self
		importer.importOnlyNewData = newDataOnly
		self.present(documentPickerController, animated: false, completion: nil)
	}

	private final func runImportInBackground(_ importer: Importer, _ url: URL? = nil) {
		let dataType = importer.dataTypePluralName
		let source = importer.sourceName
		let taskDescription = "Import " + dataType + " from " + source
		DispatchQueue.global(qos: .utility).async {
			let uuid = UUID()
			let backgroundTask = UIApplication.shared.beginBackgroundTask(withName: taskDescription) { [weak self] in
				self?.log.info("Background task to import %@ from %@ expired", dataType, source)
				importer.pause()
				guard let taskId = self?.taskIds[uuid] else {
					self?.log.error("Missing background task id. App might be killed by iOS due to inability to end background task.")
					return
				}
				self?.sendExtendTimeNotification(for: taskId)
				self?.endBackgroundTask(id: taskId)
			}

			do {
				self.backgroundImports[backgroundTask] = importer
				self.taskIds[uuid] = backgroundTask
				if let url = url {
					self.log.info("Starting background import for %@ from %@", dataType, source)
					try importer.importData(from: url)
				} else {
					self.log.info("Continuing background import for %@ from %@", dataType, source)
					try importer.resume()
				}
				if !importer.isPaused {
					self.sendSuccessfulImportNotification(for: importer)
				}
			} catch {
				self.log.error("Failed to import %@ from %@: %@", dataType, source, errorInfo(error))
				self.sendBackgroundErrorNotification(for: importer, error: error)
			}
			if !importer.isPaused {
				self.log.info("Finished background import for %@ from %@", dataType, source)
				self.backgroundImports[backgroundTask] = nil
				self.endBackgroundTask(id: backgroundTask)
			}
		}
	}

	private final func getImporterFor(_ indexPath: IndexPath) throws -> Importer {
		if indexPath == Me.aTrackerActivityIndex {
			return try DependencyInjector.importer.aTrackerActivityImporter()
		} else if indexPath == Me.wellnessMoodIndex {
			return try DependencyInjector.importer.wellnessMoodImporter()
		} else if indexPath == Me.easyPillMedicationIndex {
			return try DependencyInjector.importer.easyPillMedicationImporter()
		} else if indexPath == Me.easyPillDoseIndex {
			return try DependencyInjector.importer.easyPillMedicationDoseImporter()
		} else {
			log.error("Unknown index path: (section: %d, row: %d)", indexPath.section, indexPath.row)
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
				importer.sourceName])
		content.sound = UNNotificationSound.default
		switch(importer) {
			case is ActivityImporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedImportingActivities.identifier
			case is MedicationImporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedImportingMedications.identifier
			case is MoodImporter:
				content.categoryIdentifier = UserNotificationDelegate.finishedImportingMoods.identifier
			default:
				log.error("Forgot a type of importer for notifications: %@", String(describing: importer))
		}
		sendUserNotification(withContent: content, id: "FinishedImport")
	}

	private final func sendExtendTimeNotification(for backgroundTaskId: UIBackgroundTaskIdentifier) {
		guard let importer = backgroundImports[backgroundTaskId] else {
			log.error("Missing importer for background task")
			// just let it go because won't be able to resume the import anyways
			return
		}
		let content = UNMutableNotificationContent()
		content.title = NSString.localizedUserNotificationString(
			forKey: "Long running %@ import",
			arguments: [importer.dataTypePluralName])
		content.body = NSString.localizedUserNotificationString(
			forKey: "Would you like to continue the import from %@?",
			arguments: [importer.sourceName])
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
			])
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

	private final func sendUserNotification(withContent content: UNMutableNotificationContent, id: String) {
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		log.debug("Sending user notification: %@", content.title)
		UNUserNotificationCenter.current().add(request) { (error : Error?) in
			if let error = error {
				self.log.error("Failed to send user notification (%@): %@", content.title, errorInfo(error))
			}
		}
	}
}

// MARK: - UIDocumentPickerDelegate

extension ImportDataTableViewController: UIDocumentPickerDelegate {

	public final func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		runImportInBackground(importer, url)

		let taskDescription = "Importing " + importer.dataTypePluralName + " from " + importer.sourceName
		let alert = UIAlertController(title: taskDescription, message: "This may take a while. You can do something else and, if enabled, you will receive a notification when done.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		present(alert, animated: false)

		importer = nil // do this in order to make sure no importer type initialization from tableView(didSelectRowAt:) was forgotten
	}
}
