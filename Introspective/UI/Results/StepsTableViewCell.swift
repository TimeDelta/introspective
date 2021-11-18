//
//  StepsTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 11/9/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

class StepsTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var valueLabel: UILabel!
	@IBOutlet final var timestampLabel: UILabel!

	// MARK: - Instance Variables

	public final var steps: Steps! {
		didSet {
			guard let steps = steps else { return }

			let duration = TimeDuration(start: steps.start, end: steps.end)
			valueLabel.text = "\(Int(steps.steps)) steps over \(duration.description)"

			var dateString = injected(CalendarUtil.self)
				.string(for: steps.start, dateStyle: .medium, timeStyle: .short)
			dateString += " -\n"
			dateString += injected(CalendarUtil.self)
				.string(for: steps.end, dateStyle: .medium, timeStyle: .short)
			timestampLabel.text = dateString
		}
	}
}
