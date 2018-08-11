//
//  HeartRateTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 7/13/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import SwiftDate

class HeartRateTableViewCell: UITableViewCell {

	public var heartRate: HeartRate! {
		didSet {
			guard let heartRate = heartRate else { return }

			let valueFormatter = NumberFormatter()
			valueFormatter.numberStyle = .decimal
			valueLabel.text = valueFormatter.string(from: NSNumber(value: heartRate.heartRate))

			let dateString = DependencyInjector.util.calendarUtil.string(for: heartRate.timestamp)
			timestampLabel.text = dateString
		}
	}

	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
}
