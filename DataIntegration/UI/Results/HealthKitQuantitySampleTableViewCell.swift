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

	private typealias Me = HealthKitQuantitySampleTableViewCell
	private static let dateFormat = "M-d-yy 'at' HH:mm"
	private static let valueFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	public final var sample: HealthKitQuantitySample! {
		didSet {
			guard let sample = sample else { return }

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .decimal
			valueLabel.text = formatValue(sample.quantityValue()) + " " + sample.unitString

			let start = sample.dates()[.start]!
			let end = sample.dates()[.end]
			var dateString = DependencyInjector.util.calendarUtil.string(for: start, inFormat: Me.dateFormat)
			if end != nil && start != end {
				dateString += " to " + DependencyInjector.util.calendarUtil.string(for: end!, inFormat: Me.dateFormat)
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
