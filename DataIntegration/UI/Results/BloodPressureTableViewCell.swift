//
//  BloodPressureTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 9/5/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class BloodPressureTableViewCell: UITableViewCell {

	private typealias Me = BloodPressureTableViewCell
	private static let valueFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	public final var sample: BloodPressure! {
		didSet {
			guard let sample = sample else { return }

			valueLabel.text = formatValue(sample.systolic) + "/" + formatValue(sample.diastolic)

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

	private func formatValue(_ value: Double) -> String {
		return Me.valueFormatter.string(from: NSNumber(value: value))!
	}
}
