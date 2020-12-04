//
//  RecordMedicationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import Presentr
import UIKit

import Common
import DependencyInjection
import Persistence
import Samples

public final class RecordMedicationTableViewCell: UITableViewCell {
	// MARK: - Static Variables

	private typealias Me = RecordMedicationTableViewCell

	public static let errorOccurred = Notification.Name("recordMedicationErrorOcurred")
	public static let shouldPresentMedicationDoseView = Notification.Name("shouldPresentDoseViewFromRecordScreen")
	public static let shouldPresentLastDoseView = Notification.Name("shouldPresentLastDoseViewFromRecordScreen")

	private static let log = Log()

	// MARK: - IBOutlets

	@IBOutlet final var medicationNameLabel: UILabel!
	@IBOutlet final var lastTakenOnDateButton: UIButton!
	@IBOutlet final var takeButton: UIButton!

	// MARK: - Instance Variables

	public weak final var medication: Medication! {
		didSet {
			guard let medication = medication else {
				Me.log.error("Set medication to nil on RecordMedicationTableViewCell")
				return
			}
			medicationNameLabel.text = medication.name
			updateLastTakenButton()
			updateTakeButtonAccessibility()
			uniqueNotificationNameForMedication = Notification.Name("doseCreatedFor" + medication.objectID.description)
			// have to remove old observers here because table view cells get reused
			NotificationCenter.default.removeObserver(self)
			observe(selector: #selector(doseCreated), name: uniqueNotificationNameForMedication)
			observe(selector: #selector(updateLastTakenButton), name: lastDoseEdited)
		}
	}

	private final var uniqueNotificationNameForMedication: Notification.Name! {
		didSet {
			lastDoseEdited = Notification.Name("editedLast" + uniqueNotificationNameForMedication.rawValue)
		}
	}

	private final var lastDoseEdited: Notification.Name!
	private final var dateThatTakenButtonWasPressed: Date?

	// MARK: - Received Notifications

	@objc private final func doseCreated(notification: Notification) {
		do {
			if let dose: MedicationDose = value(for: .dose, from: notification) {
				let transaction = injected(Database.self).transaction()
				let doseFromTransaction = try transaction.pull(savedObject: dose)
				medication = try transaction.pull(savedObject: medication)
				medication.addToDoses(doseFromTransaction)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				medication = try injected(Database.self).pull(savedObject: medication)
				updateLastTakenButton()
			}
		} catch {
			failedToMarkAsTaken(error)
		}
	}

	// MARK: - Button Actions

	@IBAction final func takeButtonPressed(_: Any, forEvent event: UIEvent) {
		if let touch = event.allTouches?.first {
			if touch.tapCount == 1 { // tap
				quickTakeMedication()
			} else if touch.tapCount == 0 { // long press
				post(
					Me.shouldPresentMedicationDoseView,
					userInfo: [
						.notificationName: uniqueNotificationNameForMedication as Any,
						.medication: medication as Any,
					]
				)
			}
		} else {
			quickTakeMedication()
		}
	}

	@IBAction final func lastTakenButtonPressed(_: Any) {
		post(
			Me.shouldPresentLastDoseView,
			userInfo: [
				.notificationName: uniqueNotificationNameForMedication as Any,
				.medication: medication as Any,
			]
		)
	}

	// MARK: - Helper Functions

	@objc private final func updateLastTakenButton() {
		var lastTakenText: String
		do {
			if let mostRecentDose = try injected(MedicationDAO.self).mostRecentDoseOf(medication) {
				lastTakenText = ""
				if let dosage = mostRecentDose.dosage {
					lastTakenText += dosage.description + "; "
				}
				lastTakenText += injected(CalendarUtil.self)
					.string(for: mostRecentDose.date, dateStyle: .short, timeStyle: .short)
				injected(UiUtil.self).setButton(lastTakenOnDateButton, enabled: true, hidden: false)
			} else {
				lastTakenText = "Never taken"
				injected(UiUtil.self).setButton(lastTakenOnDateButton, enabled: false, hidden: false)
			}
		} catch {
			Me.log.error("Failed to retrieve most recent dose for %{private}@", medication.name)
			lastTakenText = "Last Taken: An error ocurred"
			injected(UiUtil.self).setButton(lastTakenOnDateButton, enabled: false, hidden: false)
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

	private final func quickTakeMedication() {
		do {
			try injected(MedicationDAO.self).takeMedicationUsingDefaultDosage(medication)
			updateLastTakenButton()
		} catch {
			failedToMarkAsTaken(error)
		}
	}

	private final func failedToMarkAsTaken(_ error: Error) {
		Me.log.error("Failed to mark medication (%{private}@) as taken: %@", medication.name, errorInfo(error))
		var title = "Failed to mark \(medication.name) as taken."
		var message = "Sorry for the inconvenience"
		if let error = error as? DisplayableError {
			title = error.displayableTitle
			if let description = error.displayableDescription {
				message = description
			}
		}
		syncPost(
			Me.errorOccurred,
			userInfo: [
				.title: title,
				.message: message,
			]
		)
	}
}
