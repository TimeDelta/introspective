//
//  MoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Samples

public protocol MoodTableViewCell: UITableViewCell {
	var mood: Mood! { get set }
}

final class MoodTableViewCellImpl: UITableViewCell, MoodTableViewCell {
	public final var mood: Mood! {
		didSet {
			guard let mood = mood else { return }
			moodRatingColorLabel.backgroundColor = injected(MoodUiUtil.self).colorForMood(
				rating: mood.rating,
				minRating: mood.minRating,
				maxRating: mood.maxRating
			)
			moodRatingColorLabel.text = nil
			let ratingText = injected(MoodUiUtil.self).valueToString(mood.rating)
			let minText = injected(MoodUiUtil.self).valueToString(mood.minRating)
			let maxText = injected(MoodUiUtil.self).valueToString(mood.maxRating)
			moodRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			timestampLabel.text = injected(CalendarUtil.self)
				.string(for: mood.date, dateStyle: .medium, timeStyle: .short)
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

	@IBOutlet final var moodRatingColorLabel: UILabel!
	@IBOutlet final var moodRatingLabel: UILabel!
	@IBOutlet final var timestampLabel: UILabel!
	@IBOutlet final var noteLabel: UILabel!

	override func prepareForReuse() {
		mood = nil
		moodRatingColorLabel.text = nil
		moodRatingLabel.text = nil
		timestampLabel.text = nil
		noteLabel.text = nil
	}
}
