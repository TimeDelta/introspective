//
//  NumericAttributeValueViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 8/2/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Attributes
import Common
import DependencyInjection

final class NumericAttributeValueViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var textField: UITextField!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var numericAttribute: NumericAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentValue: Any!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if currentValue != nil {
			if numericAttribute is DoubleAttribute {
				textField.text = String(currentValue as! Double)
			} else if numericAttribute is IntegerAttribute {
				textField.text = String(currentValue as! Int)
			} else {
				log.error("Forgot a type of NumericAttribute when setting initial value for text field")
			}
		}
	}

	// MARK: - Actions

	@IBAction final func valueChanged(_ sender: Any) {
		validate(value: textField.text)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.attributeValue: self.currentValue,
				]))
		}
		dismiss(animated: false, completion: nil)
	}

	// MARK: - Helper Functions

	private final func validate(value: String?) {
		if value != nil && numericAttribute.isValid(value: value!) {
			do {
				currentValue = try numericAttribute.convertToValue(from: value ?? "")
				enableSaveButton()
			} catch {
				log.error("Failed to convert value of '%@' to number: %@", value ?? "", errorInfo(error))
			}
		} else {
			disableSaveButton()
		}
	}

	private final func disableSaveButton() {
		DependencyInjector.get(UiUtil.self).setButton(saveButton, enabled: false, hidden: false)
		saveButton.backgroundColor = UIColor.gray
	}

	private final func enableSaveButton() {
		DependencyInjector.get(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
		saveButton.backgroundColor = UIColor.black
	}
}
