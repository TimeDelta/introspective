//
//  MoodTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {

	public var mood: Mood! {
		didSet {
			guard let mood = mood else { return }
			moodRatingLabel.text = valueToString(mood.rating) + " / " + valueToString(mood.maxRating)
			timestampLabel.text = DependencyInjector.util.calendarUtil.string(for: mood.timestamp)
			noteLabel.text = mood.note
		}
	}

	@IBOutlet weak var moodRatingLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var noteLabel: UILabel!

	fileprivate func valueToString(_ value: Double) -> String {
		let numFormatter = NumberFormatter()
		numFormatter.numberStyle = .decimal
		return numFormatter.string(from: NSNumber(value: value))!
	}
}
