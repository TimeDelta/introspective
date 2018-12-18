//
//  MedicationDoseEditorViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os

public final class MedicationDoseEditorViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var dosageLabel: UILabel!
	@IBOutlet weak final var dosageTextField: UITextField!
	@IBOutlet weak final var datePicker: UIDatePicker!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose?
	/// This is only used if `medicationDose` is not set
	public final var medication: Medication?
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		dosageTextField.text = medicationDose?.dosage?.description ?? medication?.dosage?.description
		if let date = medicationDose?.timestamp {
			datePicker.date = date
		}
		datePicker.maximumDate = Date()
		datePicker.datePickerMode = .dateAndTime

		validate()
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var dosage: Dosage?
		if let dosageText = dosageTextField.text {
			dosage = Dosage(dosageText)
		}
		do {
			if medicationDose == nil {
				medicationDose = try DependencyInjector.sample.medicationDose()
			}
			medicationDose!.dosage = dosage
			medicationDose!.timestamp = datePicker.date
			DispatchQueue.main.async {
				NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: self.medicationDose)
			}
			dismiss(animated: true, completion: nil)
		} catch {
			os_log("Failed to create medication dose: %@", type: .error, error.localizedDescription)
			showError(title: "Failed to save", message: "Sorry for the inconvenience")
		}
	}

	@IBAction final func dosageTextChanged(_ sender: Any) {
		validate()
	}

	// MARK: - Helper Functions

	private final func validate() {
		if dosageIsValid() {
			dosageLabel.textColor = .black
			saveButton.backgroundColor = .black
			DependencyInjector.util.ui.setButton(saveButton, enabled: true, hidden: false)
		} else {
			dosageLabel.textColor = .red
			saveButton.backgroundColor = .lightGray
			DependencyInjector.util.ui.setButton(saveButton, enabled: false, hidden: false)
		}
	}

	private final func dosageIsValid() -> Bool {
		 return dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}
}
