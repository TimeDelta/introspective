//
//  MoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class MoodTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var moodRatingColorLabel: UILabel!
	@IBOutlet weak final var moodRatingLabel: UILabel!
	@IBOutlet weak final var timestampLabel: UILabel!
	@IBOutlet weak final var noteLabel: UILabel!

	// MARK: - Instance Variables

	public final var mood: Mood! {
		didSet {
			updateUI()
			observe(selector: #selector(updateUI), name: .moodUpdated, object: mood)
		}
	}

	// MARK: - Helper Functions

	@objc private final func updateUI() {
		guard let mood = mood else { return }
		DispatchQueue.main.async {
			self.moodRatingColorLabel.backgroundColor = MoodUiUtil.colorForMood(
				rating: mood.rating,
				minRating: mood.minRating,
				maxRating: mood.maxRating)
			self.moodRatingColorLabel.text = nil
			let ratingText = MoodUiUtil.valueToString(mood.rating)
			let minText = MoodUiUtil.valueToString(mood.minRating)
			let maxText = MoodUiUtil.valueToString(mood.maxRating)
			self.moodRatingLabel.text = ratingText + " (\(minText)-\(maxText))"
			self.timestampLabel.text = DependencyInjector.util.calendar.string(for: mood.date, dateStyle: .medium, timeStyle: .short)
			self.noteLabel.text = mood.note
			self.moodRatingLabel.accessibilityValue = self.moodRatingLabel.text
			self.timestampLabel.accessibilityValue = self.timestampLabel.text
			self.noteLabel.accessibilityValue = self.noteLabel.text
		}
	}
}
