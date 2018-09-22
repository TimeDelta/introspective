//
//  ImportDataTableViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 9/3/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

final class ImportDataTableViewController: UITableViewController, UIDocumentPickerDelegate {

	private typealias Me = ImportDataTableViewController
	private static let presenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 300), height: .custom(size: 200), center: .center)

		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()
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
				let errorMessageController = UIStoryboard(name: "ErrorMessage", bundle: nil).instantiateViewController(withIdentifier: "errorMessage") as! ErrorMessageViewController
				errorMessageController.errorMessage = "Finished importing data"
				self.customPresentViewController(Me.presenter, viewController: errorMessageController, animated: true)
			} catch {
				os_log("Failed to import data: %@", type: .error, error.localizedDescription)
				let errorMessageController = UIStoryboard(name: "ErrorMessage", bundle: nil).instantiateViewController(withIdentifier: "errorMessage") as! ErrorMessageViewController
				errorMessageController.errorMessage = "Data import failed"
				self.customPresentViewController(Me.presenter, viewController: errorMessageController, animated: true)
			}
		}
		importer = nil // do this in order to make sure no importer type initialization from tableView(didSelectRowAt:) was forgotten
	}
}
