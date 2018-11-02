//
//  MedicationDoseTableTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class MedicationDoseTableTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var medicationNameLabel: UILabel!
	@IBOutlet weak final var doseAndTimestampLabel: UILabel!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose! {
		didSet {
			medicationNameLabel.text = medicationDose.medication.name

			var doseText = ""
			if let dosage = medicationDose.dosage {
				doseText += dosage.description + " on "
			}
			doseText += DependencyInjector.util.calendar.string(for: medicationDose.timestamp, dateStyle: .medium, timeStyle: .short)
			doseAndTimestampLabel.text = doseText
		}
	}
}
