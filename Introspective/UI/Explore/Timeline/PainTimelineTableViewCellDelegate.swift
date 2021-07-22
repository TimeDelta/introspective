//
//  PainTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 7/22/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class PainTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	private typealias Me = PainTimelineTableViewCellDelegate

	private static let log = Log()

	func editController(for sample: Sample) -> UIViewController? {
		guard let pain = sample as? Pain else {
			Me.log.error(
				"Wrong type of sample passed to retrieve edit controller for pain: %@",
				sample.attributedName
			)
			return nil
		}
		let controller: EditPainTableViewController = injected(UiUtil.self).controller(
			named: "editPain",
			from: "Util",
			as: EditPainTableViewController.self
		)
		controller.pain = pain
		return controller
	}
}
