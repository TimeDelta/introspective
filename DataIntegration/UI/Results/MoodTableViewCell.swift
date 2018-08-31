//
//  MoodTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

class MoodTableViewCell: UITableViewCell {

	fileprivate typealias Me = MoodTableViewCell

	public var mood: Mood! {
		didSet {
			guard let mood = mood else { return }
			moodRatingColorLabel.backgroundColor = MoodUiUtil.colorForMood(rating: mood.rating, maxRating: mood.maxRating)
			moodRatingColorLabel.text = nil
			moodRatingLabel.text = MoodUiUtil.valueToString(mood.rating) + " / " + MoodUiUtil.valueToString(mood.maxRating)
			timestampLabel.text = DependencyInjector.util.calendarUtil.string(for: mood.timestamp)
			noteLabel.text = mood.note
		}
	}

	@IBOutlet weak var moodRatingColorLabel: UILabel!
	@IBOutlet weak var moodRatingLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var noteLabel: UILabel!
}
