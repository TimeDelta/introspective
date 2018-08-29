//
//  WeightTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/29/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class WeightTableViewCell: UITableViewCell {

	public var weight: Weight! {
		didSet {
			guard let weight = weight else { return }

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .decimal
			valueLabel.text = valueFormatter.string(from: NSNumber(value: weight.weight))

			let dateString = DependencyInjector.util.calendarUtil.string(for: weight.timestamp)
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
}
