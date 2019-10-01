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
			moodRatingColorLabel.backgroundColor = DependencyInjector.get(MoodUiUtil.self).colorForMood(
				rating: mood.rating,
				minRating: mood.minRating,
				maxRating: mood.maxRating)
			moodRatingColorLabel.text = nil
			let ratingText = DependencyInjector.get(MoodUiUtil.self).valueToString(mood.rating)
			let minText = DependencyInjector.get(MoodUiUtil.self).valueToString(mood.minRating)
			let maxText = DependencyInjector.get(MoodUiUtil.self).valueToString(mood.maxRating)
			moodRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			timestampLabel.text = DependencyInjector.get(CalendarUtil.self).string(for: mood.date, dateStyle: .medium, timeStyle: .short)
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
