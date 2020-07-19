//
//  EditMedicationViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 10/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples

public final class EditMedicationViewController: UIViewController {
	// MARK: - Static Variables

	private typealias Me = EditMedicationViewController
	private static let frequencyChanged = Notification.Name("medicationFrequencyChanged")
	private static let startedOnChanged = Notification.Name("medicationStartedOnChanged")
	private static let frequencyPresenter: Presentr = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 250),
		height: .custom(size: 250),
		center: .topCenter
	)
	private static let startedOnPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)
	private static let descriptionPresenter = DependencyInjector.get(UiUtil.self).customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center
	)

	// MARK: - IBOutlets

	@IBOutlet final var nameLabel: UILabel!
	@IBOutlet final var nameTextField: UITextField!

	@IBOutlet final var frequencyButton: UIButton!
	@IBOutlet final var resetFrequencyButton: UIButton!

	@IBOutlet final var startedOnButton: UIButton!
	@IBOutlet final var resetStartedOnButton: UIButton!

	@IBOutlet final var dosageLabel: UILabel!
	@IBOutlet final var dosageTextField: UITextField!

	@IBOutlet final var notesLabel: UILabel!
	@IBOutlet final var notesTextView: UITextView!

	@IBOutlet final var scrollView: UIScrollView!
	@IBOutlet final var scrollContentView: UIView!

	// MARK: - Instance Variables

	public final var notificationToSendOnAccept: Notification.Name!
	/// This will only be used in the case that `medication` is not set
	public final var initialName: String?
	public final var medication: Medication?
	private final var startedOnDate: Date?
	private final var frequency: Frequency?

	private final var saveButton: UIBarButtonItem!

	private final let log = Log()

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		extendedLayoutIncludesOpaqueBars = true

		if let medication = medication {
			navigationItem.title = "Edit \(medication.name)"
		} else {
			navigationItem.title = "Create New Medication"
		}

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
			action: #selector(saveButtonPressed)
		)
		navigationItem.rightBarButtonItem = saveButton

		validate()

		if frequency == nil {
			DependencyInjector.get(UiUtil.self).setButton(resetFrequencyButton, enabled: false, hidden: true)
		}
		if startedOnDate == nil {
			DependencyInjector.get(UiUtil.self).setButton(resetStartedOnButton, enabled: false, hidden: true)
		}

		notesTextView.delegate = self
		scrollView.contentSize = scrollContentView.frame.size

		observe(selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification)
		observe(selector: #selector(setFrequency), name: Me.frequencyChanged)
		observe(selector: #selector(setStartedOnDate), name: Me.startedOnChanged)

		hideKeyboardOnTapNonTextInput()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Received Notifications

	@objc private final func setFrequency(notification: Notification) {
		frequency = value(for: .frequency, from: notification)
		updateFrequencyButtonTitle()
		if frequency != nil {
			DependencyInjector.get(UiUtil.self).setButton(resetFrequencyButton, enabled: true, hidden: false)
		}
	}

	@objc private final func setStartedOnDate(notification: Notification) {
		let date: Date? = value(for: .date, from: notification)
		if date != nil {
			startedOnDate = DependencyInjector.get(CalendarUtil.self).start(of: .day, in: date!)
			DependencyInjector.get(UiUtil.self).setButton(resetStartedOnButton, enabled: true, hidden: false)
		} else {
			startedOnDate = nil
		}
		updateStartedOnDateButtonTitle()
	}

	@objc private final func keyboardWillHide(notification _: Notification) {
		scrollView.contentSize = scrollContentView.frame.size
	}

	// MARK: - Button Actions

	@IBAction final func frequencyDescriptionButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = Medication.frequency.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func frequencyButtonPressed(_: Any) {
		let controller: FrequencyEditorViewController = viewController(named: "chooseFrequency", fromStoryboard: "Util")
		controller.initialFrequency = medication?.frequency
		controller.notificationToSendOnAccept = Me.frequencyChanged
		customPresentViewController(Me.frequencyPresenter, viewController: controller, animated: false)
	}

	@IBAction final func resetFrequencyButtonPressed(_: Any) {
		frequency = nil
		updateFrequencyButtonTitle()
		DependencyInjector.get(UiUtil.self).setButton(resetFrequencyButton, enabled: false, hidden: true)
	}

	@IBAction final func startedOnDescriptionButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = Medication.startedOn.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func startedOnButtonPressed(_: Any) {
		let controller = viewController(named: "datePicker", fromStoryboard: "Util") as! SelectDateViewController
		controller.initialDate = startedOnDate
		controller.notificationToSendOnAccept = Me.startedOnChanged
		controller.datePickerMode = .date
		customPresentViewController(Me.startedOnPresenter, viewController: controller, animated: false)
	}

	@IBAction final func resetStartedOnButtonPressed(_: Any) {
		startedOnDate = nil
		updateStartedOnDateButtonTitle()
		DependencyInjector.get(UiUtil.self).setButton(resetStartedOnButton, enabled: false, hidden: true)
	}

	@IBAction final func dosageDescriptionButtonPressed(_: Any) {
		let controller: DescriptionViewController = viewController(named: "description", fromStoryboard: "Util")
		controller.descriptionText = Medication.dosage.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.get(Database.self).transaction()
			var medication: Medication
			if let localMedication = self.medication {
				medication = try transaction.pull(savedObject: localMedication)
			} else {
				medication = try transaction.new(Medication.self)
				medication.setSource(.introspective)
				medication
					.recordScreenIndex = Int16(
						try DependencyInjector.get(Database.self)
							.query(Medication.fetchRequest()).count
					)
			}
			medication.name = nameTextField.text!
			medication.frequency = frequency
			medication.startedOn = startedOnDate
			if let dosageText = dosageTextField.text {
				medication.dosage = Dosage(dosageText)
			}
			if !notesTextView.text.isEmpty {
				medication.notes = notesTextView.text
			}
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
			medication = try DependencyInjector.get(Database.self).pull(savedObject: medication)

			post(
				notificationToSendOnAccept,
				userInfo: [
					.medication: medication as Any,
				]
			)
			navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save medication: %@", errorInfo(error))
			showError(title: "Could not save medication", error: error, tryAgain: { self.saveButtonPressed(sender) })
		}
	}

	@IBAction final func nameOrDosageValueChanged(_: Any) {
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
			startedOnText = DependencyInjector.get(CalendarUtil.self)
				.string(for: date, dateStyle: .long, timeStyle: .none)
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
			if #available(iOS 13.0, *) {
				label.textColor = .label
			} else {
				label.textColor = .black
			}
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
		do {
			return try DependencyInjector.get(MedicationDAO.self).medicationExists(withName: name)
		} catch {
			log.error("Failed to check for medication name duplication: %@", errorInfo(error))
			return true
		}
	}

	private final func dosageIsValid() -> Bool {
		dosageTextField.text == nil ||
			dosageTextField.text!.isEmpty ||
			Dosage(dosageTextField.text!) != nil
	}
}

// MARK: - UITextViewDelegate

extension EditMedicationViewController: UITextViewDelegate {
	public func textViewShouldBeginEditing(_: UITextView) -> Bool {
		scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
		scrollView.scrollToView(view: notesLabel, animated: false)
		return true
	}
}
