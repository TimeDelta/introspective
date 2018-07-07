//
//  TimeConstraintTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class TimeConstraintTableViewCell: UITableViewCell {

	@IBOutlet weak var startsEndsLabel: UILabel!
	@IBOutlet weak var onAfterBeforeLabel: UILabel!
	@IBOutlet weak var specificDateOrDaysOfWeekLabel: UILabel!

	var timeConstraint: TimeConstraint! {
		didSet {
			guard let timeConstraint = timeConstraint else { return }

			let constraintType = timeConstraint.constraintType
			onAfterBeforeLabel.text = constraintType.description
			startsEndsLabel.text = timeConstraint.useStartOrEndDate.description

			switch(constraintType) {
				case .after, .before:
					specificDateOrDaysOfWeekLabel.text = String(describing: timeConstraint.specificDate)
					break
				case .on:
					if !timeConstraint.daysOfWeek.isEmpty {
						var labelText = ""
						for dayOfWeek in timeConstraint.daysOfWeek {
							labelText += dayOfWeek.abbreviation + ", "
						}
						labelText.removeLast()
						specificDateOrDaysOfWeekLabel.text = labelText
					} else if timeConstraint.specificDate != nil {
						specificDateOrDaysOfWeekLabel.text = String(describing: timeConstraint.specificDate)
					}
					break
			}
		}
	}
}
