//
//  RecordMoodTableViewCell.swift
//  Introspective
//
//  Created by Bryan Nova on 8/11/18.
//  Copyright © 2018 Bryan Nova. All rights reserved.
//

import UIKit
import Presentr
import os

final class RecordMoodTableViewCell: UITableViewCell {

	// MARK: - Static Variables

	private typealias Me = RecordMoodTableViewCell
	private static let presenter: Presentr = DependencyInjector.util.ui.customPresenter(width: .custom(size: 300), height: .custom(size: 200), center: .topCenter)

	// MARK: - IBOutlets

	@IBOutlet weak final var ratingSlider: UISlider!
	@IBOutlet weak final var outOfMaxRatingLabel: UILabel!
	@IBOutlet weak final var doneButton: UIButton!
	@IBOutlet weak final var addNoteButton: UIButton!

	// MARK: - Instance Variables

	final var note: String? = nil

	// MARK: - UIView Overrides

	public final override func awakeFromNib() {
		super.awakeFromNib()
		reset()
		observe(selector: #selector(noteSaved), name: MoodNoteViewController.noteSavedNotification)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Button Actions

	@IBAction final func ratingChanged(_ sender: Any) {
		let maxValue = DependencyInjector.settings.maxMood
		let newValue = Double(ratingSlider.value) * maxValue

		ratingSlider.thumbTintColor = MoodUiUtil.colorForMood(rating: newValue, maxRating: maxValue)

		outOfMaxRatingLabel.text = MoodUiUtil.valueToString(newValue) + " / " + MoodUiUtil.valueToString(maxValue)
	}

	@IBAction final func presentMoodNoteController(_ sender: Any) {
		let controller: MoodNoteViewController = viewController(named: "moodNote", fromStoryboard: "RecordData")
		controller.note = note ?? ""
		NotificationCenter.default.post(
			name: RecordDataTableViewController.showViewController,
			object: self,
			userInfo: info([
				.controller: controller,
				.presenter: Me.presenter,
			]))
	}

	@IBAction final func doneButtonPressed(_ sender: Any) {
		do {
			let mood = try DependencyInjector.sample.mood()
			mood.timestamp = Date()
			mood.rating = Double(ratingSlider.value) * DependencyInjector.settings.maxMood
			mood.note = note
			mood.maxRating = DependencyInjector.settings.maxMood
			mood.setSource(.introspective)
			DependencyInjector.db.save()

			reset()
		} catch {
			os_log("Failed to create mood: %@", type: .error, error.localizedDescription)
			NotificationCenter.default.post(
				name: RecordDataTableViewController.showErrorMessage,
				object: self,
				userInfo: info([
					.title: "Failed to save mood rating",
					.message: "Sorry for the inconvenience",
				]))
		}
	}

	// MARK: - Received Notifications

	@objc private final func noteSaved(notification: Notification) {
		if let note: String = value(for: .text, from: notification) {
			self.note = note
			addNoteButton.setTitle(note, for: .normal)
			addNoteButton.accessibilityValue = "Add Note"
		}
	}

	// MARK: - Helper Functions

	private final func reset() {
		note = nil
		addNoteButton.setTitle("Add Note", for: .normal)
		ratingSlider.value = (ratingSlider.maximumValue - ratingSlider.minimumValue) / 2.0
		ratingChanged(self)
	}
}
