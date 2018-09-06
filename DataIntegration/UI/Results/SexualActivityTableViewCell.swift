//
//  SexualActivityTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/6/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class SexualActivityTableViewCell: UITableViewCell {

	public final var sample: SexualActivity! {
		didSet {
			guard let sample = sample else { return }

			valueLabel.text = "Protection: " + sample.protectionUsed.description

			let start = sample.dates()[.start]!
			let end = sample.dates()[.end]
			var dateString = DependencyInjector.util.calendarUtil.string(for: start)
			if end != nil && start != end {
				dateString += " to " + DependencyInjector.util.calendarUtil.string(for: end!)
			}
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
}
