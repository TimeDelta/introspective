//
//  ActivityDefinitionNameTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/30/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import CoreData
import os

public final class ActivityDefinitionNameTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var nameLabel: UILabel!
	@IBOutlet weak final var nameTextField: UITextField!

	// MARK: - Instance Variables

	public final var notificationToSendOnInvalidName: Notification.Name!
	public final var notificationToSendOnNameChange: Notification.Name!
	public final var initialName: String = "" {
		didSet {
			nameTextField.text = initialName
			nameChanged(self)
		}
	}

	// MARK: - Actions

	@IBAction final func nameChanged(_ sender: Any) {
		if nameTextField.text?.isEmpty ?? true || isDuplicate() {
			nameLabel.textColor = .red
			sendInvalidNameNotification()
		} else {
			nameLabel.textColor = .black
			// only need to notify when the name is changed to something valid because user can't save when invalid
			sendNameChangeNotification()
		}
	}

	// MARK: - Helper Functions

	private final func sendNameChangeNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnNameChange, object: self.nameTextField.text ?? "")
		}
	}

	private final func sendInvalidNameNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnInvalidName, object: nil)
		}
	}

	private final func isDuplicate() -> Bool {
		if let name = nameTextField.text {
			guard name.localizedLowercase != initialName.localizedLowercase else { return false }
			let fetchRequest: NSFetchRequest<ActivityDefinition> = ActivityDefinition.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
			do {
				let results = try DependencyInjector.db.query(fetchRequest)
				return results.count > 0
			} catch {
				os_log("Failed to check for activity name duplication", type: .error)
			}
		}
		return false
	}
}