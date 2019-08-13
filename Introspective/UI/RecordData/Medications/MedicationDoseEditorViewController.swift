//
//  MedicationDoseEditorViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public protocol MedicationDoseEditorViewController: UIViewController {

	var medicationDose: MedicationDose? { get set }
	/// If `medicationDose` is not set, will use default dosage and is only required if not editing an existing dose
	var medication: Medication! { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
}

public final class MedicationDoseEditorViewControllerImpl: UIViewController, MedicationDoseEditorViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var dosageLabel: UILabel!
	@IBOutlet weak final var dosageTextField: UITextField!
	@IBOutlet weak final var datePicker: UIDatePicker!
	@IBOutlet weak final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose?
	/// If `medicationDose` is not set, will use default dosage and is only required if not editing an existing dose
	public final var medication: Medication!
	public final var notificationToSendOnAccept: Notification.Name!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		dosageTextField.text = medicationDose?.dosage?.description ?? medication.dosage?.description
		if let date = medicationDose?.date {
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
			let transaction = DependencyInjector.db.transaction()
			if let dose = medicationDose {
				medicationDose = try transaction.pull(savedObject: dose)
			} else {
				medicationDose = try transaction.new(MedicationDose.self)
				medicationDose?.setSource(.introspective)
				medicationDose?.medication = try transaction.pull(savedObject: medication)
			}
			medicationDose?.dosage = dosage
			medicationDose?.date = datePicker.date
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			medicationDose = try DependencyInjector.db.pull(savedObject: medicationDose!)
			post(
				notificationToSendOnAccept,
				userInfo: [
					.dose: self.medicationDose as Any,
				])
			dismiss(animated: false, completion: nil)
		} catch {
			log.error("Failed to create medication dose: %@", errorInfo(error))
			showError(title: "Failed to save dose", error: error, tryAgain: { self.saveButtonPressed(sender) })
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
