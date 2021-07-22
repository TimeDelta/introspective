//
//  FatigueTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 12/9/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class FatigueTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	private typealias Me = FatigueTimelineTableViewCellDelegate

	private static let log = Log()

	func editController(for sample: Sample) -> UIViewController? {
		guard let fatigue = sample as? Fatigue else {
			Me.log.error(
				"Wrong type of sample passed to retrieve edit controller for fatigue: %@",
				sample.attributedName
			)
			return nil
		}
		let controller: EditFatigueTableViewController = injected(UiUtil.self).controller(
			named: "editFatigue",
			from: "Util",
			as: EditFatigueTableViewController.self
		)
		controller.fatigue = fatigue
		return controller
	}
}
