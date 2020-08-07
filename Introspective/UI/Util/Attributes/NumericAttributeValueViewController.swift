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
	// MARK: - Static Variables

	private typealias Me = NumericAttributeValueViewController

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var textField: UITextField!
	@IBOutlet final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var numericAttribute: NumericAttribute!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var currentValue: Any!

	// MARK: - UIViewController Overrides

	final override func viewDidLoad() {
		super.viewDidLoad()
		if let currentValue = currentValue {
			if numericAttribute is DoubleAttribute {
				if let doubleValue = currentValue as? Double {
					textField.text = String(doubleValue)
				} else {
					Me.log.error("Unable to cast DoubleAttribute value as double: %@", String(describing: currentValue))
				}
			} else if numericAttribute is IntegerAttribute {
				if let intValue = currentValue as? Int {
					textField.text = String(intValue)
				} else {
					Me.log.error("Unable to cast IntegerAttribute value as int: %@", String(describing: currentValue))
				}
			} else {
				Me.log.error("Forgot a type of NumericAttribute when setting initial value for text field")
			}
		}
		textField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func valueChanged(_: Any) {
		validate(value: textField.text)
	}

	@IBAction final func saveButtonPressed(_: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.attributeValue: self.currentValue,
				])
			)
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
				Me.log.error("Failed to convert value of '%@' to number: %@", value ?? "", errorInfo(error))
			}
		} else {
			disableSaveButton()
		}
	}

	private final func disableSaveButton() {
		injected(UiUtil.self).setButton(saveButton, enabled: false, hidden: false)
		if #available(iOS 13.0, *) {
			saveButton.backgroundColor = .systemGray
		} else {
			saveButton.backgroundColor = .gray
		}
	}

	private final func enableSaveButton() {
		injected(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
		if #available(iOS 13.0, *) {
			saveButton.backgroundColor = .label
		} else {
			saveButton.backgroundColor = .black
		}
	}
}
