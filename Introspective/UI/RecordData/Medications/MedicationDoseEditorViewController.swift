//
//  MedicationDoseEditorViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Persistence
import Samples

public protocol MedicationDoseEditorViewController: UIViewController {
	var medicationDose: MedicationDose? { get set }
	/// If `medicationDose` is not set, will use default dosage and is only required if not editing an existing dose
	var medication: Medication! { get set }
	var notificationToSendOnAccept: Notification.Name! { get set }
	var userInfoKey: UserInfoKey { get set }
}

public final class MedicationDoseEditorViewControllerImpl: UIViewController, MedicationDoseEditorViewController {
	// MARK: - Static Variables

	private typealias Me = MedicationDoseEditorViewControllerImpl

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var dosageLabel: UILabel!
	@IBOutlet final var dosageTextField: UITextField!
	@IBOutlet final var datePicker: UIDatePicker!
	@IBOutlet final var saveButton: UIButton!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose?
	/// If `medicationDose` is not set, will use default dosage and is only required if not editing an existing dose
	public final var medication: Medication!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var userInfoKey: UserInfoKey = .dose

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let medicationDose = medicationDose {
			dosageTextField.text = medicationDose.dosage?.description
		} else {
			dosageTextField.text = medication.dosage?.description
		}
		if let date = medicationDose?.date {
			datePicker.date = date
		}
		datePicker.maximumDate = Date()
		datePicker.datePickerMode = .dateAndTime

		validate()

		dosageTextField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var dosage: Dosage?
		if let dosageText = dosageTextField.text {
			dosage = Dosage(dosageText)
		}
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
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
			medicationDose = try DependencyInjector.get(Database.self).pull(savedObject: medicationDose!)
			post(
				notificationToSendOnAccept,
				userInfo: [
					userInfoKey: medicationDose as Any,
				]
			)
			dismiss(animated: false, completion: nil)
		} catch {
			Me.log.error("Failed to create medication dose: %@", errorInfo(error))
			showError(title: "Failed to save dose", error: error, tryAgain: { self.saveButtonPressed(sender) })
		}
	}

	@IBAction final func dosageTextChanged(_: Any) {
		validate()
	}

	// MARK: - Helper Functions

	private final func validate() {
		if dosageIsValid() {
			if #available(iOS 13.0, *) {
				dosageLabel.textColor = .label
				saveButton.backgroundColor = .label
			} else {
				dosageLabel.textColor = .black
				saveButton.backgroundColor = .black
			}
			DependencyInjector.get(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
		} else {
			dosageLabel.textColor = .red
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .systemGray
			} else {
				saveButton.backgroundColor = .gray
			}
			DependencyInjector.get(UiUtil.self).setButton(saveButton, enabled: false, hidden: false)
		}
	}

	private final func dosageIsValid() -> Bool {
		dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}
}
