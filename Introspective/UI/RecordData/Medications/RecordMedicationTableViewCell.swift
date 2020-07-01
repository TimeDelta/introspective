//
//  RecordMedicationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

import Common
import DependencyInjection
import Persistence
import Samples

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
				let transaction = DependencyInjector.get(Database.self).transaction()
				let doseFromTransaction = try transaction.pull(savedObject: dose)
				medication = try transaction.pull(savedObject: medication)
				medication.addToDoses(doseFromTransaction)
				try retryOnFail({ try transaction.commit() }, maxRetries: 2)
				medication = try DependencyInjector.get(Database.self).pull(savedObject: medication)
				updateLastTakenButton()
			}
		} catch {
			failedToMarkAsTaken(error)
		}
	}

	// MARK: - Button Actions

	@IBAction final func takeButtonPressed(_ sender: Any, forEvent event: UIEvent) {
		if let touch = event.allTouches?.first {
			if touch.tapCount == 1 { // tap
				quickTakeMedication()
			} else if touch.tapCount == 0 { // long press
				post(
					Me.shouldPresentMedicationDoseView,
					userInfo: [
						.notificationName: uniqueNotificationNameForMedication,
						.medication: medication,
					])
			}
		} else {
			quickTakeMedication()
		}
	}

	@IBAction final func lastTakenButtonPressed(_ sender: Any) {
		post(
			Me.shouldPresentDosesView,
			userInfo: [
				.medication: medication,
			])
	}

	// MARK: - Helper Functions

	private final func updateLastTakenButton() {
		var lastTakenText = "Never taken"
		if let mostRecentDose = medication.sortedDoses(ascending: true).last {
			lastTakenText = "Last taken: "
			if let dosage = mostRecentDose.dosage {
				lastTakenText += dosage.description + " on "
			}
			lastTakenText += DependencyInjector.get(CalendarUtil.self).string(for: mostRecentDose.date, dateStyle: .medium, timeStyle: .short)
			DependencyInjector.get(UiUtil.self).setButton(lastTakenOnDateButton, enabled: true, hidden: false)
		} else {
			DependencyInjector.get(UiUtil.self).setButton(lastTakenOnDateButton, enabled: false, hidden: false)
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
			var transaction = DependencyInjector.get(Database.self).transaction()
			let medicationDose = try transaction.new(MedicationDose.self)
			medicationDose.setSource(.introspective)
			medicationDose.medication = try transaction.pull(savedObject: medication)
			medicationDose.dosage = medication.dosage
			medicationDose.date = Date()
			// have to save created dose before adding it to medication doses
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)

			transaction = DependencyInjector.get(Database.self).transaction()
			let doseFromTransaction = try transaction.pull(savedObject: medicationDose)
			medication = try transaction.pull(savedObject: medication)
			medication.addToDoses(doseFromTransaction)
			try retryOnFail({ try transaction.commit() }, maxRetries: 2)
		} catch {
			failedToMarkAsTaken(error)
		}
	}

	private final func failedToMarkAsTaken(_ error: Error) {
		log.error("Failed to mark medication (%{private}@) as taken: %@", medication.name, errorInfo(error))
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
			])
	}
}
