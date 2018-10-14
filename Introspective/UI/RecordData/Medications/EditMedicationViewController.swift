//
//  EditMedicationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os
import Presentr

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

	@IBOutlet weak final var notesTextView: UITextView!

	@IBOutlet weak final var saveButton: UIButton!

	@IBOutlet final var keyboardHeightLayoutConstraint: NSLayoutConstraint?

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	/// This will only be used in the case that `medication` is not set
	public final var initialName: String?
	public final var medication: Medication?
	private final var startedOnDate: Date?
	private final var frequency: Frequency?

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		frequency = medication?.frequency
		nameTextField.text = medication?.name ?? initialName
		startedOnDate = medication?.startedOn
		updateFrequencyButtonTitle()
		updateStartedOnDateButtonTitle()
		dosageTextField.text = medication?.dosage?.description

		validate()

		if frequency == nil {
			UiUtil.setButton(resetFrequencyButton, enabled: false, hidden: true)
		}
		if startedOnDate == nil {
			UiUtil.setButton(resetStartedOnButton, enabled: false, hidden: true)
		}

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
			UiUtil.setButton(resetFrequencyButton, enabled: true, hidden: false)
		}
	}

	@objc private final func setStartedOnDate(notification: Notification) {
		if let date = notification.object as? Date {
			startedOnDate = DependencyInjector.util.calendarUtil.start(of: .day, in: date)
			UiUtil.setButton(resetStartedOnButton, enabled: true, hidden: false)
		} else {
			startedOnDate = nil
		}
		updateStartedOnDateButtonTitle()
	}

	@objc private final func keyboardNotification(notification: NSNotification) {
		if let userInfo = notification.userInfo {
			let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
			let endFrameY = endFrame?.origin.y ?? 0
			let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
			let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
			let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
			let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
			if endFrameY >= UIScreen.main.bounds.size.height {
				self.keyboardHeightLayoutConstraint?.constant = 0.0
			} else {
				self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
			}
			UIView.animate(
				withDuration: duration,
				delay: TimeInterval(0),
				options: animationCurve,
				animations: { self.view.layoutIfNeeded() },
				completion: nil)
		}
	}

	// MARK: - Button Actions

	@IBAction final func frequencyDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.frequency.extendedDescription ?? "No description"
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: false)
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
		UiUtil.setButton(resetFrequencyButton, enabled: false, hidden: true)
	}

	@IBAction final func startedOnDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.startedOn.extendedDescription ?? "No description"
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func startedOnButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "datePicker") as! SelectDateViewController
		controller.initialDate = startedOnDate
		controller.notificationToSendOnAccept = Me.startedOnChanged
		controller.datePickerMode = .date
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: true)
	}

	@IBAction final func resetStartedOnButtonPressed(_ sender: Any) {
		startedOnDate = nil
		updateStartedOnDateButtonTitle()
		UiUtil.setButton(resetStartedOnButton, enabled: false, hidden: true)
	}

	@IBAction final func dosageDescriptionButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Util", bundle: nil).instantiateViewController(withIdentifier: "description") as! DescriptionViewController
		controller.descriptionText = Medication.dosage.extendedDescription ?? "No description"
		customPresentViewController(UiUtil.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		do {
			if medication == nil {
				medication = try DependencyInjector.db.new(objectType: Medication.self)
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
		frequencyButton.setTitle(frequency?.description ?? "As needed", for: .normal)
	}

	private final func updateStartedOnDateButtonTitle() {
		if let date = startedOnDate {
			startedOnButton.setTitle(DependencyInjector.util.calendarUtil.string(for: date, inFormat: "MMMM d, yyyy"), for: .normal)
		} else {
			startedOnButton.setTitle("Not set", for: .normal)
		}
	}

	private final func validate() {
		if markFieldAsValid(nameIsValid(), nameLabel) && markFieldAsValid(dosageIsValid(), dosageLabel) {
			saveButton.backgroundColor = .black
			UiUtil.setButton(saveButton, enabled: true, hidden: false)
		}
	}

	private final func markFieldAsValid(_ valid: Bool, _ label: UILabel) -> Bool {
		if valid {
			label.textColor = .black
		} else {
			label.textColor = .red
			saveButton.backgroundColor = .lightGray
			UiUtil.setButton(saveButton, enabled: false, hidden: false)
		}
		return valid
	}

	private final func nameIsValid() -> Bool {
		return nameTextField.text != nil && !nameTextField.text!.isEmpty
	}

	private final func dosageIsValid() -> Bool {
		 return dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}
}
