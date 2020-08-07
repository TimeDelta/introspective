//
//  MoodRatingCollectionViewCell.swift
//  DiscreteMoodWidget
//
//  Created by Bryan Nova on 10/4/19.
//  Copyright © 2019 Bryan Nova. All rights reserved.
//

import UIKit

import Common
import DependencyInjection
import Settings

public class MoodRatingCollectionViewCell: UICollectionViewCell {
	// MARK: - IBOutlets

	@IBOutlet final var ratingButton: UIButton!

	// MARK: - Instance Variables

	public final var rating: Int! {
		didSet {
			guard let rating = rating else { return }

			ratingButton.setTitle(String(rating), for: .normal)
			let min = injected(Settings.self).minMood
			let max = injected(Settings.self).maxMood
			let color = injected(MoodUiUtil.self).colorForMood(
				rating: Double(rating),
				minRating: min,
				maxRating: max
			)
			ratingButton.backgroundColor = color
			ratingButton.setTitleColor(color.highContrast(), for: .normal)
		}
	}

	public final var notificationToSendOnAccept: Notification.Name!

	// MARK: - Button Actions

	@IBAction func ratingButtonPressed(_: Any) {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: self.notificationToSendOnAccept,
				object: self,
				userInfo: [
					UserInfoKey.mood: self.rating,
				]
			)
		}
	}
}
