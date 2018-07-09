//
//  TimeConstraintTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/7/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import os
import SwiftDate

class TimeConstraintTableViewCell: UITableViewCell {

	@IBOutlet weak var label: UILabel!

	var timeConstraint: TimeConstraint! {
		didSet {
			guard let timeConstraint = timeConstraint else { return }

			let constraintType = timeConstraint.constraintType
			var text = timeConstraint.useStartOrEndDate.description + " "
			text += constraintType.description + " "

			switch(constraintType) {
				case .after, .before:
					if timeConstraint.specificDate != nil {
						let calendar = Calendar.autoupdatingCurrent
						let dateInRegion = DateInRegion(timeConstraint.specificDate!, region: Region(calendar: calendar, zone: calendar.timeZone))
						text += dateInRegion.toFormat("YYYY-MM-dd HH:mm:ss")
					} else {
						os_log("No date for time constraint being displayed", type: .error)
					}
					break
				case .on:
					if !timeConstraint.daysOfWeek.isEmpty {
						var daysOfWeekText = ""
						for dayOfWeek in timeConstraint.daysOfWeek {
							daysOfWeekText += dayOfWeek.abbreviation + ", "
						}
						daysOfWeekText.removeLast()
						text += daysOfWeekText
					} else if timeConstraint.specificDate != nil {
						text += timeConstraint.specificDate!.toFormat("YYYY-MM-dd")
					} else {
						os_log("No date or days of week for time constraint being displayed", type: .error)
					}
					break
			}
			label.text = text
		}
	}
}
