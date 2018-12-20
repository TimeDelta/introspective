//
//  ImportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import os

final class ImportDataTableViewController: UITableViewController {

	private typealias Me = ImportDataTableViewController
	private enum Errors: Error {
		case unknownIndexPath
	}

	// activities
	private static let activitiesSection = 0
	private static let aTrackerActivityIndex = IndexPath(row: 0, section: activitiesSection)

	// medications
	private static let medicationSection = 1
	private static let easyPillMedicationIndex = IndexPath(row: 0, section: medicationSection)
	private static let easyPillDoseIndex = IndexPath(row: 1, section: medicationSection)

	// moods
	private static let moodSection = 2
	private static let wellnessMoodIndex = IndexPath(row: 0, section: moodSection)

	private final var importer: Importer!

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
				self.importer.resetLastImportDate()
			})
			actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
				self.tableView.deselectRow(at: indexPath, animated: false)
			})
			present(actionSheet, animated: true, completion: nil)
		} catch {
			os_log("Failed to create data importer while presenting menu: %@", error.localizedDescription)
		}
	}

	// MARK: - Helper Functions

	private final func promptForDataImport(_ indexPath: IndexPath) {
		var message = "This will only import data that was recorded after the imported record with the most recent date and time."
		if indexPath == Me.easyPillMedicationIndex {
			message = "This will not import any medications with the name of one that you have already saved."
		}
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
		self.present(documentPickerController, animated: true, completion: nil)
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
			os_log("Unknown index path: (section: %d, row: %d)", type: .error, indexPath.section, indexPath.row)
			throw Errors.unknownIndexPath
		}
	}
}

// MARK: - UIDocumentPickerDelegate

extension ImportDataTableViewController: UIDocumentPickerDelegate {

	public final func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		let localImporter = self.importer!
		DispatchQueue.global(qos: .background).async {
			do {
				try localImporter.importData(from: url)
				let messageText = "Sucessfully imported " + localImporter.dataTypePluralName.localizedLowercase + " from " + localImporter.sourceName
				DispatchQueue.main.async {
					let banner = StatusBarNotificationBanner(title: messageText, style: .success)
					banner.show()
				}
			} catch {
				os_log("Failed to import data: %@", type: .error, error.localizedDescription)
				var title = "Failed to import data"
				var message: String? = nil
				if let displayableError = error as? DisplayableError {
					title = displayableError.displayableTitle
					message = displayableError.displayableDescription
				}
				let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: false)
			}
		}
		importer = nil // do this in order to make sure no importer type initialization from tableView(didSelectRowAt:) was forgotten
	}
}
