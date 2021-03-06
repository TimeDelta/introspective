//
//  ContinuousMoodRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings
import UIExtensions

public final class ContinuousMoodRatingTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var ratingTextField: UITextField!
	@IBOutlet final var ratingRangeLabel: UILabel!

	// MARK: - Instance Variables

	public final var rating: Double = 0 {
		didSet { updateUI() }
	}

	public final var minRating: Double = injected(Settings.self).minMood {
		didSet { updateUI() }
	}

	public final var maxRating: Double = injected(Settings.self).maxMood {
		didSet { updateUI() }
	}

	// MARK: - Actions

	@IBAction final func sliderValueChanged(_: Any) {
		rating = Double(ratingSlider.value) * maxRating
		sendRatingChangedNotification()
	}

	@IBAction final func textFieldValueChanged(_: Any) {
		let ratingText = ratingTextField.text!
		guard !ratingText.hasSuffix(".") else { return }
		if let rating = Double(ratingText) {
			if minRating <= rating && rating <= maxRating {
				self.rating = rating
			} else if rating > maxRating {
				self.rating = maxRating
				ratingTextField.text = injected(MoodUiUtil.self).valueToString(maxRating)
			} else {
				self.rating = minRating
				ratingTextField.text = injected(MoodUiUtil.self).valueToString(minRating)
			}
			sendRatingChangedNotification()
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		ratingSlider.setValue(Float(rating / maxRating), animated: false)
		ratingSlider.thumbTintColor = injected(MoodUiUtil.self)
			.colorForMood(rating: rating, minRating: minRating, maxRating: maxRating)
		ratingTextField.text = injected(MoodUiUtil.self).valueToString(rating)
		let minText = injected(MoodUiUtil.self).valueToString(minRating)
		let maxText = injected(MoodUiUtil.self).valueToString(maxRating)
		ratingRangeLabel.text = "(\(minText)-\(maxText))"
	}

	private final func sendRatingChangedNotification() {
		post(.moodRatingChanged, userInfo: [.number: rating])
	}
}
