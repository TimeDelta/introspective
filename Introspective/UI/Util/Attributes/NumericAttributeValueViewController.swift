//
//  NumericAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

final class NumericAttributeValueViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var textField: UITextField!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var numericAttribute: NumericAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentValue: Any!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if currentValue != nil {
			if numericAttribute is DoubleAttribute {
				textField.text = String(currentValue as! Double)
			} else if numericAttribute is IntegerAttribute {
				textField.text = String(currentValue as! Int)
			} else {
				os_log("Forgot a type of NumericAttribute when setting initial value for text field", type: .error)
			}
		}
	}

	// MARK: - Actions

	@IBAction final func valueChanged(_ sender: Any) {
		validate(value: textField.text)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: self.currentValue)
		}
		dismiss(animated: true, completion: nil)
	}

	// MARK: - Helper Functions

	private final func validate(value: String?) {
		if value != nil && numericAttribute.isValid(value: value!) {
			currentValue = try! numericAttribute.convertToValue(from: value!)
			enableSaveButton()
		} else {
			disableSaveButton()
		}
	}

	private final func disableSaveButton() {
		DependencyInjector.util.ui.setButton(saveButton, enabled: false, hidden: false)
		saveButton.backgroundColor = UIColor.gray
	}

	private final func enableSaveButton() {
		DependencyInjector.util.ui.setButton(saveButton, enabled: true, hidden: false)
		saveButton.backgroundColor = UIColor.black
	}
}
