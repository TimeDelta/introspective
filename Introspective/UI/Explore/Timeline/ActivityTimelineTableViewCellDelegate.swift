//
//  ActivityTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class ActivityTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	private typealias Me = ActivityTimelineTableViewCellDelegate

	private static let log = Log()

	func editController(for sample: Sample) -> EditViewController? {
		guard let activity = sample as? Activity else {
			Me.log.error(
				"Wrong type of sample passed to retrieve edit controller for activity: %@",
				sample.attributedName
			)
			return nil
		}
		let controller: EditActivityTableViewController = injected(UiUtil.self).controller(
			named: "editActivity",
			from: "RecordData",
			as: EditActivityTableViewControllerImpl.self
		)
		controller.activity = activity
		return controller
	}
}
