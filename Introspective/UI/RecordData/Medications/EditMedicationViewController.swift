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
	private static let descriptionPresenter = DependencyInjector.util.ui.customPresenter(
		width: .custom(size: 300),
		height: .custom(size: 200),
		center: .center)

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
	@IBOutlet weak final var scrollContentView: UIView!

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
			DependencyInjector.util.ui.setButton(resetFrequencyButton, enabled: true, hidden: false)
		}
	}

	@objc private final func setStartedOnDate(notification: Notification) {
		let date: Date? = value(for: .date, from: notification)
		if date != nil {
			startedOnDate = DependencyInjector.util.calendar.start(of: .day, in: date!)
			DependencyInjector.util.ui.setButton(resetStartedOnButton, enabled: true, hidden: false)
		} else {
			startedOnDate = nil
		}
		updateStartedOnDateButtonTitle()
	}

	@objc private final func keyboardWillHide(notification: Notification) {
		scrollView.contentSize = scrollContentView.frame.size
	}

	// MARK: - Button Actions

	@IBAction final func frequencyDescriptionButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named:"description", fromStoryboard: "Util")
		controller.descriptionText = Medication.frequency.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func frequencyButtonPressed(_ sender: Any) {
		let controller: FrequencyEditorViewController = viewController(named: "chooseFrequency", fromStoryboard: "Util")
		controller.initialFrequency = medication?.frequency
		controller.notificationToSendOnAccept = Me.frequencyChanged
		customPresentViewController(Me.frequencyPresenter, viewController: controller, animated: false)
	}

	@IBAction final func resetFrequencyButtonPressed(_ sender: Any) {
		frequency = nil
		updateFrequencyButtonTitle()
		DependencyInjector.util.ui.setButton(resetFrequencyButton, enabled: false, hidden: true)
	}

	@IBAction final func startedOnDescriptionButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named:"description", fromStoryboard: "Util")
		controller.descriptionText = Medication.startedOn.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func startedOnButtonPressed(_ sender: Any) {
		let controller = viewController(named:"datePicker", fromStoryboard: "Util") as! SelectDateViewController
		controller.initialDate = startedOnDate
		controller.notificationToSendOnAccept = Me.startedOnChanged
		controller.datePickerMode = .date
		customPresentViewController(DependencyInjector.util.ui.defaultPresenter, viewController: controller, animated: false)
	}

	@IBAction final func resetStartedOnButtonPressed(_ sender: Any) {
		startedOnDate = nil
		updateStartedOnDateButtonTitle()
		DependencyInjector.util.ui.setButton(resetStartedOnButton, enabled: false, hidden: true)
	}

	@IBAction final func dosageDescriptionButtonPressed(_ sender: Any) {
		let controller: DescriptionViewController = viewController(named:"description", fromStoryboard: "Util")
		controller.descriptionText = Medication.dosage.extendedDescription ?? "No description"
		customPresentViewController(Me.descriptionPresenter, viewController: controller, animated: false)
	}

	@IBAction final func saveButtonPressed(_ sender: Any) {
		do {
			let transaction = DependencyInjector.db.transaction()
			var medication: Medication
			if let localMedication = self.medication {
				medication = try transaction.pull(savedObject: localMedication)
			} else {
				medication = try transaction.new(Medication.self)
				medication.setSource(.introspective)
				medication.recordScreenIndex = Int16(try DependencyInjector.db.query(Medication.fetchRequest()).count)
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
			medication = try DependencyInjector.db.pull(savedObject: medication)

			post(
				notificationToSendOnAccept,
				userInfo: [
					.medication: medication as Any,
				])
			navigationController?.popViewController(animated: false)
		} catch {
			log.error("Failed to save medication: %@", errorInfo(error))
			showError(title: "Could not save medication", error: error, tryAgain: { self.saveButtonPressed(sender) })
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
			log.error("Failed to check for medication name duplication: %@", errorInfo(error))
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
		scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
		scrollView.scrollToView(view: notesLabel, animated: false)
		return true
	}
}
