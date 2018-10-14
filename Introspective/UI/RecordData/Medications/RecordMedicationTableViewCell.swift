//
//  RecordMedicationTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/9/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

public final class RecordMedicationTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMedicationTableViewCell
	public static let errorOccurred = Notification.Name("recordMedicationErrorOcurred")
	public static let shouldPresentMedicationDoseView = Notification.Name("shouldPresentDoseViewFromRecordScreen")
	public static let shouldPresentDosesView = Notification.Name("shouldPresentDosesViewFromRecordScreen")
	public static let medicationUserInfoKey = "dosage"
	public static let notificationUserInfoKey = "notificationToSendWhenDosageSet"

	// MARK: - IBOutlets

	@IBOutlet weak final var medicationNameLabel: UILabel!
	@IBOutlet weak final var lastTakenOnDateButton: UIButton!

	// MARK: - Instance Variables

	public final var medication: Medication! {
		didSet {
			medicationNameLabel.text = medication.name
			updateLastTakenButton()
			uniqueNotificationNameForMedication = Notification.Name("doseCreatedFor" + medication.objectID.description)
			// have to remove old observers here because table view cells get reused
			NotificationCenter.default.removeObserver(self)
			NotificationCenter.default.addObserver(self, selector: #selector(doseCreated), name: uniqueNotificationNameForMedication, object: nil)
		}
	}
	private final var uniqueNotificationNameForMedication: Notification.Name!
	private final var dateThatTakenButtonWasPressed: Date?

	// MARK: - Received Notifications

	@objc private final func doseCreated(notification: Notification) {
		do {
			if let dose = notification.object as? MedicationDose {
				medication = try DependencyInjector.db.pull(savedObject: medication, fromSameContextAs: dose)
				dose.medication = medication
				medication.addToDoses(dose)
				DependencyInjector.db.save()
				updateLastTakenButton()
			} else {
				os_log("Expected MedicationDose as notification object but received %@", type: .error, String(describing: type(of: notification.object)))
			}
		} catch {
			os_log("Failed to mark medication (%@) as taken: %@", type: .error, medication.name, error.localizedDescription)
			NotificationCenter.default.post(name: Me.errorOccurred, object: "Unable to mark \(medication.name) as taken.")
		}
	}

	// MARK: - Button Actions

	@IBAction final func takeButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			let userInfo: [String: Any] = [
				Me.notificationUserInfoKey: self.uniqueNotificationNameForMedication,
				Me.medicationUserInfoKey: self.medication,
			]
			NotificationCenter.default.post(name: Me.shouldPresentMedicationDoseView, object: nil, userInfo: userInfo)
		}
	}

	@IBAction final func lastTakenButtonPressed(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: Me.shouldPresentDosesView, object: self.medication)
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
			lastTakenText += DependencyInjector.util.calendarUtil.string(for: mostRecentDose.timestamp, inFormat: "MMM dd, yyyy 'at' HH:mm")
			UiUtil.setButton(lastTakenOnDateButton, enabled: true, hidden: false)
		} else {
			UiUtil.setButton(lastTakenOnDateButton, enabled: false, hidden: false)
		}
		lastTakenOnDateButton.setTitle(lastTakenText, for: .normal)
	}
}
