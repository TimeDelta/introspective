//
//  MedicationDoseTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class MedicationDoseTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	private typealias Me = MedicationDoseTimelineTableViewCellDelegate

	private static let log = Log()

	func editController(for sample: Sample) -> EditViewController? {
		guard let dose = sample as? MedicationDose else {
			Me.log.error(
				"Wrong type of sample passed to retrieve edit controller for medication dose: %@",
				sample.attributedName
			)
			return nil
		}
		let controller = injected(UiUtil.self).controller(
			named: "medicationDoseEditor",
			from: "RecordData",
			as: MedicationDoseEditorViewControllerImpl.self
		)
		controller.medicationDose = dose
		return controller
	}
}
