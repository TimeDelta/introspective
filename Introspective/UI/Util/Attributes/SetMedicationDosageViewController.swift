//
//  SetMedicationDosageViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection

public final class SetMedicationDosageViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var textField: UITextField!
	@IBOutlet final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var initialDosage: Dosage?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		textField.text = initialDosage?.description
		textField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_: Any) {
		var dosage: Dosage?
		if let dosageText = textField.text {
			dosage = Dosage(dosageText)
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.attributeValue: dosage as Any,
				])
			)
		}
		dismiss(animated: false, completion: nil)
	}

	@IBAction final func dosageTextChanged(_: Any) {
		if dosageIsValid() {
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .label
			} else {
				saveButton.backgroundColor = .black
			}
			injected(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
		} else {
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .systemGray
			} else {
				saveButton.backgroundColor = .gray
			}
			injected(UiUtil.self).setButton(saveButton, enabled: false, hidden: false)
		}
	}

	// MARK: - Helper Functions

	private final func dosageIsValid() -> Bool {
		textField.text == nil ||
			textField.text!.isEmpty ||
			Dosage(textField.text!) != nil
	}
}
