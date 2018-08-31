//
//  MoodTableViewCell.swift
//  DataIntegration
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class MoodTableViewCell: UITableViewCell {

	private typealias Me = MoodTableViewCell

	public final var mood: Mood! {
		didSet {
			guard let mood = mood else { return }
			moodRatingColorLabel.backgroundColor = MoodUiUtil.colorForMood(rating: mood.rating, maxRating: mood.maxRating)
			moodRatingColorLabel.text = nil
			moodRatingLabel.text = MoodUiUtil.valueToString(mood.rating) + " / " + MoodUiUtil.valueToString(mood.maxRating)
			timestampLabel.text = DependencyInjector.util.calendarUtil.string(for: mood.timestamp)
			noteLabel.text = mood.note
		}
	}

	@IBOutlet weak final var moodRatingColorLabel: UILabel!
	@IBOutlet weak final var moodRatingLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
	@IBOutlet weak final var noteLabel: UILabel!
}
