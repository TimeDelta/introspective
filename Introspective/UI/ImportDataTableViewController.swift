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

final class ImportDataTableViewController: UITableViewController, UIDocumentPickerDelegate {

	private typealias Me = ImportDataTableViewController
	
	private final var importer: Importer!

	final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let documentPickerController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
		documentPickerController.allowsMultipleSelection = false
		documentPickerController.delegate = self
		self.present(documentPickerController, animated: true, completion: nil)
		if indexPath.section == 0 && indexPath.row == 0 {
			importer = DependencyInjector.importer.wellnessMoodImporter()
		}
	}

	public final func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		let localImporter = self.importer!
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try localImporter.importData(from: url)
				let messageText = "Sucessfully imported " + localImporter.dataTypePluralName.localizedLowercase + " from " + localImporter.sourceName
				DispatchQueue.main.async {
					let banner = StatusBarNotificationBanner(title: messageText, style: .success)
					banner.show()
				}
			} catch {
				os_log("Failed to import data: %@", type: .error, error.localizedDescription)
				let alert = UIAlertController(title: "Failed to import data", message: nil, preferredStyle: .alert)
				self.present(alert, animated: false)
			}
		}
		importer = nil // do this in order to make sure no importer type initialization from tableView(didSelectRowAt:) was forgotten
	}
}
