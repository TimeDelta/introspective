//
//  EditMedicationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import CoreData
import os

public final class EditMedicationViewController: UIViewController {

	// MARK: - Static Variables

	private typealias Me = EditMedicationViewController
	private static let frequencyChanged = Notification.Name("medicationFrequencyChanged")
	private static let startedOnChanged = Notification.Name("medicationStartedOnChanged")
	private static let frequencyPresenter: Presentr = {
		let customType = PresentationType.custom(width: .custom(size: 250), height: .custom(size: 250), center: .topCenter)
		let customPresenter = Presentr(presentationType: customType)
		customPresenter.dismissTransitionType = .crossDissolve
		customPresenter.roundCorners = true
		return customPresenter
	}()

	// MARK: - IBOutlets

	@IBOutlet weak final var nameLabel: UILabel!
	@IBOutlet weak final var nameTextField: UITextField!

	@IBOutlet weak final var frequencyButton: UIButton!
	@IBOutlet weak final var resetFrequencyButton: UIButton!

	@IBOutlet weak final var startedOnButton: UIButton!
	@IBOutlet weak final var resetStartedOnButton: UIButton!

	@IBOutlet weak final var dosageLabel: UILabel!
	@IBOutlet weak final var dosageTextField: UITextField!

	@IBOutlet weak final var notesLabel: UILabel!
	@IBOutlet weak final var notesTextView: UITextView!

	@IBOutlet weak final var scrollView: UIScrollView!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	/// This will only be used in the case that `medication` is not set
	public final var initialName: String?
	public final var medication: Medication?
	private final var startedOnDate: Date?
	private final var frequency: Frequency?

	private final var saveButton: UIBarButtonItem!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		frequency = medication?.frequency
		nameTextField.text = medication?.name ?? initialName
		startedOnDate = medication?.startedOn
		updateFrequencyButtonTitle()
		updateStartedOnDateButtonTitle()
		dosageTextField.text = medication?.dosage?.description
		notesTextView.text = medication?.notes ?? ""

		saveButton = UIBarButtonItem(
			title: "Save",
			style: .done,
			target: self,
			action: #selector(saveButtonPressed))
		navigationItem.rightBarButtonItem = saveButton

		validate()

		if frequency == nil {
			DependencyInjector.util.ui.setButton(resetFrequencyButton, enabled: false, hidden: true)
		}
		if startedOnDate == nil {
			DependencyInjector.util.ui.setButton(resetStartedOnButton, enabled: false, hidden: true)
		}

		notesTextView.delegate = self
		scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(setFrequency), name: Me.frequencyChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(setStartedOnDate), name: Me.startedOnChanged, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Received Notifications

	@objc private final func setFrequency(notification: Notification) {
		frequency = notification.object as? Frequency
		updateFrequencyButtonTitle()
		if frequency != nil {
			DependencyInjector.util.ui.setButton(resetFrequencyButton, enabled: true, hidden: false)
		}
	}

	@objc private final func setStartedOnDate(notification: Notification) {
		if let date = notification.object as? Date {
			startedOnDate = DependencyInjector.util.calendar.start(of: .day, in: date)
			DependencyInjector.util.ui.setButton(resetStartedOnButton, enabled: true, hidden: false)
		} else {
			startedOnDate = nil
		}
		updateStartedOnDateButtonTitle()
	}

	@objc private final func keyboardWillHide(notification: Notification) {
		scrollView.scrollTo(direction: .top, animated: false)
	}

	// MARK: - Button Actions

	@IBAction final func frequencyDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.frequency.extendedDescription ?? "No description"
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func frequencyButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "chooseFrequency") as! FrequencyEditorViewController
		controller.initialFrequency = medication?.frequency
		controller.notificationToSendOnAccept = Me.frequencyChanged
		customPresentViewController(Me.frequencyPresenter, viewController: controller, animated: true)
	}

	@IBAction final func resetFrequencyButtonPressed(_ sender: Any) {
		frequency = nil
		updateFrequencyButtonTitle()
		DependencyInjector.util.ui.setButton(resetFrequencyButton, enabled: false, hidden: true)
	}

	@IBAction final func startedOnDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.startedOn.extendedDescription ?? "No description"
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func startedOnButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController
		controller.initialDate = startedOnDate
		controller.notificationToSendOnAccept = Me.startedOnChanged
		controller.datePickerMode = .date
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: true)
	}

	@IBAction final func resetStartedOnButtonPressed(_ sender: Any) {
		startedOnDate = nil
		updateStartedOnDateButtonTitle()
		DependencyInjector.util.ui.setButton(resetStartedOnButton, enabled: false, hidden: true)
	}

	@IBAction final func dosageDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.dosage.extendedDescription ?? "No description"
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		do {
			if medication == nil {
				medication = try DependencyInjector.db.new(Medication.self)
			}
			medication!.name = nameTextField.text!
			medication!.frequency = frequency
			medication!.startedOn = startedOnDate
			if let dosageText = dosageTextField.text {
				medication!.dosage = Dosage(dosageText)
			}
			if !notesTextView.text.isEmpty {
				medication!.notes = notesTextView.text
			}

			DispatchQueue.main.async {
				NotificationCenter.default.post(name: self.notificationToSendOnAccept, object: self.medication)
			}
			navigationController?.popViewController(animated: true)
		} catch {
			os_log("Failed to save medication: %@", type: .error, error.localizedDescription)
			let alert = UIAlertController(title: "Could not save medication", message: "Sorry for the inconvenience", preferredStyle: .alert)
			present(alert, animated: false, completion: nil)
		}
	}

	@IBAction final func nameOrDosageValueChanged(_ sender: Any) {
		validate()
	}

	// MARK: - Helper Functions

	private final func updateFrequencyButtonTitle() {
		let frequencyText = frequency?.description ?? "As needed"
		frequencyButton.setTitle(frequencyText, for: .normal)
		frequencyButton.accessibilityValue = frequencyText
	}

	private final func updateStartedOnDateButtonTitle() {
		var startedOnText = "Not set"
		if let date = startedOnDate {
			startedOnText = DependencyInjector.util.calendar.string(for: date, dateStyle: .long, timeStyle: .none)
		}
		startedOnButton.setTitle(startedOnText, for: .normal)
		startedOnButton.accessibilityValue = startedOnText
	}

	private final func validate() {
		if markFieldAsValid(nameIsValid(), nameLabel) && markFieldAsValid(dosageIsValid(), dosageLabel) {
			saveButton.isEnabled = true
		}
	}

	private final func markFieldAsValid(_ valid: Bool, _ label: UILabel) -> Bool {
		if valid {
			label.textColor = .black
		} else {
			label.textColor = .red
			saveButton.isEnabled = false
		}
		return valid
	}

	private final func nameIsValid() -> Bool {
		if let nameText = nameTextField.text {
			return !nameText.isEmpty && !isDuplicate(nameText)
		}
		return false
	}

	private final func isDuplicate(_ name: String) -> Bool {
		let originalName = medication?.name ?? initialName ?? ""
		guard name.localizedLowercase != originalName.localizedLowercase else { return false }
		let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", name)
		do {
			let medicationsWithSameName = try DependencyInjector.db.query(fetchRequest)
			return medicationsWithSameName.count > 0
		} catch {
			os_log("Failed to check for medication name duplication", type: .error)
		}
		return false
	}

	private final func dosageIsValid() -> Bool {
		 return dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}
}

// MARK: - UITextViewDelegate

extension EditMedicationViewController: UITextViewDelegate {

	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		scrollView.scrollToView(view: notesLabel, animated: true)
		return true
	}
}
