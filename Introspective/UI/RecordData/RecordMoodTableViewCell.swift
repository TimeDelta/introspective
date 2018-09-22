//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit

final class RecordMoodTableViewCell: UITableViewCell {

	@IBOutlet final var ratingSlider: UISlider!
	@IBOutlet final var outOfMaxRatingLabel: UILabel!
	@IBOutlet final var doneButon: UIButton!
	@IBOutlet final var addNoteButton: UIButton!

	final var note: String? = nil

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		NotificationCenter.default.addObserver(self, selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification, object: nil)
	}

	@IBAction final func ratingChanged(_ sender: Any) {
		let maxValue = DependencyInjector.settings.maximumMood
		let newValue = Double(ratingSlider.value) * maxValue

		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: newValue, maxRating: maxValue)

		outOfMaxRatingLabel.text = MoodUiUtil.valueToString(newValue) + " / " + MoodUiUtil.valueToString(maxValue)
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		let mood = DependencyInjector.sample.mood()
		mood.timestamp = Date()
		mood.rating = Double(ratingSlider.value) * DependencyInjector.settings.maximumMood
		mood.note = note
		mood.maxRating = DependencyInjector.settings.maximumMood
		DependencyInjector.db.save()

		reset()
	}

	@objc private final func noteSaved(notification: Notification) {
		note = (notification.object as! String)
		addNoteButton.setTitle(note, for: .normal)
	}

	private final func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		ratingSlider.value = (ratingSlider.maximumValue - ratingSlider.minimumValue) / 2.0
		ratingChanged(self)
	}
}
