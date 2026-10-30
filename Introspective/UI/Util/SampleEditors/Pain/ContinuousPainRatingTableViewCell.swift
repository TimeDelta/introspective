//
//  ContinuousPainRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 6/16/21.
//  Copyright © 2021 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings
import UIExtensions

public final class ContinuousPainRatingTableViewCell: UITableViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var ratingTextField: UITextField!
	@IBOutlet final var ratingRangeLabel: UILabel!

	// MARK: - Instance Variables

	public final var rating: Double = 0 {
		didSet { updateUI() }
	}

	public final var minRating: Double = injected(Settings.self).minPain {
		didSet { updateUI() }
	}

	public final var maxRating: Double = injected(Settings.self).maxPain {
		didSet { updateUI() }
	}

	// MARK: - Actions

	@IBAction final func sliderValueChanged(_: Any) {
		let range = maxRating - minRating
		rating = range.isFinite && range > 0 ? minRating + Double(ratingSlider.value) * range : minRating
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
				ratingTextField.text = injected(PainUiUtil.self).valueToString(maxRating)
			} else {
				self.rating = minRating
				ratingTextField.text = injected(PainUiUtil.self).valueToString(minRating)
			}
			sendRatingChangedNotification()
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		let range = maxRating - minRating
		let hasRange = range.isFinite && range > 0
		ratingSlider.isEnabled = hasRange
		ratingSlider.setValue(hasRange ? Float((rating - minRating) / range) : 0, animated: false)
		if hasRange {
			ratingSlider.thumbTintColor = injected(PainUiUtil.self)
				.colorForPain(rating: rating, minRating: minRating, maxRating: maxRating)
		} else {
			ratingSlider.thumbTintColor = .gray
		}
		ratingTextField.text = injected(PainUiUtil.self).valueToString(rating)
		let minText = injected(PainUiUtil.self).valueToString(minRating)
		let maxText = injected(PainUiUtil.self).valueToString(maxRating)
		ratingRangeLabel.text = "(\(minText)-\(maxText))"
	}

	private final func sendRatingChangedNotification() {
		post(.painRatingChanged, userInfo: [.number: rating])
	}
}
