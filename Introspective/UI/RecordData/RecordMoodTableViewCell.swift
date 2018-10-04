//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr

final class RecordMoodTableViewCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var outOfMaxRatingLabel: UILabel!
	@IBOutlet weak final var doneButton: UIButton!
	@IBOutlet weak final var addNoteButton: UIButton!

	// MARK: - Instance Member Variables

	final var note: String? = nil

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		NotificationCenter.default.addObserver(self, selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification, object: nil)
	}

	// MARK: - Button Actions

	@IBAction final func ratingChanged(_ sender: Any) {
		let maxValue = DependencyInjector.settings.maximumMood
		let newValue = Double(ratingSlider.value) * maxValue

		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: newValue, maxRating: maxValue)

		outOfMaxRatingLabel.text = MoodUiUtil.valueToString(newValue) + " / " + MoodUiUtil.valueToString(maxValue)
	}

	@IBAction final func presentMoodNoteController(_ sender: Any) {
		let controller = UIStoryboard(name: "RecordData", bundle: nil).instantiateViewController(withIdentifier: "moodNote") as! MoodNoteViewController
		controller.note = note ?? ""
		NotificationCenter.default.post(name: RecordDataTableViewController.showViewController, object: controller)
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

	// MARK: - Received Notifications

	@objc private final func noteSaved(notification: Notification) {
		note = (notification.object as! String)
		addNoteButton.setTitle(note, for: .normal)
	}

	// MARK: - Helper Functions

	private final func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		ratingSlider.value = (ratingSlider.maximumValue - ratingSlider.minimumValue) / 2.0
		ratingChanged(self)
	}
}
