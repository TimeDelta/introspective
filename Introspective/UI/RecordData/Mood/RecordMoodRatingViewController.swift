//
//  RecordMoodRatingViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

public final class RecordMoodRatingViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingTextField: UITextField!

	// MARK: - Instance Variables

	public final var rating: Double = DependencyInjector.settings.maxMood / 2
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		ratingTextField.text = String(rating)
		DependencyInjector.util.ui.addSaveButtonToKeyboardFor(ratingTextField, target: self, action: #selector(saveClicked))
		ratingTextField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func textFieldValueChanged(_ sender: Any) {
		let ratingText = ratingTextField.text!
		let minRating = DependencyInjector.settings.minMood
		let maxRating = DependencyInjector.settings.maxMood
		guard !ratingText.hasSuffix(".") else { return }
		if let rating = Double(ratingText) {
			if minRating <= rating && rating <= maxRating {
				self.rating = rating
			} else if rating > maxRating {
				self.rating = maxRating
				ratingTextField.text = MoodUiUtil.valueToString(maxRating)
			} else {
				self.rating = minRating
				ratingTextField.text = MoodUiUtil.valueToString(minRating)
			}
		}
	}

	@objc private final func saveClicked(_ sender: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.number: self.rating,
				]))
		}
		dismiss(animated: false)
	}
}
