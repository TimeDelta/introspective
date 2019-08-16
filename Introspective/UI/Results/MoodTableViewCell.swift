//
//  MoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public protocol MoodTableViewCell: UITableViewCell {

	var mood: Mood! { get set }
}

final class MoodTableViewCellImpl: UITableViewCell, MoodTableViewCell {

	public final var mood: Mood! {
		didSet {
			guard let mood = mood else { return }
			moodRatingColorLabel.backgroundColor = MoodUiUtil.colorForMood(
				rating: mood.rating,
				minRating: mood.minRating,
				maxRating: mood.maxRating)
			moodRatingColorLabel.text = nil
			let ratingText = MoodUiUtil.valueToString(mood.rating)
			let minText = MoodUiUtil.valueToString(mood.minRating)
			let maxText = MoodUiUtil.valueToString(mood.maxRating)
			moodRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			timestampLabel.text = DependencyInjector.util.calendar.string(for: mood.date, dateStyle: .medium, timeStyle: .short)
			if let note = mood.note {
				if !note.isEmpty {
					noteLabel.text = mood.note
				}
			}
			moodRatingLabel.accessibilityValue = moodRatingLabel.text
			timestampLabel.accessibilityValue = timestampLabel.text
			noteLabel.accessibilityValue = noteLabel.text
		}
	}

	@IBOutlet weak final var moodRatingColorLabel: UILabel!
	@IBOutlet weak final var moodRatingLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
	@IBOutlet weak final var noteLabel: UILabel!
}
