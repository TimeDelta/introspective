//
//  SetMedicationDosageViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class SetMedicationDosageViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var textField: UITextField!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var initialDosage: Dosage?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		textField.text = initialDosage?.description
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var dosage: Dosage?
		if let dosageText = textField.text {
			dosage = Dosage(dosageText)
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: dosage)
		}
		dismiss(animated: true, completion: nil)
	}

	@IBAction final func dosageTextChanged(_ sender: Any) {
		if dosageIsValid() {
			saveButton.backgroundColor = .black
			DependencyInjector.util.ui.setButton(saveButton, enabled: true, hidden: false)
		} else {
			saveButton.backgroundColor = .lightGray
			DependencyInjector.util.ui.setButton(saveButton, enabled: false, hidden: false)
		}
	}

	// MARK: - Helper Functions

	private final func dosageIsValid() -> Bool {
		 return textField.text == nil ||
			textField.text!.isEmpty ||
			Dosage(textField.text!) != nil
	}
}
