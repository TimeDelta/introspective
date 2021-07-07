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

	/// cannot be called unless name is not empty and not alreeady taken.
	@IBAction public func savePressed(_: Any) {
		let name = nameField.text!
		// make sure query with that name doesn't exist yet
		post(notificationToSendOnSave, userInfo: [.text: name])
		dismiss(animated: false, completion: nil)
	}

	@IBAction public func cancelPressed() {
		dismiss(animated: false, completion: nil)
	}

	@IBAction public func nameEdited(_: Any) {
		guard let name = nameField.text else {
			saveButton.isEnabled = false
			return
		}
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
			Me.log.error("Failed to check for existing query with name: %@", errorInfo(error))
		}
	}
}
