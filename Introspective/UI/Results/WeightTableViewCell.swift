//
//  WeightTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class WeightTableViewCell: UITableViewCell {

	public final var weight: Weight! {
		didSet {
			guard let weight = weight else { return }

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .decimal
			valueLabel.text = valueFormatter.string(from: NSNumber(value: weight.weight))

			let dateString = DependencyInjector.util.calendar.string(for: weight.timestamp, dateStyle: .medium, timeStyle: .short)
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak final var valueLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
}
