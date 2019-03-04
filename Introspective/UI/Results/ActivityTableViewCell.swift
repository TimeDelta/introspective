//
//  ActivityTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/27/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class ActivityTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var nameLabel: UILabel!
	@IBOutlet weak final var timestampsLabel: UILabel!
	@IBOutlet weak final var durationLabel: UILabel!
	@IBOutlet weak final var noteLabel: UILabel!

	// MARK: - Instance Variables

	public final var activity: Activity! {
		didSet {
			nameLabel.text = activity.definition.name

			timestampsLabel.text = DependencyInjector.util.calendar.string(for: activity.start, dateStyle: .short, timeStyle: .medium) + " - "
			if let endDate = activity.end {
				timestampsLabel.text! += DependencyInjector.util.calendar.string(for: endDate, dateStyle: .short, timeStyle: .medium)
			}

			durationLabel.text = activity.duration.description

			noteLabel.text = activity.note
		}
	}
}
