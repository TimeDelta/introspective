//
//  WeightTimelineTableViewCellDelegate.swift
//  Introspective
//
//  Created by Bryan Nova on 9/6/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

class WeightTimelineTableViewCellDelegate: TimelineTableViewCellDelegate {
	func isEditable() -> Bool {
		false
	}

	func editController() -> UIViewController? {
		nil
	}
}
