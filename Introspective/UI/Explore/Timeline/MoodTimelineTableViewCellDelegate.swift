//
//  MoodTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class MoodTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	private typealias Me = MoodTimelineTableViewCellDelegate

	private static let log = Log()

	func editController(for sample: Sample) -> EditViewController? {
		guard let mood = sample as? Mood else {
			Me.log.error(
				"Wrong type of sample passed to retrieve edit controller for mood: %@",
				sample.attributedName
			)
			return nil
		}
		let controller: EditMoodTableViewController = injected(UiUtil.self).controller(
			named: "editMood",
			from: "Util",
			as: EditMoodTableViewControllerImpl.self
		)
		controller.mood = mood
		return controller
	}
}
