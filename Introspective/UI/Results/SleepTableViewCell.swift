//
//  SleepTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class SleepTableViewCell: UITableViewCell {

	public final var sleep: Sleep! {
		didSet {
			guard let sleep = sleep else { return }

			valueLabel.text = sleep.state.description

			var dateString = DependencyInjector.util.calendar.string(for: sleep.startDate, dateStyle: .medium, timeStyle: .short)
			dateString += " to "
			dateString += DependencyInjector.util.calendar.string(for: sleep.endDate, dateStyle: .medium, timeStyle: .short)
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
}
