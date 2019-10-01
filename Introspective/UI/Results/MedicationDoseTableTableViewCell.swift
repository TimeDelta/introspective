//
//  MedicationDoseTableTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 10/12/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

public final class MedicationDoseTableTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var medicationNameLabel: UILabel!
	@IBOutlet weak final var doseAndTimestampLabel: UILabel!

	// MARK: - Instance Variables

	public final var medicationDose: MedicationDose! {
		didSet {
			guard let medicationDose = medicationDose else { return }
			medicationNameLabel.text = medicationDose.medication.name

			var doseText = ""
			if let dosage = medicationDose.dosage {
				doseText += dosage.description + " on "
			}
			doseText += DependencyInjector.get(CalendarUtil.self).string(for: medicationDose.date, dateStyle: .medium, timeStyle: .short)
			doseAndTimestampLabel.text = doseText
		}
	}
}
