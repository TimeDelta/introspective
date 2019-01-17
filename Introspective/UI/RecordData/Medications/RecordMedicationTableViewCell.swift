//
//  RecordMedicationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

public final class RecordMedicationTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMedicationTableViewCell
	public static let errorOccurred = Notification.Name("recordMedicationErrorOcurred")
	public static let shouldPresentMedicationDoseView = Notification.Name("shouldPresentDoseViewFromRecordScreen")
	public static let shouldPresentDosesView = Notification.Name("shouldPresentDosesViewFromRecordScreen")

	// MARK: - IBOutlets

	@IBOutlet weak final var medicationNameLabel: UILabel!
	@IBOutlet weak final var lastTakenOnDateButton: UIButton!
	@IBOutlet weak final var takeButton: UIButton!

	// MARK: - Instance Variables

	public final var medication: Medication! {
		didSet {
			medicationNameLabel.text = medication.name
			updateLastTakenButton()
			updateTakeButtonAccessibility()
			uniqueNotificationNameForMedication = Notification.Name("doseCreatedFor" + medication.objectID.description)
			// have to remove old observers here because table view cells get reused
			NotificationCenter.default.removeObserver(self)
			observe(selector: #selector(doseCreated), name: uniqueNotificationNameForMedication)
		}
	}
	private final var uniqueNotificationNameForMedication: Notification.Name!
	private final var dateThatTakenButtonWasPressed: Date?

	private final let log = Log()

	// MARK: - Received Notifications

	@objc private final func doseCreated(notification: Notification) {
		do {
			if let dose: MedicationDose = value(for: .dose, from: notification) {
				let transaction = DependencyInjector.db.transaction()
				let doseFromTransaction = try transaction.pull(savedObject: dose)
				medication = try transaction.pull(savedObject: medication)
				medication.addToDoses(doseFromTransaction)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				medication = try DependencyInjector.db.pull(savedObject: medication)
				updateLastTakenButton()
			}
		} catch {
			log.error("Failed to mark medication (%@) as taken: %@", medication.name, errorInfo(error))
			var title = "Failed to mark \(medication.name) as taken."
			var message = "Sorry for the inconvenience"
			if let error = error as? DisplayableError {
				title = error.displayableTitle
				if let description = error.displayableDescription {
					message = description
				}
			}
			NotificationCenter.default.post(
				name: Me.errorOccurred,
				object: self,
				userInfo: info([
					.title: title,
					.message: message,
				]))
		}
	}

	// MARK: - Button Actions

	@IBAction final func takeButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: Me.shouldPresentMedicationDoseView,
				object: self,
				userInfo: self.info([
					.notificationName: self.uniqueNotificationNameForMedication,
					.medication: self.medication,
				]))
		}
	}

	@IBAction final func lastTakenButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: Me.shouldPresentDosesView,
				object: self,
				userInfo: self.info([
					.medication: self.medication,
				]))
		}
	}

	// MARK: - Helper Functions

	private final func updateLastTakenButton() {
		var lastTakenText = "Never taken"
		if let mostRecentDose = medication.sortedDoses(ascending: true).last {
			lastTakenText = "Last taken: "
			if let dosage = mostRecentDose.dosage {
				lastTakenText += dosage.description + " on "
			}
			lastTakenText += DependencyInjector.util.calendar.string(for: mostRecentDose.timestamp, dateStyle: .medium, timeStyle: .short)
			DependencyInjector.util.ui.setButton(lastTakenOnDateButton, enabled: true, hidden: false)
		} else {
			DependencyInjector.util.ui.setButton(lastTakenOnDateButton, enabled: false, hidden: false)
		}
		lastTakenOnDateButton.setTitle(lastTakenText, for: .normal)
		lastTakenOnDateButton.accessibilityValue = lastTakenText
		lastTakenOnDateButton.accessibilityHint = "Show all doses of \(medication.name) taken"
		lastTakenOnDateButton.accessibilityLabel = "last \(medication.name) dose button"
		lastTakenOnDateButton.accessibilityIdentifier = "last \(medication.name) dose button"
	}

	private final func updateTakeButtonAccessibility() {
		takeButton.accessibilityIdentifier = "take \(medication.name) button"
		takeButton.accessibilityLabel = "take \(medication.name) button"
		takeButton.accessibilityHint = "Take a dose of \(medication.name)"
	}
}
