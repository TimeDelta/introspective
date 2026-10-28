//
//  QueryNameViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 7/3/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Queries

public final class QueryNameViewController: UIViewController {
	private typealias Me = QueryNameViewController
	private static let log = Log()
	public static let presenter: Presentr = injected(UiUtil.self)
		.customPresenter(width: .full, height: .custom(size: 100), center: .topCenter)

	@IBOutlet final var nameField: UITextField!
	@IBOutlet final var alreadyExistsLabel: UILabel!
	@IBOutlet final var saveButton: UIButton!

	public var notificationToSendOnSave: Notification.Name!

	public override func viewDidLoad() {
		super.viewDidLoad()
		nameEdited(self)
	}

	/// cannot be called unless name is not empty and not alreeady taken.
	@IBAction public func savePressed(_: Any) {
		let name = (nameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
		guard !name.isEmpty, saveButton.isEnabled else { return }
		// make sure query with that name doesn't exist yet
		saveButton.isEnabled = false
		dismiss(animated: false) {
			self.syncPost(self.notificationToSendOnSave, userInfo: [.text: name])
		}
	}

	@IBAction public func cancelPressed() {
		dismiss(animated: false, completion: nil)
	}

	@IBAction public func nameEdited(_: Any) {
		guard let rawName = nameField.text, !rawName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
			saveButton.isEnabled = false
			alreadyExistsLabel.isHidden = true
			return
		}
		let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
		do {
			let query = try injected(StoredQueriesDAO.self).getQueryWith(name: name)
			if query == nil {
				saveButton.isEnabled = true
				alreadyExistsLabel.isHidden = true
			} else {
				saveButton.isEnabled = false
				alreadyExistsLabel.isHidden = false
			}
		} catch {
			saveButton.isEnabled = false
			Me.log.error("Failed to check for existing query with name: %@", errorInfo(error))
		}
	}
}
