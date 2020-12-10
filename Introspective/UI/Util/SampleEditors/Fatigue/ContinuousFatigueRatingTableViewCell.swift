//
//  ContinuousFatigueRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/8/20.
//  Copyright © 2020 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings
import UIExtensions

public final class ContinuousFatigueRatingTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var ratingTextField: UITextField!
	@IBOutlet final var ratingRangeLabel: UILabel!

	// MARK: - Instance Variables

	public final var rating: Double = 0 {
		didSet { updateUI() }
	}

	public final var minRating: Double = injected(Settings.self).minFatigue {
		didSet { updateUI() }
	}

	public final var maxRating: Double = injected(Settings.self).maxFatigue {
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
				ratingTextField.text = injected(FatigueUiUtil.self).valueToString(maxRating)
			} else {
				self.rating = minRating
				ratingTextField.text = injected(FatigueUiUtil.self).valueToString(minRating)
			}
			sendRatingChangedNotification()
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		ratingSlider.setValue(Float(rating / maxRating), animated: false)
		ratingSlider.thumbTintColor = injected(FatigueUiUtil.self)
			.colorForFatigue(rating: rating, minRating: minRating, maxRating: maxRating)
		ratingTextField.text = injected(FatigueUiUtil.self).valueToString(rating)
		let minText = injected(FatigueUiUtil.self).valueToString(minRating)
		let maxText = injected(FatigueUiUtil.self).valueToString(maxRating)
		ratingRangeLabel.text = "(\(minText)-\(maxText))"
	}

	private final func sendRatingChangedNotification() {
		post(.fatigueRatingChanged, userInfo: [.number: rating])
	}
}
