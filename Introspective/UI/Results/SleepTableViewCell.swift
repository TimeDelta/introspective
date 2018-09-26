//
//  SleepTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 9/25/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class SleepTableViewCell: UITableViewCell {

	private typealias Me = SleepTableViewCell
	private static let dateFormat = "MMM dd, yyyy 'at' HH:mm"

	public final var sleep: Sleep! {
		didSet {
			guard let sleep = sleep else { return }

			valueLabel.text = sleep.state.description

			var dateString = DependencyInjector.util.calendarUtil.string(for: sleep.startDate, inFormat: Me.dateFormat)
			dateString += " to "
			dateString += DependencyInjector.util.calendarUtil.string(for: sleep.endDate, inFormat: Me.dateFormat)
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
}
