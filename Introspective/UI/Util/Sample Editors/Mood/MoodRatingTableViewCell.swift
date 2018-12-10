//
//  MoodRatingTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 12/10/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class MoodRatingTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var ratingTextField: UITextField!
	@IBOutlet weak final var maxRatingLabel: UILabel!

	// MARK: - Instance Variables

	public final var notificationToSendOnChange: Notification.Name!
	public final var rating: Double = 0 {
		didSet { updateUI() }
	}
	public final var maxRating: Double = DependencyInjector.settings.maximumMood {
		didSet { updateUI() }
	}

	// MARK: - Actions

	@IBAction final func sliderValueChanged(_ sender: Any) {
		rating = Double(ratingSlider.value) * maxRating
		sendRatingChangedNotification()
	}

	@IBAction final func textFieldValueChanged(_ sender: Any) {
		let ratingText = ratingTextField.text!
		guard !ratingText.hasSuffix(".") else { return }
		if let rating = Double(ratingText) {
			if rating <= maxRating {
				self.rating = rating
			} else {
				self.rating = maxRating
			}
			sendRatingChangedNotification()
		}
	}

	// MARK: - Helper Functions

	private final func updateUI() {
		ratingSlider.setValue(Float(rating / maxRating), animated: false)
		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: rating, maxRating: maxRating)
		ratingTextField.text = MoodUiUtil.valueToString(rating)
		maxRatingLabel.text = "/ " + MoodUiUtil.valueToString(maxRating)
	}

	private final func sendRatingChangedNotification() {
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: self.notificationToSendOnChange, object: self.rating)
		}
	}
}
