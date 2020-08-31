//
//  MedicationDoseEditorViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import SwiftDate
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
	@IBOutlet final var dosageToolbar: UIToolbar!
	@IBOutlet final var resetDosageButton: UIBarButtonItem!
	@IBOutlet final var dateToolbar: UIToolbar!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose?
	/// If `medicationDose` is not set, will use default dosage and is only required if not editing an existing dose
	public final var medication: Medication!
	public final var notificationToSendOnAccept: Notification.Name!
	public final var userInfoKey: UserInfoKey = .dose

	private final var limitDateToStartOfMinute = true
	private final var initialDosageText: String?

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()
		if let medicationDose = medicationDose {
			dosageTextField.text = medicationDose.dosage?.description
		} else {
			dosageTextField.text = medication.dosage?.description
		}
		initialDosageText = dosageTextField.text
		if let date = medicationDose?.date {
			datePicker.date = date
		}
		datePicker.maximumDate = Date()
		datePicker.datePickerMode = .dateAndTime

		resetDosageButton.isEnabled = initialDosageText != nil

		validate()

		dosageTextField.becomeFirstResponder()
		let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		fixedSpace.width = CGFloat(10)
		var dateBarButtons = [UIBarButtonItem]()
		if (try? injected(Database.self).count(Medication.self) > 1) ?? false {
			dateBarButtons.append(UIBarButtonItem(
				title: "Last",
				style: .plain,
				target: self,
				action: #selector(lastButtonPressed)
			))
		}
		dateBarButtons.append(contentsOf: [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			barButton(
				title: "-30",
				quickPress: #selector(quickPressDecrementByThirty),
				longPress: #selector(longPressDecrementByThirty)
			),
			fixedSpace,
			barButton(
				title: "-15",
				quickPress: #selector(quickPressDecrementByFifteen),
				longPress: #selector(longPressDecrementByFifteen)
			),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			barButton(
				title: "+15",
				quickPress: #selector(quickPressIncrementByFifteen),
				longPress: #selector(longPressIncrementByFifteen)
			),
			fixedSpace,
			barButton(
				title: "+30",
				quickPress: #selector(quickPressIncrementByThirty),
				longPress: #selector(longPressIncrementByThirty)
			),
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
			UIBarButtonItem(title: "Now", style: .plain, target: self, action: #selector(nowButtonPressed)),
		])
		dateToolbar.setItems(dateBarButtons, animated: false)
	}

	// MARK: - Actions

	@IBAction final func saveButtonPressed(_ sender: Any) {
		var dosage: Dosage?
		if let dosageText = dosageTextField.text {
			dosage = Dosage(dosageText)
		}
		do {
			let transaction = injected(Database.self).transaction()
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
			medicationDose = try injected(Database.self).pull(savedObject: medicationDose!)
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

	@IBAction final func datePickerValueChanged(_: Any) {
		limitDateToStartOfMinute = true
	}

	@IBAction final func timesTwoPressed(_: Any) {
		multiplyDosage(by: 2)
	}

	@IBAction final func timesThreePressed(_: Any) {
		multiplyDosage(by: 3)
	}

	@IBAction final func timesFourPressed(_: Any) {
		multiplyDosage(by: 4)
	}

	@IBAction final func resetButtonPressed(_: Any) {
		dosageTextField.text = initialDosageText
	}

	@IBAction final func divideByFourPressed(_: Any) {
		multiplyDosage(by: 1.0 / 4)
	}

	@IBAction final func divideByThreePressed(_: Any) {
		multiplyDosage(by: 1.0 / 3)
	}

	@IBAction final func divideByTwoPressed(_: Any) {
		multiplyDosage(by: 1.0 / 2)
	}

	private final func multiplyDosage(by multiplier: Double) {
		guard let dosageText = dosageTextField.text else {
			return
		}
		guard var dosage = Dosage(dosageText) else {
			return
		}
		dosage *= multiplier
		dosageTextField.text = dosage.description
	}

	@IBAction final func lastButtonPressed(_: Any) {
		let actionSheet = injected(UiUtil.self).alert(
			title: "Last dose of which medication?",
			message: "This will pull the date from the last taken dose of the chosen medication",
			preferredStyle: .actionSheet
		)
		do {
			let medications = try injected(MedicationDAO.self).allMedications()
			for medication in medications {
				guard let lastDoseDate = try injected(MedicationDAO.self).mostRecentDoseOf(medication)?.date else {
					continue
				}
				actionSheet.addAction(injected(UiUtil.self).alertAction(
					title: medication.name,
					style: .default
				) { _ in
					self.datePicker.setDate(lastDoseDate, animated: true)
				})
			}
			actionSheet.addAction(injected(UiUtil.self).cancelAlertAction())
			limitDateToStartOfMinute = false
			presentView(actionSheet)
		} catch {
			showError(title: "Something went wrong", message: "Unable to find last dose of other medications")
		}
	}

	@IBAction final func quickPressDecrementByThirty() {
		quickPressIncrementOrDecrement(amountToAdd: -30)
	}

	@IBAction final func longPressDecrementByThirty() {
		showChooseTimeUnitActionSheet(amountToAdd: -30)
	}

	@IBAction final func quickPressDecrementByFifteen() {
		quickPressIncrementOrDecrement(amountToAdd: -15)
	}

	@IBAction final func longPressDecrementByFifteen() {
		showChooseTimeUnitActionSheet(amountToAdd: -15)
	}

	@IBAction final func quickPressIncrementByFifteen() {
		quickPressIncrementOrDecrement(amountToAdd: 15)
	}

	@IBAction final func longPressIncrementByFifteen() {
		showChooseTimeUnitActionSheet(amountToAdd: 15)
	}

	@IBAction final func quickPressIncrementByThirty() {
		quickPressIncrementOrDecrement(amountToAdd: 30)
	}

	@IBAction final func longPressIncrementByThirty() {
		showChooseTimeUnitActionSheet(amountToAdd: 30)
	}

	@IBAction final func nowButtonPressed(_: Any) {
		datePicker.date = Date()
		limitDateToStartOfMinute = false
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
			injected(UiUtil.self).setButton(saveButton, enabled: true, hidden: false)
			// dosageToolbar.items should never be nil but just in case
			if let buttons = dosageToolbar.items {
				for button in buttons {
					button.isEnabled = true
				}
			}
		} else {
			dosageLabel.textColor = .red
			if #available(iOS 13.0, *) {
				saveButton.backgroundColor = .systemGray
			} else {
				saveButton.backgroundColor = .gray
			}
			injected(UiUtil.self).setButton(saveButton, enabled: false, hidden: false)
			// dosageToolbar.items should never be nil but just in case
			if let buttons = dosageToolbar.items {
				for button in buttons {
					button.isEnabled = false
				}
			}
		}
	}

	private final func dosageIsValid() -> Bool {
		dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}

	private final func quickPressIncrementOrDecrement(amountToAdd: Int) {
		datePicker.date = datePicker.date + amountToAdd.minutes
	}

	private final func showChooseTimeUnitActionSheet(amountToAdd: Int) {
		let actionSheet = UIAlertController(title: "Which unit?", message: nil, preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: "Months", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.months
		})
		actionSheet.addAction(UIAlertAction(title: "Weeks", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.weeks
		})
		actionSheet.addAction(UIAlertAction(title: "Days", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.days
		})
		actionSheet.addAction(UIAlertAction(title: "Hours", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.hours
		})
		actionSheet.addAction(UIAlertAction(title: "Minutes", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.minutes
		})
		actionSheet.addAction(UIAlertAction(title: "Seconds", style: .default) { _ in
			self.datePicker.date = self.datePicker.date + amountToAdd.seconds
			self.limitDateToStartOfMinute = false
		})
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		presentView(actionSheet)
	}
}
