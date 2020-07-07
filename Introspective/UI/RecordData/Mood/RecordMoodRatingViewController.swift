//
//  RecordMoodRatingViewController.swift
//  Introspective
//
//  Created by Bryan Nova on 12/24/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public final class RecordMoodRatingViewController: UIViewController {
	// MARK: - IBOutlets

	@IBOutlet final var ratingTextField: UITextField!

	// MARK: - Instance Variables

	public final var rating: Double = DependencyInjector.get(Settings.self).maxMood / 2
	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - UIViewController Overrides

	public final override func viewDidLoad() {
		super.viewDidLoad()

		ratingTextField.text = String(rating)
		DependencyInjector.get(UiUtil.self)
			.addSaveButtonToKeyboardFor(ratingTextField, target: self, action: #selector(saveClicked))
		ratingTextField.becomeFirstResponder()
	}

	// MARK: - Actions

	@IBAction final func textFieldValueChanged(_: Any) {
		let ratingText = ratingTextField.text!
		let minRating = DependencyInjector.get(Settings.self).minMood
		let maxRating = DependencyInjector.get(Settings.self).maxMood
		guard !ratingText.hasSuffix(".") else { return }
		if let rating = Double(ratingText) {
			if minRating <= rating && rating <= maxRating {
				self.rating = rating
			} else if rating > maxRating {
				self.rating = maxRating
				ratingTextField.text = DependencyInjector.get(MoodUiUtil.self).valueToString(maxRating)
			} else {
				self.rating = minRating
				ratingTextField.text = DependencyInjector.get(MoodUiUtil.self).valueToString(minRating)
			}
		}
	}

	@objc private final func saveClicked(_: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: self.info([
					.number: self.rating,
				])
			)
		}
		dismiss(animated: false)
	}
}
