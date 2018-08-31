//
//  HealthKitQuantitySampleTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate

final class HealthKitQuantitySampleTableViewCell: UITableViewCell {

	public final var sample: HealthKitQuantitySample! {
		didSet {
			guard let sample = sample else { return }

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .decimal
			valueLabel.text = valueFormatter.string(from: NSNumber(value: sample.quantityValue()))

			let start = sample.startDate()
			let end = sample.endDate()
			var dateString = DependencyInjector.util.calendarUtil.string(for: start)
			if start != end {
				dateString += " to " + DependencyInjector.util.calendarUtil.string(for: end)
			}
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
}
